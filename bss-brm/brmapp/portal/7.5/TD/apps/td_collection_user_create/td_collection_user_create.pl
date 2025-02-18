#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
################################################################################
# Script name : td_collection_user_create
# This utilty does the follwing activities:
#       - Creates customer for collection action
#       - Creats the service proflie
#       - Modifies the customer and maps the profie with it
# Written by: Sukanya       Date: 16-MAR-2015
# Revision date : 
################################################################################
#use Time::localtime;
#use Time::Local;
use pcmif;

my $service_obj;
my $profile_obj;
my $profile_poid;
my $poid;
sub get_flist_fld_value($);

my $log_file = "td_collection_user_create.log";
open(LOG_FILE,">> $log_file") or die "Could not open log file";

######################################
# Get context and create error buffer
######################################
$ebufp = pcmif::pcm_perl_new_ebuf();
$pcm_ctxp = pcmif::pcm_perl_connect($db_no, $ebufp);
if (pcmif::pcm_perl_is_err($ebufp)) {
        print LOG_FILE "FAILED to Connect to Infranet\n";
        pcmif::pcm_perl_print_ebuf($ebufp);
        display_date("finished");
        print "\nLog File $log_file\n\n";
        close(LOG_FILE);
        exit(1);
}
my $db_no="0.0.0.1";
my $DB_NO = $db_no;
$fliststr = << "END"
0 PIN_FLD_POID           POID [0] 0.0.0.1 /plan -1 0
0 PIN_FLD_BILLINFO      ARRAY [0] allocated 20, used 4
1     PIN_FLD_POID           POID [0] 0.0.0.1 /billinfo -1 0
1     PIN_FLD_BILLINFO_ID     STR [0] "Default Bill Unit"
1     PIN_FLD_PAY_TYPE       ENUM [0] 0
1     PIN_FLD_BAL_INFO      ARRAY [0]     NULL array ptr
0 PIN_FLD_ACCTINFO      ARRAY [0] allocated 20, used 2
1     PIN_FLD_POID           POID [0] 0.0.0.1 /account -1 0
1     PIN_FLD_BAL_INFO      ARRAY [0]     NULL array ptr
0 PIN_FLD_NAMEINFO      ARRAY [1] allocated 20, used 7
1     PIN_FLD_LAST_NAME       STR [0] "brm"
1     PIN_FLD_COUNTRY         STR [0] "india"
1     PIN_FLD_FIRST_NAME      STR [0] "brm"
1     PIN_FLD_ZIP             STR [0] "712246"
1     PIN_FLD_STATE           STR [0] "WB"
1     PIN_FLD_CITY            STR [0] "kol"
1     PIN_FLD_ADDRESS         STR [0] "kol"
0 PIN_FLD_BAL_INFO      ARRAY [0] allocated 20, used 3
1     PIN_FLD_NAME            STR [0] "Default Balance Group"
1     PIN_FLD_POID           POID [0] 0.0.0.1 /balance_group -1 0
1     PIN_FLD_BILLINFO      ARRAY [0]     NULL array ptr
0 PIN_FLD_SERVICES      ARRAY [0] allocated 20, used 5
1     PIN_FLD_SERVICE_OBJ    POID [0] 0.0.0.1 /service/admin_client -1 0
1     PIN_FLD_PASSWD_CLEAR    STR [0] "brm"
1     PIN_FLD_PASSWD_STATUS   ENUM [0] 0
1     PIN_FLD_LOGIN           STR [0] "brm"
1     PIN_FLD_DEAL_OBJ       POID [0] 0.0.0.0 / 0 0
END
;
 $poid=create_collection_user($fliststr);
#print"\npoid $poid \n";

