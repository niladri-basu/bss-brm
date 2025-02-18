#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: readConfigUtility.pm:RWSmod7.3.1Int:1:2007-Jul-03 00:52:15 %
#
# Copyright (c) 2007 Oracle. All rights reserved.
#
# This material is the confidential property of Oracle Corporation or
# its licensors and may be used, reproduced, stored or transmitted only
# in accordance with a valid Oracle license or sublicense agreement.
#


package readConfigUtility;
use Env;

our @ISA =qw(Exporter);
our @EXPORT =qw(readConfigValue);
$config_file="./pin_db_alert.conf";

sub readConfigValue {
    my $inputParameter= $_[0];
    #print STDOUT "input param: $inputParameter \n";
    my $onlyValue="";
    open( PINCONFFILE, "<", $config_file) || die "cannot open configuration file : $config_file";
    while ( my $line = <PINCONFFILE>) {
        # skip comment line begining with #
        next if ($line =~ /^\s*#/ );
        # matching entry then return the value
        if ( $line =~ /$inputParameter/ ) {
            # split at '=' to extract the value
            my @inputLine = split (/=/, $line);
            $paramValue= $inputLine[1];
            chomp($paramValue);
            #print STDOUT " MATCHED VALUE: $paramValue \n";
            # check if it has open and close brace
            if ( $paramValue =~ /^\(/ ) {
            # skip the open and close brace for an array variable
            #print STDOUT " MATCHED BRACES \n";
            $onlyValue=substr($paramValue,1, -2);
            }
            if ( $paramValue =~ /^"/ )
            {
            # This is a string value. Skip the open and close double quotes.
            #print STDOUT " MATCHED QUOTE \n";
            $onlyValue=substr($paramValue, 1, -2);
            }
            #print STDOUT "value: $onlyValue \n";
	    last;	
        }
     }
     close( PINCONFFILE );
     return $onlyValue;
}

1;
