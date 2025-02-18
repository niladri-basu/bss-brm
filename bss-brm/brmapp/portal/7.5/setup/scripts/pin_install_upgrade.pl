#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl

########################################################
# Execute the script to support install upgrade overlay
########################################################

require "pin_cmp_storable_class_to_xml.pl";
require "pin_cmp_pin_billd.pl";

our %MAIN_DM;
our %DM;
our %MAIN_CM;
our %CM;
%DM = %MAIN_DM;
%CM = %MAIN_CM;

print " Executing function configure_PriceList()....\n\n";
eval "&configure_PriceList()";

print " Executing function configure_storable_class_to_xml_config_files()....\n\n";
eval "&configure_storable_class_to_xml_config_files()";

print " Executing function configure_DeviceMgmt()....\n\n";
eval "&configure_DeviceMgmt()";

print " Executing function configure_Sepa()....\n\n";
eval "&configure_Sepa()";

if($DM{'db_num'} eq "0.0.0.1" )
{
print " Executing function load_config_note_status().......\n\n";
eval "&load_config_note_status()";

print " Executing function load_config_note_type().......\n\n";
eval "&load_config_note_type()";
}

# Check for optional managers

if ( -e "pin_cmp_cmt.pl") {

        print " Executing function configure_cmt_config_files()....\n\n";
        eval qq!require "pin_cmp_cmt.pl"!;
        eval "&configure_cmt_config_files()";
}
else{
        print "CMT optional manager not present. \n";
}
if ( -e "pin_cmp_iptmgr.pl" ) {
        print " Executing function configure_iptmgr_post_restart()....\n\n";
        eval qq!require "pin_cmp_iptmgr.pl"!;
        eval "&configure_iptmgr_post_restart()";
}
else{
        print "IPT optional manager not present. \n";
}

#Unbundle previously packaged OpenSSL libraries in 75PS10 
my $ssl_lib_path = "$ENV{'PIN_HOME'}/lib\/libssl$ENV{'LIBRARYEXTENSION'}";
my $crypto_lib_path = "$ENV{'PIN_HOME'}/lib\/libcrypto$ENV{'LIBRARYEXTENSION'}";
if (-e $ssl_lib_path)
{
	print " Removing previously packaged $ssl_lib_path \n";
        system("rm $ssl_lib_path*");
}
if (-e $crypto_lib_path)
{
	print " Removing previously packaged $crypto_lib_path \n";
        system("rm $crypto_lib_path*");
}
#End of OpenSSL library unbundling

#Unbundle previously packaged libBAS_crypt64 in earlier patch set

my $bas_crypt_lib_path = "$ENV{'IFW_HOME'}/lib\/libBAS_crypt64$ENV{'LIBRARYEXTENSION'}";
if (-e $bas_crypt_lib_path)
{
        print " Removing previously packaged $bas_crypt_lib_path\n";
        system("rm $bas_crypt_lib_path*");
}