$service_fliststr = << "END"
0 PIN_FLD_POID           POID [0] 0.0.0.1 /service/admin_client -1 0
0 PIN_FLD_NAME            STR [0] "Collection Center"
0 PIN_FLD_PASSWD_CLEAR    STR [0] "XXXX"
0 PIN_FLD_ACCOUNT_OBJ    POID [0] 0.0.0.1 /account 1 0
0 PIN_FLD_LOGIN           STR [0] "ROLE-<Collection Center>CollectionsMgr"
0 PIN_FLD_INHERITED_INFO SUBSTRUCT [0] allocated 20, used 16
1     PIN_FLD_SERVICE_ADMINCLIENT SUBSTRUCT [0] allocated 20, used 2
2         PIN_FLD_DESCR           STR [0] "CollectionsMgr"
2         PIN_FLD_PROFILE         INT [0] 1
1     PIN_FLD_PERMITTEDS    ARRAY [0] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/accounttool/collections/agent"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [1] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/accounttool/collections/manager"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [2] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/appcenter/collectioncenter"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [3] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/actionhistory"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [4] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/assign"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [5] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/changestatus"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [6] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/chargeCC"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [7] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/exempt"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [8] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/insert"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [9] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/maskcarddetails"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [10] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/newcard"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [11] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/promisetopay"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [12] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/removeexempt"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [13] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/reschedule"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
1     PIN_FLD_PERMITTEDS    ARRAY [14] allocated 20, used 4
2         PIN_FLD_ACTION          STR [0] "/collectionapps/collections/updatepayment"
2         PIN_FLD_MAXIMUM      DECIMAL [0] 0
2         PIN_FLD_MINIMUM      DECIMAL [0] 0
2         PIN_FLD_TYPE           ENUM [0] 2
0 PIN_FLD_STATUS         ENUM [0] 10102
0 PIN_FLD_START_T      TSTAMP [0] (0) 
0 PIN_FLD_END_T        TSTAMP [0] (0)
END
;

$profile_poid=create_service($service_fliststr);

$modify_fliststr = << "END"
0 PIN_FLD_POID           POID [0] 0.0.0.1 /service/admin_client $poid 0
0 PIN_FLD_INHERITED_INFO SUBSTRUCT [0] allocated 20, used 1
1     PIN_FLD_ROLE          ARRAY [assign] allocated 20, used 2
2         PIN_FLD_APPLICATION     STR [0] "Collection Center"
2         PIN_FLD_PROFILE_OBJ    POID [0] 0.0.0.1 /service/admin_client $profile_poid 0
END
;

#   print LOG_FILE ("\nmodify flist: \n$modify_fliststr");
modify_service($modify_fliststr);

my $sql_file = "td_collection_user_create.sql";
open(SQL_FILE,"> $sql_file") or die "Could not open sql file";

print SQL_FILE ("Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,0,'/accounttool/collections/agent',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,1,'/accounttool/collections/manager',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,2,'/appcenter/collectioncenter',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,3,'/collectionapps/collections/actionhistory',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,4,'/collectionapps/collections/assign',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,5,'/collectionapps/collections/changestatus',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,6,'/collectionapps/collections/chargeCC',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,7,'/collectionapps/collections/exempt',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,8,'/collectionapps/collections/insert',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,9,'/collectionapps/collections/maskcarddetails',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,10,'/collectionapps/collections/newcard',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,11,'/collectionapps/collections/promisetopay',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,12,'/collectionapps/collections/removeexempt',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,13,'/collectionapps/collections/reschedule',0,0,2);
Insert into service_admin_permitteds_t (OBJ_ID0,REC_ID,ACTION,MAXIMUM,MINIMUM,TYPE) values ($poid,14,'/collectionapps/collections/updatepayment',0,0,2);
commit;");


system("insert_sql.sh");
close(SQL_FILE);
close(LOG_FILE);

# Close the context
pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);

###################################################
#Subroutine to create customer
###################################################

sub create_collection_user($)
{

        my $in_flist=$_[0];
        print LOG_FILE ("PCM_OP_CREATE_CUSTOMER input flist: \n$in_flist");
        $input_flist = pin_perl_str_to_flist($in_flist, $DB_NO, $ebufp);
        if (pcm_perl_is_err($ebufp))
        {
                print LOG_FILE ("Error converting string to flist.");
                pcm_perl_print_ebuf($ebufp);
                return 2;
        }

        #PCM_OP_CREATE_customer
        $out_flist = pcm_perl_op($pcm_ctxp, "PCM_OP_CUST_CREATE_CUSTOMER", 0, $input_flist, $ebufp);

        if (pcm_perl_is_err($ebufp))
        {
                print LOG_FILE ("Error executing PCM_OP_CREATE_CUSTOMER.");
                pcm_perl_print_ebuf($ebufp);
                pin_flist_destroy($input_flist);
                pin_flist_destroy($out_flist);
                return 2;
        }

        pin_flist_destroy($input_flist);

        $out_fliststr = pin_perl_flist_to_str($out_flist, $ebufp);
        if (pcm_perl_is_err($ebufp))
        {
                print LOG_FILE ("Error converting flist to string.");
                pcm_perl_print_ebuf($ebufp);
                pin_flist_destroy($out_flist);
                return 2;
        }

        pin_flist_destroy($out_flist);

        print LOG_FILE ("\nPCM_OP_CUST_CREATE_CUSTOMER output flist: \n$out_fliststr");

        my @value = split(/\n/, $out_fliststr);
        foreach my $val_array_element(@value){
	        chomp($val_array_element);
        	if ($val_array_element=~ /PIN_FLD_SERVICE_OBJ/i)
        	{
 	       		$service_obj = get_flist_fld_value($val_array_element);
        	}
	}
        print LOG_FILE ("\nservice_obj: $service_obj\n");
        return $service_obj;
}

