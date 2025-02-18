#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=======================================================================
#  @(#)%Portal Version: pin_setup.pl:PortalBase7.3.1Int:1:2007-Sep-11 23:43:12 %
# 
# Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Main Perl script for the Portal installation
#
#=============================================================

use Cwd;
require "pin_res.pl";
require "pin_functions.pl";
require "../pin_setup.values";

$RUNNING_IN_PIN_SETUP = TRUE;

$StartTime = localtime(time());


#
#Run pin_setup for a particular product by passing the product name as arguments and
#Run pin_setup for all products by passing the argument "-all"
# usage:  pin_setup.pl <product_name> or 
#	  pin_setup.pl -all
#
#  product_name - Name of the product to be present in the PRODUCT_LIST array of pin_etup.values.  


if ( @ARGV && $ARGV[0] !~ /-all/) {
	@PRODUCT_LIST = reverse @PRODUCT_LIST;
	undef(@COMPONENT_LIST);
	foreach $arg (@ARGV) {			   
	   if(grep(/^$arg$/,@PRODUCT_LIST)) {  	      
	      print "configuring for $arg \n";
	      push(@COMPONENT_LIST,@$arg);
	      print "\nConfiguring pin_setup for $arg\n";
	      &call_pinsetup();
	      undef(@COMPONENT_LIST);
	      }
	   else {
	      print "$arg is not present in the  @PRODUCT_LIST array of pin_setup.values\n";
	   }
	}
}

if ($ARGV[0] =~ /-all/) {
	print "\n Configuring pin_setup for the all the products\n";
	undef(@COMPONENT_LIST);
	@MY_PRODUCT_LIST = reverse @PRODUCT_LIST;
	foreach $prod(@MY_PRODUCT_LIST) {	   
	   print "configuring for $prod \n";
	   push(@COMPONENT_LIST,@$prod);
	   print "\nConfiguring pin_setup for $prod\n";
	   &call_pinsetup();
	   undef(@COMPONENT_LIST);	   
	}
}
		   
#
#Existing method of calling pin_setup for last installed product
#need to be removed once started using PRODUCT_LIST array
#

if (!@ARGV) {
    &call_pinsetup();
}
		   
