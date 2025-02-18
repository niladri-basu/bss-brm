#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_testnap.pl:InstallVelocityInt:1:2005-Mar-25 18:13:21 %
# 
# Copyright (c) 1999, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the Testnap Component
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
# Configure testnap files
#
#####
sub configure_testnap_config_files {
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;

  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &Configure_PinCnf( $TESTNAP{'location'}."/".$PINCONF, 
                     $CONNECT_PINCONF_HEADER, 
                     %CONNECT_PINCONF_ENTRIES );
}

######
#
# Test the connection to Portal Base
#
######
sub testnap_TestConnection {
   local( %CM ) = @_;
   local( %DM ) = %MAIN_DM;
   local ( $NumTries ) = 0;
   local ( $Connected ) = 0;

   local( $Cmd );
   local( $Return );
   local( $CurrentDir ) = cwd();
   &ReadIn_PinCnf( "pin_cnf_connect.pl" );
   chdir( $PIN_TEMP_DIR );
   &Configure_PinCnf( "$PIN_TEMP_DIR/".$PINCONF, 
                      $CONNECT_PINCONF_HEADER, 
                      %CONNECT_PINCONF_ENTRIES );
   $Cmd = &FixSlashes( "$PIN_HOME/bin/testnap" );
   $Cmd = "echo q | ".$Cmd; 
   
   while ( ( $NumTries < 30 ) && ($Connected == 0) ) {
     $Return = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", FALSE, $Cmd, "" );
     # Let's see if it really failed
     
        open( OUTPUTFILE, "< $PIN_TEMP_DIR/tmp.out" );
	$string = "";
 	while (<OUTPUTFILE> ){$string = $string.$_;};
	close( OUTPUTFILE);
        if ( $string =~ /ERROR:.*PIN_ERR_NAP_CONNECT_FAILED/ ) {
	     # May not be up yet, let's try again
	     $NumTries = $NumTries + 1;
 	     sleep( 10 );
	  } elsif ( $string =~ /===\> database/ ) {
	      # Success !
 	      $Connected = 1;
              &Output( fpLogFile, $IDS_TESTNAP_SUCCESS );
              &Output( STDOUT, $IDS_TESTNAP_SUCCESS );
          } else {
              # Failed for other reason !!
	      $NumTries = 40;
	      $Connected = 0;
  	  }
        }

        unlink( "$PIN_TEMP_DIR/tmp.out" );
        unlink( "$PIN_TEMP_DIR/pin.conf" );
        chdir( $CurrentDir );
	if ( $Connected == 0 ) {
	   &Output( fpLogFile, $IDS_TESTNAP_FAILED );
	   &Output( STDOUT, $IDS_TESTNAP_FAILED );
	   exit -1;
	}
    
}

#######
#
# Configuring database for testnap
#
#######
#sub configure_testnap_config_database {
#}
