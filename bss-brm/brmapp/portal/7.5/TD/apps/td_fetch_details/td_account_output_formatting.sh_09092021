#!/bin/bash
#####################################################################
# 
# 
# 
####################################################################

#PIN_HOME = "/brmapp/portal/7.5";
#source $PIN_HOME/source.me.sh
LOG_DIR=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
EXT_OUT_DIR=`egrep -v "#" login.cfg | grep "EXT_OUT_DIR" |cut -d'=' -f2`
FETCH_ACCOUNT_OUT_BACKUP_DIR=`egrep -v "#" login.cfg | grep "FETCH_ACCOUNT_OUT_BACKUP_DIR" |cut -d'=' -f2`
FETCH_ACCOUNT_OUT_DIR=`egrep -v "#" login.cfg | grep "FETCH_ACCOUNT_OUT_DIR" |cut -d'=' -f2`
#ARCHIVE_DIR="$LOG_DIR/ARCHIVE_DIR";

ARCHIVE_DIR=`egrep -v "#" login.cfg | grep "ARCHIVE_DIR" |cut -d'=' -f2`

#Name of the script
SCRIPT_NAME="td_account_output_formatting.sh"
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "$SCRIPT_NAME started at "`date`  >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log
#echo
#echo "Current Working Directory: $LOG_DIR" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo " Starting formatting output for accounts fetched `date`" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log
			
			#cd `$FETCH_ACCOUNT_OUT_DIR`
			fileval=`ls -l $FETCH_ACCOUNT_OUT_DIR |wc -l`
			#echo "$fileval"
			if [ $fileval -ge 1 ]; then			
				for file1 in $FETCH_ACCOUNT_OUT_DIR/*; do
					if [ -f "$file1" ]; then 
						filename=${file1##*/}
						#date_run=`echo "$filename" | cut -d'_' -f2`
						#date_run=`ls $filename | sed -e s/[^0-9]//g`
						#date_run=`echo $filename | sed -e s/[^0-9]//g`
						count=`wc -l $file1 | cut -d' ' -f1`
						#echo $count
						#lines=`expr $count - 1`
						#echo $lines
						now=`date +'%Y%m%d%H'`
						#target_file=$EXT_OUT_DIR/BRM_ACCOUNT_EXPORT-$date_run-$now.txt
						target_file=$EXT_OUT_DIR/BRM_ACCOUNT_EXPORT-$now.txt
						`cp $file1 $target_file`
						#`sed -i 'Total number of rows = ' $target_file`
						echo "Record_count*$count" >>$target_file
						sed -i '1 s/^/ACCOUNT_POID*ACCOUNT_NO*CUSTOMER_SEG_DESC*ACCOUNT_CREATED_T*ACCOUNT_MOD_T* BILLINFO_POID*AR_BILLINFO_OBJ_ID0*BILL_INFO_ID*BILLINFO_CREATED_T*BILLINFO_MOD_T*BILLINFO_PAY_TYPE*BILLINFO_ACTG_CYCLE_DOM*BILLINFO_BILLING_STATUS*BILLINFO_STATUS*BILLINFO_NUM_SUPPRESSED_CYCLES*BILLINFO_EXEMPT_FROM_COLLECTIONS*BILLINFO_SCENARIO_OBJ_ID0\n/' $target_file
						echo "rows" >> $LOG_DIR/td_fetch_gl_details_extract.log
					fi 
				done
			fi
			fileval=`ls -l $FETCH_ACCOUNT_OUT_BACKUP_DIR |wc -l`
			#echo "fileval"
			#echo $fileval
			if [ $fileval -ge 1 ]; then
			#echo "moving to backup"
				`mv $FETCH_ACCOUNT_OUT_DIR/* $FETCH_ACCOUNT_OUT_BACKUP_DIR`
			fi

echo "End of td_account_output_formatting.sh" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################">> $LOG_DIR/td_fetch_gl_details_extract.log
echo "$SCRIPT_NAME finished at "`date`  >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################">> $LOG_DIR/td_fetch_gl_details_extract.log
