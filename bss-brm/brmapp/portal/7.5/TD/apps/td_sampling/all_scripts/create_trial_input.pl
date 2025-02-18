#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
##----------------------------------------------------------------------
##
##Author: Rakesh Nair
##Date: 2-Jan-2015
##Descr: Create trial billing input file
##----------------------------------------------------------------------
require "sampling_control.cfg";

$array_cnt=0;

if ($#ARGV + 1 < 1)
{
        print "Usage : create_trial_input.pl <INPUT_FILE>";
        exit;
}

$file_name = $ARGV[0];

my $actg_dom = $ACTG_CYCLE_DOM_CONF;

my ($dd, $mm, $yyyy) = (localtime)[3..5];
$mm=$mm+1;
$yyyy=$yyyy+1900;

$tmp_file_dir = "./scenario_logs/";
$tmp_file_name = "trial_bill_input_";
$tmp_bip_file_name = "docgen_file_input_";

if ($dd > $actg_dom)
	{
	$mm=$mm+1;
	if ($mm == 13)
		{$mm = 1;
		 $yyyy = $yyyy+1;
		}
	}

if (length $mm ne 2)
        {
        $mm=LPad($mm,2,0);
        }

if (length $actg_dom ne 2)
        {
        $actg_dom=LPad($actg_dom,2,0);
        }

$out_file_name = $tmp_file_dir.$tmp_file_name.$mm.$actg_dom.$yyyy;
$trial_out_file = $tmp_file_name.$mm.$actg_dom.$yyyy;
$bip_file_name = $tmp_file_dir.$tmp_bip_file_name.$mm.$actg_dom.$yyyy.".xml";
$bip_out_file = $tmp_bip_file_name.$mm.$actg_dom.$yyyy.".xml";


print "Started @ : ";
print scalar localtime()."\n";


open (IN_FILE, "$file_name") || die "Cant open input file";
open(MYOUTFILE, ">$out_file_name");
open(MYBIPOUTFILE, ">$bip_file_name");

$bip_input_xml_header=<< "EOF"
<?xml version="1.0" encoding = 'UTF-8'?>
<InvoiceDocGenConfig xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     xmlns="http://www.oracle.com/BRM/schemas"
                     xsi:schemaLocation="http://www.oracle.com/BRM/schemas InvoiceList.xsd">
EOF
;

print MYBIPOUTFILE $bip_input_xml_header;


test: while(<IN_FILE>)
{
        $RECORD = $_;
        chomp($RECORD);
        @value = $RECORD;
        $apnipvar = $value[0];
	@apnip = split(',',$apnipvar);
	$e_pdp = $apnip[0];
	$e_pdp1 = $apnip[1];
	$bill_account_fl = "";

$bill_account_fl=<< "EOF"
0 PIN_FLD_RESULTS             ARRAY [$array_cnt] allocated 1, used 1
1     PIN_FLD_ACCOUNT_OBJ      POID [0] 0.0.0.1 /account $e_pdp
1     PIN_FLD_POID             POID [0] 0.0.0.1 /billinfo $e_pdp1
EOF
;

$bip_input_xml=<< "EOF"
<InvoicingList>
    <Account>$e_pdp</Account>
    <Billinfo>$e_pdp1</Billinfo>
</InvoicingList>
EOF
;

$array_cnt=$array_cnt+1;
print MYOUTFILE $bill_account_fl;
print MYBIPOUTFILE $bip_input_xml;

}

close(MYOUTFILE);
$bip_input_xml_trail=<< "EOF"
</InvoiceDocGenConfig>
EOF
;

print MYBIPOUTFILE $bip_input_xml_trail;
close(MYBIPOUTFILE);



print "Starting Trial bill execution: \n";
`cp $out_file_name $TRIAL_INPUT_DIR`;
$trial_bill_file = $TRIAL_INPUT_DIR.$trial_out_file;
`cd  $TRIAL_INPUT_DIR`;
print "pin_trial_bill_accts -end $mm/$actg_dom/$yyyy -verbose -f $trial_bill_file > ./scenario_logs/$trial_out_file.log";

`pin_trial_bill_accts -end $mm/$actg_dom/$yyyy -verbose -f $trial_bill_file > ./scenario_logs/$trial_out_file.log`;
`cd -`;

`cp $bip_file_name $BIP_INPUT_DIR`; 

print "\n cp $BIP_INPUT_DIR/$bip_out_file InvoiceList.xml ";
`cp $BIP_INPUT_DIR/$bip_out_file $BIP_INPUT_DIR/InvoiceList.xml`;
`cd $BIP_INPUT_DIR`;
print "\n cd $BIP_INPUT_DIR";

#print "\n $BIP_INPUT_DIR/docgen_trial.sh $BIP_INPUT_DIR/InvoiceList.xml > ./scenario_logs/$bip_out_file.log \n " ;
#print "\n $BIP_INPUT_DIR/docgen_trial.sh InvoiceList.xml > $bip_out_file.log \n " ;
#`cd $BIP_INPUT_DIR;./docgen_trial.sh InvoiceList.xml > $bip_out_file.log`;
`cd -`;
sub LPad
{
        ($str, $len, $chr) = @_;
        $chr = "0" unless (defined($chr));
        return substr(($chr x ($len - length $str)).$str, 0, $len);
}