sub call_pinsetup {
#
# Open the log file for installation
#
&OpenLogFile( $SETUP_LOG_FILENAME, $SETUP_LOG_ACCESS_TYPE );
&Output( fpLogFile, $IDS_LOG_TIME, $StartTime );
&Output( STDOUT, $IDS_SHOW_TIME, $StartTime );
if( ! exists ($ENV{'PIN_HOME'}) )
{
  &Output( STDOUT,$IDS_ENV_VARIABLES_NOT_FOUND,"\$PIN_HOME");
  exit;
}
if( ! -e "$ENV{'PIN_HOME'}" )
{
  &Output( STDOUT,$IDS_ENV_VARIABLES_PATH_INVALID,"\$PIN_HOME");
  exit;
}
if(! exists ( $ENV{'PIN_LOG_DIR'}) )
{
  &Output( STDOUT,$IDS_ENV_VARIABLES_NOT_FOUND,"\$PIN_LOG_DIR");
  exit;
}
if(! -e "$ENV{'PIN_LOG_DIR'}" )
{
  &Output( STDOUT,$IDS_ENV_VARIABLES_PATH_INVALID,"\$PIN_LOG_DIR");
  exit;
}


if ( $^O !~ /win/i )
{
	if(! exists ( $ENV{'LIBRARYPREFIX'}) )
  	{
  		&Output( STDOUT,$IDS_ENV_VARIABLES_NOT_FOUND,"\$LIBRARYPREFIX");
 		 exit;
	}
}

if(! exists ( $ENV{'LIBRARYEXTENSION'}) )
{
  &Output( STDOUT,$IDS_ENV_VARIABLES_NOT_FOUND,"\$LIBRARYEXTENSION");
  exit;
}

#
# Verify the sanity of the database if dm_oracle dm_odbc or dm_db2 is selected
#
if ( join ( " ", @COMPONENT_LIST ) =~ /(\bdm_oracle\b|\bdm_odbc\b|\bdm_db2\b)/i ) {
  ($DB_TYPE = $1) =~ s/dm_//;
  eval qq!require "pin_".$DB_TYPE."_functions.pl"!;
  if ( $CREATE_DATABASE_TABLES =~ /YES/i )
  {
    &VerifyLogin( "system", %MAIN_DB );
  }
  else
  {
    &VerifyLogin( "portal", %MAIN_DB );
  }
}


#
# Adjust the order of components in @COMPONENT_LIST.
# "cm" must be at the end, with "dm_db2", "dm_odbc" and "dm_oracle" just before "cm".
# This is because the cm/pin.conf creation and the main database configuration must occur first.
#
@TEMP_LIST = ();
$add_cm = "";
$add_dm_db2 = "";
$add_dm_odbc = "";
$add_dm_oracle = "";
$i = 0;
foreach $CurrentComponent ( @COMPONENT_LIST ) {
	if ( $CurrentComponent =~ /(\bcm\b|\bdm_db2\b|\bdm_odbc\b|\bdm_oracle\b)/i )
	{
		# Set flags if these special components are found.
		if ( $CurrentComponent =~ /^cm$/i ) { $add_cm = "y" };
		if ( $CurrentComponent =~ /^dm_db2$/i ) { $add_db2 = "y" };
		if ( $CurrentComponent =~ /^dm_odbc$/i ) { $add_dm_odbc = "y" };
		if ( $CurrentComponent =~ /^dm_oracle$/i ) { $add_dm_oracle = "y" };
	}
	elsif ( $CurrentComponent =~ /[a-z]+/ )
	{
		# Add the regular components to the list.
		$TEMP_LIST[$i++] = $CurrentComponent;
	}
}
# Add these special components to the end of the list.
if ( $add_db2 =~ /^y$/ )        { $TEMP_LIST[$i++] = "dm_db2" };
if ( $add_dm_odbc =~ /^y$/ )    { $TEMP_LIST[$i++] = "dm_odbc" };
if ( $add_dm_oracle =~ /^y$/ )  { $TEMP_LIST[$i++] = "dm_oracle" };
if ( $add_cm =~ /^y$/ )         { $TEMP_LIST[$i++] = "cm" };
$TEMP_LIST[$i] = "";
@COMPONENT_LIST = @TEMP_LIST;


#
# For each component in the list (starting at the end), configure their pin.conf
# entries and their database
#
@TEMP_LIST = reverse( @COMPONENT_LIST );
foreach $CurrentComponent ( @TEMP_LIST ) {
   #
   # Is this a real component or is this just a stub for starting and stopping
   # 
   eval qq!require "pin_cmp_$CurrentComponent.pl"!;

   #
   # If the pre-configure script is there, run it.
   #
   &pre_configure;
     
   $skip = eval '$setup_execute_pin_cmp_'.$CurrentComponent;

   if ( $skip eq TRUE ) {
      &Output( fpLogFile, $IDS_SCRIPT_SKIPPED, "pin_cmp_$CurrentComponent.pl" );
      &Output( STDOUT, $IDS_SCRIPT_SKIPPED, "pin_cmp_$CurrentComponent.pl" );
   } else {

      # Make sure the component is stopped
      if ( $ServiceName{ $CurrentComponent } !~ /^$/ ) {
          &Stop( $ServiceName{ $CurrentComponent } );
      }

      #
      # if the function for configure_xxx_config file is defined, call it
      #
      $function_name = "configure_$CurrentComponent"."_config_files";
      if ( ( $SETUP_CONFIGURE =~ /^YES$/i ) &&
           ( defined ( &$function_name ) ) ) {
         #&Output( STDOUT, $IDS_CONFIGURING_PIN_CONF, $CurrentComponent );
         #&Output( fpLogFile, $IDS_CONFIGURING_PIN_CONF, $CurrentComponent );
         eval "&configure_$CurrentComponent"."_config_files;";
      }
      $function_name = "configure_$CurrentComponent"."_database";
      if ( ( $SETUP_INIT_DB =~ /^YES$/i ) &&  
           ( defined( &$function_name ) ) ) {
    	 &Output( STDOUT, $IDS_CONFIGURING_DATABASE, $CurrentComponent );
         &Output( fpLogFile, $IDS_CONFIGURING_DATABASE, $CurrentComponent );
         eval '&configure_'.$CurrentComponent.'_database;';
      }
   }
   #
   # If there is a post-install script there, run it
   # 
   &post_configure;

}
#
# Encrypt passwords in config. files
#
if (-e "encryptpassword.pl") {
  my $my_cmd = "./encryptpassword.pl pin_setup";
  my $ret = system($my_cmd);
  if ($ret >> 8 != 0) {
     print "fail to run $my_cmd. Reason: $! \n val is $? \n";
  }
}

#
# Make sure the CM is stopped before starting all components.
#
if ( -f $MAIN_CM{'location'}."/".$PINCONF )
{
    &Stop( $ServiceName{ "cm" } );
    sleep( 10 );
}

#
# Stop & Start all the components 
#
foreach $CurrentComponent ( @COMPONENT_LIST ) {
      if ( $ServiceName{ $CurrentComponent } !~ /^$/ ) {
        &Output( STDOUT, $IDS_STARTING, $CurrentComponent );
        &Output( fpLogFile, $IDS_STARTING, $CurrentComponent );
        &Stop( $ServiceName{ "$CurrentComponent" } );
        &Start( $ServiceName{ "$CurrentComponent" } );
      }
}

#
# Make sure the CM is started incase CM is not in the COMPONENT list.
#
if  ( join ( " ", @COMPONENT_LIST, " " ) !~ /\bcm\b/i ) {
		&Start( $ServiceName{ 'cm' } );
		sleep( 10 );
}

#
# We should now have Portal up and running. If testnap is present,
# let's test out our connection
#
if ( ( join ( " ", @COMPONENT_LIST, " " ) =~ /\btestnap\b/i ) &&
     ( join ( " ", @COMPONENT_LIST, " " ) =~ /\bcm\b/i ) &&
     ( $SETUP_INIT_DB =~ /^YES$/i ) ) {
  &WaitWithDots( $IDS_WAITING_FOR_PORTAL, 50 );
  &testnap_TestConnection( %MAIN_CM );
}


#
# Do additional configuration after all components have been started 
#
foreach $CurrentComponent ( @COMPONENT_LIST ) {
      $function_name = "configure_$CurrentComponent"."_post_restart";
      if ( ( $SETUP_INIT_DB =~ /^YES$/i ) &&
	   ( defined( &$function_name ) ) ) {
         eval '&configure_'.$CurrentComponent.'_post_restart;';
      }
}


#
# Do any final configuration for all components
#
foreach $CurrentComponent ( @COMPONENT_LIST ) {
      $function_name = "configure_$CurrentComponent"."_post_configure";
      if ( defined( &$function_name ) ) {
         eval '&configure_'.$CurrentComponent.'_post_configure;';
      }
}

#
# change permission for config. files post restart
#
if (-e "encryptpassword.pl") {
  my $my_cmd = "./encryptpassword.pl pin_setup_chmod";
  my $ret = system($my_cmd);
  if ($ret >> 8 != 0) {
     print "fail to run $my_cmd. Reason: $! \n val is $? \n";
  }
}

# Restart the CM to clear cached Information
if ( ( join ( " ", @COMPONENT_LIST, " " ) =~ /\bcm\b/i ) &&
     ( $SETUP_INIT_DB =~ /^YES$/i ) ) {
      &Output( STDOUT, $RESTARTING_CM ); 
      &Output( fpLogFile, $RESTARTING_CM ); 
      if ( $ServiceName{ 'cm' } !~ /^$/ ) {
        &Stop( $ServiceName{ 'cm' } );
	sleep( 6 );
        &Start( $ServiceName{ 'cm' } );
	sleep( 10 );
      }
}
   

$partlog = "partition_utils.log";

if(-e $partlog) {
  open(PARTUTIL, "$partlog");
  $errlog=1;
  &Err_Validation();
}
else {
  &Output( fpLogFile, $IDS_SUCCESS );
  &Output( STDOUT, $IDS_SUCCESS );
}

sub Err_Validation {
  while(<PARTUTIL>) {
    if($_=~/ERROR/) {
       print"Your installation has completed with errors \nLook into partition_utils.log for detail error messages \n";
       exit ( 0 );
       $errlog=0;
    }
  }

  if($errlog){
    &Output( fpLogFile, $IDS_SUCCESS );
    &Output( STDOUT, $IDS_SUCCESS );
  }

}

}

exit ( 0 );
