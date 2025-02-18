/*********************************************************************************************
 * Objective: 
 * The script would take dom date as input and check the count and update status of owner profile.
 * This script will be executed from cron and will need to be run daily.
 * The script should log the execution details in a file (or db object??)
 *
 * Written by: Dev Sharma 			Date: 03/24/2015
**********************************************************************************************/
#include <malloc.h>
#include <stdio.h>
#include <string.h>
#include "pcm.h"
#include "pin_type.h"
#include "pinlog.h"
#include "custom_opcodes.h"
#include "pin_decimal.h"
#include "ops/pymt.h"

pin_flist_t*  td_get_active_owner(
                 pcm_context_t   *ctxp,
                 pin_flist_t     *op_in_flistp,
                 pin_errbuf_t    *ebufp);


/*****************************
	Main Function
******************************/
int 
main(int argc, 
       char *argv[])
{
	 pcm_context_t   *ctxp = NULL;
	 int64           db_no = 1;
         pin_errbuf_t    ebuf;

         char            *logfile;
         char            *template;

         pin_rec_id_t        rec_id = 0;
         pin_cookie_t        cookie = 0;

         pin_flist_t     *s_iflistp = NULL;
	 pin_flist_t     *s_oflistp = NULL;
         pin_flist_t     *arg_flistp = NULL;
         pin_flist_t     *data_flistp = NULL;
	 pin_flist_t     *read_flistp= NULL;
	 pin_flist_t     *r_flistp = NULL;
	 pin_flist_t     *temp_flistp = NULL;
	 pin_flist_t	 *res_flistp = NULL;
	 pin_flist_t     *act_owner_flistp = NULL;
	 pin_flist_t     *result_flistp = NULL;
	 pin_flist_t     *mod_profile_iflistp = NULL;
	 pin_flist_t     *mod_profile_oflistp = NULL;

         int32           s_flags = 256;
         poid_t          *s_pdp = NULL;
         int64           id = -1;
         int		 status = 1; 
	 void            *vp = NULL;

         char           *ass_owner = "ASSOCIATION_OWNER";
         char           *dom = "DOM";
         char           *dom_val = "1";

	 char		*min_cons = NULL;
	 char           *max_cons = NULL;


	 pin_decimal_t	*count = NULL;
	 pin_decimal_t  *zerop = pbo_decimal_from_str("0", &ebuf);;

	 char            ebufpp[256];
        
	/******************************
        *Clear the error buffer
        *******************************/
        PIN_ERR_CLEAR_ERR(&ebuf);

        /******************************
        *Configure log
        ******************************/
        pin_conf("td_association_discounting", "logfile", PIN_FLDT_STR, &logfile, (void *)&ebuf);
        PIN_ERR_SET_LOGFILE(logfile);
        PIN_ERR_SET_PROGRAM((void *)basename(argv[0]));
        PIN_ERR_SET_LEVEL(PIN_ERR_LEVEL_DEBUG);
        /******************************
        *Open the database context
        *******************************/
        PCM_CONNECT(&ctxp, &db_no, &ebuf);

        if(ctxp == NULL)
        {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_DEBUG, "Connection error.", &ebuf);
   		return;
        }
        PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "Connected to the database");


        PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"In td_association_discounting before search.........." );

          /**********************************************************************
          * Step 1: Find owner profile poids which have DOM as of the date passed. 
          ***********************************************************************/
	  dom_val = argv[1];	
          s_iflistp = PIN_FLIST_CREATE(&ebuf);

         /**********************************************************
          * Search flist for OBRM Initiated Payment
          ***********************************************************
                0 PIN_FLD_POID           POID [0] 0.0.0.1 /search/pin -1 0
                0 PIN_FLD_FLAGS           INT [0] 256
                0 PIN_FLD_TEMPLATE        STR [0] "select X from /profile/offer_details where F1 = V1 and F2 = V2 and F3 = V3 "
                0 PIN_FLD_ARGS          ARRAY [1] allocated 20, used 1
                1        PIN_FLD_EXTRATING    SUBSTRUCT [0] allocated 20, used 1
                2            PIN_FLD_LABEL           STR [0] "ASSOCIATION_OWNER"
                0 PIN_FLD_ARGS          ARRAY [2] allocated 20, used 1
                1        PIN_FLD_DATA_ARRAY    ARRAY [5] allocated 20, used 4
                2            PIN_FLD_NAME            STR [0] "DOM"
                0 PIN_FLD_ARGS          ARRAY [3] allocated 20, used 1
                1        PIN_FLD_DATA_ARRAY    ARRAY [5] allocated 20, used 4
                2            PIN_FLD_VALUE            STR [0] "15"
                0 PIN_FLD_RESULTS       ARRAY [0]  allocated 20, used 2
                1        PIN_FLD_DATA_ARRAY    ARRAY [*]  allocated 20, used 4

          ***********************************************************/
         s_pdp = PIN_POID_CREATE(db_no, "/search", id, &ebuf);
         PIN_FLIST_FLD_PUT(s_iflistp, PIN_FLD_POID,
                                           (void *)s_pdp, &ebuf);

         PIN_FLIST_FLD_SET (s_iflistp, PIN_FLD_FLAGS, &s_flags, &ebuf);

	 template = "select X from /profile/offer_details where F1 = V1 and F2 = V2 and F3 = V3 ";
         PIN_FLIST_FLD_SET (s_iflistp, PIN_FLD_TEMPLATE, template, &ebuf);

         /***********************************************************
          * Search arguments
          ***********************************************************/
         arg_flistp = PIN_FLIST_ELEM_ADD (s_iflistp,PIN_FLD_ARGS, 1, &ebuf);
         data_flistp = PIN_FLIST_SUBSTR_ADD(arg_flistp, PIN_FLD_EXTRATING, &ebuf);
         PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_LABEL, ass_owner, &ebuf);

         arg_flistp = PIN_FLIST_ELEM_ADD (s_iflistp,PIN_FLD_ARGS, 2, &ebuf);
         data_flistp = PIN_FLIST_ELEM_ADD(arg_flistp, PIN_FLD_DATA_ARRAY, 6, &ebuf);
         PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_NAME, dom, &ebuf);

         arg_flistp = PIN_FLIST_ELEM_ADD(s_iflistp, PIN_FLD_ARGS,3, &ebuf);
         data_flistp = PIN_FLIST_ELEM_ADD(arg_flistp, PIN_FLD_DATA_ARRAY, 6, &ebuf);
         PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_VALUE, dom_val, &ebuf);


         /***********************************************************
          * Search results
          ***********************************************************/
         arg_flistp = PIN_FLIST_ELEM_ADD (s_iflistp, PIN_FLD_RESULTS, 0, &ebuf);
	 PIN_FLIST_FLD_SET(arg_flistp, PIN_FLD_POID, NULL, &ebuf);

         PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Search inflist", s_iflistp);

	 PCM_OP(ctxp, PCM_OP_SEARCH, 0, s_iflistp, &s_oflistp, &ebuf);

         if (PIN_ERR_IS_ERR(&ebuf)) {
                 PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "Search error", &ebuf);

                 PIN_POID_DESTROY (&s_pdp, NULL);
		 PIN_FLIST_DESTROY_EX (&s_iflistp, NULL);
		 return;

         }else{

                 PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Search outflist", s_oflistp);
         }

         while ((temp_flistp = PIN_FLIST_ELEM_GET_NEXT(s_oflistp, PIN_FLD_RESULTS,
                                &rec_id, 1, &cookie, &ebuf)) != (pin_flist_t *) NULL) {

	 	s_pdp = (poid_t *) PIN_FLIST_FLD_GET(temp_flistp, PIN_FLD_POID, 1 , &ebuf);

		//PIN_POID_PRINT(s_pdp, NULL, &ebuf);	
		
		if(!PIN_POID_IS_NULL(s_pdp)){
	           /**************************************************************
        	    * Step 2: Read /profile/offer_details, For each owner profile 
		    * poid to get Min connections, Max connections
		    **************************************************************/
		    read_flistp = PIN_FLIST_CREATE(&ebuf);
		    PIN_FLIST_FLD_SET(read_flistp, PIN_FLD_POID, (void *)s_pdp, &ebuf);
		    PCM_OP(ctxp, PCM_OP_READ_OBJ, 0, read_flistp, &r_flistp, &ebuf);

		    PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "ReadObj outflist", r_flistp);	
	            
		    if (PIN_ERR_IS_ERR(&ebuf)) {
                   	 PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "Read Obj error", &ebuf);

   			 PIN_FLIST_DESTROY_EX(&read_flistp, NULL);
	                 PIN_FLIST_DESTROY_EX(&r_flistp,NULL);
        	         return;

   	            }
		    //Release memory 
		    PIN_FLIST_DESTROY_EX(&read_flistp, NULL); 
		   /**************************************************************
		    * Step 3: For each owner id, find the number of active members 
		    * having this owner id
		    **************************************************************/
		   act_owner_flistp = td_get_active_owner(ctxp, r_flistp, &ebuf);
			  
		   PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Return outflist in main function", act_owner_flistp);
				 
		   result_flistp = PIN_FLIST_ELEM_GET(act_owner_flistp, PIN_FLD_RESULTS, 0, 1, &ebuf);
        	   
		   //Get no. of active members       
		   count = PIN_FLIST_ELEM_GET(result_flistp, PIN_FLD_AMOUNT, 1, 0, &ebuf); 

		   if(pbo_decimal_is_null(count, &ebuf)){
			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "Count is null");
 			return;
		   }
					   
		   //if(!pbo_decimal_is_zero(count, &ebuf)){	
				
		   	sprintf (ebufpp, "Count is: %s", pbo_decimal_to_str(count, &ebuf));
			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, ebufpp);		
	
			data_flistp = PIN_FLIST_ELEM_GET(r_flistp, PIN_FLD_DATA_ARRAY, 3, 1, &ebuf);
			min_cons = PIN_FLIST_FLD_GET(data_flistp, PIN_FLD_VALUE, 0, &ebuf); 
			
                        data_flistp = PIN_FLIST_ELEM_GET(r_flistp, PIN_FLD_DATA_ARRAY, 4, 1, &ebuf);
                        max_cons = PIN_FLIST_FLD_GET(data_flistp, PIN_FLD_VALUE, 0, &ebuf);

			/******************************************************************
			 * Step 4: If count between Min connections and Max connections, 
			 * update owner status to 1 else to 0
			 *****************************************************************/ 
			if(( pbo_decimal_compare(count, pbo_decimal_from_str(min_cons, &ebuf), &ebuf) == 1)
				&& (pbo_decimal_compare(count, pbo_decimal_from_str(max_cons, &ebuf), &ebuf) == -1)){
			
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "Count is between Min and Max value");
                                /************************************************************
                                 * If count is between Min connections and Max connections
                                 * Set owner status as 1
                                 ************************************************************/
                                mod_profile_iflistp = PIN_FLIST_CREATE(&ebuf);
                                PIN_FLIST_FLD_SET(mod_profile_iflistp, PIN_FLD_POID, (void *)s_pdp, &ebuf);

                                data_flistp = PIN_FLIST_ELEM_ADD(mod_profile_iflistp, PIN_FLD_PROFILES, 0, &ebuf);
                                PIN_FLIST_FLD_SET(data_flistp, PIN_FLD_PROFILE_OBJ, (void *)s_pdp, &ebuf);
                                temp_flistp = PIN_FLIST_SUBSTR_ADD(mod_profile_iflistp, PIN_FLD_INHERITED_INFO, &ebuf);
                                data_flistp = PIN_FLIST_SUBSTR_ADD(temp_flistp, PIN_FLD_EXTRATING, &ebuf);

				status = 1;
                                PIN_FLIST_FLD_SET(data_flistp, PIN_FLD_STATUS, &status, &ebuf);
                                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "input flist ", mod_profile_iflistp );

			}
			else{
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "Count is NOT between Min and Max value");
                         	/************************************************************
				 * If count is NOT between Min connections and Max connections
				 * Set owner status as 0
				 ************************************************************/
			        mod_profile_iflistp = PIN_FLIST_CREATE(&ebuf);
                                PIN_FLIST_FLD_SET(mod_profile_iflistp, PIN_FLD_POID, (void *)s_pdp, &ebuf);

                                data_flistp = PIN_FLIST_ELEM_ADD(mod_profile_iflistp, PIN_FLD_PROFILES, 0, &ebuf);
                                PIN_FLIST_FLD_SET(data_flistp, PIN_FLD_PROFILE_OBJ, (void *)s_pdp, &ebuf);
                                temp_flistp = PIN_FLIST_SUBSTR_ADD(mod_profile_iflistp, PIN_FLD_INHERITED_INFO, &ebuf);
                                data_flistp = PIN_FLIST_SUBSTR_ADD(temp_flistp, PIN_FLD_EXTRATING, &ebuf);

				status = 0;
                                PIN_FLIST_FLD_SET(data_flistp, PIN_FLD_STATUS, &status, &ebuf);
                                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "input flist ", mod_profile_iflistp );
			}
		       	/*Updating status*/ 
			PCM_OP(ctxp, PCM_OP_CUST_MODIFY_PROFILE, 32 , mod_profile_iflistp, &mod_profile_oflistp, &ebuf); 

			if (PIN_ERR_IS_ERR(&ebuf)) {
                         	PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "update status error", &ebuf);

                        	PIN_FLIST_DESTROY_EX(&mod_profile_iflistp, NULL);
                         	PIN_FLIST_DESTROY_EX(&mod_profile_oflistp,NULL);
                         	return;
			}
			PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "Output flist ", mod_profile_oflistp );
                   
			//Release memory
			PIN_FLIST_DESTROY_EX(&mod_profile_oflistp, NULL); 
			PIN_FLIST_DESTROY_EX(&r_flistp, NULL);
			//PIN_FLIST_DESTROY_EX (&s_oflistp, NULL);
		   //}
		
	      }	

	}//while loop ends
	/*******************************
	*Release Memory
	*******************************/
        PIN_FLIST_DESTROY_EX(&mod_profile_oflistp, NULL);
        PIN_FLIST_DESTROY_EX(&r_flistp, NULL);
        PIN_FLIST_DESTROY_EX (&s_oflistp, NULL);
		
   	/******************************
    	Close the database connection
    	******************************/
   	if(ctxp != NULL)
   	{
   		PCM_CONTEXT_CLOSE(ctxp, 0, &ebuf); 
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "Connection closed");
   	}

   	return;

}

