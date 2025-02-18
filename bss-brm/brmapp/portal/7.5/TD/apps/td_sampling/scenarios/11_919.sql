select /*+ full(td) full(ec) parallel(td,2) parallel(ec,2) */ distinct TD.POID_ID0 ||',11_919' from PIN.TD_USGEVENT_DETAILS TD,PIN.event_dlyd_session_custom_t ec
where 
td.POID_ID0=ec.obj_id0
and td.descr='Data'
and ec.Sharers_msisdn is null;
