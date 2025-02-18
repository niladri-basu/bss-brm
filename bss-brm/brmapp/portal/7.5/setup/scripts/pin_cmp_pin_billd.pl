#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_pin_billd.pl:InstallVelocityInt:12:2005-Jul-06 17:30:08 %
# 
# Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the pin_billd Component
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


#####
#
# Configure pin_billd files
#
#####
sub configure_pin_billd_config_files {
  local( %CM ) = %MAIN_CM;
  local( %DM ) = %MAIN_DM;
  local ( $TEMP ) = $CurrentComponent;

  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  $PIN_TB_PINCONF_HEADER = $MTA_PINCONF_HEADER;
 
  &ReadIn_PinCnf( "pin_cnf_ar_taxes.pl" );
  &ReadIn_PinCnf( "pin_cnf_pin_billd.pl" );
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &ReadIn_PinCnf( "pin_cnf_pin_remit.pl" );
  &ReadIn_PinCnf( "pin_cnf_pin_bulk.pl" );
  &ReadIn_PinCnf( "pin_cnf_rate_change.pl" );
  &ReadIn_PinCnf( "pin_cnf_monitor_balance.pl" );
  
  # create sample pin.conf with default CM entries in the sys/data/config directory.
  &Configure_PinCnf( "$PIN_HOME/sys/data/config/$PINCONF",
                     $CONNECT_PINCONF_HEADER,
                     %CONNECT_PINCONF_ENTRIES );
  
  # create sample pin.conf with default CM entries in the sys/data/pricing directory.
  &Configure_PinCnf( "$PIN_HOME/sys/data/pricing/example/$PINCONF",
                     $CONNECT_PINCONF_HEADER,
                     %CONNECT_PINCONF_ENTRIES );

  &ReadIn_PinCnf( "pin_cnf_pricing_admin.pl" );
  
  if ( $MAIN_DM{'db'}->{'vendor'} =~ /oracle/i )
  {
    	&AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PRICING_ADMIN_PINCONF_ENTRIES_COMMON );
    	&AddArrays( \%PRICING_ADMIN_PINCONF_ENTRIES_ORACLE, \%PRICING_ADMIN_PINCONF_ENTRIES_COMMON );
  }
  else
  {
    	&AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PRICING_ADMIN_PINCONF_ENTRIES_COMMON );
    	&AddArrays( \%PRICING_ADMIN_PINCONF_ENTRIES_SQLSERVER, \%PRICING_ADMIN_PINCONF_ENTRIES_COMMON );
  }
  
  # create pin.conf in the setup/scripts directory.
  &Configure_PinCnf( "$PIN_HOME/setup/scripts/$PINCONF",
                     $PRICING_ADMIN_PINCONF_HEADER,
                     %PRICING_ADMIN_PINCONF_ENTRIES_COMMON );
  
  if ( ! -e "$PIN_HOME/apps" ){
   mkdir ("$PIN_HOME/apps", 0755) || die "Unable to create $PIN_HOME/apps directory";
  }

                    
  # Create pin.conf entry in the pin_remit directory
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_REMIT_PINCONF_ENTRIES );
  &Configure_PinCnf( $BILLING{'remit_location'}."/".$PINCONF, 
                     $PIN_REMIT_PINCONF_HEADER,
                     %PIN_REMIT_PINCONF_ENTRIES );  
                     
  # Add CM entries and pin_rate_change entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_RATE_CHANGE_PINCONF_ENTRIES );
                     
  # Create pin.conf entry in the pin_rate_change directory
  &Configure_PinCnf( $BILLING{'rate_change_location'}."/".$PINCONF, 
                     $PIN_RATE_CHANGE_PINCONF_HEADER,
                     %PIN_RATE_CHANGE_PINCONF_ENTRIES ); 

  # Add CM entries and pin_billd entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_BILLD_PINCONF_ENTRIES );
  
  # Create pin.conf entry in the pin_billd directory
  &Configure_PinCnf( $BILLING{'location'}."/".$PINCONF,
                     $PIN_BILLD_PINCONF_HEADER,
                     %PIN_BILLD_PINCONF_ENTRIES );
  
  # Add MTA entries and trial billing entries
  &AddArrays( \%MTA_PINCONF_ENTRIES, \%PIN_TB_PINCONF_ENTRIES );
  
  # Add CM entries and trial billing entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_TB_PINCONF_ENTRIES );             

  # Create pin.conf entry in the pin_bill_trial directory
  &Configure_PinCnf( $TB{'location'}."/".$PINCONF,
                     $PIN_TB_PINCONF_HEADER,
                     %PIN_TB_PINCONF_ENTRIES );

  $CurrentComponent = "pin_bulk_adjust";
  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  $CurrentComponent = $TEMP;
             
  # Add MTA entries and bulk adjustment entries
  &AddArrays( \%MTA_PINCONF_ENTRIES, \%PIN_BULK_PINCONF_ENTRIES );
  
  # Add pin_billd entries to bulk adjustment entries
  &AddArrays(\%CONNECT_PINCONF_ENTRIES, \%PIN_BULK_PINCONF_ENTRIES );                 
  
  # Create pin.conf entry in the pin_bulk directory                   
  &Configure_PinCnf( $BILLING{'bulk_location'}."/".$PINCONF, 
                     $PIN_BULK_PINCONF_HEADER,
                     %PIN_BULK_PINCONF_ENTRIES );
  
  # Create pin.conf entries for pin_monitor application
  $CurrentComponent = "pin_monitor";
  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  $CurrentComponent = $TEMP;
             
  # Add MTA entries and pin monitor balance entries
  &AddArrays( \%MTA_PINCONF_ENTRIES, \%PIN_MONITOR_BALANCE_PINCONF_ENTRIES );
                     
  # Add CM entries and pin_monitor_balance entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_MONITOR_BALANCE_PINCONF_ENTRIES );
                     
  # Create pin.conf entry in the pin_monitor directory
  &Configure_PinCnf( $BILLING{'monitor_location'}."/".$PINCONF, 
                     $PIN_MONITOR_BALANCE_PINCONF_HEADER,
                     %PIN_MONITOR_BALANCE_PINCONF_ENTRIES ); 
  
  # Create entries for the pin_bill_handler
  $CurrentComponent = "pin_bill_handler";
  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  $CurrentComponent = $TEMP;
  
  # Add MTA entries and CM entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%MTA_PINCONF_ENTRIES );
  
  # Create pin.conf entry in the pin_bill_handler directory
  &Configure_PinCnf( $BILLING{'bill_handler_location'}."/".$PINCONF,
                     $MTA_PINCONF_HEADER,
                     %MTA_PINCONF_ENTRIES );
             
  # Create entries for the pin_balance_transfer
  $CurrentComponent = "pin_balance_transfer";
  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  $CurrentComponent = $TEMP;
  
  # Add MTA entries and CM entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%MTA_PINCONF_ENTRIES );
  
  # Create pin.conf entry in the pin_balance_transfer directory
  &Configure_PinCnf( $BILLING{'balance_transfer_location'}."/".$PINCONF,
                     $MTA_PINCONF_HEADER,
                     %MTA_PINCONF_ENTRIES );

  # Add CM entries and pin_ar_taxes entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_AR_TAXES_PINCONF_ENTRIES );                  
                     
  if ( ! -e "$PIN_HOME/apps" ){
   mkdir ("$PIN_HOME/apps", 0755) || die "Unable to create $PIN_HOME/apps directory";
  }
  if ( ! -e "$PIN_HOME/apps/pin_ar_taxes" ){
   mkdir ("$PIN_HOME/apps/pin_ar_taxes", 0755) || die "Unable to create $PIN_HOME/apps/pin_ar_taxes directory";
  }
 
  # Create pin.conf entry in the pin_ar_taxes directory                   
  &Configure_PinCnf( $BILLING{'ar_taxes_location'}."/".$PINCONF,
                     $PIN_AR_TAXES_PINCONF_HEADER,
                     %PIN_AR_TAXES_PINCONF_ENTRIES );
                     
  #
  # If the sys/cm/pin.conf is there, add the entries for the Bill Cycle feature.
  # If not, add the entries to the temporary pin.conf file.
  #
  if ( -f $CM{'location'}."/".$PINCONF )
  {
    &ReplacePinConfEntries( $CM{'location'}."/".$PINCONF, %PIN_BILL_CYCLE_ENTRIES );
  }
  else
  {
    # Create temporary file, if it does not exist.
    $TEMP_PIN_CONF_FILE = $PIN_HOME."/".$IDS_TEMP_PIN_CONF;
    open( PINCONFFILE, ">> $TEMP_PIN_CONF_FILE" );
    close( PINCONFFILE );

    &ReplacePinConfEntries( "$TEMP_PIN_CONF_FILE", %PIN_BILL_CYCLE_ENTRIES );

    # Display a message saying to append this file to cm/pin.conf file.
    &Output( STDOUT, $IDS_APPEND_PIN_CONF_MESSAGE,
                        $CM{'location'}."/".$PINCONF,
                        $CurrentComponent,
                        $TEMP_PIN_CONF_FILE );
    }
  if ( ( -e "pin_cmp_pin_billd.pl" ) &&
       ( join ( " ", @COMPONENT_LIST, " " ) =~ /\bpin_billd\b/i ) ) {
      &configure_PriceList( *MAIN_CM, *MAIN_DM );
      &configure_DeviceMgmt( *MAIN_CM, *MAIN_DM );
      &configure_Sepa( *MAIN_CM, *MAIN_DM );
  }
}

