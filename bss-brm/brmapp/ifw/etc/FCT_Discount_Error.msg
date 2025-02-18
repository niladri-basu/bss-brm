ERR_ACCOUNT_CANCEL                      | Could not cancel transaction '%s'.            | 18021
ERR_ACCOUNT_COMMIT                      | Could not commit transaction '%s'.            | 18020
ERR_ACCOUNT_COMMIT_RESTART              | Could not commit transaction '%s' on restart. | 18018
ERR_ACCOUNT_PREPARECOMMIT               | Could not prepare commit transaction '%s'.    | 18019
ERR_ACCOUNT_ROLLBACK                    | Could not rollback transaction '%s'.          | 18022
ERR_BEGIN_DSC_TRANSACTION               | Cannot start the transaction '%s'.            | 18011
ERR_BEGIN_EDR                           | Cannot begin EDR transaction.                 | 18006
ERR_CANCEL_DEMANDED_EDR                 | EDR belongs to a cancel demanded transaction. | 18010
ERR_CANCEL_EDR                          | EDR transaction cancel demanded.              | 18008
ERR_CANNOT_COMPILE_SCRIPT               | Failed to compile the following IScript: '%s' | 18025
ERR_COMMIT_EDR                          | Cannot commit EDR transaction.                | 18007
ERR_CURRENCY_RESID_NOT_FOUND            | Failed to find this currency from DAT::Currency: '%s'         | 18026
ERR_DISCOUNT_DETACH_MODULE              | Could not detach pipeline '%s' (not attached).        | 18017
WRN_DSC_CONF_NOT_FOUND                  | Cannot find configuration for discount model '%s', date '%s'.         | 18013
ERR_EDR_ITERATOR                        | Could not reset EDR iterator.                 | 18004
ERR_EDRPACK_NOT_READY_DSC               | Not all EDR fields needed for discounting are filled.         | 18005
ERR_END_DSC_TRANSACTION                 | Cannot start the transaction '%s'.            | 18012
ERR_INVALID_BASE_AMOUNT                 | Invalid base amount value. Expression: '%s'.  | 18027
ERR_INVALID_BASE_EXPR                   | Discount with no Charge Packet (Billing Time discount) cannot reference CP amount: '%s'.      | 18028
ERR_INVALID_COND_AMOUNT                 | Invalid condition amount value. Expression: '%s'.     | 18029
WRN_INVALID_DRUM_AMOUNT                 | Invalid DRUM amount value. Expression: '%s'.  | 18030
ERR_INVALID_DISCOUNT_TYPE               | Invalid discount type '%s'.                   | 18016
ERR_INVALID_GRANT_TYPE                  | The grant type '%s' is invalid.               | 18002
ERR_INVALID_THRESHOLD_TYPE              | Invalid threshold type '%s'.                  | 18015
ERR_INVALID_THRESHOLD_AMOUNT            | Invalid threshold_to amount value. Expression: '%s'   | 18031
ERR_NO_ACCOUNT_BALANCE                  | Could not create/find balance for BG/Resource: %s.    | 18023
ERR_PLUGIN_INVALID_STATE                | Required action does not fit to current state '%s'.   | 18003
ERR_REJECT_EDR                          | EDR rejection demanded.                                | 18033
ERR_ROLLBACK_EDR                        | EDR transaction rollback demanded             | 18009
ERR_EXPR_REF_CP                         | Expression referencing Charge Packet amount when there is no Charge Packet: '%s'. | 18035
ERR_GETTING_BG_ID                       | Failed to get balance group id for account: '%s'. | 18036
ERR_WRONG_EDR_FIELD_TYPE                | Given EDR field is not of Long or Decimal type: '%s'.  | 18041
ERR_INVALID_INTERPRETER                 | Error instanciationg the IXT Interpreter               | 18042
ERR_FAILED_EXTENSION_INSERTION          | Given EDR field is not of Long or Decimal type: '%s'.  | 18043

INF_ACCOUNT_DEADLOCK                    | Could not get balance for BG/Resource '%s' due to deadlock, the transcation will be canceled and retried.    | 18024
INF_ACCOUNT_REJECT                      | No sub-balance found for BG/Resource '%s', this EDR rejected.     | 18032
INF_EDR_STATISTICS                      | EDRs: '%s' processed ('%s' committed; '%s' cancelled). '%s' charge breakdowns '%s' charge packets processed.  | 18001
INF_IGNORE_ON_DISCOUNTACCOUNT_DEADLOCK  | Edr has been ignored due to discount account deadlock. | 18037
INF_BALANCE_NOT_FOUND                   | Balance for balance group '%s', resource id '%s' is not found from existing data | 18038
INF_IGNORE_ON_DISCOUNT_ERROR            | Ignoring the EDR for discounting error  | 18039
INF_DISCOUNT_BUNDLE_RULE_INVALID        | Discount Bundle rule '%s' is invalid for account id '%s'-'%s'. | 18040
WRN_BALANCEGROUP_LOCKED                 | Could not get balance for BG/Resource '%s' due to lock of balance group. '%s'. | 18044
INF_IGNORE_ON_BALANCEGROUP_LOCK         | Edr has been ignored due to lock of balance group | 18045

