select /*+ full(td) full(edbc) parallel(td,2) parallel(edbc,2) */ distinct td.poid_id0 ||',11_903'
from TD_USGEVENT_DETAILS td , event_dlyd_session_bal_cust_t edbc
where td.EVENT_POID_ID0=edbc.obj_id0
and td.GL_ID='310201300'
and edbc.RESOURCE_NAME='C018 Craft Regular User Data';
