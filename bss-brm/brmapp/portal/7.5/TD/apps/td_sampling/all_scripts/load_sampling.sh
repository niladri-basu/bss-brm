#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile_ctl=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/sampling.ctl/'`
outfile_log=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/sampling.log/'`

#for lines in `ls input_files | awk '{print $NF}'`
for lines in `ls -lrt input_files | awk '{if ($5 != 0) print $NF}' | grep dat`
do



echo "LOAD DATA
  INFILE './input_files/$lines'
  APPEND
  INTO TABLE td_sample_account_t
  FIELDS TERMINATED BY \",\"
  TRAILING NULLCOLS
  ( BILLINFO_OBJ_ID0,
    SCENARIO_NO,
    STATUS constant \"N\"
  )" > $outfile_ctl


sqlldr $LOGINSQL control=$outfile_ctl log=$outfile_log >> ./scenario_logs/sql_loader.log

done
