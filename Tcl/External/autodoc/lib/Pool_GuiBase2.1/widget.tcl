# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/widget.cls'.
# Date: Thu Sep 14 23:03:59 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> widget <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::widget {
    variable  _superclasses    {}
    variable  _scChainForward  widget
    variable  _scChainBackward widget
    variable  _classVariables  {}
    variable  _methods         {PropagateOption SetFrame WidgetProp addSubwidget constructor createSubwidgets destructor frameWidget setBindings subwidget}

    variable  _variables
    array set _variables  {subWidgets {widget {isArray 1 initialValue {}}} widgetType {widget {isArray 0 initialValue frame}}}

    variable  _options
    array set _options  {width {widget {-default {} -type ::pool::getopt::notype -action SetFrame -class Width}} highlightthickness {widget {-default 1 -type ::pool::getopt::integer -action SetFrame -class Highlightthickness}} activebackground {widget {-default #ececec -type ::pool::getopt::notype -action PropagateOption -class Activebackground}} background {widget {-default #d9d9d9 -type ::pool::getopt::notype -action PropagateOption -class Background}} height {widget {-default {} -type ::pool::getopt::notype -action SetFrame -class Height}} data {widget {-default {} -type ::pool::getopt::notype -action {} -class Data}} border {widget {-default 0 -type ::pool::getopt::integer -action SetFrame -class Border}} relief {widget {-default flat -type ::pool::ui::relief -action SetFrame -class Relief}} activeforeground {widget {-default Black -type ::pool::getopt::notype -action PropagateOption -class Activeforeground}} foreground {widget {-default Black -type ::pool::getopt::notype -action PropagateOption -class Foreground}}}

    variable  _optionAliases
    array set _optionAliases  {activebg activebackground activefg activeforeground bg background fg foreground bd border}

    variable  _methodTable
    array set _methodTable  {PropagateOption . createSubwidgets . WidgetProp . constructor . setBindings . subwidget . destructor . addSubwidget . frameWidget . SetFrame .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::widget::PropagateOption {option oldValue} {
    ::pool::oo::support::SetupVars widget
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



proc ::pool::oo::class::widget::SetFrame {option oldValue} {
    ::pool::oo::support::SetupVars widget
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



proc ::pool::oo::class::widget::WidgetProp {} {
    ::pool::oo::support::SetupVars widget
    # @c Executed after the complete initialization of the new megawidget.
	# @c Initializes the recursively propagated options.

	PropagateOption -foreground ""
	PropagateOption -background ""
	PropagateOption -activeforeground ""
	PropagateOption -activebackground ""
	return
}



proc ::pool::oo::class::widget::addSubwidget {name path} {
    ::pool::oo::support::SetupVars widget
    # @c Interface to derived classes. Allows them to register part of
	# @c their widget structure as user-visible components of the
	# @c megawidget.
	#
	# @a name: Symbolic name of the registered component.
	# @a path: tk widet path of the registered component.

	set subWidgets($name) $path
	return
}



proc ::pool::oo::class::widget::constructor {} {
    ::pool::oo::support::SetupVars widget
    # @c Megawidget base constructor. Uses the special runtime support to
	# @c delay actual construction of widgets and binding until the
	# @c completion of the standard construction. 'chainToDerived' uses
	# @c the same calling sequence as the constructor itself.

	${this}::AfterCons [list ${this}::chainToDerived createSubwidgets]
	${this}::AfterCons [list ${this}::chainToDerived setBindings]
	${this}::AfterCons ${this}::WidgetProp
}



proc ::pool::oo::class::widget::createSubwidgets {} {
    ::pool::oo::support::SetupVars widget
    # @c Delayed construction of the container widget holding the
	# @c megawidget components. Subclasses may have changed the
	# @c 'widgetType' during standard object construction. The
	# @c <c dialog>-class is an example of this.

	::$widgetType $this  -class [::pool::string::cap [set ${this}::_className]]  -border             $opt(-border)              -relief             $opt(-relief)              -background         $opt(-background)          -highlightthickness $opt(-highlightthickness)

	if {$opt(-width) != {}} {
	    $this configure -width $opt(-width)
	}

	if {$opt(-height) != {}} {
	    $this configure -height $opt(-height)
	}

	rename $this ::widgetOf$this
	return
}



proc ::pool::oo::class::widget::destructor {} {
    ::pool::oo::support::SetupVars widget
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



proc ::pool::oo::class::widget::frameWidget {args} {
    ::pool::oo::support::SetupVars widget
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



proc ::pool::oo::class::widget::setBindings {} {
    ::pool::oo::support::SetupVars widget
    # @c Delayed association of a binding reacting to the destruction of
	# @c a megawidget.

	bind $this <Destroy>  "if {\[string compare %W $this\] == 0} { ${this}::delete }"
	return
}



proc ::pool::oo::class::widget::subwidget {name args} {
    ::pool::oo::support::SetupVars widget
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



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::widget::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods widget
::pool::oo::support::FixOptions widget

# Create object instantiation procedure
interp alias {} widget {} ::pool::oo::support::New widget

# -------------------------------

