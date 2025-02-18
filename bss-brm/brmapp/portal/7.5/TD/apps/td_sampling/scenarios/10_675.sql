select distinct iot.billinfo_poid_id0 ||',10_675'
from IOT_BILLINFO_T iot, item_t it
where item_poid_id0=it.poid_id0
and it.poid_type='/item/late_fee';
