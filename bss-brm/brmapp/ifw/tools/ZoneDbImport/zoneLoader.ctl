load data
infile '<Path of Input data file>'
append
into table IFW_STANDARD_ZONE
( ZONEMODEL       CONSTANT 1,
  SERVICECODE     POSITION(1:10) CHAR,
  VALID_FROM      POSITION(12:25) DATE "YYYYMMDDHH24MISS",
  VALID_TO        POSITION(27:40) DATE "YYYYMMDDHH24MISS" NULLIF VALID_TO=BLANKS,
  ORIGIN_AREACODE POSITION(42:61) CHAR,
  DESTIN_AREACODE POSITION(84:103) CHAR,
  ZONE_RT         POSITION(126:133) INTEGER EXTERNAL "decode(:ZONE_RT, '3', '4', :ZONE_RT)",
  ZONE_WS         POSITION(135:142) INTEGER EXTERNAL )
