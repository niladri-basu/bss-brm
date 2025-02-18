#ifndef lint
static  char    Sccs_id[] = "@(#)$Id: td_bill_suppress.c /cgbubrm_7.3.2.idcmod/3 2013/04/16 10:41:40 samhegde Exp $";
#endif

/*******************************************************************
 * Program to suppress bill manually
* This program will ba called via td_blii_suppress.sh script.
* This will set the BILLINFO_STATUS as 1 to suppress the billinfo
* or BILLINFO_STATUS as 0 to remove from suppression.
* It will write the file processing history in log file
* and successful records will be captured in sucess directory and
* unsuccessful records in error directory as well.
* Revision Date : 28-01-2015
 *******************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

#ifndef WINDOWS
#include <libgen.h>
#endif

#include "pinlog.h"
#include "pin_errs.h"
#include "pcm.h"
#include "ops/base.h"
#include "pin_cust.h"
#include "ops/act.h"
#include "pin_os.h"
#include "pin_os_getopt.h"

#define FILE_SOURCE_ID "td_bill_suppress.c (1.14)"

#define STR_LEN 1024
int
main(
        int             argc,
        char            *argv[])
        
{
        pcm_context_t    *ctxp = NULL;
        pin_errbuf_t     ebuf;
        //u_int64          database=1;
        u_int64          database;
        int32            err;
        int              counter = 0;
        FILE             *filepointr;
	FILE             *filepointer2;
        FILE             *filepointer1;
	char             *char_ptr = (char *)NULL;
        char             *program;
        char             *input_str[9];
        char             *line = NULL;
        char             *character = NULL;
        size_t           len = 0;
        ssize_t          read;
	const 		 char s[2] = ",";
        char             billinfo_taken[STR_LEN];
	char             logfile[STR_LEN];
	char             reportfile[STR_LEN];
	char		 errorfile[STR_LEN];
	time_t           now;
	struct           tm *today;
        char             date[STR_LEN];

	
	pin_flist_t      *suppression_in_flistp=NULL;
	pin_flist_t 	 *suppression_out_flistp=NULL;
	pin_flist_t      *args_flistp = NULL;
	pin_flist_t      *search_in_flistp = NULL;
	pin_flist_t      *search_out_flistp = NULL;
	pin_flist_t      *acc_result_flistp = NULL;
	pin_flist_t	 *billinfo_add_flistp = NULL;
	
        poid_t           *acc_pdp = NULL;
        poid_t           *search_pdp = NULL;
	poid_t           *billinfo_pdp = NULL;
        char             *program_name ="td_bill_suppress";
        
        void             *vp = NULL;
	char             *inputfile;
        char             *template;
	char             file_location[STR_LEN];
	char             file_location_unsuppress[STR_LEN];

        pin_cookie_t     cookie = NULL;
        int32            rec_id;
	char		 *suppression_checking=NULL;
	int		 *billing_status = 0;
	int32            elemid = 0;
	int 		 status_suppress = 1;
	int              status_unsuppress = 0;
	char             filename_char[50];
	char             total_record_char[50];
	char             success_char[50];
	int              counter_success = 0;
	int              counter_error = 0;
	char             error_char[50];
	 /***********************************************************

         * Clear the error buffer (for safety).
         ***********************************************************/

        PIN_ERR_CLEAR_ERR(&ebuf);
	program = basename(argv[0]);
        PIN_ERR_SET_PROGRAM(program);
        PIN_ERR_SET_LEVEL(PIN_ERR_LEVEL_DEBUG);
	/***********************************************************
         * Reading logfile from pin.conf
         ***********************************************************/
        pin_conf("bill_suppress", "logfile", PIN_FLDT_STR, (caddr_t *)&(char_ptr), &err);
        if (char_ptr != (char *)NULL) {
                pin_strlcpy(logfile, char_ptr, sizeof(logfile));
                pin_free(char_ptr);
                char_ptr = (char *)NULL;
		time(&now);
                today = localtime(&now);
                strftime(date, 15, "%d.%m.%Y", today);
                strcat(logfile, "_");
                strcat(logfile, date);

        }
        PIN_ERR_SET_LOGFILE(logfile);

	/***********************************************************
         * Reading reportfile from pin.conf and apening system date
         ***********************************************************/
        pin_conf("bill_suppress", "reportfile", PIN_FLDT_STR, (caddr_t *)&(char_ptr), &err);
        if (char_ptr != (char *)NULL) {
                pin_strlcpy(reportfile, char_ptr, sizeof(reportfile));
                pin_free(char_ptr);
                char_ptr = (char *)NULL;
                time(&now);
                today = localtime(&now);
                strftime(date, 15, "%d.%m.%Y", today);
                strcat(reportfile, "_");
                strcat(reportfile, date);
        }

	/***********************************************************
         * Reading Errorfile from pin.conf and apening system date
         ***********************************************************/
	pin_conf("bill_suppress", "errorfile", PIN_FLDT_STR, (caddr_t *)&(char_ptr), &err);
        if (char_ptr != (char *)NULL) {
                pin_strlcpy(errorfile, char_ptr, sizeof(errorfile));
                pin_free(char_ptr);
                char_ptr = (char *)NULL;
                time(&now);
                today = localtime(&now);
                strftime(date, 15, "%d.%m.%Y", today);
                strcat(errorfile, "_");
                strcat(errorfile, date);
        }

	/********************************************************
	Get input file location from pin.conf file of cm
	********************************************************/
	/*27th pin_conf("bill_suppress", "input_dir_suppress", PIN_FLDT_STR, (caddr_t *)&(c_ptr), &err);
        if (c_ptr != (char *)NULL) {
                pin_strlcpy(file_location, c_ptr, sizeof(file_location));
                pin_free(c_ptr);
                c_ptr = (char *)NULL;
        }

	pin_conf("bill_suppress", "input_dir_unsuppress", PIN_FLDT_STR, (caddr_t *)&(c_ptr), &err);
        if (c_ptr != (char *)NULL) {
                pin_strlcpy(file_location_unsuppress, c_ptr, sizeof(file_location_unsuppress));
                pin_free(c_ptr);
                c_ptr = (char *)NULL;
        }
	27th */
	/***********************************************************
         * Open the database context
         ***********************************************************/
	PCM_CONNECT(&ctxp, &database, &ebuf);
	if (PIN_ERR_IS_ERR(&ebuf)) {
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "error opening pcm_connection", &ebuf);
                fprintf(stderr, "%s: error (see pinlog)\n", "bill_suppress");
                exit(2);
        }
        /*else{
                fprintf(stderr, "%s : pcm_connection open\n", "bill_suppress");
        } */
	/******************* checking command line argument to suppress or unsuppress bill *****************/
        
	suppression_checking=basename(argv[2]);
        if(argv[2]==NULL){
                printf("\n please select -suppress to suppress billinfo or -unsuppress to remove billinfo from suppression \n");

        }
	 //fprintf(stderr, "%s test");
	/***********************************
        open the file
        ********************************/
	//printf ("%s",suppression_checking);
	inputfile = basename(argv[1]);
        PIN_ERR_SET_PROGRAM(inputfile);
        PIN_ERR_SET_LEVEL(PIN_ERR_LEVEL_DEBUG);
	filepointr = fopen(argv[1], "r");
        if (filepointr == NULL){
        exit(1);
        }
	/*PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "File processing started for");
        sprintf(filename_char,"%s",inputfile);
        PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,filename_char);*/
	fprintf(stderr, "Reading input file : %s \n ", inputfile);
	if(argv[1] != NULL){
	    //PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "File processing started for");
            //sprintf(filename_char,"%s",argv[1]);
            //PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,filename_char);
	    while ((read = getline(&line, &len, filepointr)) != -1) {
		//printf ("%s \n",line);
               character = (char *)strtok(line, "\n");
                //counter = 0;
                while (character != NULL){
			//printf ("%s\n",character);
                        input_str[counter] = character;
                        character = (char *)strtok(NULL, "\n");
         	/***************************************************
        	Take billinfo ID from input file
        	***************************************************/
	
		strcpy(billinfo_taken,input_str[counter]);
		
                PIN_ERR_CLEAR_ERR(&ebuf);
		database=1;
		search_in_flistp = PIN_FLIST_CREATE(&ebuf);
		search_pdp = PIN_POID_CREATE(database,"/search",-1,&ebuf);

		//PIN_FLIST_FLD_SET(search_in_flistp ,PIN_FLD_POID ,(void *)search_pdp ,&ebuf);
		PIN_FLIST_FLD_PUT(search_in_flistp ,PIN_FLD_POID ,(void *)search_pdp ,&ebuf);

		PIN_FLIST_FLD_SET(search_in_flistp ,PIN_FLD_FLAGS ,NULL ,&ebuf);

		template="select X from /billinfo where F1=V1";

		PIN_FLIST_FLD_SET(search_in_flistp ,PIN_FLD_TEMPLATE ,(void *)template ,&ebuf);

                args_flistp = PIN_FLIST_ELEM_ADD(search_in_flistp, PIN_FLD_ARGS, 1, &ebuf);

                PIN_FLIST_FLD_SET(args_flistp, PIN_FLD_BILLINFO_ID, billinfo_taken, &ebuf);

                search_out_flistp = PIN_FLIST_ELEM_ADD(search_in_flistp, PIN_FLD_RESULTS, 0, &ebuf);

                PIN_FLIST_FLD_SET(search_out_flistp, PIN_FLD_ACCOUNT_OBJ,(void *) NULL, &ebuf);
		PIN_FLIST_FLD_SET (search_out_flistp, PIN_FLD_BILLING_STATUS,(void *) NULL, &ebuf);

		//PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,"Serach input flist", search_in_flistp);
		PCM_OP(ctxp, 7, 0, search_in_flistp, &search_out_flistp, &ebuf);
		//PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,"Search output flist", search_out_flistp);

		acc_result_flistp = PIN_FLIST_ELEM_GET(search_out_flistp,PIN_FLD_RESULTS,0,1, &ebuf);
			
		if (acc_result_flistp == NULL){
			//PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "No record found for this Billinfo");
			filepointer2 = fopen(errorfile, "a");
                        if (filepointer2 == NULL){
                                printf("Error in opening reject file for writing \n");
                        }
                        else
                                fprintf(filepointer2,"td_bill_suppress rejected as no record found for billinfo id %s,filename  %s \n",billinfo_taken,inputfile);
                                counter_error = counter_error+1;
                                counter = counter+1;
				fclose(filepointer2);
                                break;

		}
		if (acc_result_flistp!= (pin_flist_t *)NULL) {
				//acc_result_flistp = NULL;
				acc_pdp = PIN_FLIST_FLD_GET(acc_result_flistp, PIN_FLD_ACCOUNT_OBJ, 1, &ebuf);		
				billinfo_pdp = PIN_FLIST_FLD_GET(acc_result_flistp, PIN_FLD_POID, 1,  &ebuf);
				billing_status = PIN_FLIST_FLD_GET(acc_result_flistp,PIN_FLD_BILLING_STATUS,1,&ebuf);

				suppression_in_flistp = PIN_FLIST_CREATE(&ebuf);
				PIN_FLIST_FLD_SET(suppression_in_flistp, PIN_FLD_POID, (void *)acc_pdp, &ebuf);
				PIN_FLIST_FLD_SET(suppression_in_flistp, PIN_FLD_PROGRAM_NAME, program_name, &ebuf);

				billinfo_add_flistp = PIN_FLIST_ELEM_ADD(suppression_in_flistp, PIN_FLD_BILLINFO, 0, &ebuf);

				PIN_FLIST_FLD_SET(billinfo_add_flistp, PIN_FLD_POID, (void *)billinfo_pdp, &ebuf);
				if(strcmp(suppression_checking,"-suppress")==0){
					if(*billing_status == 1)
					{
						filepointer2 = fopen(errorfile, "a");
                                                if (filepointer2 == NULL){
                                                        printf("Error in opening reject file for writing \n");
                                                }
                                                else
                                                        fprintf(filepointer2,
                                                           "td_bill_suppress rejected as billinfo is already suppressed for billinfo id %s,filename  %s \n",
                                                            billinfo_taken,inputfile);
                                                        counter_error = counter_error+1;
                                                        counter = counter+1;
							fclose(filepointer2);
                                                        break;

					}	
					else
					PIN_FLIST_FLD_SET(billinfo_add_flistp, PIN_FLD_BILLING_STATUS, &status_suppress, &ebuf);
				}	
				else if(strcmp(suppression_checking,"-unsuppress")==0){
					if(*billing_status == 0)
                                        {
						 filepointer2 = fopen(errorfile, "a");
                                                if (filepointer2 == NULL){
                                                       printf("Error in opening reject file for writing \n");
                                                }
                                                else
                                                     fprintf(filepointer2,
                                                        "td_bill_suppress rejected as billinfo is already unsuppressed for billinfo id %s,filename %s \n",
                                                         billinfo_taken,inputfile);
                                                     counter_error = counter_error+1;
                                                     counter = counter+1;
						     fclose(filepointer2);
                                                     break;

                                        }
                                        else
					PIN_FLIST_FLD_SET(billinfo_add_flistp, PIN_FLD_BILLING_STATUS, &status_unsuppress, &ebuf);
				}
				//PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,"Suppression input flist", suppression_in_flistp);
				//PIN_FLIST_PRINT(suppression_in_flistp, stdout, &ebuf);
				PCM_OP(ctxp, PCM_OP_CUST_SET_BILLINFO, 0, suppression_in_flistp, &suppression_out_flistp, &ebuf);
				
				//PIN_FLIST_PRINT(suppression_out_flistp, stdout, &ebuf);
				//PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,"Suppression output flist", suppression_out_flistp);
				if (PIN_ERR_IS_ERR(&ebuf)){
        	                        PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_ERROR,"Error in processing PCM_OP_CUST_SET_BILLINFO", suppression_out_flistp);
	                                
					PIN_FLIST_DESTROY_EX( &suppression_in_flistp, NULL );
                        	        PIN_FLIST_DESTROY_EX( &suppression_out_flistp, NULL );
                	                return;
                        	}
				else{
				 //fprintf(stderr, "\nstep\n\n");
				 
                                        filepointer1 = fopen(reportfile, "a");
                                        if (filepointer1 == NULL){
                                                printf("Error in opening report file for writing \n");
                                        }
                                        else
                                                fprintf(filepointer1,"Record processed successfully for billinfo id %s,filename  %s \n",billinfo_taken,inputfile);
                                                counter_success = counter_success+1;
						fclose(filepointer1);

				}
			} // End if

			//return;
			acc_result_flistp = NULL;

		//} // End inner while	
		counter = counter+1;
		}
	
        PIN_FLIST_DESTROY_EX(&search_in_flistp, NULL);
	PIN_FLIST_DESTROY_EX(&search_out_flistp, NULL);
	if(suppression_in_flistp != NULL)
		PIN_FLIST_DESTROY_EX(&suppression_in_flistp, NULL);
	if(suppression_out_flistp != NULL)
		PIN_FLIST_DESTROY_EX(&suppression_out_flistp, NULL);

	}// End outer While
	/*PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "Total number of records processed");
        sprintf(total_record_char,"%d",counter);
        PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,total_record_char);

	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "Total number of successful records:");
        sprintf(success_char,"%d",counter_success);
        PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,success_char);
	
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "Total number of error:");
        sprintf(error_char,"%d",counter_error);
        PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,error_char);*/
	fprintf(stderr, "Total number of records in file : %d\n", counter);	
	fprintf(stderr, "Total number of records successfully processed : %d\n", counter_success);
	fprintf(stderr, "Total number of records rejected : %d\n", counter_error);
	}// Enf if block of checking argument
 if (line)
        free (line);
        fclose(filepointr);
	//fclose(filepointer1);
	//fclose(filepointer2);
        /***********************************************/
         if (PIN_ERR_IS_ERR(&ebuf)) {
                fprintf(stderr, "\nTest Failed, See Log File\n\n");
        } 
         
	/***********************************************************
         * Close the database channel (a formality since we exit).
         ***********************************************************/
        PCM_CONTEXT_CLOSE(ctxp, 0, &ebuf);
	return;
/*cleanup:
        //PIN_FLIST_DESTROY_EX(&search_in_flistp, NULL);
	//PIN_FLIST_DESTROY_EX(&search_out_flistp, NULL);
        //PIN_POID_DESTROY(search_pdp, NULL);
	//PIN_POID_DESTROY(billinfo_pdp, NULL);
	//PIN_FLIST_DESTROY_EX(&suppression_in_flistp, NULL);
	//PIN_FLIST_DESTROY_EX(&suppression_out_flistp, NULL);
        return(0);*/
}

