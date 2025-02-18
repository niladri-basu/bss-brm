#===============================================================================
# $Id: FCT_IRules_Error.msg,v 1.3 2001/09/26 08:32:35 sd Exp $
#
# $RCSfile: FCT_IRules_Error.msg,v $
# $Revision: 1.3 $
# $Author: sd $
# $Date: 2001/09/26 08:32:35 $
# $Locker:  $
#-------------------------------------------------------------------------------
# $Log: FCT_IRules_Error.msg,v $
# Revision 1.3  2001/09/26 08:32:35  sd
# - Usage of error messages corrected
#
# Revision 1.2  2001/05/29 07:58:05  sd
# - Initial iScript added
#
# Revision 1.1  2000/04/25 15:17:03  sd
# - Renamed from GenericRules.
#
# Revision 1.2  2000/04/25 14:31:32  sd
# - Interface for edr duplication added.
# - Certification added (currently not working).
#
# Revision 1.1  2000/04/11 13:32:43  sd
# - Initial revision.
#
#===============================================================================

# info messages
INF_LOADING_RULESET               | Loading ruleset `%s'.
INF_FINISHED_RULESET              | Finished ruleset (%s rules).
INF_LOADING_RULE                  | Loading rule `%s'.
INF_FINISHED_RULE                 | Finished rule (%s items with %s compare patterns).

# error messages
ERR_RULESET_FILE                  | %s:line %s: %s.
ERR_RULE_DESCRIPTION              | Failed to create ruleset from description: %s.
ERR_RULESET_NOT_FOUND             | Ruleset `%s' not found.
ERR_ILLEGAL_CUSTOMER_KEY          | Illegal customer key `%s'.
ERR_ILLEGAL_LICENSE_KEY           | Illegal license key `%s'.
ERR_RULE_SETUP                    | Failed to setup rule `%s': %s.
