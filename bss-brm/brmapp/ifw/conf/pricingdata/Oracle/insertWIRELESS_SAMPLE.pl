#!/brmapp/portal/ThirdParty/perl/5.8.0/bin/perl

$cmd = "sqlplus integrate\@QA10/integrate \@insertWIRELESS_SAMPLE.sql";
system($cmd);

exit 0;