###################################################
#Subroutine to create service
###################################################
sub create_service($)
{

        my $in_flist=$_[0];
        print LOG_FILE ("PCM_OP_CREATE_SERVICE input flist: \n$in_flist");
        $input_flist = pin_perl_str_to_flist($in_flist, $DB_NO, $ebufp);
        if (pcm_perl_is_err($ebufp))
        {
                print LOG_FILE ("Error converting string to flist.");
                pcm_perl_print_ebuf($ebufp);
                return 2;
        }

        #PCM_OP_CREATE_customer
        $out_flist = pcm_perl_op($pcm_ctxp, "PCM_OP_CUST_CREATE_SERVICE", 0, $input_flist, $ebufp);

        if (pcm_perl_is_err($ebufp))
        {
                print LOG_FILE ("Error executing PCM_OP_CUST_CREATE_CUSTOMER.");
                pcm_perl_print_ebuf($ebufp);
                pin_flist_destroy($input_flist);
                pin_flist_destroy($out_flist);
                return 2;
        }

        pin_flist_destroy($input_flist);

        $out_fliststr = pin_perl_flist_to_str($out_flist, $ebufp);
        if (pcm_perl_is_err($ebufp))
        {
                print LOG_FILE ("Error converting flist to string.");
                pcm_perl_print_ebuf($ebufp);
                pin_flist_destroy($out_flist);
                return 2;
        }

        pin_flist_destroy($out_flist);

        print LOG_FILE ("\nPCM_OP_CUST_CREATE_SERVICE output flist: \n$out_fliststr");

        my @value = split(/\n/, $out_fliststr);
        foreach my $val_array_element(@value){
                chomp($val_array_element);
                if ($val_array_element=~ /PIN_FLD_POID/i)
                {
                        $profile_obj = get_flist_fld_value($val_array_element);
                }
        }
        print LOG_FILE ("\nprofile: $profile_obj\n");
        return $profile_obj;
}

###########################################
# Subroutine to modify service
##########################################
sub modify_service($)
{

        my $in_flist=$_[0];
        print LOG_FILE ("PCM_OP_CUST_MODIFY_SERVICE input flist: \n$in_flist");
        $input_flist = pin_perl_str_to_flist($in_flist, $DB_NO, $ebufp);
        if (pcm_perl_is_err($ebufp))
        {
                print LOG_FILE ("Error converting string to flist.");
                pcm_perl_print_ebuf($ebufp);
                return 2;
        }

        #PCM_OP_CREATE_customer
        $out_flist = pcm_perl_op($pcm_ctxp, "PCM_OP_CUST_MODIFY_SERVICE", 0, $input_flist, $ebufp);

        if (pcm_perl_is_err($ebufp))
        {
                print LOG_FILE ("Error executing PCM_OP_CUST_MODIFY_SERVICE.");
                pcm_perl_print_ebuf($ebufp);
                pin_flist_destroy($input_flist);
                pin_flist_destroy($out_flist);
                return 2;
        }

        pin_flist_destroy($input_flist);

        $out_fliststr = pin_perl_flist_to_str($out_flist, $ebufp);
        if (pcm_perl_is_err($ebufp))
        {
                print LOG_FILE ("Error converting flist to string.");
                pcm_perl_print_ebuf($ebufp);
                pin_flist_destroy($out_flist);
                return 2;
        }

        pin_flist_destroy($out_flist);

        print LOG_FILE ("\nPCM_OP_CUST_MODIFY_SERVICE output flist: \n$out_fliststr");

        return 0;
}

###########################################
# Subroutine to get field value from flist
###########################################
sub get_flist_fld_value($)
{
         my $out_flist_string_row = shift;
         my @return_value = split(/\s/, $out_flist_string_row);
         my $temp_value = $return_value[$#return_value-1];
        my $ret_flist_fld_value = $temp_value;
}


