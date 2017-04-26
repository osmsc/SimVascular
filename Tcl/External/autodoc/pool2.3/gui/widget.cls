# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: widget.cls,v 1.1 1998/06/01 19:56:00 aku Exp $
#
# @c base class of all megawidgets
# @s megawidget base
# @i megawidget base, widget base class
# -------------------------------------------

class widget {

    # @v widgetType: Type of the master widget containing the components of
    # @v widgetType: the megawidgets. Defaults to 'frame', but is overiden
    # @v widgetType: by <c dialog> to 'toplevel'.

    # @v subWidgets: Maps from logical names of the user visible widget
    # @v subWidgets: components to their actual paths. Such components are
    # @v subWidgets: registered during widget creation (in
    # @v subWidgets: <m createSubwidgets>) by calling <m addSubwidget>.

    var        widgetType frame
    var -array subWidgets


    method widget {} {
	# @c Megawidget base constructor. Uses the special runtime support to
	# @c delay actual construction of widgets and binding until the
	# @c completion of the standard construction. 'chainToDerived' uses
	# @c the same calling sequence as the constructor itself.

	${this}::AfterCons [list ${this}::chainToDerived createSubwidgets]
	${this}::AfterCons [list ${this}::chainToDerived setBindings]
	${this}::AfterCons ${this}::WidgetProp
    }


    method ~widget {} {
	# @c Standard destructor. Depending on the way of invocation it is
	# @c possible that the widget associated to this megawidget is already
	# @c destroyed. We not only have nothing to do in this case, it is
	# @c actually forbidden as it would cause an error.

	# 1)	x::delete
	#	=> destroy widget
	#	=> invokes binding <Destroy>,
	#	=> this causes a recursive call to 'delete'. This is catched
	#	   by the runtime system, see <p ::pool::oo::support::delete>.

	# 2)    destroy x
	#	=> invokes binding <Destroy>,
	#	=> invokes x::delete
	#	   the widget is already destroyed, there is nothing to do.

	if {[::info commands ::widgetOf$this] != {}} {
	    rename ::widgetOf$this $this
	    destroy $this
	}

	rename ::${this} {}
	return
    }


    method createSubwidgets {} {
	# @c Delayed construction of the container widget holding the
	# @c megawidget components. Subclasses may have changed the
	# @c 'widgetType' during standard object construction. The
	# @c <c dialog>-class is an example of this.

	::$widgetType $this \
		-class [::pool::string::cap [set ${this}::_className]] \
		-border             $opt(-border)             \
		-relief             $opt(-relief)             \
		-background         $opt(-background)         \
		-highlightthickness $opt(-highlightthickness)

	if {$opt(-width) != {}} {
	    $this configure -width $opt(-width)
	}

	if {$opt(-height) != {}} {
	    $this configure -height $opt(-height)
	}

	rename $this ::widgetOf$this
	return
    }


    method setBindings {} {
	# @c Delayed association of a binding reacting to the destruction of
	# @c a megawidget.

	bind $this <Destroy> \
		"if {\[string compare %W $this\] == 0} { ${this}::delete }"
	return
    }


    method addSubwidget {name path} {
	# @c Interface to derived classes. Allows them to register part of
	# @c their widget structure as user-visible components of the
	# @c megawidget.
	#
	# @a name: Symbolic name of the registered component.
	# @a path: tk widet path of the registered component.

	set subWidgets($name) $path
	return
    }



