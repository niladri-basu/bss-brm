#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# Copyright (c) 2004, 2014, Oracle and/or its affiliates. All rights reserved.
#
#  This material is the confidential property of Oracle Corporation
#  or its subsidiaries or licensors and may be used, reproduced, stored
#  or transmitted only in accordance with a valid Oracle license or
#  sublicense agreement. 
#
# @(#)% %
#


use strict;
use FileHandle;
use IPC::Open2;
use Getopt::Long;
use pcmif;
use Flist;
use aes;

use constant TRUE => 1; 
use constant FALSE => 0; 

my $_KEY_PPLN = "pipeline";
my $_KEY_HOST = "host";
my $_KEY_PORT = "port";
my $_KEY_DB = "db";
my $_KEY_DBTYPE = "db_type";
my $_KEY_DBALIAS = "db_alias";
my $_KEY_LOGIN = "login_name";
my $_KEY_PASSWD = "login_pw";
my $_KEY_ADMIN = "admin";
my $_KEY_ADMINPW = "admin_pw";
my $_PINCONF = "pin.conf";
my $_BOGUS_STMT = "aaaaaaa";
my $_DEFAULT_TBS = "default_table_space_name";
my $_ROLES_TBA = "database_role_name";
my $SQLSCRIPT_EXECUTABLE = "osql";
my ($_ctx, $_ebuf, $_db);
my ($_admins_flist, $_configs_flist);
my ($_sql_input, $_sql_output);
my $_pinconf_hash_ref;   # used only by get_pinconf_entries()
my $tmpErrorFile   = "tmp.out";
my $tmpCommandFile   = "tmp.sql";
my $Is_Win32  = $^O eq "MSWin32"; 

$| = 1;   # turn on output autoflush for prompts
my $_CLASS_EXISTS = "NO";
my $option = get_opt();
open( SAVEOUT, ">&STDOUT");
open( SAVEERR, ">&STDERR");
get_pinconf_entries();
log_in();   # sets _ctx, $_ebuf, $_db; exits on failure
$_admins_flist = search("/service/admin_client");
if(pcmif::pcm_perl_is_err($_ebuf)){
        print "Search failed for /service/admin_client object.\n";
        log_out();
        exit;
}
$_CLASS_EXISTS = checkifclassexists("/config/pricing_admin");
if($_CLASS_EXISTS eq "YES" )
{
	$_configs_flist = search("/config/pricing_admin");
	if(pcmif::pcm_perl_is_err($_ebuf)){
                print "Search failed for /config/pricing_admin object.\n";
                log_out();
                exit;
        }
}
if ($option eq "init") {
	init_pricing_admin();
}
elsif ($option eq "set") {
	loop_to_call("set_pricing_admin", "username", "password");
}
elsif ($option eq "remove") {
	loop_to_call("remove_pricing_admin", "username");
}
log_out();
exit;


#----------------------------------------------------------------------------
# init_pricing_admin
#
# Looks for an existing config object associated with the root account.
# If it exists, its fields are set according to pin.conf entries.  Otherwise,
# it creates the /config/pricing_admin storable class and an object of it for
# the root account, setting it to values of entries in pin.conf.
#----------------------------------------------------------------------------
sub init_pricing_admin
{
	my $hash_ref;
	my $result;
	my $config_flist;
	my $crypt_pw;
	my $password;

	$hash_ref = get_pinconf_entries();

	$crypt_pw = $$hash_ref{$_KEY_PASSWD};
	if ($crypt_pw =~ /^\&aes\|/i) {
		$password = psiu_perl_decrypt_pw($crypt_pw);
	}
	else {
		$password = $crypt_pw;
	}

	if($_configs_flist)
	{
		$config_flist = $_configs_flist->get_subflist("RESULTS.ACCOUNT_OBJ",
		"$_db /account 1 0");
	}

	if ($config_flist) {
		my $obj_poid = $config_flist->get_field("POID");
		$result = set_config_obj($obj_poid, 1, $$hash_ref{$_KEY_HOST},
			$$hash_ref{$_KEY_PORT}, $$hash_ref{$_KEY_LOGIN},
			$password, $$hash_ref{$_KEY_DB}, $$hash_ref{$_KEY_DBTYPE});
	}
	else {
		$result = create_class_from_spec_file("pricing_admin.sce");
		if(!pcmif::pcm_perl_is_err($_ebuf)){
			$result = create_config_obj(1, $$hash_ref{$_KEY_HOST},
				$$hash_ref{$_KEY_PORT}, $$hash_ref{$_KEY_LOGIN},
				$password, $$hash_ref{$_KEY_DB},
				$$hash_ref{$_KEY_DBTYPE});
		}
		else {
			print "Could not create config class.\n",
				"Make sure the following entry in DM pin.conf is set:\n",
				"\t- dm dd_write_enable_objects 1\n";
		}
	}
	if(!pcmif::pcm_perl_is_err($_ebuf)){
		print "Initialized config object for pricing admin.\n";
	}
	else {
		print "Initializing config object for pricing admin failed.\n";
	}
}


