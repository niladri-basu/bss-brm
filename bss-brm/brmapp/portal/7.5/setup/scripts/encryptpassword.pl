#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=======================================================================
#@(#)%Portal Version: encryptpassword.pl:PortalBase7.3.1PatchInt:1:2007-Dec-06 02:40:33 %
#
# Copyright (c) 2006, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
##########################################################################
# This script does the following
#
# 1.prompts the user input to encrypt all the password
# 2.encrypts all the passwords present in the pin_setup.values file 
# 3.encrypts all the passwords present in the Infranet.properties file
# 4.encrypts all the CM connect passwords present in the pin.conf file
# 5.encrypts all product specific passwords present in the pin.conf file
# 6.sets config file permission

use lib "/brmapp/portal/7.5/lib";
use aes;
use Cwd;
use File::Find;
use File::stat;
my $version = "2011.05.25";
my $debug = 0;

$home = "/brmapp/portal/7.5";
chdir "$home/setup/scripts";

require "pin_res.pl";
require "pin_functions.pl";
require "../pin_setup.values";
$program_name = $ARGV[0];
#
# Argument options:
#
# (no value) - call all functions
# ISMP -  call only encrypt_pinsetup()
# pin_setup - call all functions without bouncing dm_oracle
# pin_setup_chmod - call only set_permission_post_restart()
#

#
# Components with connection passwords in pin.conf
#
my @conf_files = (
"apps/cmt","sys/dm_opstore","sys/dm_opstore/data","apps/popper","apps/pin_mailer","sys/dm_ldap","apps/exportapps",
"sys/data/pricing/example","apps/pin_billd","apps/pin_trial_bill","apps/load_config","apps/pin_collections","apps/sap/invoice_store",
"apps/sample_handler","apps/pin_rel","apps/sap","/apps/multi_db","apps/pin_clean_rsvns","apps/pin_clean_asos",
"apps/pin_event_extract","apps/pin_crypt","sys/cm_proxy","apps/pin_inv","apps/pin_rerate","apps/pin_ood_handler",
"apps/pin_ood_handler/process","apps/pin_subscription","sys/test","apps/uel","apps/pin_ra_check_thresholds",
"apps/batch_controller","apps/pin_remit","sys/data/config","setup/scripts","/sys/infmgr_cli","source/apps/sampleviewer",
"source/apps/sample","source/apps/mta_sample","apps/pin_rel/gsm/tel","apps/pin_rel/gsm/data","apps/pin_rel/gsm/fax",
"apps/pin_rel/gsm/sms","apps/pin_rel/gsm/tel","apps/pin_rel/gsm/gprs","apps/pin_rate_change","apps/pin_monitor",
"apps/pin_bulk_adjust","apps/pin_bill_handler","apps/pin_balance_transfer","apps/pin_ar_taxes","apps/integrate_sync",
"apps/radius","apps/load_channel_config","apps/pin_export_price","apps/pin_update_poid_to_null","sys/dm_timos",
"apps/load_notification_event","apps/pin_unlock_service","bin/pin_ctl.conf","sys/diagnostics/pin_adu_validate"
);

#
# pin_setup.values password list
#
my @passwordlist = (
"MAIN_DB{'password'}","MAIN_DB{'system_password'}","PRICING_ADMIN{'oracle_admin_passwd'}","PRICING_ADMIN{'odbc_admin_passwd'}",
"INVOICE_DB{'password'}","DM_FDC{'batch_password'}","DM_FDC{'ftp_password'}","DM_FUSA{'presenter_password'}","DM_FUSA{'submitter_password'}",
"DNA{'infmgr_login_pw'}","TERACOMM{'ldap_password'}","DM_IFW_SYNC{'queuing_db_password'}","DM_VERTEX{'db_passwd'}","BERTELSMANN{'fias_ftp_password'}",
"CMT{'passwd'}","CMT{'primarydbpasswd'}","DM_AQ{'queuing_db_password'}","TimesTen_DB{'password'}" 
);

