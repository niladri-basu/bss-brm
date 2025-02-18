#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_dm_suspense.pl:InstallVelocityInt:1:2005-Mar-25 18:11:11 %
# 
# Copyright (c) 2003, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the DM_SUSPENSE Component
#
#=============================================================

use Cwd;

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_functions.pl";
   require "../pin_setup.values";

   &ConfigureComponentCalledSeparately ( $0 );
}

#######
#
# Configuring database for DM SUSPENSE
#
#######
sub configure_dm_suspense_database {

  require "pin_".$MAIN_DM{'db'}->{'vendor'}."_functions.pl";
  require "pin_cmp_dm_db.pl";
  local ( $TMP ) = $SKIP_INIT_OBJECTS;
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;
  &PreModularConfigureDatabase( %CM, %DM );

  #
  # If this is an fresh install the SUSP_USAGE_EDIT_T table will not be present.
  # Hence call the full dd_objects script to initialize the schema.
  #
  if ( VerifyPresenceOfTable( "SUSP_USAGE_EDIT_T", %{%DM->{"db"}} ) == 0 ) {

	$SKIP_INIT_OBJECTS = "YES";
	$USE_SPECIAL_DD_FILE = "YES";
	$SPECIAL_DD_FILE = "$DD{'location'}/dd_objects_suspense.source";
	$SPECIAL_DD_DROP_FILE = "$DD{'location'}/drop_tables_suspense_".$MAIN_DM{'db'}->{'vendor'}.".source";
	$SPECIAL_DD_CREATE_INDEXES_FILE = "$DD{'location'}/create_indexes_suspense_".$MAIN_DM{'db'}->{'vendor'}.".source";

	if ( $SETUP_DROP_ALL_TABLES =~ m/^YES$/i ) {
		&DropTables( %{MAIN_DM->{"db"}} );
	}

	&pin_pre_modular( %{%DM->{"db"}} );
	&pin_init( %DM );
	&pin_post_modular( %DM );

	$USE_SPECIAL_DD_FILE = "NO";
	$SKIP_INIT_OBJECTS = $TMP;

	&ExecuteSQL_Statement_From_File( $SPECIAL_DD_CREATE_INDEXES_FILE, TRUE, TRUE, %{%DM->{'db'}} );

   }
   
  #
  # If this is an upgrade install from Version 1.0 to 2.0 
  # the suspended_usage_edits_t table will not be present.
  # Hence call the upgrade script to create the new field and table.
  #
  if ( VerifyPresenceOfTable( "SUSPENDED_USAGE_EDITS_T", %{%DM->{"db"}} ) == 0 )
  {
	print "Suspense: updating from version 1.0 to 2.0\n";
  	$SKIP_INIT_OBJECTS = "YES";
  	$USE_SPECIAL_DD_FILE = "YES";
  	$SPECIAL_DD_FILE = "$DD{'location'}/10_20_suspense_upgrade_dd_objects.source";
  		 
  	&pin_pre_modular( %{%DM->{"db"}} );
  	&pin_init( %DM );
  	&pin_post_modular( %DM );

  	$USE_SPECIAL_DD_FILE = "NO";
  	$SKIP_INIT_OBJECTS = $TMP;

  }  
  
  #
  # If this is an upgrade install from Version 6.5 to 7.2 
  # the susp_usage_telco_gsm_info_t table will not be present.
  # Hence call the upgrade script to create the new field and table.
  #
  if ( VerifyPresenceOfTable( "SUSP_USAGE_TELCO_GSM_INFO_T", %{%DM->{"db"}} ) == 0 )
  {

  	&PreModularConfigureDatabase( %CM, %DM );
  
    	$SKIP_INIT_OBJECTS = "YES";
    	$USE_SPECIAL_DD_FILE = "YES";
    	$SPECIAL_DD_FILE = "$DD{'location'}/65_72_suspense_upgrade_dd_objects.source";
    		 
    	&pin_pre_modular( %{%DM->{"db"}} );
    	&pin_init( %DM );
    	&pin_post_modular( %DM );
  
    	$USE_SPECIAL_DD_FILE = "NO";
    	$SKIP_INIT_OBJECTS = $TMP;
  
  }  
  
  #
    # If this is an upgrade from 7.2 to 7.3,
    # the SUSP_BATCH_RESUBMIT_T table will not be present.
    # Hence call the upgrade script to create the new table.
    #
    if ( VerifyPresenceOfTable( "SUSP_BATCH_RESUBMIT_T", %{%DM->{"db"}} ) == 0 )
    {
  
    	$SKIP_INIT_OBJECTS = "YES";
    	$USE_SPECIAL_DD_FILE = "YES";
    	$SPECIAL_DD_FILE = "$DD{'location'}/7.2_7.3_dd_objects_batch_suspense.source";
    		 
    	&pin_pre_modular( %{%DM->{"db"}} );
    	&pin_init( %DM );
    	&pin_post_modular( %DM );
  
    	$USE_SPECIAL_DD_FILE = "NO";
    	$SKIP_INIT_OBJECTS = $TMP;
  
  } 
      	&PostModularConfigureDatabase( %CM, %DM );

}
