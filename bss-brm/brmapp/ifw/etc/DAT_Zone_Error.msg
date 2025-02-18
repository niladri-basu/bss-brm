#
# Normal/Info messages.
#
INF_ZONEMODEL_REUSED                    | Error during reload of zone model '%s'. Reusing existing data.        | 30601
INF_ZONEMODEL_LOADED                    | Zone model '%s' with %s entries loaded.       | 30602
INF_NUM_ZONEMODELS_LOADED               | %s zone models successfully loaded.           | 30603
INF_NUM_ZONEMODELS_RELOADED             | %s zone models successfully reloaded.         | 30604

#
# Warnings.
#
WRN_INVALID_AREACODE                    | AreaCode contains non-digit characters. Error=%s.     | 30605
WRN_DUPLICATE_SERVICETYPE               | Duplicate entry for ServiceType=%s. Corresponding ServiceCode=%s. | 30611

#
# Errors.
#
ERR_ZONEMODEL_NOT_IN_CONFIG             | Cannot find zone model '%s' in configuration data.    | 30606
ERR_INSERT_ZONEMODEL                    | Error inserting zone model into configuration.        | 30607
ERR_INV_ZONECONFIG_ROW                  | Error invalid values in INT_STANDARD_ZONE: ZONEMODEL=%s, ORIGIN_AREACODE=%s, DESTIN_AREACODE=%s, SERVICECODE=%s, VALID_FROM=%s, VALID_TO=%s, ZONE_WS=%s, ZONE_RT=%s, ALT_ZONEMODEL=%s.        | 30608
ERR_INV_ZONECONFIG_LINE                 | Error invalid zone config line: %s.           | 30609
ERR_INVALID_BEAT                        | Error: Invalid value for Beat (must be greater than 0).       | 30610
