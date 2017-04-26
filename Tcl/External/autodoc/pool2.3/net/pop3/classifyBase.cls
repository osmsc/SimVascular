# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: classifyBase.cls,v 1.1 1998/06/01 19:56:37 aku Exp $
#
# @c Interface used by the POP3 client core (<c pop3Client>) to classify
# @c messages
#
# @s Interface used by a POP3 client (see <c pop3Client>) for message
# @s classification.
# @i pop3 client
# -----------------------------

class popClientMsgClassificatorBase {
    # @c This class defines the interface used by instances of <c pop3Client>
    # @c to request the classification of incoming mails through their headers
    # @c (alone). 

    method classify {client msgId messageHeader} {
	# @c Abstract method, used by <c pop3Client> to request the
	# @c classification of incoming mail. Use one of the methods
	# @c <pop3Client:msgRetrieve>, <pop3Client:msgIgnore> and
	# @c <pop3Client:msgDelete> to send the client the decision.
	#
	# @a client:        Handle of the pop client object requesting our
	# @a client:        assistance.
	# @a msgId:         Number of the message to classify
	# @a messageHeader: Ignored here.

	error "[oinfo class]: abstract method 'classify' not overidden"
    }
}