    method subwidget {name args} {
	# @c General accessor method to user-visible subwidgets as registered
	# @c by <m addSubwidget>. Two modes of calling are possible.
	# @c Without additional arguments after the name the widget path of
	# @c the specified component is retrieved and returned to the user.
	# @c Otherwise the arguments will be interpreted as subcommand of the
	# @c component and arguments supplied to it. This command is then
	# @c executed in the calling level and its result returned as the
	# @c result of this method. This mode is usually used to configure
	# @c the component (like: x subwidget y configure -z w).
	# @r See description.
	#
	# @a name: Symbolic name of the component, must be the same as used in
	# @a name: the call to <m addSubwidget>.
	# @a args: Subcommand to invoke, and its arguments. Can be empty, see
	# @a args: description.

	if {! [::info exists subWidgets($name)]} {
	    error "$this: unknown subwidget $name"
	}

	if {$args == {}} {
	    return $subWidgets($name)
	}

	set w $subWidgets($name)
	set method [::pool::list::shift args]

	return [uplevel 1 $w $method $args]
    }


    method frameWidget {args} {
	# @c Basically the same as <m subwidget>, but specialized on
	# @c accessing the container widget holding the components of the
	# @c megawidget. The arguments are interpreted as subcommand of the
	# @c container and arguments supplied to it. This command is then
	# @c executed in the calling level and its result returned as the
	# @c result of this method.
	# @r See description.
	#
	# @a args: Subcommand to invoke, and its arguments.

	if {$args == {}} {
	    error "no subcommand supplied"
	}

	return [uplevel 1 ::widgetOf$this $args]
    }


    # standard options for all megawidgets

    # This hacky code makes it necesssary to use wish in <f apps/gen_cls>.
    # Creates a widget during compilation, reads out it option values and
    # uses then these as the defaults for all megawidgets derived from this
    # class.

    # @o foreground:         Foreground color of widget.
    # @o background:         Background color of widget.
    # @o activeforeground:   Foreground color of widget in active state.
    # @o activebackground:   Background color of widget in active state.
    # @o highlightthickness: Width of border (in pixels)
    # @o highlightthickness: reserved for highlighting of widget.
    # @o relief:             Relief of widget (sunken, raised, ...)
    # @o border:             Width of widget border, in pixels.
    # @o width:              The requested width of the widget, in pixels.
    # @o height:             The requested height of the widget, in pixels.


    button ._

    option foreground         -d [._ cget -fg]               -a PropagateOption
    option background         -d [._ cget -bg]               -a PropagateOption
    option activeforeground   -d [._ cget -activeforeground] -a PropagateOption
    option activebackground   -d [._ cget -activebackground] -a PropagateOption
    option highlightthickness \
	    -d [._ cget -highlightthickness] \
	    -t ::pool::getopt::integer \
	    -a SetFrame

    option relief             -d flat -t ::pool::ui::relief     -a SetFrame
    option border             -d 0    -t ::pool::getopt::integer -a SetFrame
    option width              -d {}   -a SetFrame
    option height             -d {}   -a SetFrame

    alias fg       foreground
    alias bg       background
    alias activefg activeforeground
    alias activebg activebackground
    alias bd       border

    destroy ._


    # @o data: Allows the association of arbitrary information with the widget.
    # @o data: This class will not interpret the contents of this option and
    # @o data: its subclasses should not do it either.

    option data


    method SetFrame {option oldValue} {
	# @c Configure procedure. Sets the new value of the option into the
	# @c megawidget container.
	#
	# @a option:   The name of the changed option.
	# @a oldValue: The value the option had before the change.

	if {$opt($option) != {}} {
	    frameWidget configure $option $opt($option)
	}
	return
    }



    method PropagateOption {option oldValue} {
	# @c Configure procedure. Sets the new value of the option into the
	# @c megawidget container and all its children.
	#
	# @a option:   The name of the changed option.
	# @a oldValue: The value the option had before the change.

	catch {
	    frameWidget configure $option $opt($option)
	}

	foreach w [winfo children $this] {
	    catch {
		::pool::ui::mapWindow $w configure $option $opt($option)
	    }
	}

	return
    }


    method WidgetProp {} {
	# @c Executed after the complete initialization of the new megawidget.
	# @c Initializes the recursively propagated options.

	PropagateOption -foreground ""
	PropagateOption -background ""
	PropagateOption -activeforeground ""
	PropagateOption -activebackground ""
	return
    }
}

