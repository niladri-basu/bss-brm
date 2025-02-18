select /*+ full(td) parallel(td,2) */ distinct td.poid_id0 ||',11_798'
from td_usgevent_details td, event_dlyd_session_vp_t tdvp
where td.poid_type = '/event/delayed/session/telco/gsm/valuepack'
and td.event_poid_id0 = tdvp.obj_id0
and tdvp.unit = 'Days'
and tdvp.EXT1 = 'Data Clock';
