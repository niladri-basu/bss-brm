#!/usr/bin/ksh

#=====================================================================
# Author : Rakesh Nair
# Date   : 1-Jan-2015
# Descr  : Script to generate pre-bill check/pre-bill reports from BIP
# Exec	 : td_prebill_report.sh YYYYMMDD: 
#	   where YYYYMMDD should correspond to billing DOM
#	   Eg: td_prebill_report.sh 20150101
#======================================================================


LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
BIPLOGINSQL=`egrep -v "#" login.cfg | grep "BIP_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/pre_bill_logs.log/'`



`./all_scripts/ac_pre_bill_arrears.sh > $outfile`

IS_ERROR=`grep ORA- ${outfile}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${outfile}
                        exit 0
                fi

echo "Completed pre_bill_arrears.sh for bill date  at"
date


#free_space=`df -k | awk '(NF<5){f=$1; next} (NF>5){f=$1} {print f, $2, $3, $NF}' | sed -e 's/\s\+/,/g'`
free_space=0






echo "New Forecast Report Generation Process completed at: " `date`

