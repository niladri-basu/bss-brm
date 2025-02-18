#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile_ctl=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/report_loader.ctl/'`
outfile_log=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/report_loader_data.log/'`

for lines in `ls output_files | grep txt | awk '{print $NF}'`
do



echo "LOAD DATA
  INFILE './output_files/$lines'
  APPEND
  INTO TABLE TD_REVENUE_FORECAST_T
  FIELDS TERMINATED BY \",\"
  TRAILING NULLCOLS
  (ACCOUNT_OBJ_ID0,
   BILLINFO_OBJ_ID0,
   PRODUCT_OBJ_ID0,
   OFFERING_OBJ_ID0,
   EARNED_START_T,
   EARNED_END_T,
   CURRENCY,
   AMOUNT,
   GL_ID,
   QUANTITY,
   TAX_CODE
  )" > $outfile_ctl


sqlldr $LOGINSQL control=$outfile_ctl log=$outfile_log >> ./logs/sql_loader.log

done