#----------------------------------------------------------------------------
# set_pricing_admin NAME PASSWORD
#
# Looks for a CSR account with login NAME.  If it's found, looks for an
# existing /config/pricing_admin object associated with it.  If it exists,
# its fields are set according to pin.conf entries and parameters passed in.
# Otherwise, a new config object is created with those values.  Then the
# corresponding Pipeline account is created if it doesn't exist, and set, if
# if it does.
#----------------------------------------------------------------------------
sub set_pricing_admin
{
	my ($name, $password) = @_;
	my $result;
	my $dbtype;

	my ($acct_poid, $config_poid) = find_account_and_config_poids($name);
	if (not $acct_poid) {
		print "$name does not have a CSR account, ",
			"so cannot be set up as a pricing admin.\n";
		return;
	}

	my ($db, $class, $acct_no, $rest) = split(/\s+/, $acct_poid, 4);
	my $hash_ref = get_pinconf_entries();
	if ($config_poid) {
		$result = set_config_obj($config_poid, $acct_no, $$hash_ref{$_KEY_HOST},
			$$hash_ref{$_KEY_PORT}, $name, $password, $$hash_ref{$_KEY_DB},
			$$hash_ref{$_KEY_DBTYPE});
	}
	else {
		$result = create_config_obj($acct_no, $$hash_ref{$_KEY_HOST},
			$$hash_ref{$_KEY_PORT}, $name, $password, $$hash_ref{$_KEY_DB},
			$$hash_ref{$_KEY_DBTYPE});
	}
	if(pcmif::pcm_perl_is_err($_ebuf)){
                print"Could not create/update /config/pricing_admin object...\n";
                return ;
        }
	$dbtype = $$hash_ref{$_KEY_DBTYPE};

	if ($dbtype =~ /^oracle$/i) {
        
		$result = set_jsa_user_oracle($name, $password);
	}
	elsif ($dbtype =~ /^sqlserver$/i) {
		$result = set_jsa_user_mssql($name, $password);
	}	
	else {
		print "Database type $dbtype not supported. Check db_type in pin.conf file either it should be oracle or sqlserver\n";
		print "Exitting...\n";
		exit;
	}


	if ($result) {
		print "Set pricing admin $name SUCCESSFUL...\n";
	}
	else {
		print "Setting pricing admin $name failed.\n";
	}
}


#---------------------------------------------------------------------------
# remove_pricing_admin NAME
#
# Looks for a CSR account with login NAME.  If it's found, looks for a
# /config/pricing_admin object associated with it, and deletes it if it
# exists.  Then it deletes the corresponding Pipeline account.
#---------------------------------------------------------------------------
sub remove_pricing_admin
{
	my $name = shift;
	my $result;
	my $dbtype;
	my ($acct_poid, $config_poid) = find_account_and_config_poids($name);
	my $hash_ref = get_pinconf_entries();
	$dbtype = $$hash_ref{$_KEY_DBTYPE};
	if ($config_poid) {
		$result = delete_obj($config_poid);
	}
	else {
		print "$name is not a pricing admin.\n";
		return;
	}
	if (pcmif::pcm_perl_is_err($_ebuf)) {
                print " Removing pricing admin $name failed. \n";
                return;
        }
	$dbtype = $$hash_ref{$_KEY_DBTYPE};
	if ($dbtype =~ /^oracle$/i) {
       		$result = remove_jsa_user_oracle($name);
	}
	elsif ($dbtype =~ /^sqlserver$/i) {
        	$result = remove_jsa_user_mssql($name);
	}
	else {
		print "Database type $dbtype not supported. Check db_type in pin.conf file supported types are oracle or sqlserver\n";
		print "Exitting...\n";
		exit;
	}
	if ($result) {
		print "Removed pricing admin $name.\n";
	}
	else {
		print "Removing pricing admin $name failed.\n";
	}
}


#--------------------------------------------------------------------------
# find_account_and_config_poids NAME
#
# Looks for a CSR account with login NAME.  If it's found, looks for a
# /config/pricing_admin object associated with it.  It returns the account
# and config object poids, and null for each one that was not found.
#--------------------------------------------------------------------------
sub find_account_and_config_poids
{
	my $name = shift;
	my ($admin_flist, $acct_poid, $config_flist, $config_poid);

	$admin_flist = $_admins_flist->get_subflist("RESULTS.LOGIN", $name);
	if (not $admin_flist) {
		return $acct_poid, $config_poid;
	}

	$acct_poid = $admin_flist->get_field("ACCOUNT_OBJ");
	if($_configs_flist)
	{
	$config_flist = $_configs_flist->get_subflist("RESULTS.ACCOUNT_OBJ",
		$acct_poid);
	}
	if ($config_flist) {
		$config_poid = $config_flist->get_field("POID");
	}

	return $acct_poid, $config_poid;
}


#----------------------------------------------------------------------------
# create_class_from_spec_file FILENAME
#
# Opens and reads the storable class spec file FILENAME, and calls the opcode
# PCM_OP_SDK_SET_OBJ_SPECS to create the class in Portal.  Returns what the
# opcode returns as an Flist object.
#----------------------------------------------------------------------------
sub create_class_from_spec_file
{
	my $class_spec_file = shift(@_);
	my ($params, $flist);

	$params = "0 PIN_FLD_POID     POID [0] $_db /dd/objects 0 0\n";
	$params .= read_file($class_spec_file);
	return call_opcode("PCM_OP_SDK_SET_OBJ_SPECS", \$params);
}


