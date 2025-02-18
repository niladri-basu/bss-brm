select TBU.POID_ID0 ||',12_174'
from
  PIN.TD_BSMS_USGDETAILS_T TBU
group by
TBU.POID_ID0 
having count(1) between 31 and 50;