#
# Components with passwords in Infranet.properties
#
my @properties_files = (
"apps/cmt","apps/load_price_list","apps/storable_class_to_xml","apps/device_management","apps/uel","apps/telco","apps/batch_controller",
"apps/pin_rel","apps/pin_rel/gsm/data","apps/pin_rel/gsm/fax","apps/pin_rel/gsm/sms","apps/pin_rel/gsm/tel",
"apps/pin_rel/gsm/gprs","deploy/web_services","sys/amt","sys/formatter"
);

#
# Components with specific passwords in pin.conf
# hash array defined with the pin.conf path as a "key" and pin.conf password entries key as a "value"
#
my %pinconf_enc = (
	     'sys/dm_oracle' => '- dm sm_pw',
	     'sys/dm_odbc' => '- dm sm_pw',
	     'sys/cm' => '- cm infmgr_login_pw',
	     'sys/dm_ifw_sync' => '- dm_ifw_sync sm_pw',
	     'sys/dm_aq' => '- dm_aq	sm_pw',
	     'sys/dm_opstore' => '- cm infmgr_login_pw',
	     'sys/dm_fusa' => '- dm_fusa	pid_pwd',
	     'sys/dm_fusa/' => '- dm_fusa	sid_pwd',
	     'apps/perf/simtools' => '- nap   login_pw',
	     'apps/perf/simtools/' => '- perfmgr password_pattern',
	     'apps/perf/sql_loader' => '- nap   login_pw',
	     'apps/perf/sql_loader/' => '- perfmgr password_pattern',
	     'sys/dm_vertex' => '- dm_vertex  quantumdb_passwd',
	     'setup/scripts' => '- pipeline login_pw',
	     'setup/scripts/' => '- pipeline admin_pw',
	     'sys/dm_ldap' => '- ldap_ds	password'
);
my @pinconf_enc_comps = (
	'sys/dm_oracle',
	'sys/dm_odbc',
	'sys/cm',
	'sys/dm_ifw_sync',
	'sys/dm_aq',
	'sys/dm_opstore',
	'sys/dm_fusa',
	'sys/dm_fusa/',
	'apps/perf/simtools',
	'apps/perf/simtools/',
	'apps/perf/sql_loader',
	'apps/perf/sql_loader/',
	'sys/dm_vertex',
	'setup/scripts',
	'setup/scripts/',
	'sys/dm_ldap'
);

if ($program_name eq "pin_setup_chmod") {
  #
  # Set config file permission post restart
  #
  &set_permission_post_restart();

} else { 
  #
  # prompts the user input for enabling password encryption
  #
  &userprompt();
};

sub userprompt {
  my $Enable_encryption = "Yes";
  if ($program_name eq "") {
    $debug = 1;
    print "\n Do you want to enable password encryption? Type 'Yes' or 'No':";
    $Enable_encryption=<stdin>;
  }

  if($Enable_encryption =~ /Yes/i) {
     &OpenLogFile( $SETUP_LOG_FILENAME, $SETUP_LOG_ACCESS_TYPE );

     #
     # For installers, only encrypt pin_setup.values
     #
     if ($program_name ne "pin_setup") {
       &encrypt_pinsetup();
     }

     if ($program_name ne "ISMP") {
       &enable_dm_oracle();

       &Output( STDOUT, "\nEncrypting passwords...\n");
       &Output( fpLogFile, "\nEncrypting passwords...\n");
       &encrypt_properties_all();
       &encrypt_config_all();
       &encrypt_specific_conf_all();
       if ($program_name eq "") {
	 &set_permission_post_restart();
       }
     }
  }
}


#
#encrypts all the passwords present in the pin_setup.values file
#

