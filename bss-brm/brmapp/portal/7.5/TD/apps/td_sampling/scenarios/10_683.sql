select distinct iot.billinfo_poid_id0 ||',10_683'
from iot_billinfo_t iot, billinfo_t bit
where bit.scenario_obj_id0  > 0
and bit.pending_recv > 0
AND bit.poid_id0 = iot.billinfo_poid_id0;
