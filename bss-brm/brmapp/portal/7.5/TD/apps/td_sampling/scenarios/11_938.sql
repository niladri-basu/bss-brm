select distinct TD.POID_ID0 ||',11_938'
from
  PIN.TD_USGEVENT_DETAILS TD,
  PIN.ITEM_T IT,
  PIN.PURCHASED_PRODUCT_T PROD,
  PIN.EVENT_T ET
where
    TD.POID_TYPE = '/event/delayed/session/telco/gsm/valuepack'
and TD.DESCR='Roaming Data Add-on'
and TD.TAX_CODE!='GST'
and IT.POID_ID0 = TD.ITEM_POID_ID0
and IT.SERVICE_OBJ_ID0 = PROD.SERVICE_OBJ_ID0
and ET.POID_ID0 = TD.EVENT_POID_ID0
AND ET.START_T > PROD.CREATED_T
and PROD.PRODUCT_OBJ_ID0 in ('1245000273','1245003089','1245009885','1244977433','84854619','1245053672','208038844','84853880','84853362','83163939','84992284','1245001361','1245002641','1036012016','1036010992');