#----------------------------------------------------------------------------
# create_config_obj ACCTNO HOST PORT USERNAME PASSWORD DBNAME DBTYPE
#
# Creates a /config/pricing_admin object in Portal for the CSR ACCTNO, set
# to the values of the rest of the parameters.  Returns what PCM_OP_CREATE_OBJ
# returns as an Flist object.
#-----------------------------------------------------------------------------
sub create_config_obj
{
	my ($acctno, $host, $port, $username, $password, $dbname, $dbtype) = @_;
	my $params;

	$username = uc($username);
	$params = <<FLIST
0 PIN_FLD_POID                   POID [0] $_db /config/pricing_admin -1 0
0 PIN_FLD_ACCOUNT_OBJ            POID [0] $_db /account $acctno 0
0 PIN_FLD_HOSTNAME                STR [0] "-"
0 PIN_FLD_NAME                    STR [0] "config_pricing_admin"
0 PIN_FLD_PROGRAM_NAME            STR [0] "-"
0 PIN_FLD_CONFIG_INFO       SUBSTRUCT [0] allocated 6, used 6
1     PIN_FLD_HOSTNAME            STR [0] "$host"
1     PIN_FLD_LOGIN               STR [0] "$username"
1     PIN_FLD_NAME                STR [0] "$dbname"
1     PIN_FLD_PASSWD              STR [0] "$password"
1     PIN_FLD_PORT                INT [0] $port
1     PIN_FLD_SERVER_TYPE         STR [0] "$dbtype"
FLIST
	;

	return call_opcode("PCM_OP_CREATE_OBJ", \$params);
}


#------------------------------------------------------------------------------
# set_config_obj OBJPOID ACCTNO HOST PORT USERNAME PASSWORD DBNAME DBTYPE
#
# Sets the /config/pricing_admin object with OBJPOID to the value of the rest of
# the parameters.  Returns what PCM_OP_WRITE_FLDS returns as an Flist object.
#-------------------------------------------------------------------------------
sub set_config_obj
{
	my ($obj_poid, $acctno, $host, $port, $username, $password, $dbname,
		$dbtype) = @_;
	my $params;

	$username = uc($username);
	$params = <<FLIST
0 PIN_FLD_POID                   POID [0] $obj_poid
0 PIN_FLD_ACCOUNT_OBJ            POID [0] $_db /account $acctno 0
0 PIN_FLD_HOSTNAME                STR [0] "-"
0 PIN_FLD_NAME                    STR [0] "config_pricing_admin"
0 PIN_FLD_PROGRAM_NAME            STR [0] "-"
0 PIN_FLD_CONFIG_INFO       SUBSTRUCT [0] allocated 6, used 6
1     PIN_FLD_HOSTNAME            STR [0] "$host"
1     PIN_FLD_LOGIN               STR [0] "$username"
1     PIN_FLD_NAME                STR [0] "$dbname"
1     PIN_FLD_PASSWD              STR [0] "$password"
1     PIN_FLD_PORT                INT [0] $port
1     PIN_FLD_SERVER_TYPE         STR [0] "$dbtype"
FLIST
	;

	return call_opcode("PCM_OP_WRITE_FLDS", \$params);
}


sub search
{
	my ($type, $criteria, $fields) = @_;
	my $params;

	$params = <<FLIST
0 PIN_FLD_RESULTS                  ARRAY [*] NULL
0 PIN_FLD_POID                      POID [0] $_db /search -1 0
0 PIN_FLD_ARGS                     ARRAY [1] allocated 1, used 1
1     PIN_FLD_POID                  POID [0] $_db $type -1 0
0 PIN_FLD_TEMPLATE                   STR [0] "select X from $type where F1 = V1 "
0 PIN_FLD_FLAGS                      INT [0] 0
FLIST
	;

	return call_opcode("PCM_OP_GLOBAL_SEARCH", \$params);
}

sub checkifclassexists
{
	my ($classname) = @_;
	my $params;
        my $outflistp;
        my $subflistp;
	my $dbclassname;
	my $params = <<FLIST
0 PIN_FLD_POID     POID [0] $_db /dd/objects 0 0
0 PIN_FLD_OBJ_DESC  ARRAY [0]
1 PIN_FLD_NAME      STR [0]  "$classname"
FLIST
	;

	$outflistp=call_opcode("PCM_OP_SDK_GET_OBJ_SPECS", \$params);
        $subflistp=$outflistp->get_subflist("OBJ_DESC.NAME",$classname);
	if($subflistp)
        { 
	$dbclassname=$subflistp->get_field("NAME");
	$classname= "\"".$classname."\"" ;
               if( $dbclassname eq $classname )
               {
		return   "YES";
               }
        }
return "NO"; 
}

sub delete_obj
{
	my $obj_poid = shift;
	my $params;

	$params = <<FLIST
0 PIN_FLD_POID                   POID [0] $obj_poid
FLIST
	;

	return call_opcode("PCM_OP_DELETE_OBJ", \$params);
}


sub read_obj
{
	my $obj_poid = shift;
	my $params;

	$params = <<FLIST
0 PIN_FLD_POID           POID [0] $obj_poid
FLIST
	;

	return call_opcode("PCM_OP_READ_OBJ", \$params);
}


sub get_opt
{
	my $usage = "Use one of the following options:\n" .
		"\t-init    (initialize config object for pricing admins)\n" .
		"\t-set     (modify or create pricing admin(s))\n" .
		"\t-remove  (remove pricing admin(s))\n";

	if ($#ARGV > 0) {
		print "Specify one option at a time.\n";
		exit;
	}

	if ($ARGV[0] =~ /-(init|set|remove)$/) {
		return $1;
	}
	elsif ($ARGV[0] =~ /-(h)$/) {
		print "$usage";
		exit;
	}
	else {
		print "Error: Invalid option.\n$usage";
		exit;
	}
}


