#
# Normal/Info messages.
#
INF_NUM_OF_PRICE_LOADED                 | %s price models with %s config entries loaded into memory.    | 30301
INF_NUM_OF_PRICE_NOT_LOADED             | %s price models with NO valid entries in IFW_PRICEMODEL_STEP NOT loaded into memory.  | 30302

#
# Warnings.
#
WRN_NO_PRICEMODEL_STEPS                 | PM=%s has no valid entries in IFW_PRICEMODEL_STEP configured. Skipped loading.        | 30303

#
# Errors.
#
ERR_APPEND_CONFIG                       | Config entry could not be appended to Pricemodel-Step.        | 30304
ERR_INSERT_INTO_MAP                     | Cannot insert entry into memory map.          | 30305
ERR_INSERT_STEP                         | Cannot insert Pricemodel-Step onto RUM.       | 30306
ERR_RESOURCE_NOT_FOUND                  | Cannot find resource '%s' in table IFW_RESOURCE.      | 30307
ERR_INVALID_GL_ACCOUNT                  | Current GL/Account '%s' does not match initial value '%s' for PM=%s, RES=%s, RUM=%s.  | 30308
ERR_INVALID_REVENUE_GROUP               | Current RevenueGroup '%s' does not match initial value '%s' for PM=%s, RES=%s, RUM=%s.        | 30309
ERR_PRICEMODEL_NOT_FOUND	  	| Cannot find PriceModel '%s' in table IFW_PRICEMODEL.	| 30310
ERR_RESOURCE_LNK_NOT_FOUND	  	| Cannot find the ResourceLnk object.	| 30311
ERR_RUM_NOT_FOUND	  	        | Cannot find the RUM from the ResourceLnk object.	| 30312
ERR_PRICE_MODEL_STEP_NOT_FOUND	  	| Cannot find PriceModel step from the RUM object.	| 30313
ERR_PRICE_MODEL_CONFIG_NOT_FOUND	  	| Cannot find PriceModel config from the PriceModel Step object.	| 30314
