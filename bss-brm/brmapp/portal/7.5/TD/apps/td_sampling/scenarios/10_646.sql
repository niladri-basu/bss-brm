select distinct iot.billinfo_poid_id0 ||',10_646'
from purchased_discount_t ppt, discount_t pt, service_t st, bal_grp_t bg, iot_billinfo_t iot
where
iot.billinfo_poid_id0=bg.billinfo_obj_id0
and bg.poid_id0=st.bal_grp_obj_id0
and ppt.service_obj_id0=st.poid_id0
and ppt.discount_obj_id0=pt.poid_id0
and ppt.status=1
and pt.name='Multi Connection Credit'
and bg.billinfo_obj_id0 in
(select billinfo_obj_id0 from
(select billinfo_obj_id0, sum(CURRENT_BAL)
from bal_grp_t ibg, bal_grp_sub_bals_t ibgs, (select distinct billinfo_poid_id0 from iot_billinfo_t) iiot  
where ibg.poid_id0=ibgs.obj_id0
and rec_id2=1000107    
and iiot.billinfo_poid_id0=ibg.billinfo_obj_id0
group by billinfo_obj_id0
having sum(CURRENT_BAL) between 6 and 15));