/***********************************************************
 * td_get_active_owner new function to get the
 * active owner informatiom.
 ***********************************************************/
pin_flist_t*
td_get_active_owner(
        pcm_context_t   *ctxp,
        pin_flist_t     *op_in_flistp,
        pin_errbuf_t    *ebufp)
 {
        pin_flist_t   *sv_flistp = NULL;
        pin_flist_t   *argv_flistp = NULL;
        pin_flist_t   *data_flistp = NULL;
        pin_flist_t   *resv_flistp = NULL;
        pin_flist_t   *flistp = NULL;
        poid_t        *s_pdp = NULL;
        int32          s_flags = 1;

        int32           rec_id = 0;
        pin_cookie_t    cookie = 0;
        char          *ass_member = "ASSOCIATION_MEMBER";
        char          *ass_owner_id = "OWNER_ID";
        char          *ass_owner = NULL;
        pin_decimal_t         *count = NULL;
        char            template[256] = {"select count(1) from /profile/offer_details 1, /purchased_discount 2 where 1.F1=2.F2 and 1.F3=V3 and 1.F4=V4 and 1.F5=V5 "};


        /***********************************************************
        0 PIN_FLD_POID           POID [0] 0.0.0.1 /search/pin -1 0
        0 PIN_FLD_FLAGS           INT [0] 1
        0 PIN_FLD_TEMPLATE        STR [0] "select count(1) from /profile/offer_details 1, /purchased_discount 2 where 1.F1=2.F2 and 1.F3=V3 and 1.F4=V4 and 1.F5=V5 "
        0 PIN_FLD_ARGS          ARRAY [1] allocated 20, used 1
        1        PIN_FLD_EXTRATING    SUBSTRUCT [0] allocated 20, used 1
        2            PIN_FLD_OFFERING_OBJ   POID [0] NULL
        0 PIN_FLD_ARGS          ARRAY [2] allocated 20, used 1
        1              PIN_FLD_POID           POID [0] NULL
        0 PIN_FLD_ARGS          ARRAY [3] allocated 20, used 1
        1        PIN_FLD_EXTRATING    SUBSTRUCT [0] allocated 20, used 1
        2            PIN_FLD_LABEL           STR [0] "ASSOCIATION_MEMBER"
        0 PIN_FLD_ARGS          ARRAY [4] allocated 20, used 1
        1        PIN_FLD_DATA_ARRAY    ARRAY [1] allocated 20, used 4
        2            PIN_FLD_NAME            STR [0] "OWNER_ID"
        0 PIN_FLD_ARGS          ARRAY [5] allocated 20, used 1
        1        PIN_FLD_DATA_ARRAY    ARRAY [1] allocated 20, used 4
        2            PIN_FLD_VALUE            STR [0] "ORACLE"
        0 PIN_FLD_RESULTS       ARRAY [0]  allocated 20, used 2
        1   PIN_FLD_AMOUNT DECIMAL [0] NULL

        */
        /***********************************************************
         * Check the error buffer.
         ***********************************************************/
        if (PIN_ERR_IS_ERR(ebufp))
                return;
        PIN_ERR_CLEAR_ERR(ebufp);


	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "td_get_active_owner ", op_in_flistp);

        while((flistp = /*!=NULL*/
                PIN_FLIST_ELEM_GET_NEXT(op_in_flistp, PIN_FLD_DATA_ARRAY, &rec_id,
                                                                   1, &cookie, ebufp))!= NULL){

        	ass_owner_id = PIN_FLIST_FLD_GET (flistp, PIN_FLD_NAME, 1, ebufp);

        	if(!strcmp(ass_owner_id,"OWNER_ID")){
		        ass_owner = PIN_FLIST_FLD_GET (flistp, PIN_FLD_VALUE, 1, ebufp);

        		/***********************************************************
		         * Allocate the flist for searching.
        		 ***********************************************************/
	        	sv_flistp = PIN_FLIST_CREATE(ebufp);
	        	s_pdp = PIN_POID_CREATE(1, "/search/pin", (int64)-1, ebufp);
		        PIN_FLIST_FLD_PUT(sv_flistp, PIN_FLD_POID, (void *)s_pdp, ebufp);
        		PIN_FLIST_FLD_SET (sv_flistp, PIN_FLD_FLAGS, &s_flags, ebufp);
		        PIN_FLIST_FLD_SET (sv_flistp, PIN_FLD_TEMPLATE, template, ebufp);

        		/***********************************************************
	        	 * Search arguments
	        	 ***********************************************************/
		        argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_ARGS,1, ebufp);
        		data_flistp = PIN_FLIST_SUBSTR_ADD(argv_flistp, PIN_FLD_EXTRATING, ebufp);
		        PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_OFFERING_OBJ, NULL, ebufp);

        		argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_ARGS,2, ebufp);
	        	PIN_FLIST_FLD_PUT(argv_flistp, PIN_FLD_POID, NULL,  ebufp);

	        	argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_ARGS,3, ebufp);
		        data_flistp = PIN_FLIST_SUBSTR_ADD(argv_flistp, PIN_FLD_EXTRATING, ebufp);
        		PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_LABEL, ass_member, ebufp);

		        argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_ARGS,4, ebufp);
        		data_flistp = PIN_FLIST_ELEM_ADD(argv_flistp, PIN_FLD_DATA_ARRAY,1, ebufp);
	        	PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_NAME, ass_owner_id, ebufp);

	        	argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_ARGS,5, ebufp);
		        data_flistp = PIN_FLIST_ELEM_ADD(argv_flistp, PIN_FLD_DATA_ARRAY,1, ebufp);
        		PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_VALUE, ass_owner, ebufp);

		        /***********************************************************
        		 * Search results
	        	 ***********************************************************/
	        	argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_RESULTS, 0, ebufp);
		        PIN_FLIST_FLD_PUT(argv_flistp, PIN_FLD_AMOUNT, NULL, ebufp);

        		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Active owner Search Input Flist:td_get_active_owner ",
                        				                   sv_flistp);
		        /***********************************************************
        		 * Call the DM to do the search.
	        	 ***********************************************************/
	        	PCM_OP (ctxp, PCM_OP_SEARCH, 0, sv_flistp, &resv_flistp, ebufp);


	                /* Error? */
		        if (PIN_ERR_IS_ERR(ebufp)) {
        		        PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "sample_read_obj_search error", ebufp);
        		        /* Free local memory */
        			PIN_FLIST_DESTROY_EX(&sv_flistp, NULL);
	
				return;
			}
			else{
				PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Active owner Search Output Flist:td_get_active_owner ",
                                		           resv_flistp);
			}
		}
    }
return resv_flistp;
}
