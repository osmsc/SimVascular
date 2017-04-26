# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: acceptEverything.cls,v 1.1 1998/06/01 19:56:37 aku Exp $
#
# @c Interface used by the POP3 client core (<c pop3Client>) to classify messages
#
# @s Message classificator accepting every incoming mail.
# @i pop3 client, classificator
# -----------------------------

class acceptEverything : popClientMsgClassificatorBase {
    # @c This message classificator just accepts everything.

    method classify {client msgId messageHeader} {
	# @c Just tell the calling pop client to get the mail. See
	# @c <c pop3Client> for a class using it.
	#
	# @a client:        Handle of the pop client object requesting our
	# @a client:        assistance.
	# @a msgId:         Number of the message to classify
	# @a messageHeader: Ignored here.

	$client msgRetrieve $msgId
	return
    }
}


