#
# @(#)%Portal Version: aes_db.pm:CUPmod7.3PatchInt:1:2006-Oct-17 02:13:07 %
#
#	Copyright (c) 2006  Oracle. All rights reserved.
# 
#	This material is the confidential property of Oracle Corporation or its
#	licensors and may be used, reproduced, stored or transmitted only in
#	accordance with a valid Oracle license or sublicense agreement.
#

use aes;
package aes_db;

#
# This procedure decrypts the password(second parameter), if it is in encrypt format
# replace string PASSWORD with decrypted password and execute it (like system command).
# Example to run sqlplus command with input file.
# Expected : connect to database through sqlplus command and executes the input file
# Arg 1: sqlplus command with input file and with string password in it.
#	 Like, 'sqlplus <user_name>/PASSWORD@<database_name> < /tmp/input.sql >tmp.out'
# Arg 2: Encrypted password
#	 Like,  '&aes|05|0D5E11BFDD97D2769D9B0DBFBD1BBF7E5A47EE7B6C8677D6E95F4E14E55CA745C1'
# Returns the output of command
sub exec_sql_cmd
{
	my $cmd = $_[0];
	my $pswd = $_[1];
	if ($pswd =~ m/&aes*/) {
		my ($inp, $plain);
		$inp = aes::pcm_new_charp($pswd);
		$plain = aes::psiu_perl_decrypt_pw($inp);
		$cmd =~ s/PASSWORD/$plain/i;
	} else {
		$cmd =~ s/PASSWORD/$pswd/i;
	}
	$output = system($cmd);
	return $output;
}
1;