sub log_in
{
	$_ebuf = pcmif::pcm_perl_new_ebuf();
	$_ctx = pcm_perl_connect($_db, $_ebuf);
	if (not $_ctx) {
		print "Failed to log in to Portal server.\n",
			"Make sure $_PINCONF entries are correct.\n";
		exit;
	}
}


sub log_out
{
	pcmif::pcm_context_close($_ctx, 0, $_ebuf);
	if (pcmif::pcm_perl_is_err($_ebuf)) {
		print "log_out() failed.\n";
		pcmif::pcm_perl_print_ebuf($_ebuf);
	}

	pcmif::pcm_perl_destroy_ebuf($_ebuf);
}


sub call_opcode
{
	my ($opcode, $params_ref) = @_;

	my $flist = new Flist($params_ref);
	my $flist_ptr = pcmif::pcm_perl_op($_ctx, $opcode, 0, $flist->to_pointer(), $_ebuf);
	if (pcmif::pcm_perl_is_err($_ebuf)) {
		pcmif::pcm_perl_print_ebuf($_ebuf);
		print $$params_ref;
		warn "call_opcode: ", $opcode, " failed.";
	}

	return new Flist($flist_ptr);
}


#------------------------------------------------------------------------------
# loop_to_call SUB LIST
#
# Will repeatedly call SUB subroutine.  If STDIN is a tty, it calls
# prompt_and_call(), which will do the job by prompting the user for the items
# in the list and passing the user input to SUB.  If STDIN is a pipe, it calls
# for_every_input_line_call(), which will call SUB once for each line read from
# STDIN, passing each word on a line as a param to SUB.
#------------------------------------------------------------------------------
sub loop_to_call
{
	if (-t STDIN) {
		prompt_and_call(@_);
	}
	else {
		for_every_input_line_call(@_);
	}
}


sub for_every_input_line_call
{
	no strict 'refs';
	my $func_ref = shift;

	while (<STDIN>) {
		s/(^\s+)|(\s+$)//g;      # remove leading and trailing spaces
		my @words = split(/\s+/);
		if (@words == @_) {
			&$func_ref(@words);
		}
		else {
			print "Line \"$_\" ignored.\n",
			"Each line should have ", scalar(@_), " words: ", join(" ", @_), "\n";
		}
	}
}


sub prompt_and_call
{
	no strict 'refs';
	my $func_ref = shift;
	my ($i, $prompt, @params);

	do {
		$i = 0;
		foreach $prompt (@_) {
			if ( $prompt eq "password" ) {
				$params[$i++] = getpass($prompt);
			}
			else {
				$params[$i++] = prompt_get_word($prompt);
			}
		}
		&$func_ref(@params);
	} while (prompt_yes_no("Another"))
}


#-------------------------------------------------------------------------------
# prompt_get_word PROMPT
#
# Prompts the user with PROMPT string and returns the user input.  It limits the
# user input to one word.  If the user input contains a space character, it
# prompts the user again.
#-------------------------------------------------------------------------------
sub prompt_get_word
{
	my $prompt = shift() . ":";
	my $reply;

	while (($reply = prompt($prompt)) =~ /\s/) {
		print "Spaces are not allowed.\n";
	}

	return $reply;
}


#-----------------------------------------------------------------------------
# prompt_yes_no QUESTION
#
# Prompts the user with QUESTION, limiting the user input to y/n, returning 1
# for yes, 0 for no.  Prompts the user again if the response is anything other
# than y/n.
#-----------------------------------------------------------------------------
sub prompt_yes_no
{
	my $prompt = shift() . " (y/n)?";
	my $reply;

	while ($reply = prompt($prompt)) {
		if ($reply =~ /^\s*[Yy]+\s*$/) {
			$reply = 1;
			last;
		}
		elsif ($reply =~ /^\s*[Nn]+\s*$/) {
			$reply = 0;
			last;
		}
	}

	return $reply;
}


sub prompt
{
	print @_, " ";
	my $reply = <STDIN>;
	chomp($reply);
	return $reply;
}


#-----------------------------------------------------------------------------
# get_pinconf_entries
#
# Returns the reference to a hash containing pipeline parameters in pin.conf.
# It reads the file only on the first invocation and sets a global variable to
# keep a reference to the resulting hash.  It simply returns that value on
# subsequent calls.
#-----------------------------------------------------------------------------
sub get_pinconf_entries
{
	my $missing_keys;
	if ($_pinconf_hash_ref) {
		return $_pinconf_hash_ref;
	}

	my $hash_ref = read_pinconf($_PINCONF, $_KEY_PPLN);
	if ($option eq "init") {
		$missing_keys = verify_hash_keys($hash_ref, $_KEY_HOST, $_KEY_PORT,
			$_KEY_DB, $_KEY_DBTYPE, $_KEY_LOGIN, $_KEY_PASSWD,
			$_KEY_ADMIN, $_KEY_ADMINPW);
	}
	elsif ( $option eq "set" ) {
		$missing_keys = verify_hash_keys($hash_ref, $_KEY_HOST, $_KEY_PORT,
				$_KEY_DB, $_KEY_DBTYPE, $_KEY_LOGIN, $_KEY_PASSWD,
				$_KEY_ADMIN, $_KEY_ADMINPW,$_DEFAULT_TBS,$_ROLES_TBA);
	}
	elsif ( $option eq "remove" ) {
		$missing_keys = verify_hash_keys($hash_ref, $_KEY_HOST, $_KEY_PORT,
				$_KEY_DB, $_KEY_DBTYPE, $_KEY_LOGIN, $_KEY_PASSWD,
				$_KEY_ADMIN, $_KEY_ADMINPW);
	}
	if (@$missing_keys) {
		my $prefix = "\n\t- $_KEY_PPLN ";
		print "Error:  entry/entries missing in $_PINCONF:",
			$prefix, join($prefix, @$missing_keys), "\n";
		exit;
	}

	if (!exists($$hash_ref{$_KEY_DBALIAS})) {
		print "Warning:  - $_KEY_PPLN $_KEY_DBALIAS entry missing in $_PINCONF\n",
			"\t- $_KEY_PPLN $_KEY_HOST will be used to connect to DB server.\n";
	}

	return $_pinconf_hash_ref = $hash_ref;
}


