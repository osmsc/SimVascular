# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: ocDialog.cls,v 1.1 1998/06/01 19:55:59 aku Exp $
#
# @c Dialog with ok and cancel buttons.
# @s Dialog with ok and cancel buttons.
# @i ok, cancel, dialog
# -------------------------------------------

class okCancelDialog : multipleChoiceDialog {
    # @c A dialog having a standard button bar: 'Ok' and 'Cancel'.

    method createSubwidgets {} {
	# @c Well, just add 2 buttons to the buttonbar inherited from the
	# @c superclass.

	addButton ok     Ok
	addButton cancel Cancel
	return
    }


    method setBindings {} {
	# @c Let the buttons react to 'return' and 'escape' keys.

	set w [subwidget ok]
	bind  [winfo toplevel $w] <Return>   [list $w invoke]
	bind  [winfo toplevel $w] <KP_Enter> [list $w invoke]

	set w [subwidget cancel]
	bind  [winfo toplevel $w] <Key-Escape> [list $w invoke]
	return
    }
}

