select distinct iot.billinfo_poid_id0 ||',12_264'
from purchased_product_t ppt, service_t st, bal_grp_t bgt, IOT_BILLINFO_T iot, billinfo_t bt
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and iot.billinfo_poid_id0=bt.poid_id0
and ppt.status=1
and ppt.PRODUCT_OBJ_ID0 in ('2309252466','2309254002','1245000273','2309251314','2309254386','1245053672','2309252850','2309253618','2309252082','1245002641','2309255154','2309252106','2309253642','2309251338','1245009885','2309254410','2309252874','2309253258','1245001361','2309251722','1244977433','84854619','84853362')
and (ppt.ACCOUNT_OBJ_ID0, ppt.SERVICE_OBJ_ID0) 
in (
select pp.ACCOUNT_OBJ_ID0, pp.SERVICE_OBJ_ID0
from purchased_product_t pp, service_t s, bal_grp_t bg, IOT_BILLINFO_T io, billinfo_t b,product_t p
where pp.SERVICE_OBJ_ID0=s.poid_id0
and pp.PRODUCT_OBJ_ID0=p.poid_id0
and pp.descr ='Gold'
and s.BAL_GRP_OBJ_ID0=bg.poid_id0
and io.billinfo_poid_id0=bg.BILLINFO_OBJ_ID0
and io.billinfo_poid_id0=b.poid_id0
and pp.cycle_start_t <= b.next_BILL_T
and pp.cycle_start_t >= b.last_BILL_T
and pp.status=1);