#-------------------------------------------------------------------------------
# verify_hash_keys HASHREF LIST
#
# It verifies that all the items in LIST exist as keys in the hash referenced by
# HASHREF, and returns a list of those that don't.
#-------------------------------------------------------------------------------
sub verify_hash_keys
{
	my $hash_ref = shift;
	my ($key, @missing_keys);

	while (@_) {
		$key = shift;
		if (!exists($$hash_ref{$key})) {
			push(@missing_keys, $key);
		}
	}

	return \@missing_keys;
}


#--------------------------------------------------------------------------------
# read_pinconf FILENAME PREFIX
#
# Reads FILENAME (almost always pin.conf) looking for lines whose first and
# second words are "-" and PREFIX, respectively (excluding comments, of course);
# and saves them in a hash: the third word as the key, and the rest of the line
# as the corresponding value.  It returns a reference to the hash.
#--------------------------------------------------------------------------------
sub read_pinconf
{
	my $file = shift;
	my $field2 = shift;   # second field/word of lines in config file
	my ($dash, $name, $value, %hash);
	my $retval;

	$retval = open(PINCONF, $file) or die "Failed to open $file";
	if(!$retval) {
		print "Failed to open pin.conf file....\n";
		return ;
	}

	while (<PINCONF>) {
		if (/^\s*-\s+$field2/) {  # pick lines with $field2 as second word
			s/\#.*//;             # remove comments
			s/\s+$//;             # remove trailing space
			($dash, $field2, $name, $value) = split(/\s+/, $_, 4);
			if($value eq "") {
				print "$name has no value specified in pin.conf file please provide the same and rerun. \n";
				exit(0);
			}

			$hash{$name} = $value;
		}
	}

	close(PINCONF);
	return \%hash;
}


sub read_file
{
	my $file = shift(@_);
	my ($line, $contents);

	if (open(FH, $file)) {
		while ($line = <FH>) {
			$contents .= $line;
		}
		close(FH);
	}

	return $contents;
}


#------------------------------------------------------------------------------
# set_jsa_user USER PASSWORD
#
# Creates or modifies a Pipeline pricing admin.  Returns 0 if it fails, 1 if it
# succeeds.
#------------------------------------------------------------------------------
sub set_jsa_user_oracle
{
	my $hash_ref = get_pinconf_entries();
        my $default_table_space = $$hash_ref{$_DEFAULT_TBS};
        my $roles_tobe_assigned = $$hash_ref{$_ROLES_TBA};
	my $user = uc(shift);
	my $password = shift;
	my $result;

	if (not open_sql()) {
		return 0;
	}

	my $sql_script = <<"SCRIPT"
		user $user identified by $password
			default tablespace $default_table_space
			temporary tablespace TEMP;

		grant $roles_tobe_assigned  to $user with admin option ;
		grant create public synonym to $user ;
		grant drop public synonym   to $user ;
		grant create view           to $user ;
		grant create sequence       to $user ;
		grant create table          to $user ;
		grant create any index      to $user ;
		grant create procedure      to $user ;
SCRIPT
	;

	$result = exec_sql_statement("create $sql_script");
	####### If user already present then do alter user #######
	if ($result =~ /ORA-01920/i) {
		$result = "";
		exec_sql_statement("alter $sql_script");
	}
	if ($result =~ /error/i) {
		print "$result\n";
                print "Could not create/alter database user :$user";
                close_sql();
                return 0;
        }

	####### This is needed for FMUI environments as each account will have JSA_USER table ####
	####### we need to explicitly prefix schema name to JSA_USER table to be able to      ####
	####### access by system user                                                         ####

	$result = exec_sql_statement("select user_id from jsa_user where login='$user' ;");

	my $statement;
	if ($result =~ /\s+\d+/) {
		$statement = "update jsa_user set active=1 where login='$user' ;";
	}
	else {
		$statement = "insert into jsa_user" .
			"(user_id, active, login, entrydate, entryby, modified, recver)" .
			"values(jsa_seq_user_id.nextval, 1, '$user', sysdate, 0, 1, 0) ;";
	}
	exec_sql_statement($statement);
	if ($result =~ /error/i) {
		print "$result\n";
                print "Could not create/alter jsa_user user :$user";
                close_sql();
                return 0;
        }

	close_sql();
	return 1;
}


