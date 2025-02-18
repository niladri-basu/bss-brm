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
FETCH_AMD_OUT_BACKUP_DIR=`egrep -v "#" login.cfg | grep "FETCH_AMD_OUT_BACKUP_DIR" |cut -d'=' -f2`
FETCH_AMD_OUT_DIR=`egrep -v "#" login.cfg | grep "FETCH_AMD_OUT_DIR" |cut -d'=' -f2`
#ARCHIVE_DIR="$LOG_DIR/ARCHIVE_DIR";

ARCHIVE_DIR=`egrep -v "#" login.cfg | grep "ARCHIVE_DIR" |cut -d'=' -f2`

#Name of the script
SCRIPT_NAME="td_amd_output_formatting.sh"
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "$SCRIPT_NAME started at "`date`  >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log
#echo
#echo "Current Working Directory: $LOG_DIR" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo " Starting formatting output for amd fetched `date`" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log

			#cd `$FETCH_AMD_OUT_DIR`
			fileval=`ls -l $FETCH_AMD_OUT_DIR |wc -l`
			#echo "$fileval"
			if [ $fileval -ge 1 ]; then			
				for file1 in $FETCH_AMD_OUT_DIR/*; do
					if [ -f "$file1" ]; then 
						filename=${file1##*/}
						#date_run=`echo "$filename" | cut -d'_' -f2`
						#date_run=`ls $filename | sed -e s/[^0-9]//g`
						date_run=`echo $filename | sed -e s/[^0-9]//g`
						count=`wc -l $file1 | cut -d' ' -f1`
						#echo $count
						#lines=`expr $count - 1`
						#echo $lines
						#now=`date +'%Y%m%d%H'`
						target_file=$EXT_OUT_DIR/BRM_PLAN_AMD_EXPORT-$date_run.txt
						`cp $file1 $target_file`
						#`sed -i 'Total number of rows = ' $target_file`
						echo "Record_count*$count" >>$target_file
						sed -i '1 s/^/ACCOUNT_NO*BILL_INFO_ID*BILL_CYCLE*MSISDN*DISCOUNT_NAME*DISC_START_DATE*STATUS*DISCOUNT_END*LAST_BILL_DATE*NEXT_BILL_DATE*ACCOUNT_POID*BILL_INFO_POID*PURCHASE_DISC_POID*SERVICE_POID*DISCOUNT_POID*DISC_NODE_LOCATION\n/' $target_file
						echo "rows" >> $LOG_DIR/td_fetch_gl_details_extract.log
					fi 
				done
			fi
			fileval=`ls -l $FETCH_AMD_OUT_BACKUP_DIR |wc -l`
			#echo "fileval"
			#echo $fileval
			if [ $fileval -ge 1 ]; then
			#echo "moving to backup"
				`mv $FETCH_AMD_OUT_DIR/* $FETCH_AMD_OUT_BACKUP_DIR`
			fi

echo "End of td_amd_output_formatting.sh" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################">> $LOG_DIR/td_fetch_gl_details_extract.log
echo "$SCRIPT_NAME finished at "`date`  >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################">> $LOG_DIR/td_fetch_gl_details_extract.log