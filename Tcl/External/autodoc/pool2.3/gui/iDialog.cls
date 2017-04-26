# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: iDialog.cls,v 1.1 1998/06/01 19:55:58 aku Exp $
#
# @c Dialog with a single ok button.
# @s Dialog with an ok button.
# @i ok, dialog, information display
# -------------------------------------------

class infoDialog : multipleChoiceDialog {
    # @c A dialog having a standard button bar: 'Ok'.

    method createSubwidgets {} {
	# @c Well, just add the button to the buttonbar inherited from the
	# @c superclass.

	addButton ok Ok
	return
    }


    method setBindings {} {
	# @c Let the button react to the 'return' key.

	set w [subwidget ok]
	bind  [winfo toplevel $w] <Return>   [list $w invoke]
	bind  [winfo toplevel $w] <KP_Enter> [list $w invoke]
	return
    }
}