sub remove_jsa_user_oracle
{
	my $hash_ref = get_pinconf_entries();
	my $user = uc(shift);
	my $result;
	my $ret_val = 1;

	if (not open_sql()) {
		return 0;
	}

	$result = exec_sql_statement("drop user $user ;");
	if ($result =~ /error/i) {
		print "$result\n";
                print "Could not delete user :$user";
                $ret_val =  0;
        }
        else {
		$result = exec_sql_statement("update jsa_user set active=0 where login='$user' ;");
		if ($result =~ /error/i) {
			print "$result\n";
                	print "Could not update jsa user to inactive:$user";
                	$ret_val =  0;
		}
        }

	close_sql();
	return $ret_val;
}


sub exec_sql_statement
{
	my $statement = shift;
	my ($line, $result, $response_flag);

	print $_sql_output $statement, "\n";
	print $_sql_output "$_BOGUS_STMT\n";

	while (($line = <$_sql_input>) !~ /$_BOGUS_STMT/o) {
		if ($line =~ /^SQL> /) {
			$response_flag = 1;
			next;
		}
		if ($response_flag == 1) {
			$result .= $line;
		}
		else {
			next;
		}
	}

	return $result;
}


sub open_sql
{
	my $hash_ref = get_pinconf_entries();

	my $password;
	my $dba = $$hash_ref{$_KEY_ADMIN};
	my $dba_crypt_pw = $$hash_ref{$_KEY_ADMINPW};
	my $alias = $$hash_ref{$_KEY_DBALIAS} ;

	if ($dba_crypt_pw =~ /^\&aes\|/i) {
		$password = psiu_perl_decrypt_pw($dba_crypt_pw);
	}
	else {
		$password = $dba_crypt_pw;
	}

	($_sql_input, $_sql_output) = (new FileHandle, new FileHandle);
	my $pid = open2($_sql_input, $_sql_output, "sqlplus $dba/$password" . '@' .
		"$alias");

	my $logged_in;
	if ($pid) {
		while (<$_sql_input>) {
			if (/connected/i) {
				$logged_in = 1;
				last;
			}
			if (/error/i) {
				kill(9, $pid);
				print "Failed to log in to Pipeline DB.\n",
					"Make sure you can log in with sqlplus ",
					"using the parameters in $_PINCONF.\n";
				last;
			}
		}
	}
	else {
		print "Failed to run sqlplus.\n";
	}

	if ($logged_in) {
		return $pid;
	}
	else {
		return 0;
	}
}


sub close_sql
{
	print $_sql_output "exit\n";
	$_sql_output->close();
	$_sql_input->close();
}




#--------------------------------------------------------------------------------------
# MSSQL specific functions
#--------------------------------------------------------------------------------------
sub set_jsa_user_mssql
{
	my $hash_ref  		= get_pinconf_entries();
        my $roles_tobe_assigned = $$hash_ref{$_ROLES_TBA};
	my $database		= $$hash_ref{$_KEY_DB};
	my $user 		= uc(shift);
	my $password 		= shift;
	my $result;
	my $temp 		= 0;
	my $ret_val		= 0;
	my $Statement;	
	my $Result;	
	my $stmt;

		
	###########################################
	## Creating the user in the database
	###########################################
	$stmt = <<END
EXEC sp_addlogin $user, $password, $database
GO
END
;
	
	$result = &ExecuteSQL_Statement_AsSystem( $stmt, TRUE, TRUE );
	$ret_val = &CheckForErrors ( $tmpErrorFile );
	if( $ret_val == -1 ) {
		return 0;
	}
	elsif($ret_val eq "15025")
	{
		$stmt = <<END
EXEC sp_password NULL, $password, $user
GO
END
;
		$result = &ExecuteSQL_Statement_AsSystem( $stmt, TRUE, TRUE );
		$ret_val = &CheckForErrors ( $tmpErrorFile );
		if( $ret_val == -1 ) {
			return 0;
		}

	}
		
	###########################################
	## Adding the user 
	###########################################
	
	$stmt = <<END			
use $database
GO
EXEC sp_adduser $user
GO
END
	;
	$result = &ExecuteSQL_Statement_AsSystem( $stmt, TRUE, TRUE,);
	$ret_val = &CheckForErrors ( $tmpErrorFile );	
	if( $ret_val == -1 ) {
		return 0;
	}
	
	###########################################
	## Adding roles to the user
	###########################################
	$Statement = <<END
use $database
GO
EXEC sp_addrolemember 'db_owner', "$user"
GO
END
	;
	$Result = &ExecuteSQL_Statement_AsSystem( $Statement, TRUE, TRUE );
	$ret_val = &CheckForErrors ( $tmpErrorFile );
	if( $ret_val == -1 ) {
		return 0;
	}

	###########################################
	## Adding another role to the user.
	###########################################
	
	$Statement = <<END
use $database
GO
EXEC sp_addsrvrolemember "$user", 'sysadmin'
GO
END
;
	$Result = &ExecuteSQL_Statement_AsSystem( $Statement, TRUE, TRUE );
	$ret_val = &CheckForErrors ( $tmpErrorFile );
	if( $ret_val == -1 ) {
		return 0;
	}
	
	###########################################
	## Adding another role to the user.
	###########################################
		
	$Statement = <<END
use $database
GO
EXEC sp_addrolemember "$roles_tobe_assigned", "$user"
GO
END
;
	$Result = &ExecuteSQL_Statement_AsSystem( $Statement, TRUE, TRUE );
	$ret_val = &CheckForErrors ( $tmpErrorFile );
	if( $ret_val == -1 ) {
		return 0;
	}
	
	############################################
	# Adding user to table space
	############################################
	$ret_val = 0;
	$Statement = <<END
insert into jsa_user (active, login, entryby, modified, recver) 
values (1, '$user', 0, 1, 0)
GO
END
;
	$ret_val = 0;
	$Result = &ExecuteSQL_Statement_AsSystem( $Statement, TRUE, TRUE );
	$ret_val = &CheckForErrors ( $tmpErrorFile );
	if( $ret_val == -1 ) {
		return 0;
	}
	############################################
	# if the user already exists updating info
	############################################
	elsif ( $ret_val eq "2601" )
	{	
		$Statement = <<END
update jsa_user set active=1 where login='$user'
GO
END
;
		$Result = &ExecuteSQL_Statement_AsSystem( $Statement, TRUE, TRUE );
		$ret_val = &CheckForErrors ( $tmpErrorFile );
		if( $ret_val == -1 ) {
			return 0;
		}
	
	}
	return 1;
}

