#!/usr/bin/ksh
TEMPFILE=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/scenario_master.log/'`
touch $TEMPFILE

file1=$1
out1=$2

file2=$3
out2=$4
file3=$5
out3=$6


echo "Starting scenario_exec.sh for $file1 at: "
date
sh ./all_scripts/scenario_exec.sh $file1 $out1 &

if [ ! -z "$file2" ];
then
        echo "Starting scenario_exec.sh for $file2 at: "
        date
        sh ./all_scripts/scenario_exec.sh $file2 $out2 &
fi


if [ ! -z "$file3" ];
then
        echo "Starting scenario_exec.sh for $file3 at: "
        date
        sh ./all_scripts/scenario_exec.sh $file3 $out3 &
fi




USER=`id | awk -F\( '{print $2}' | awk -F\) '{print $1}'`

count=`ps -ef | grep "$USER" | grep "scenario_exec.sh $file1 $out1" | grep -v grep | wc -l`
while [ $count -gt 0 ]
do
sleep 0 
count=`ps -ef | grep "$USER" | grep "scenario_exec.sh $file1 $out1"  | grep -v grep |grep -v "sh -c"|wc -l`
done
IS_ERROR=`grep ORA- ${TEMPFILE}|wc -l`
		if [ $IS_ERROR -gt 0 ];
			then
			echo "ORACLE ERROR"
			cat ${TEMPFILE}
			exit 0
		fi

echo "Completed scenario_exec.sh for $file1 at: "
date



if [ ! -z "$file2" ];
then

count=`ps -ef | grep "$USER" | grep "scenario_exec.sh $file2 $out2"  | grep -v grep |grep -v "sh -c"|wc -l`
while [ $count -gt 0 ]
do
sleep 0
count=`ps -ef | grep "$USER" | grep "scenario_exec.sh $file2 $out2"  | grep -v grep |grep -v "sh -c"|wc -l`
done
IS_ERROR=`grep ORA- ${TEMPFILE}|wc -l`
		if [ $IS_ERROR -gt 0 ];
			then
			echo "ORACLE ERROR"
			cat ${TEMPFILE}
			exit 0
		fi

echo "Completed scenario_exec.sh for $file2 at: "
date

fi



if [ ! -z "$file3" ];
then

count=`ps -ef | grep "$USER" | grep "scenario_exec.sh $file3 $out3"  | grep -v grep |grep -v "sh -c"|wc -l`
while [ $count -gt 0 ]
do
sleep 0
count=`ps -ef | grep "$USER" | grep "scenario_exec.sh $file3 $out3"  | grep -v grep |grep -v "sh -c"|wc -l`
done
IS_ERROR=`grep ORA- ${TEMPFILE}|wc -l`
		if [ $IS_ERROR -gt 0 ];
			then
			echo "ORACLE ERROR"
			cat ${TEMPFILE}
			exit 0
		fi

echo "Completed scenario_exec.sh for $file3 at: "
date

fi

