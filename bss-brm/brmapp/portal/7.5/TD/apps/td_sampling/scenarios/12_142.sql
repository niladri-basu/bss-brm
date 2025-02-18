select distinct TD.POID_ID0 ||',12_142'
from
  PIN.TD_USGEVENT_DETAILS TD,
  PIN.ITEM_T IT,
  PIN.PURCHASED_PRODUCT_T PROD,
  PIN.EVENT_T ET
where
    TD.POID_TYPE = '/event/delayed/session/telco/gsm/voice'
and TD.GL_ID='400201605'
and mod(TD.AMOUNT,1)= '0'
and TD.AMOUNT!='0'
and ET.DESCR = 'Roaming incoming calls'
and IT.POID_ID0 = TD.ITEM_POID_ID0
and IT.SERVICE_OBJ_ID0 = PROD.SERVICE_OBJ_ID0
and ET.POID_ID0 = TD.EVENT_POID_ID0
AND ET.START_T > PROD.CREATED_T;