#--------------------------------------------------------------
#  This function Removes the user specified and makes the login
#  inactive.
#--------------------------------------------------------------
sub remove_jsa_user_mssql
{
	my $user = uc(shift);
	my $result;
	my $ret_val = 1;
	my $Statement = " ";
	###########################################
	## deleting the user in the database
	###########################################
	
	$Statement = <<END
EXEC sp_dropuser "$user"
GO
END
;	
	$result = &ExecuteSQL_Statement_AsSystem( $Statement, TRUE, TRUE );
	$ret_val = &CheckForErrors ( $tmpErrorFile );
	if( $ret_val == -1 ) {
		return 0;
	}
	$Statement = <<END
update jsa_user set active=0 where login='$user'
GO
END
;
	$result = &ExecuteSQL_Statement_AsSystem( $Statement, TRUE, TRUE );
	$ret_val = &CheckForErrors ( $tmpErrorFile );
	if( $ret_val == -1 ) {
		return 0;
	}
	
	$Statement = <<END
EXEC sp_droplogin "$user"
GO
END
;
	$result = &ExecuteSQL_Statement_AsSystem( $Statement, TRUE, TRUE );
	$ret_val = &CheckForErrors ( $tmpErrorFile );
	if( $ret_val == -1 ) {
		return 0;
	}
	return 1;
	
}

#=============================================================
#  This function Executes a SQL statement as the system user. This assumes
#  that the username, password, and Alias have already been verified.
#
#  Arguments:
#    $Statement 	- Statement to execute
#    bOutputStatement 	- Display the statement
#    bOutputResult 	- Display the resulting output
#
#  Returns:		- Return value of plus80 command
#=============================================================

sub ExecuteSQL_Statement_AsSystem {
	my $password;
	my $result;
	my $hash_ref	 	= get_pinconf_entries();
	my $alias   	 	= $$hash_ref{$_KEY_DBALIAS};
	my $hostname	 	= $$hash_ref{$_KEY_HOST};
	my $roles_tobe_assigned = $$hash_ref{$_ROLES_TBA};
	my $user 		= $$hash_ref{$_KEY_ADMIN};
	my $dba_crypt_pw	= $$hash_ref{$_KEY_ADMINPW};

	my $stmt		= shift( @_ );
	my $bOutputStatement	= shift( @_ );
	my $bOutputResult	= shift( @_ );
	my $Tmp;
	my $ReadIn;
	my $sqlshell;
	my $return;


	if ($dba_crypt_pw =~ /^\&aes\|/i) {
		$password = psiu_perl_decrypt_pw($dba_crypt_pw);
	}
	else {
		$password = $dba_crypt_pw;
	}

	$Tmp = eval "qq!$stmt!";
	if ( $Tmp ) {
		$stmt = $Tmp;
	}

	open(  TMPFILE, ">$tmpCommandFile") || die "Cannot create $tmpCommandFile\n";
	print( TMPFILE "\n\n\n" );
	print( TMPFILE "$stmt" );
	print( TMPFILE "\nexit\n" );
	close( TMPFILE );

	$sqlshell = "$SQLSCRIPT_EXECUTABLE -U ".$user." -P ".$password." -D ".$alias." -S ".$hostname." -n";

	$return = &ExecuteShell_Piped( "$tmpErrorFile",$sqlshell,"< \"$tmpCommandFile\"" );
  	if ( $bOutputResult eq TRUE ) {
  			$stmt = "";
  	  	open( TMPFILE, "<"."/$tmpErrorFile");
  	  	while ( $ReadIn = <TMPFILE> ) { 
  	 		$stmt = $stmt.$ReadIn; 
		}
  	  	close( TMPFILE );		
  	}
	unlink($tmpCommandFile);
	return $return;
}

#=============================================================
#
#  This function executes a shell command and pipes its output
#  to another file pointer.
#  Arguments:
#    $FileName - FileName to pipe to tmp.out
#    $Echo - Display command to be executed ?
#    $Cmd - Command to be executed
#    @<...> Arguments passed to execute function
#
#  Returns:the value returned by the system call
#=============================================================
sub ExecuteShell_Piped {
	my $FileName  = shift( @_ );
	my $Cmd 	= shift( @_ );
	my $Command; 
	my $result;

	$Command = join( " ", $Cmd, @_ );
	&OpenPipeFile( $FileName );
	open( STDOUT, ">&fpPipeFile");
	open( STDERR, ">&fpPipeFile");
	$result = system( $Command );
	close( fpPipedFile );
	close( STDOUT );
	close( STDERR );
	open( STDOUT, ">&SAVEOUT" );
	open( STDERR, ">&SAVEERR" );
	return $result;
  }


