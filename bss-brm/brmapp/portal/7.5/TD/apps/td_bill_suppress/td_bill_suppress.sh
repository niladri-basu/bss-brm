#!/bin/sh
#################################################
# This Shell script is to suppress bill manually.
# This will receive the option either "-suppress" or 
# "-unsuppress" and follow action picking the files accordingly.
# It will internally call td_bill_suppress application
# Revision Date : 28-01-2015
################################################
echo "Starting td_bill_suppress execution at : " `date +'%m/%d/%Y'`

executable="td_bill_suppress"
cd $PIN_HOME/TD/apps/td_bill_suppress
pattern="ls $PIN_HOME/TD/apps/td_bill_suppress/pin.conf"
if ls $PIN_HOME/TD/apps/td_bill_suppress/pin.conf &> /dev/null; then
        for input_file in `eval $pattern`
        do
	       if [ "$1" = "-suppress" ]
	       then
			input_dir=$(grep input_dir_suppress $PIN_HOME/TD/apps/td_bill_suppress/pin.conf | awk -F' ' '{print $4}')
			input_dir=$PIN_HOME$input_dir
		echo $input_dir
			FILES=$input_dir/*.csv
			for filename in $FILES
			do
				#echo "$filename"
				if [[ ! -s $filename ]] ; then
					echo "$filename is empty."
				break
				fi ;
				
				command="./$executable $filename -suppress"
				eval $command 
                		flag=$?
                		if (($flag == 0)); then
                        		#echo "File processing completed successfully"
                        		move_archive_command="mv $filename archive/"
                        		eval $move_archive_command
                        		if [ $? -eq 0 ]; then
                                		echo "Successful processed file moved to archive"
                        		else
                                		echo "Move to archive failed"
                        		fi
                		else
                        		echo "File processing failed"
                        		move_reject_command="mv $filename reject/"
                        		eval $move_reject_command
                        	if [ $? -eq 0 ]; then
                                	echo "Failed file moved to reject"
                        	else
                                	echo "Move to reject failed"
                        	fi
                		fi

			done
		fi

		if [ "$1" = "-unsuppress" ]
		then
		input_dir=$(grep input_dir_unsuppress $PIN_HOME/TD/apps/td_bill_suppress/pin.conf | awk -F' ' '{print $4}')
                        #echo $input_dir
			input_dir=$PIN_HOME$input_dir
			FILES=$input_dir/*.csv
                        for filename in $FILES
                        do
                                #echo "$filename"
				if [[ ! -s $filename ]] ; then
                                	echo "$filename is empty."
                                break
                                fi ;
                                command="./$executable $filename -unsuppress"
                                eval $command
                                flag=$?
                                if (($flag == 0)); then
                                        #echo "File processing completed successfully"
                                        move_archive_command="mv $filename archive/"
                                        eval $move_archive_command
                                        if [ $? -eq 0 ]; then
                                        	echo "Successful processed file moved to archive"
                                	else
                                        	echo "Move to archive failed"
                                	fi
                                else
                                       	echo "File processing failed"
                                        move_reject_command="mv $filename reject/"
                                        eval $move_reject_command
                                if [ $? -eq 0 ]; then
                                        echo "Failed file moved to reject"
                                else
                                        echo "Move to reject failed"
                                fi
                                fi

                        done

		fi

	done
fi