sub configure_bus_params {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_bus_params -v $BILLING{'bus_params_file'}" );

   &Output( fpLogFile, $IDS_BUS_PARAMS_LOADING );
   &Output( STDOUT, $IDS_BUS_PARAMS_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_BUS_PARAMS_FAILED );
      &Output( STDOUT, $IDS_BUS_PARAMS_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_BUS_PARAMS_SUCCESS );
      &Output( STDOUT, $IDS_BUS_PARAMS_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_GLCHARTs {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_glchartaccts -v $BILLING{'glchart_file'}" );

   &Output( fpLogFile, $IDS_GLCHART_LOADING );
   &Output( STDOUT, $IDS_GLCHART_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_GLCHART_FAILED );
      &Output( STDOUT, $IDS_GLCHART_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_GLCHART_SUCCESS );
      &Output( STDOUT, $IDS_GLCHART_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_GLIDs {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_glid -v $BILLING{'glid_file'}" );

   &Output( fpLogFile, $IDS_GLIDS_LOADING );
   &Output( STDOUT, $IDS_GLIDS_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_GLIDS_FAILED );
      &Output( STDOUT, $IDS_GLIDS_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_GLIDS_SUCCESS );
      &Output( STDOUT, $IDS_GLIDS_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_RUMs {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_rum $BILLING{'rums_file'}" );

   &Output( fpLogFile, $IDS_RUMS_LOADING );
   &Output( STDOUT, $IDS_RUMS_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_RUMS_FAILED );
      &Output( STDOUT, $IDS_RUMS_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_RUMS_SUCCESS );
      &Output( STDOUT, $IDS_RUMS_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_UsageMap {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "$PIN_HOME/bin/load_usage_map $BILLING{'usage_file'}" );

   &Output( fpLogFile, $IDS_USAGE_LOADING );
   &Output( STDOUT, $IDS_USAGE_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_USAGE_FAILED );
      &Output( STDOUT, $IDS_USAGE_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_USAGE_SUCCESS );
      &Output( STDOUT, $IDS_USAGE_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_PinEventMap {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "$PIN_HOME/bin/load_event_map $BILLING{'event_map_file'}" );

   &Output( fpLogFile, $IDS_EVENT_LOADING );
   &Output( STDOUT, $IDS_EVENT_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_EVENT_FAILED );
      &Output( STDOUT, $IDS_EVENT_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_EVENT_SUCCESS );
      &Output( STDOUT, $IDS_EVENT_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_BEIDs {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_beid $BILLING{'beid_file'}" );

   &Output( fpLogFile, $IDS_BEIDS_LOADING );
   &Output( STDOUT, $IDS_BEIDS_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_BEIDS_FAILED );
      &Output( STDOUT, $IDS_BEIDS_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_BEIDS_SUCCESS );
      &Output( STDOUT, $IDS_BEIDS_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_SpecRates {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_spec_rates $BILLING{'spec_rates_file'}" );

   &Output( fpLogFile, $IDS_SPEC_RATES_LOADING );
   &Output( STDOUT, $IDS_SPEC_RATES_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_SPEC_RATES_FAILED );
      &Output( STDOUT, $IDS_SPEC_RATES_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_SPEC_RATES_SUCCESS );
      &Output( STDOUT, $IDS_SPEC_RATES_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_ImpactCategories {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_impact_category $BILLING{'impact_file'}" );

   &Output( fpLogFile, $IDS_IMPACT_LOADING );
   &Output( STDOUT, $IDS_IMPACT_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_IMPACT_FAILED );
      &Output( STDOUT, $IDS_IMPACT_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_IMPACT_SUCCESS );
      &Output( STDOUT, $IDS_IMPACT_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_PriceList {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $Sep );

   open( PROPFILE, "> $PIN_HOME/apps/load_price_list/Infranet.properties" ) || die( "Can't open Infranet.properties" );
   print PROPFILE "infranet.connection=pcp://root.$DM{'db_num'}:\&aes|08|0D5E11BFDD97D2769D9B0DBFBD1BBF7E5D40C305EDF3D77DF111AAB8F781E92122\@$CM{'hostname'}:$MAIN_CM{'port'}/$DM{'db_num'} /service/admin_client 1\n";
   print PROPFILE "infranet.login.type=1\n";
   print PROPFILE "infranet.log.level=1\n";
   print PROPFILE "infranet.log.logallebuf=true\n";
   print PROPFILE "infranet.flist.tostring.enable=true\n";
   print PROPFILE " # To enable SSL, make sure to provide correct values for below config entries. e.g wallet location and filename etc.\n";
   print PROPFILE "infranet.pcp.ssl.enabled = false\n";
   print PROPFILE "infranet.pcp.ssl.wallet.location = PIN_HOME/wallet/client\n";
   print PROPFILE "infranet.pcp.ssl.wallet.filename = cwallet.sso\n";	
   close( PROPFILE );

   if ( $^O =~ /win/i ) {
     $header = "";    
     $Pref = "@";
     $Sep = ";";
     $wild = "\%*";
     $extension = ".bat";
   } else {
     $header = "#!/bin/sh";
     $Pref = "";
     $Sep = ":";
     $wild = "\$\@";
     $extension = "";
   }
   $Cmd = &FixSlashes($header."\n" 
		       .$Pref."$ENV{'BRM_JRE'}/bin/java -cp \"$PIN_HOME/jars/loadpricelist.jar".$Sep
		       ."$PIN_HOME/jars/xercesImpl.jar".$Sep
		       ."$PIN_HOME/jars/xmlParserAPIs.jar".$Sep
		       ."$PIN_HOME/jars/pcm.jar".$Sep
		       ."$PIN_HOME/jars/pcmext.jar".$Sep
		       ."$PIN_HOME/jars/oraclepki.jar".$Sep
		       ."$PIN_HOME/jars/osdt_cert.jar".$Sep
		       ."$PIN_HOME/jars/osdt_core.jar".$Sep
		       ."$PIN_HOME/apps/load_price_list\" com.portal.loadpricelist.LoadPriceList \"$wild\"" );
   open( BATCHFILE, "> $PIN_HOME/bin/loadpricelist$extension" );
   print BATCHFILE $Cmd;
   close( BATCHFILE );
      chmod 0755, "$PIN_HOME/bin/loadpricelist$extension";
}


sub setupLoad_PriceList {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $Sep );

   #
   # Restart the CM to clear cached Information
   #
   &Stop( $ServiceName{ 'cm' } );
   sleep( 6 );
   &Start( $ServiceName{ 'cm' } );
   sleep( 30 );

   &Output( fpLogFile, $IDS_PRICE_LOADING );
   &Output( STDOUT, $IDS_PRICE_LOADING );

   if ( $SETUP_INIT_DB =~ /^YES$/i ) {
      $Cmd = &FixSlashes( "loadpricelist$extension -f -v -c $BILLING{'price_list_file'}" );

      $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

      if( $Cmd != 0 ) {
         &Output( fpLogFile, $IDS_PRICE_FAILED );
         &Output( STDOUT, $IDS_PRICE_FAILED );
         exit -1;
      } else {
         &Output( fpLogFile, $IDS_PRICE_SUCCESS );
         &Output( STDOUT, $IDS_PRICE_SUCCESS );
      }
      unlink( "$PIN_TEMP_DIR/tmp.out" );
   }
}

sub configure_DeviceMgmt {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $Sep );

   open( PROPFILE, "> $PIN_HOME/apps/device_management/Infranet.properties" ) || die( "Can't open Infranet.properties" );
   print PROPFILE "infranet.connection=pcp://root.$DM{'db_num'}:\&aes|08|0D5E11BFDD97D2769D9B0DBFBD1BBF7E5D40C305EDF3D77DF111AAB8F781E92122\@$CM{'hostname'}:$MAIN_CM{'port'}/$DM{'db_num'} /service/admin_client 1\n";
   print PROPFILE "infranet.login.type=1\n";
   print PROPFILE "infranet.log.file=./default.pinlog\n";
   print PROPFILE "infranet.log.level=1\n";
   print PROPFILE "infranet.log.logallebuf=true\n";
   print PROPFILE "# To enable SSL, make sure to provide correct values for below config entries. e.g wallet location and filename etc.\n";
   print PROPFILE "infranet.pcp.ssl.enabled = false\n";
   print PROPFILE "infranet.pcp.ssl.wallet.location = PIN_HOME/wallet/client\n";
   print PROPFILE "infranet.pcp.ssl.wallet.filename = cwallet.sso\n";	
   close( PROPFILE );

   &Output( fpLogFile, $IDS_DEVICE_MGMT_LOADING );
   &Output( STDOUT, $IDS_DEVICE_MGMT_LOADING );
   if ( $^O =~ /win/i ) {
     $Pref = "@";
     $Sep = ";";
     $wild = "\%*";
     $extension = ".bat";
   } else {
     $Pref = "";
     $Sep = ":";
     $wild = "\$*";
     $extension = "";
   }

   # Create 'load_pin_device_permit_map' script file #
   $Cmd = &FixSlashes( $Pref."$ENV{'BRM_JRE'}/bin/java -cp \"$PIN_HOME/jars/pcm.jar".$Sep
		       ."$PIN_HOME/jars/pcmext.jar".$Sep
		       ."$PIN_HOME/jars/oraclepki.jar".$Sep
		       ."$PIN_HOME/jars/osdt_cert.jar".$Sep
		       ."$PIN_HOME/jars/osdt_core.jar".$Sep
           ."$PIN_HOME/jars/pfc.jar".$Sep
           ."$PIN_HOME/jars/xmlParserAPIs.jar".$Sep
           ."$PIN_HOME/apps/device_management\" com.portal.common.LoadDevicePermitMap $wild" );
   open( BATCHFILE, "> $PIN_HOME/bin/load_pin_device_permit_map$extension" );
   print BATCHFILE $Cmd;
   close( BATCHFILE );
   chmod 0755, "$PIN_HOME/bin/load_pin_device_permit_map$extension";

   # Create 'load_pin_device_state' script file #
   $Cmd = &FixSlashes( $Pref."$ENV{'BRM_JRE'}/bin/java -cp \"$PIN_HOME/jars/pcm.jar".$Sep
		       ."$PIN_HOME/jars/pcmext.jar".$Sep
		       ."$PIN_HOME/jars/oraclepki.jar".$Sep
		       ."$PIN_HOME/jars/osdt_cert.jar".$Sep
		       ."$PIN_HOME/jars/osdt_core.jar".$Sep
           ."$PIN_HOME/jars/pfc.jar".$Sep
           ."$PIN_HOME/jars/xmlParserAPIs.jar".$Sep
           ."$PIN_HOME/apps/device_management\" com.portal.common.LoadDeviceState $wild" );
   open( BATCHFILE, "> $PIN_HOME/bin/load_pin_device_state$extension" );
   print BATCHFILE $Cmd;
   close( BATCHFILE );
   chmod 0755, "$PIN_HOME/bin/load_pin_device_state$extension";
}

sub configure_BusinessType {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "load_pin_config_business_type $BILLING{'config_business_type_file'}" );

   &Output( fpLogFile, $IDS_BUSINESS_TYPE_LOADING );
   &Output( STDOUT, $IDS_BUSINESS_TYPE_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_BUSINESS_TYPE_FAILED );
      &Output( STDOUT, $IDS_BUSINESS_TYPE_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_BUSINESS_TYPE_SUCCESS );
      &Output( STDOUT, $IDS_BUSINESS_TYPE_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_ACH {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "load_pin_ach $BILLING{'config_ach_file'}" );

   &Output( fpLogFile, $IDS_ACH_LOADING );
   &Output( STDOUT, $IDS_ACH_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_ACH_FAILED );
      &Output( STDOUT, $IDS_ACH_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_ACH_SUCCESS );
      &Output( STDOUT, $IDS_ACH_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_Contributor {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "load_pin_sub_bal_contributor $BILLING{'config_contributor_file'}" );

   &Output( fpLogFile, $IDS_CONTRIBUTOR_LOADING );
   &Output( STDOUT, $IDS_CONTRIBUTOR_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_CONTRIBUTOR_FAILED );
      &Output( STDOUT, $IDS_CONTRIBUTOR_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_CONTRIBUTOR_SUCCESS );
      &Output( STDOUT, $IDS_CONTRIBUTOR_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_Transition {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();

   $Cmd = &FixSlashes( "load_transition_type $BILLING{'transition_file'}" );

   &Output( fpLogFile, $IDS_TRANSITION_LOADING );
   &Output( STDOUT, $IDS_TRANSITION_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_TRANSITION_FAILED );
      &Output( STDOUT, $IDS_TRANSITION_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_TRANSITION_SUCCESS );
      &Output( STDOUT, $IDS_TRANSITION_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_EventRecordMap {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $CurrentDir ) = cwd();
                      
   $Cmd = &FixSlashes( "load_pin_event_record_map -v $BILLING{'event_record_map'}" );

   &Output( fpLogFile, $IDS_EVENT_RECORD_MAP_LOADING );
   &Output( STDOUT, $IDS_EVENT_RECORD_MAP_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_EVENT_RECORD_MAP_FAILED );
      &Output( STDOUT, $IDS_EVENT_RECORD_MAP_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_EVENT_RECORD_MAP_SUCCESS );
      &Output( STDOUT, $IDS_EVENT_RECORD_MAP_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
}

sub configure_Sepa {
   local( *CM ) = shift( @_ );
   local( *DM ) = shift( @_ );

   local( $Cmd );
   local( $Sep );

   open( PROPFILE, "> $PIN_HOME/apps/pin_sepa/Infranet.properties" ) || die( "Can't open Infranet.properties" );
   print PROPFILE "infranet.connection=pcp://root.$DM{'db_num'}:\&aes|08|0D5E11BFDD97D2769D9B0DBFBD1BBF7E5D40C305EDF3D77DF111AAB8F781E92122\@$CM{'hostname'}:$MAIN_CM{'port'}/$DM{'db_num'} /service/admin_client 1\n";
   print PROPFILE "infranet.login.type=1\n";
   print PROPFILE "infranet.log.level=1\n";
   print PROPFILE "infranet.log.file=./pin_sepa.pinlog\n\n";

   print PROPFILE "# Path for xml document generation\n";
   print PROPFILE "infranet.sepa_dd_req_dir.path=$PIN_HOME/apps/pin_sepa/sepa_dd\n";
   print PROPFILE "infranet.sepa_ct_req_dir.path=$PIN_HOME/apps/pin_sepa/sepa_ct\n";
   print PROPFILE "infranet.sepa_rev_req_dir.path=$PIN_HOME/apps/pin_sepa/sepa_rev\n\n";
   
   print PROPFILE "# Path for response xml documents\n";
   print PROPFILE "infranet.sepa_resp_dir.path=$PIN_HOME/apps/pin_sepa/sepa_resp/input\n\n";

   print PROPFILE "# Threading Parameters - Performance Tuning\n";
   print PROPFILE "infranet.threadpool.size=3\n";
   print PROPFILE "infranet.threadpool.maxsize=5\n";
   print PROPFILE "infranet.threadpool.fetchsize=100\n\n";
   
   print PROPFILE "# Specify the Chargebearer. The value could be one of the following:\n";
   print PROPFILE "# DEBT, CRED, SHAR, SLEV\n";
   print PROPFILE "infranet.sepa.sddrequest.ChrgBr=SLEV\n";
   print PROPFILE "infranet.sepa.sctrequest.ChrgBr=SLEV\n";
   print PROPFILE "infranet.sepa.sddreversal.ChrgBr=SLEV\n\n";

   print PROPFILE "# Specify the instruction priority\n";
   print PROPFILE "infranet.sepa.sddrequest.InstrPrty=NORM\n";
   print PROPFILE "infranet.sepa.sctrequest.InstrPrty=NORM\n\n";

   print PROPFILE "# Specify the payment method\n";
   print PROPFILE "infranet.sepa.sddrequest.PmtInf.PmtMtd=DD\n";
   print PROPFILE "infranet.sepa.sctrequest.PmtInf.PmtMtd=TRF\n\n";

   print PROPFILE "# Date on which the creditor requests that the amount of money is to be collected from the debtor.\n";
   print PROPFILE "# File must be submitted at least 6 days in advance of this date for first collections and atleast\n";
   print PROPFILE "# 3 days in advance of this data for subsequent collections. Cut off times also apply.\n";
   print PROPFILE "# Date Pattern=YYYY-MM-DD\n";
   print PROPFILE "infranet.sepa.sddrequest.ReqdColltnDt.pattern=yyyy-MM-dd\n";
   print PROPFILE "#infranet.sepa.sddrequest.ReqdColltnDt.value=1984-04-08\n";
   print PROPFILE "infranet.sepa.sctrequest.ReqdExctnDt.pattern=yyyy-MM-dd\n";
   print PROPFILE "#infranet.sepa.sctrequest.ReqdExctnDt.value=1984-04-08\n\n";

   print PROPFILE "# To enable SSL, make sure to provide correct values for below config entries. e.g wallet location and filename etc.\n";
   print PROPFILE "infranet.pcp.ssl.enabled = false\n";
   print PROPFILE "infranet.pcp.ssl.wallet.location = $PIN_HOME/wallet/client\n";
   print PROPFILE "infranet.pcp.ssl.wallet.filename = cwallet.sso\n\n";

   print PROPFILE "# Specify Name and Id of the Initiating Party.\n";
   print PROPFILE "#infranet.sepa.sddrequest.InitgPty.Nm=\n";
   print PROPFILE "#infranet.sepa.sddrequest.InitgPty.OrgId=\n";
   print PROPFILE "#infranet.sepa.sctrequest.InitgPty.Nm=\n";
   print PROPFILE "#infranet.sepa.sctrequest.InitgPty.OrgId=\n";
   print PROPFILE "#infranet.sepa.sddreversal.InitgPty.Nm=\n";
   print PROPFILE "#infranet.sepa.sddreversal.InitgPty.OrgId=\n\n";

   print PROPFILE "infranet.sepa.sddrequest.PmtTpInf.LclInstrm=CORE\n";
   print PROPFILE "infranet.sepa.sddrequest.PmtTpInf.SvcLvl=SEPA\n";
   print PROPFILE "infranet.sepa.sctrequest.PmtTpInf.LclInstrm=CORE\n";
   print PROPFILE "infranet.sepa.sctrequest.PmtTpInf.SvcLvl=SEPA\n\n";

   print PROPFILE "#Custom class Implementation for Sepa DD/Sepa CT/Sepa reversal\n";
   print PROPFILE "#infranet.sepa_dd_custom_class=com.brm.customDD.class\n";
   print PROPFILE "#infranet.sepa_ct_custom_class=com.brm.customCT.class\n";
   print PROPFILE "#infranet.sepa_reversal_custom_class=com.brm.customRev.class\n\n";

   close( PROPFILE );

   if ( $^O =~ /win/i ) {
     $header = "";
     $Pref = "@";
     $Sep = ";";
     $wild = "\%*";
     $extension = ".bat";
   } else {
     $header = "#!/bin/sh";
     $Pref = "";
     $Sep = ":";
     $wild = "\$\@";
     $extension = "";
   }
   $Cmd = &FixSlashes($header."\n"
                       .$Pref."$ENV{'BRM_JRE'}/bin/java -cp \"$PIN_HOME/jars/sepa.jar".$Sep
                       ."$PIN_HOME/jars/pcm.jar".$Sep
                       ."$PIN_HOME/jars/pcmext.jar".$Sep
                       ."$PIN_HOME/jars/pfc.jar".$Sep
                       ."$PIN_HOME/jars/oraclepki.jar".$Sep
                       ."$PIN_HOME/jars/osdt_cert.jar".$Sep
                       ."$PIN_HOME/jars/osdt_core.jar".$Sep
                       ."$PIN_HOME/apps/pin_sepa\" sepapp.PinSepaProcess \"$wild\"" );
   open( BATCHFILE, "> $PIN_HOME/bin/pin_sepa$extension" );
   print BATCHFILE $Cmd;
   close( BATCHFILE );
   chmod 0755, "$PIN_HOME/bin/pin_sepa$extension";
}


#####
#
# Additional configuration after Portal processes have started
#
#####
sub configure_pin_billd_post_restart {
  #
  # Let's load all the post installation information
  #
  if ( ( -e "pin_cmp_pin_billd.pl" ) &&
       ( $SETUP_INIT_DB =~ /^YES$/i ) &&
       ( join ( " ", @COMPONENT_LIST, " " ) =~ /\bpin_billd\b/i ) ) {
      &configure_bus_params( *MAIN_CM, *MAIN_DM );
      &configure_GLCHARTs( *MAIN_CM, *MAIN_DM );
      &configure_GLIDs( *MAIN_CM, *MAIN_DM );
      &configure_RUMs( *MAIN_CM, *MAIN_DM );
      &configure_UsageMap( *MAIN_CM, *MAIN_DM );
      &configure_PinEventMap( *MAIN_CM, *MAIN_DM );
      &configure_BEIDs( *MAIN_CM, *MAIN_DM );
      &configure_SpecRates( *MAIN_CM, *MAIN_DM );
      &configure_ImpactCategories( *MAIN_CM, *MAIN_DM );      
      &configure_BusinessType( *MAIN_CM, *MAIN_DM );
      &configure_ACH( *MAIN_CM, *MAIN_DM );
      &configure_Contributor( *MAIN_CM, *MAIN_DM );
      &configure_Transition( *MAIN_CM, *MAIN_DM );
      &configure_EventRecordMap( *MAIN_CM, *MAIN_DM );      
      &setupLoad_PriceList( *MAIN_CM, *MAIN_DM );
      &load_config_note_status();
      &load_config_note_type(); 
  }

  #
  # Let's load the localized strings
  #

  &load_localized_strings_errors_en();
  &load_localized_strings_locale_desc();
  &load_localized_strings_reasons_en();
  &load_localized_strings_era_descr_en();
  &load_localized_strings_payment_channel();
  &load_localized_strings_lifecycle_states_en();
  &load_localized_strings_active_mediation_en();
  &load_localized_strings_collections_en();
  &load_localized_strings_note_en();
}

sub load_config_note_status {
  my $load_file = "$PIN_HOME/sys/data/config/config_note_status.xml";

  load_config( $load_file );
}

sub load_config_note_type {
  my $load_file = "$PIN_HOME/sys/data/config/config_note_type.xml";

  load_config( $load_file );
}

sub load_localized_strings_errors_en {

  my $load_file = "$PIN_HOME/sys/msgs/errorcodes/errors.en_US";

  load_strings( $load_file );
}

sub load_localized_strings_locale_desc {
  my $load_file = "$PIN_HOME/sys/msgs/localedescr/locale_descr.en_US";

  load_strings( $load_file );
}

sub load_localized_strings_reasons_en {
  my $load_file = "$PIN_HOME/sys/msgs/reasoncodes/reasons.en_US";

  load_strings( $load_file );
}

sub load_localized_strings_era_descr_en {
  my $load_file = "$PIN_HOME/sys/msgs/eradescr/era_descr.en_US";

  load_strings( $load_file );
}
  
sub load_localized_strings_payment_channel {
  my $load_file = "$PIN_HOME/sys/msgs/paymentchannel/payment_channel.en_US";

  load_strings( $load_file );
}

sub load_localized_strings_lifecycle_states_en {

  my $load_file = "$PIN_HOME/sys/msgs/lifecycle_states/lifecycle_states.en_US";

  load_strings( $load_file );
}


sub load_localized_strings_active_mediation_en {

  my $load_file = "$PIN_HOME/sys/msgs/active_mediation/active_mediation.en_US";

  load_strings( $load_file );
}

sub load_localized_strings_collections_en {

  my $load_file = "$PIN_HOME/sys/msgs/collections/collections.en_US";

  load_strings( $load_file );
}


sub load_localized_strings_note_en {

  my $load_file = "$PIN_HOME/sys/msgs/note/note.en_US";

  load_strings( $load_file );
}

sub load_config {

    my $file = shift(@_);

    if ( ( -e $file ) && ( $SETUP_INIT_DB =~ /^YES$/i ) ) {
	
	local ($Cmd);
	&Output( fpLogFile, $IDS_NOTE_CONFIG_LOADING);
	&Output( STDOUT, $IDS_NOTE_CONFIG_LOADING);
	
	$Cmd = &FixSlashes( "$PIN_HOME/bin/load_config -v $file");
	$Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

	if( $Cmd != 0 ) {
		&Output( fpLogFile, $IDS_NOTE_CONFIG_FAILED );
		&Output( STDOUT, $IDS_NOTE_CONFIG_FAILED );
		exit -1;
	} else {
		&Output( fpLogFile, $IDS_NOTE_CONFIG_SUCCESS );
		&Output( STDOUT, $IDS_NOTE_CONFIG_SUCCESS );
	}
    }
}

sub load_strings {

  my $file = shift(@_);

# Removing this condition in the below if statement
# ( join ( " ", @COMPONENT_LIST, " " ) =~ /\bpin_billd\b/i ) )
# COMPONENT_LIST may not contain pin_billd if pin_setup -all is being run
# after installing multiple optional managers
# This is the case even in upgraded environment

  if ( ( -e $file ) && 
       ( $SETUP_INIT_DB =~ /^YES$/i ) ) {
    local ($Cmd);

    &Output( fpLogFile, $IDS_MSGS_LOADING );
    &Output( STDOUT, $IDS_MSGS_LOADING );

    $Cmd = &FixSlashes( "$PIN_HOME/bin/load_localized_strings $file");
    $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

    if( $Cmd != 0 ) {
       &Output( fpLogFile, $IDS_MSGS_FAILED );
       &Output( STDOUT, $IDS_MSGS_FAILED );
       exit -1;
    } else {
       &Output( fpLogFile, $IDS_MSGS_SUCCESS );
       &Output( STDOUT, $IDS_MSGS_SUCCESS );
    }
  }
}

  
1;
