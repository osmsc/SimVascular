# Tcl package index file, version 1.0
# This file is generated by the "gen_pkg" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded Pool_Net 2.1 [list tclPkgSetup $dir Pool_Net 2.1 {
	{./adb.tcl source {::pool::oo::class::aDB::loadClass aDB}}
	{./mail/message.tcl source {::pool::mail::address ::pool::mail::addressB ::pool::mail::addresses ::pool::mail::analyse ::pool::mail::body ::pool::mail::build ::pool::mail::header ::pool::mail::headerAnalyse ::pool::mail::invisibleRecipients ::pool::mail::recipients ::pool::mail::sender}}
	{./misc.tcl source {::pool::misc::rdServer}}
	{./ns/client.tcl source {::pool::nameserver::Clean ::pool::nameserver::lookup ::pool::nameserver::register ::pool::nameserver::revoke ::pool::nameserver::revokeOther}}
	{./ns/port.tcl source {::pool::nameserver::Port}}
	{./ns/server.tcl source {::pool::nameserver::server::init ::pool::nameserver::server::lookup ::pool::nameserver::server::register ::pool::nameserver::server::revoke}}
	{./pop3/acceptEverything.tcl source {::pool::oo::class::acceptEverything::loadClass acceptEverything}}
	{./pop3/apop.tcl source {::pool::oo::class::pop3ApopSeq::loadClass pop3ApopSeq}}
	{./pop3/auth.tcl source {::pool::pop3::authmode}}
	{./pop3/classifyBase.tcl source {::pool::oo::class::popClientMsgClassificatorBase::loadClass popClientMsgClassificatorBase}}
	{./pop3/client.tcl source {::pool::oo::class::pop3Client::loadClass pop3Client}}
	{./pop3/close.tcl source {::pool::oo::class::pop3CloseSeq::loadClass pop3CloseSeq}}
	{./pop3/cltStorBase.tcl source {::pool::oo::class::popClientStorageBase::loadClass popClientStorageBase}}
	{./pop3/dele.tcl source {::pool::oo::class::pop3DeleteSeq::loadClass pop3DeleteSeq}}
	{./pop3/mbox.tcl source {::pool::oo::class::mbox::loadClass mbox}}
	{./pop3/open.tcl source {::pool::oo::class::pop3OpenSeq::loadClass pop3OpenSeq}}
	{./pop3/pop3.tcl source {::pool::oo::class::pop3Connection::loadClass pop3Connection}}
	{./pop3/pop3s.tcl source {::pool::oo::class::pop3SynConnection::loadClass pop3SynConnection}}
	{./pop3/port.tcl source {::pool::pop3::port}}
	{./pop3/retr.tcl source {::pool::oo::class::pop3RetrSeq::loadClass pop3RetrSeq}}
	{./pop3/seq.tcl source {::pool::oo::class::pop3Sequencer::loadClass pop3Sequencer}}
	{./pop3/server.tcl source {::pool::oo::class::pop3Server::loadClass pop3Server}}
	{./pop3/storage/dir.tcl source {::pool::oo::class::dirStorage::loadClass dirStorage}}
	{./pop3/storage/file.tcl source {::pool::oo::class::fileStorage::loadClass fileStorage}}
	{./pop3/storage/mem.tcl source {::pool::oo::class::memStorage::loadClass memStorage}}
	{./pop3/storage/multi.tcl source {::pool::oo::class::multiStorage::loadClass multiStorage}}
	{./pop3/storage/smtp.tcl source {::pool::oo::class::smtpStorage::loadClass smtpStorage}}
	{./pop3/storage/trig.tcl source {::pool::oo::class::triggerStorage::loadClass triggerStorage}}
	{./pop3/svrStorBase.tcl source {::pool::oo::class::popServerStorageBase::loadClass popServerStorageBase}}
	{./pop3/top.tcl source {::pool::oo::class::pop3TopSeq::loadClass pop3TopSeq}}
	{./pop3/user.tcl source {::pool::oo::class::pop3UserSeq::loadClass pop3UserSeq}}
	{./server.tcl source {::pool::oo::class::server::loadClass server}}
	{./serverUtil.tcl source {::pool::oo::class::server::InstallBgError bgerror}}
	{./smtp/close.tcl source {::pool::oo::class::smtpCloseSeq::loadClass smtpCloseSeq}}
	{./smtp/data.tcl source {::pool::oo::class::smtpDataSeq::loadClass smtpDataSeq}}
	{./smtp/open.tcl source {::pool::oo::class::smtpOpenSeq::loadClass smtpOpenSeq}}
	{./smtp/port.tcl source {::pool::smtp::port}}
	{./smtp/prepare.tcl source {::pool::oo::class::smtpPrepareSeq::loadClass smtpPrepareSeq}}
	{./smtp/seq.tcl source {::pool::oo::class::smtpSequencer::loadClass smtpSequencer}}
	{./smtp/smtp.tcl source {::pool::oo::class::smtpConnection::loadClass smtpConnection}}
	{./smtp/spooler.tcl source {::pool::oo::class::smtpSpooler::loadClass smtpSpooler}}
	{./udbBase.tcl source {::pool::oo::class::userdbBase::loadClass userdbBase}}
	{./urls.tcl source {::pool::urls::GetHostPort ::pool::urls::GetUPHP ::pool::urls::SplitFile ::pool::urls::SplitFtp ::pool::urls::SplitHttp ::pool::urls::SplitMailto ::pool::urls::extract ::pool::urls::findUrls ::pool::urls::hyperize ::pool::urls::split}}
}]