#=============================================================
#
#  This function opens a file for piping and selects it
#  Arguments :
#    $FileName - Name of file to use
#
#  Returns : fpPipeFile - File Pointer to Piped file
#
#=============================================================
sub OpenPipeFile {
	my( $FileName, $OpenType ) = @_;
	if ( !open( fpPipeFile, "> $FileName" )) {
		print "Unable to open the file $FileName \n";
    		exit( 1 );
	}
	select( fpPipeFile );
	$|=1;
	select( STDERR );
	$|=1;
	select( STDOUT );
	$|=1;
}

#=============================================================
#
#  This function outputs a string in the resource file
#  Arguments    :
#    $OutFile - Output file
#    $OutString - Output string
#    @<...> Arguments passed to write function
#
#  Returns : 1 if successful
#
#=============================================================
sub Output {
	my( $OutFile ) = shift( @_ );
	my( $OldFile ) = select( $OutFile );
	my( $Format ) = shift( @_ );
	my( $OutString ) = sprintf( $Format, @_ );
	syswrite ( $OutFile, $OutString, length( $OutString ) );
	select( $OldFile );
}

#---------------------------------------------------------------------
# This function checks for errors while any of the sql statements and
# procedures and displays the proper error messages. This function returns
# the error code or -1 on failure and 0 on success. 
#---------------------------------------------------------------------
sub CheckForErrors {
	my ( $tmpFile ) = shift( @_ );
	my ( $ReadString );
	my ( $Error ) = "NONE";  # 1st SQLserver error Msg found
	my ( $Errors ) = "";     # ALL SQLserver error Msg's found
	my ( $Result );
	my $hash_ref	 	= get_pinconf_entries();
	my $user 		= $$hash_ref{$_KEY_ADMIN};
	my $database		= $$hash_ref{$_KEY_DB};
	my $roles_tobe_assigned    = $$hash_ref{$_ROLES_TBA};

	#
	# Check for any SQLserver errors in the SQL statement output file
	#
	open( TMPFILE2, "<$tmpFile " );
	
	while( $ReadString = <TMPFILE2> )
	{		
		if ( $ReadString =~ m/osql/ ){
			print "'osql' is not recognized as an internal or external command, operable program or batch file.
			Checking whether sqlserver client is installed on you machine.\n";
			exit;
		}
		if ( $ReadString =~ m/ODBC\ Driver\ Manager/ ) {
			print " Data source name not found. Check the database alias provided, Exitting...\n";
			exit;
		}
		if ( $ReadString =~ m/Login\ failed\ for\ user/i ) {
			print "Login failed check the admin and db_alias entries provided in pin.conf. Exitting...\n";
			exit;
		}
		if ( $ReadString =~ /Msg\s([\d]*),\s.*/ )
		{
			if ( $Error eq "NONE" )
			{
				$Error = $1;
				$Errors = $1;
			}
			else
			{
				$Errors = "$Errors $1";
			}
		}
	}
	close( TMPFILE2 );
		
	#
	# If no SQLserver errors, then return now
	#
	if ( $Error eq "NONE" )
	{
		return 0;
	}		

	#
	# Process any SQLserver errors found in the SQL statement output file
	#
	if ( ( $Error eq "15025" ) || ( $Error eq "15023" ) )
	{
		#
		# MINOR ERROR
		#
		# Msg 15025, The login 'pin1' already exists.
		# Msg 15023, User or role 'pin1' already exists in the current database.
		# 
		#
		return $Error;
	}
	elsif ( $Error eq "15247" )
	{
		print "User :$user does not have user creation previleges \n Exitting...";
		return -1;	
			
	}
	elsif ( $Error eq "2601" )
	{
		return $Error;
		
	}
	elsif ( $Error eq "2812" )
	{
		print "Could not find stored procedure\n";
		return -1;
	}
	elsif ( $Error eq "15175" )
	{
		print "User has been dropped from current database \n";
		return $Error;
	}
	elsif ( $Error eq "15010" )
	{
		print "The database $database does not exist \n";
		return -1;
	}
	elsif ( $Error eq "15010" )
	{
		print "The database $database does not exist \n";
		return -1;
	}
	elsif ( $Error eq "15014" )
	{
		print "The role $roles_tobe_assigned does not exists in current database.\n";
		return -1;
	}
	elsif ( $Error eq "15434" )
        {
                print "User is currently logged in cannot remove pricing_admin.\n"; 
                return -1;
        }
	else
	{
		#
		# UNKNOWN ERROR
		#
		print "\n\n Unknown error. Check tmp.out for error Exitting... \n";
		return -1;	
	}
	
	return -1;
}

sub getpass {
    my $prompt = shift;

    unless($Is_Win32) { 
	open STDIN, "/dev/tty" or warn "couldn't open /dev/tty $!\n";
	system "stty -echo;";
    }

    my($c,$pwd1,$pwd2);
    print "$prompt:";
    $pwd1 = <STDIN>;
    chomp($pwd1);

    print "\nConfirm $prompt:";
    $pwd2 = <STDIN>;
    chomp($pwd2);

    system "stty echo" unless $Is_Win32;
    print "\n";

    if ( $pwd1 ne $pwd2 ) {
    	print "\nPassword confirmation failed\n";
	exit;
    }

    die "Can't use empty password!\n" unless length $pwd1;
    return $pwd1;
}

