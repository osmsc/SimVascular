# Tcl package index file, version 1.0
# This file is generated by the "gen_pkg" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded Testlib 0.1 [list tclPkgSetup $dir Testlib 0.1 {
	{cmd.tcl source {cmdMailReport cmdSet cmdSetAllTo mimeEnd mimeStart xAddMail xClearMail xDoneMail }}
	{if.tcl source {ifAddText ifBuild ifClearText ifCreateActions ifDoneText ifFillListbox ifMail ifMailSend ifSee ifSetState ifShowSelection ifSplashText }}
	{logo.tcl source {splashTclLogo }}
	{nlistbox.tcl source {nlistbox nlistbox:_cleanSel nlistbox:_configure nlistbox:_dispatch nlistbox:_getRange nlistbox:_illegalEntryOpt nlistbox:_illegalOpt nlistbox:_imageOf nlistbox:_indexcget nlistbox:_initTag nlistbox:_lineOfIndex nlistbox:_tagOf nlistbox:_windowOf nlistbox:activate nlistbox:bbox nlistbox:bind:AutoScan nlistbox:bind:BeginExtend nlistbox:bind:BeginSelect nlistbox:bind:BeginToggle nlistbox:bind:Cancel nlistbox:bind:DataExtend nlistbox:bind:ExtendUpDown nlistbox:bind:Motion nlistbox:bind:SelectAll nlistbox:bind:UpDown nlistbox:cget nlistbox:configure nlistbox:curselection nlistbox:delete nlistbox:get nlistbox:index nlistbox:indexcget nlistbox:indexconfigure nlistbox:insert nlistbox:nearest nlistbox:scan nlistbox:scan:dragto nlistbox:scan:mark nlistbox:see nlistbox:selection nlistbox:selection:_clear nlistbox:selection:anchor nlistbox:selection:clear nlistbox:selection:includes nlistbox:selection:set nlistbox:setBindings nlistbox:size nlistbox:xview nlistbox:yview }}
	{pkgUtil.tcl source {pkgMaintainer pkgTestSetup }}
	{run.tcl source {tsRun }}
	{scan.tcl source {testX tsScan }}
	{splash.tcl source {splashCenter splashDialog splashIntro splashRemove splashScan splashText splashWait }}
	{test.tcl source {testColor testConstraintsOk testDef testDone testExecute testStateTag testStateText testText }}
	{util.tcl source {adef foreachWin logName }}
}]
