select TBU.POID_ID0 ||',12_176'
from
  PIN.TD_BSMS_USGDETAILS_T TBU
group by
TBU.POID_ID0 
having count(1) > 70;
