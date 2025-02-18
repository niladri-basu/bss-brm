#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile='/brmapp/portal/7.5/TD/apps/td_farmsource_bill_control/fs_control_logs/fs_billing_control_create.log'
actg_dom=$1;
#csvfile='/brmapp/portal/7.5/TD/apps/td_farmsource_billing/farmsource.csv' 
csvpath='/brmapp/portal/7.5/TD/apps/td_farmsource_bill_control/csv'
filename='2DegreesMobileLtd'$actg_dom'_control'.csv
csvfile=$csvpath/$filename
dbfailure=$log_dir/$dbfailure$now.txt
echo 'Customer No,BILL PROFILE ID,Invoice No,Farmsource Account No,Balance Carried Forward,Total Charges,Total Owing,Total Billed to Farm Source,Amount of Farmsource Payment,Balance After Payment,MRO,OTHER NIL GST,INCLUDING GST,Actual GST' >>$csvfile
$ORACLE_HOME/bin/sqlplus -s $LOGINSQL>$csvfile<<EOF
SET WRAP off;
set feedback off;
set linesize 150;
set trimout ON;
set trimspool ON;
set serveroutput off;
SET PAGESIZE 0;
SET COLSEP ",";

SELECT 
       Customer_No || ',' ||
       BILL_PROFILE_ID || ',' ||
       Invoice_No || ',' ||
       Farmsource_Account_No || ',' ||
       Balance_Carried_Forward || ',' ||
       Total_Charges || ',' ||
       Total_Owing || ',' ||
       Total_Billed_To_FarmSource || ',' ||
       Amount_of_Farmsource_Payment || ',' ||
       Balance_After_Payment || ',' ||
       MRO || ',' ||
       OTHER_NIL_GST || ',' ||
       INCLUDING_GST || ',' ||
       Actual_GST 
FROM   TD_FS_BILLING_CONTROL_T;

SELECT
           NULL || ','|| 
           NULL || ',' ||
           NULL || ',' ||
           NULL || ',' ||
       sum(Balance_Carried_Forward) || ',' ||
       sum(Total_Charges) || ',' ||
       sum(Total_Owing) || ',' ||
       sum(Total_Billed_To_FarmSource) || ',' ||
       sum(Amount_of_Farmsource_Payment) || ',' ||
       sum(Balance_After_Payment) || ',' ||
       sum(MRO) || ',' ||
       sum(OTHER_NIL_GST) || ',' ||
       sum(INCLUDING_GST) || ',' ||
       sum(Actual_GST)
FROM   TD_FS_BILLING_CONTROL_T;

SELECT
           NULL || ','||
           NULL || ',' ||
           NULL || ',' ||
           NULL || ',' ||
           NULL || ',' ||
           NULL || ',' ||
           NULL || ',' ||
           NULL || ',' ||
           NULL || ',' ||
       count(case when MRO > 0 then 1 end) || ',' ||
       count(case when OTHER_NIL_GST > 0 then 1 end) || ',' ||
       count(case when ACTUAL_GST > 0 then 1 end) || ',' ||
           NULL 
FROM   TD_FS_BILLING_CONTROL_T;


clear buffer
EXIT
EOF

sed -i '1s/.*/Customer No,BILL PROFILE ID,Invoice No,Farmsource Account No,Balance Carried Forward,Total Charges,Total Owing,Total Billed to Farm Source,Amount of Farmsource Payment,Balance After Payment,MRO,OTHER NIL GST,INCLUDING GST,Actual GST/' $csvfile

awk 'NF { $1=$1; }' $csvfile
echo "CSV Generation completed "
exit;
EOF
