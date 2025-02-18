#!/usr/bin/ksh

TEMPFILE1=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/stg_create.log/'`
TEMPFILE2=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/sampling.log/'`
TEMPFILE3=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/iot_create.log/'`
TEMPFILE4=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/sampling_proc.log/'`
TEMPFILE5=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/Sample_Report.csv/'`
TEMPFILE6=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/Sample_List.csv/'`
TEMPFILE7=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/td_bip_entry.log/'`

echo "Starting Sampling execution at: "
date



#### Clear logs #####

#rm ./scenario_logs/*.log

#### Starting staging table creation ####

echo "Starting stg_create.sh at: "
date
sh ./all_scripts/stg_create.sh

	IS_ERROR=`grep ORA- ${TEMPFILE1}|wc -l`
		if [ $IS_ERROR -gt 0 ];
			then
			echo "ORACLE ERROR"
			cat ${TEMPFILE1}
			exit 0
		fi
echo "Completed stg_create.sh at: "
date




#### Starting staging table creation ####

echo "Starting load_sampling.sh at: "
date
sh ./all_scripts/load_sampling.sh

	IS_ERROR=`grep ORA- ${TEMPFILE2}|wc -l`
		if [ $IS_ERROR -gt 0 ];
			then
			echo "ORACLE ERROR"
			cat ${TEMPFILE2}
			exit 0
		fi
echo "Completed load_sampling.sh at: "
date




#### Starting IOT creation ####

echo "Starting iot_create.sh at: "
date
sh ./all_scripts/iot_create.sh

	IS_ERROR=`grep ORA- ${TEMPFILE3}|wc -l`
		if [ $IS_ERROR -gt 0 ];
			then
			echo "ORACLE ERROR"
			cat ${TEMPFILE3}
			exit 0
		fi
echo "Completed iot_create.sh at: "
date


#### Starting Sampling Proc ####


echo "Starting sampling_proc.sh at: "
date
sh ./all_scripts/sampling_proc.sh

        IS_ERROR=`grep ORA- ${TEMPFILE4}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE4}
                        exit 0
                fi
echo "Completed sampling_proc.sh at: "
date


##### Sample accounts report and list ##########

echo "Starting sample_report.sh at: "
date
sh ./all_scripts/sample_report.sh

        IS_ERROR=`grep ORA- ${TEMPFILE5}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE5}
                        exit 0
                fi
echo "Completed sample_report.sh at: "
date



echo "Starting sample_accounts.sh at: "
date
sh ./all_scripts/sample_accounts.sh

        IS_ERROR=`grep ORA- ${TEMPFILE6}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE6}
                        exit 0
                fi
echo "Completed sample_accounts.sh at: "
date

echo "Sampling execution completed at: "
date

echo "Starting Trial bill generation at: "
date
./create_trial_input.pl ./scenario_logs/Sample_List.csv

echo "Completed Trial bill generation at: "
date

echo "Starting Sampling Report generation at: "
date
sh ./all_scripts/td_trigger_bip_report.sh Sample_Accounts_Report 0


        IS_ERROR=`grep ORA- ${TEMPFILE7}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE3}
                        exit 0
                fi

echo "Completed Sampling Report generation at: "
date

