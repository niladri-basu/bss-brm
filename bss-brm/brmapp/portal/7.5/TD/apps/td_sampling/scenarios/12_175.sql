select TBU.POID_ID0 ||',12_175'
from
  PIN.TD_BSMS_USGDETAILS_T TBU
group by
TBU.POID_ID0 
having count(1) between 51 and 70;