sub encrypt_pinsetup {
  my $full_filename = "$home/setup/pin_setup.values";
  my $enabled = 0;
  if(-e "$full_filename") {
      &Output( STDOUT, "\nEncrypting password for pin_setup.values\n");
      &Output( fpLogFile, "\nEncrypting password for pin_setup.values\n");
      open (INFILE,"$full_filename")|| die ("Can't open the $full_filename $!\n");
      open (ENCFILE,">$full_filename.enc")|| die ("Can't open the $full_filename.enc $!\n");

      while ( <INFILE> ) {       
          foreach my $password (@passwordlist) {    	      	   
            if($_ =~ /^\$$password/ && $_ !~ /\&aes/) {
               $value = (split(/\=/,$_))[1];			#split the pin_setup values entries by blank equal to "=" to read the value
               $value =~s/\s+|\"|\;//g;
      	       $encvalue = psiu_perl_encrypt_pw($value);
	       $_= "\$$password = \"$encvalue\"\;\n";		#replacing the password with the encrypted value
	    }
          }
	  if ($_ =~ /\$ENABLE_ENCRYPTION = \"Yes\"/) {
	    $enabled = 1;
	  }
          print ENCFILE "$_";   	   
      }
      if (!$enabled) {
	print ENCFILE "\n\$ENABLE_ENCRYPTION = \"Yes\"\;\n";	#inlcude the new flag ENABLE_ENCRYPTION = "Yes" in pin_setup.values
      }

      close(INFILE);
      close(ENCFILE);
      #
      # backup existing config file
      #
      &backup_file($full_filename);
  }
  else {
      &Output( fpLogFile, "\npin_setup.values is not present under $home directory");  
  }      
}

#
#encrypts all the passwords present in the Infranet.properties file
#

sub encrypt_properties_all {

  foreach my $file (@properties_files) {
    &encrypt_properties("$home/$file");
  }
}

sub encrypt_properties {
      my ($file_path) = @_;
      my $full_filename = $file_path . "/Infranet.properties";
      my $need_encryption = 0;
      if(-e "$full_filename") {
        open (PROPFILE,"$full_filename")|| die ("Can't open the $full_filename $!\n");
        open (ENCPROPFILE,">$full_filename.enc")|| die ("Can't open the $full_filename.enc $!\n");
       
        while ( <PROPFILE> ) {
           if($_ =~ /infranet\.connection/ && $_ !~ /\&aes/) {
	      $need_encryption = 1;
	      $colonsplit = (split(/\:/,$_))[2];	     
	      if($colonsplit ne ''){            
                  $ampersplit = (split(/\@/,$colonsplit))[0]; 	#second split using the  symobol "@"  to read the password
                  $encpass = psiu_perl_encrypt_pw($ampersplit);
                  $_ =~s /$ampersplit/$encpass/g;         		#replacing the password with the encrypted value
 	      } 
           }        
        print ENCPROPFILE "$_";
        }
        close(PROPFILE);
        close(ENCPROPFILE);
	if (($need_encryption) && ($debug)) {
          &Output( STDOUT, "\nEncrypted password for $full_filename\n");
          &Output( fpLogFile, "\nEncrypted password for $full_filename\n");
	}
	#
	# backup existing config file
	#
	&backup_file($full_filename);
      }
      else {
	if ($debug) {
	  &Output( fpLogFile, "\n$full_filename is not present under $home directory");  
	}
      }      
}
        
#
#encrypts all the CM connect passwords present in the pin.conf file
#
sub encrypt_config_all {


  foreach my $conf (@conf_files) {
    &encrypt_config("$home/$conf");
  }
}

sub encrypt_config {
     my ($file_path) = @_;
     my $full_filename = $file_path . "/pin.conf";
     my $need_encryption = 0;
     if(-e "$full_filename") {         
         open (CONFFILE,"$full_filename")|| die ("Can't open the $full_filename $!\n");
         open (ENCCONFFILE,">$full_filename.enc")|| die ("Can't open the $full_filename.enc $!\n");
     
         while (<CONFFILE>) {
            if($_ =~ /nap login_pw/ && $_ !~ /\&aes/) {
	      $need_encryption = 1;
              $clearpwd = (split(/\s+/,$_))[3];			#split the pin.conf entries by blank space to read the password              
              $encpwd = psiu_perl_encrypt_pw($clearpwd);  
              $_ =~s /$clearpwd$/$encpwd/g;			#replacing the password with the encrypted value
            }        
         print ENCCONFFILE "$_";
         }     
         close(CONFFILE);
         close(ENCCONFFILE);
  	 if (($need_encryption) && ($debug)) {
           &Output( STDOUT, "\nEncrypted password for $full_filename\n");
           &Output( fpLogFile, "\nEncrypted password for $full_filename\n");
         }

	 #
	 # backup existing config file
	 #
	 &backup_file($full_filename);
     }
     else {
	if ($debug) {
	  &Output( fpLogFile, "\n$full_filename is not present under $home directory");  
	}
      }

}

