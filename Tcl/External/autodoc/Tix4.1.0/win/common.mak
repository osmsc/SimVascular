#
# You can set the following variables in your DOS environment. This
# way you don't need to change this file. E.g.:
#
#	set TCL_VER=7.5
#	make -f makefile.vc
#
# You can also set these variables in the command line to make. E.g.:
#
#	make TCL_VER=7.5 -f makefile.bc
#
# TOOLS       = location of BC++ 32-bit development tools.
#		(DEFAULT: C:\BC45)
# TIX_DEBUG   = Compile Tix with debug information.
#		(DEFAULT: undefined -- debug is not enabled.)
# TCL_VER     = version of Tcl to compile with. Should be either 7.5
#               or 7.6
#		(DEFAULT: Compile with Tcl 7.6)
#----------------------------------------------------------------------

!IFNDEF TOOLS
TOOLS = C:\BC45
!ENDIF

!IFNDEF TIX_DEBUG
NODEBUG = 1
!ENDIF

!IFNDEF TCL_VER
TCL_VER = 7.6
!ENDIF

!IF "$(TCL_VER)" == "7.5"

TMPDIR  = tcl7.5
TCLDIR	= ..\..\tcl7.5
TKDIR	= ..\..\tk4.1
TCLLIB  = tcl75.lib
TCLDLL  = tcl75.dll
TKLIB   = tk41.lib
TKDLL   = tk41.dll
TIXLIB  = $(TMPDIR)\tix4175.lib
TIXDLL  = $(TMPDIR)\tix4175.dll
TIXWISH = $(TMPDIR)\tix4175.exe

CONSOLE_OBJ = tkConsole41.obj

!ENDIF

!IF "$(TCL_VER)" == "7.6"

TMPDIR  = tcl7.6
TCLDIR	= ..\..\tcl7.6
TKDIR	= ..\..\tk4.2
TCLLIB  = tcl76.lib
TCLDLL  = tcl76.dll
TKLIB   = tk42.lib
TKDLL   = tk42.dll
TIXLIB  = $(TMPDIR)\tix4176.lib
TIXDLL  = $(TMPDIR)\tix4176.dll
TIXWISH = $(TMPDIR)\tix4176.exe

CONSOLE_OBJ = tkConsole42.obj

!ENDIF

!IF "$(TCL_VER)" == "8.0"

TMPDIR  = tcl8.0
TCLDIR	= ..\..\tcl8.0
TKDIR	= ..\..\tk8.0
TCLLIB  = tcl80.lib
TCLDLL  = tcl80.dll
TKLIB   = tk80.lib
TKDLL   = tk80.dll
TIXLIB  = $(TMPDIR)\tix4180.lib
TIXDLL  = $(TMPDIR)\tix4180.dll
TIXWISH = $(TMPDIR)\tix4180.exe

CONSOLE_OBJ = tkConsole80.obj

!ENDIF

!IF "$(TCL_VER)" == "2.2i"

TMPDIR  = itcl2.2
ITCL_DIR = ..\..\itcl2.2
TCLDIR	= $(ITCL_DIR)\tcl7.6
TKDIR	= $(ITCL_DIR)\tk4.2
TCLLIB  = tcl76i.lib
TCLDLL  = tcl76i.dll
TKLIB   = tk42i.lib
TKDLL   = tk42i.dll
TIXLIB  = $(TMPDIR)\tix41761.lib
TIXDLL  = $(TMPDIR)\tix41761.dll
TIXWISH = $(TMPDIR)\tix41761.exe

CONSOLE_OBJ = tkConsole42.obj

ITCL_LIBS     = $(ITCL_DIR)\itcl\win\itcl22.lib $(ITCL_DIR)\itk\win\itk22.lib 
ITCL_INCLUDES = $(ITCL_DIR)\itcl\generic;$(ITCL_DIR)\itk\generic
ITCL_DEFINES  = ITCL_2
!ENDIF

!IFNDEF TCLDIR
!ERROR "Unsupported Tcl version $(TCL_VER)"
!ENDIF


WISHOBJS = \
	$(TMPDIR)\tixWinMain.obj

TIXOBJS = \
	$(TMPDIR)\$(CONSOLE_OBJ)  \
	$(TMPDIR)\tixClass.obj    \
	$(TMPDIR)\tixCmds.obj     \
	$(TMPDIR)\tixCompat.obj   \
	$(TMPDIR)\tixDiImg.obj    \
	$(TMPDIR)\tixDiITxt.obj   \
	$(TMPDIR)\tixDiStyle.obj  \
	$(TMPDIR)\tixDItem.obj    \
	$(TMPDIR)\tixDiText.obj   \
	$(TMPDIR)\tixDiWin.obj    \
	$(TMPDIR)\tixError.obj    \
	$(TMPDIR)\tixForm.obj     \
	$(TMPDIR)\tixFormMisc.obj \
	$(TMPDIR)\tixGeometry.obj \
	$(TMPDIR)\tixHLCol.obj    \
	$(TMPDIR)\tixHLHdr.obj    \
	$(TMPDIR)\tixHLInd.obj    \
	$(TMPDIR)\tixImgCmp.obj   \
	$(TMPDIR)\tixHlist.obj    \
	$(TMPDIR)\tixList.obj     \
	$(TMPDIR)\tixMethod.obj   \
	$(TMPDIR)\tixOption.obj   \
	$(TMPDIR)\tixSmpLs.obj    \
	$(TMPDIR)\tixWidget.obj   \
	$(TMPDIR)\tixInit.obj     \
	$(TMPDIR)\tixItcl.obj     \
	$(TMPDIR)\tixUtils.obj    \
	$(TMPDIR)\tixImgXpm.obj   \
	$(TMPDIR)\tixNBFrame.obj  \
	$(TMPDIR)\tixTList.obj    \
	$(TMPDIR)\tixGrid.obj     \
	$(TMPDIR)\tixGrData.obj   \
	$(TMPDIR)\tixGrRC.obj     \
	$(TMPDIR)\tixGrFmt.obj    \
	$(TMPDIR)\tixGrSel.obj    \
	$(TMPDIR)\tixGrUtl.obj    \
	$(TMPDIR)\tixScroll.obj   \
	$(TMPDIR)\tixWCmpt.obj    \
	$(TMPDIR)\tixWinDraw.obj  \
	$(TMPDIR)\tixWinXpm.obj   \
	$(TMPDIR)\tixWinWm.obj
