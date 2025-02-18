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
FETCH_REALTIME_EVENT_OUT_BACKUP_DIR=`egrep -v "#" login.cfg | grep "FETCH_REALTIME_EVENT_OUT_BACKUP_DIR" |cut -d'=' -f2`
FETCH_REALTIME_EVENT_OUT_DIR=`egrep -v "#" login.cfg | grep "FETCH_REALTIME_EVENT_OUT_DIR" |cut -d'=' -f2`
#ARCHIVE_DIR="$LOG_DIR/ARCHIVE_DIR";

ARCHIVE_DIR=`egrep -v "#" login.cfg | grep "ARCHIVE_DIR" |cut -d'=' -f2`

#Name of the script
SCRIPT_NAME="td_realtime_event_output_formatting.sh"
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "$SCRIPT_NAME started at "`date`  >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log
#echo
#echo "Current Working Directory: $LOG_DIR" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo " Starting formatting output for realtime events `date`" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################" >> $LOG_DIR/td_fetch_gl_details_extract.log

			#cd `$FETCH_REALTIME_EVENT_OUT_DIR`
			fileval=`ls -l $FETCH_REALTIME_EVENT_OUT_DIR |wc -l`
			#echo "$fileval"
			if [ $fileval -ge 1 ]; then			
				for file1 in $FETCH_REALTIME_EVENT_OUT_DIR/*; do
					if [ -f "$file1" ]; then 
						filename=${file1##*/}
						#date_run=`echo "$filename" | cut -d'_' -f2`
						#date_run=`ls $filename | sed -e s/[^0-9]//g`
						date_run=`echo $filename | sed -e s/[^0-9]//g`
						count=`wc -l $file1 | cut -d' ' -f1`
						#echo $filename
						#echo $count
						lines=`expr $count - 1`
						#echo $lines
						now=`date +'%Y%m%d%H'`
						target_file=$EXT_OUT_DIR/BRM_REALTIME_EVENT_EXPORT-$date_run-$now.txt
						`cp $file1 $target_file`
						#`sed -i 'Total number of rows = ' $target_file`
						echo "Record_count*$lines" >>$target_file
						sed -i '1 s/^/ACCOUNT_OBJ_ID0*EVENT_CREATED_T*EVENT_DESCRIPTION*EVENT_END_T*EVENT_NO*ITEM_OBJ_ID0*EVENT_MOD_T*NET_QUANTITY *EVENT_POID_ID0*EVENT_POID_TYPE*SERVICE_OBJ_TYPE *EVENT_START_T*EVENT_AMOUNT*EVENT_GL_ID*IMPACT_TYPE*OFFERING_OBJ_ID0 *PRODUCT_OBJ_ID0*EVENT_QUANTITY*EVENT_RESOURCE_ID*EVENT_TAX_CODE*EVENT_BAL_IMPACTS_REC_ID*AR_BILLINFO_OBJ_ID0*BILLINFO_OBJ_ID0*AR_BILL_OBJ_ID0*BILL_OBJ_ID0*PROGRAM_NAME*CHANNEL_ID\n/' $target_file
						#echo "rows" >> $LOG_DIR/td_fetch_gl_details_extract.log
					fi 
				done
			fi
			fileval=`ls -l $FETCH_REALTIME_EVENT_OUT_BACKUP_DIR |wc -l`
			if [ $fileval -ge 1 ]; then
			#echo "moving to backup"
				`mv $FETCH_REALTIME_EVENT_OUT_DIR/* $FETCH_REALTIME_EVENT_OUT_BACKUP_DIR`
			fi

echo "End of td_realtime_event_output_formatting.sh" >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################">> $LOG_DIR/td_fetch_gl_details_extract.log
echo "$SCRIPT_NAME finished at "`date`  >> $LOG_DIR/td_fetch_gl_details_extract.log
echo "#################################################################">> $LOG_DIR/td_fetch_gl_details_extract.log