#
#encrypts all product specific passwords present in the pin.conf file
#

sub encrypt_specific_conf_all {

    foreach my $key (@pinconf_enc_comps) {
      &encrypt_specific_conf($home,$key);
    }
}

sub encrypt_specific_conf {
     my ($home,$key) = @_;
     my $full_filename = "$home/$key/pin.conf";
     my $need_encryption = 0;
      if(-e "$full_filename") {
        open (CONF,"$full_filename")|| die ("Can't open the $full_filename $!\n");
        open (ENC_CONF,">$full_filename.enc")|| die ("Can't open the $full_filename.enc $!\n");
       
        while ( <CONF> ) {
           if($_ =~ /$pinconf_enc{$key}/ && $_ !~ /\&aes/) {
	      $need_encryption = 1;
              $cleartxt = (split(/\s+/,$_))[3]; 		#split the pin.conf entries by blank space to read the password
              $enctxt = psiu_perl_encrypt_pw($cleartxt);              
              $_ =~s /$cleartxt$/$enctxt/g;         		#replacing the password with the encrypted value
           }        
        print ENC_CONF "$_";
        
        }
        close(CONF);
        close(ENC_CONF);
	if (($need_encryption) && ($debug)) {
          &Output( STDOUT, "\nEncrypted password for $full_filename \n");
          &Output( fpLogFile, "\nEncrypted password for $full_filename for the key '$pinconf_enc{$key}'\n");
        }
	 #
	 # backup existing config file
	 #
	 &backup_file($full_filename);

      }        
      else {
	if ($debug) {
	  &Output( fpLogFile, "\n$full_filename is not present under $home directory");  
	}
      }      
}

#
#enables the dm_oracle "encrypt_passwd" password entry which is "0" by default and restarts the DM
#
sub enable_dm_oracle {

        local ( %DM ) = %MAIN_DM;
	if ($program_name ne "pin_setup") {
	   &Stop ( $ServiceName{'dm_'.$DM{'db'}->{'vendor'}} );
        }
        if($MAIN_DB{'vendor'} =~ /oracle/i) {

           &ReplacePinConfEntry( $DM_ORACLE{'location'}."/".$PINCONF, "encrypt_passwd", "- dm encrypt_passwd 1");

        }
        elsif($MAIN_DB{'vendor'} =~ /odbc/i) {

           &ReplacePinConfEntry( $DM_ODBC{'location'}."/".$PINCONF, "encrypt_passwd", "- dm encrypt_passwd 1");

        }
	if ($program_name ne "pin_setup") {
	  &Start ( $ServiceName{'dm_'.$DM{'db'}->{'vendor'}} );
	}

}

#
# rename/backup config file
#
sub backup_file{
  my ($full_filename) = @_;

  if ((-e "$full_filename") && ($program_name ne "pin_setup") && ($program_name ne "ISMP")){
    rename($full_filename,"$full_filename.encbak");
  }
  if(-e "$full_filename.enc") {
    rename("$full_filename.enc","$full_filename");
  }
}

#
# Set config file permission post restart
#
sub set_permission_post_restart {
  &Output( STDOUT, "\nSetting permission...\n");
  &Output( fpLogFile, "\nSetting permission...\n");
  find(\&set_permission, $home);
}

sub set_permission {
  if (/^pin\.conf|^Infranet.properties|Infranet.properties$|^pin_setup.values|pin_tt_schema_gen.values/) {
    my $info = stat($File::Find::name);
    my $mode = $info->mode;
    # stat mode value 33200 is 0660
    if ($mode ne '33200') {
      if ($debug) {
        &Output( STDOUT, "\nSetting permission for $File::Find::name\n");
        &Output( fpLogFile, "\nSetting permission for $File::Find::name\n");
      }

      chmod( 0660, $File::Find::name);
    }
  }
}
