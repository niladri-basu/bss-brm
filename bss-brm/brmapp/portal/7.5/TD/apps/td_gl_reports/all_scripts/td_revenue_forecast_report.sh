#!/usr/bin/ksh

TEMPFILE1=`egrep -v "#" login.cfg | grep "INFILE_DIR_INPUT" |cut -d'=' -f2 |sed -e 's/$/\/input_file/'`
TEMPFILE2=`egrep -v "#" login.cfg | grep "OUT_FILE_DIR_OUTPUT" |cut -d'=' -f2 |sed -e 's/$/\/output_file.txt/'`
TEMPFILE3=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/report_table_create.log/'`
TEMPFILE4=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/report_loader_data.log/'`
TEMPFILE5=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/td_bip_entry.log/'`

echo "Starting Revenue Forecast execution at: "
date


if [ "$1" -lt "1" ]
  then echo "Incorrect Execution: Execute as td_revenue_forecast_report.sh YYYYMMDD"
  exit
fi


bill_date=$1



#### Starting input file creation ####

echo "Starting td_create_input_file.sh at: "
date
./all_scripts/td_create_input_file.sh

	IS_ERROR=`grep ORA- ${TEMPFILE1}|wc -l`
		if [ $IS_ERROR -gt 0 ];
			then
			echo "ORACLE ERROR"
			cat ${TEMPFILE1}
			exit 0
		fi
echo "Completed td_create_input_file.sh at: "
date





#### Starting Revenue Forecast Perl script execution ####

echo "Starting td_revenue_forecast at: "
date

if [ -f $TEMPFILE2 ]; then
:>$TEMPFILE2
fi

#./td_forecast.pl ./input_files/input_file

#valgrind --leak-check=full -v ./all_scripts/td_revenue_forecast -v -f input_file
./all_scripts/td_revenue_forecast -v -f input_file

	IS_ERROR=`grep ORA- ${TEMPFILE2}|wc -l`
		if [ $IS_ERROR -gt 0 ];
			then
			echo "ORACLE ERROR"
			cat ${TEMPFILE2}
			exit 0
		fi
echo "Completed td_revenue_forecast at: "
date


#### Starting report table creation ####


echo "Starting report_table_create.sh at: "
date
./all_scripts/report_table_create.sh

        IS_ERROR=`grep ORA- ${TEMPFILE3}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE3}
                        exit 0
                fi
echo "Completed report_table_create.sh at: "
date




#### Starting report table data load ####


echo "Starting report_table_load.sh at: "
date
./all_scripts/report_table_load.sh

        IS_ERROR=`grep ORA- ${TEMPFILE4}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE4}
                        exit 0
                fi
echo "Completed report_table_load.sh at: "
date

echo "Starting td_trigger_bip_report.sh at: "
date
sh ./all_scripts/td_trigger_bip_report.sh GL_Report_Forecast $bill_date

        IS_ERROR=`grep ORA- ${TEMPFILE3}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE3}
                        exit 0
                fi
echo "Completed td_trigger_bip_report.sh at: "
date


echo "Revenue Forecast execution completed at: "
date

