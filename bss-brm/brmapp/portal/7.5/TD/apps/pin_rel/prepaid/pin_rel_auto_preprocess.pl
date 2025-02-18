#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# @(#)%Portal Version: pin_rel_auto_preprocess.pl:UelEaiVelocityInt:3:2006-Sep-05 22:24:21 %
#
#       Copyright (c) 2005-2006 Oracle. All rights reserved.
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license
#       or sublicense agreement.
#
#	Revision: 2005-06-01
#
use FileHandle;
use File::Copy;

$USAGE = "Usage: desFile \n";

$USAGE_ERR = 1;
$CANT_OPEN_FILE = 2;

# Hash Values for Mapping for Description File DataFileds to Control File DataFields.

%IREL = (
	EVENT_T => {
			1       =>  ["HEADER","2"],
			2       =>  ["DETAIL","/event.pin_fld_"],
			3       =>  ["POP_REL",0],
			4       =>  ["ASSOCIATED_INFRANET","/event.pin_fld_"],
			5       =>  ["ASSOCIATED_INVOICE_DATA","/event.pin_fld_"],
			6       =>  ["CONSTANT", "event_const_rel"]
	},
	EVENT_DELAYED_SESSION_GPRS_T => {
			1       =>  ["HEADER","2"],
			2       =>  ["DETAIL","/event/delayed/session/gprs.pin_fld_gprs_info.pin_fld_"],
			3       =>  ["POP_REL",1],
			4       =>  ["ASSOCIATED_GPRS","/event/delayed/session/gprs.pin_fld_gprs_info.pin_fld_"]
	},
	EVENT_DLAY_SESS_TLCS_T => {
			1       =>  ["HEADER","3"],
			2       =>  ["DETAIL","/event/delayed/session/telco/gsm.pin_fld_telco_info.pin_fld_"],
			3       =>  ["POP_REL",1],
			4       =>  ["ASSOCIATED_GSMW","/event/delayed/session/telco/gsm.pin_fld_telco_info.pin_fld_"]
	},
	EVENT_DLYD_SESSION_TLCO_GSM_T   => {
			1       =>  ["HEADER","2"],
			2       =>  ["DETAIL","/event/delayed/session/telco/gsm.pin_fld_gsm_info.pin_fld_"],
			3       =>  ["POP_REL",1],
			4       =>  ["ASSOCIATED_GSMW","/event/delayed/session/telco/gsm.pin_fld_gsm_info.pin_fld_"]
	},
	EVENT_BAL_IMPACTS_T             => {
			1       =>  ["HEADER","1"],
			2       =>  ["BALANCE_PACKET","/event.pin_fld_bal_impacts.pin_fld_"],
			3       =>  ["POP_REL",2]
	},
	EVENT_DELAYED_ACT_WAP_INTER_T   => {
			1       =>  ["HEADER","2"],
			2       =>  ["DETAIL","/event/delayed/activity/wap/interactive.pin_fld_wap_info.pin_fld_"],
			3       =>  ["POP_REL",1],
			4       =>  ["ASSOCIATED_WAP","/event/delayed/activity/wap/interactive.pin_fld_wap_info.pin_fld_"]
	},
	EVENT_DLAY_SESS_TLCS_SVC_CDS_T  => {
			1       =>  ["HEADER","2"],
			2       =>  ["SS_EVENT_PACKET","/event/delayed/session/telco/gsm.pin_fld_service_codes.pin_fld_"],
			3       =>  ["POP_REL",2]
	},
	EVENT_TAX_JURISDICTIONS_T  => {
			1       =>  ["HEADER","1"],
			2       =>  ["TAX_JURISDICTION","/event.pin_fld_tax_jurisdictions.pin_fld_"],
			3       =>  ["CONSTANT","tax_const_rel"],
			4       =>  ["POP_REL",3]
	},
);


# Hash Values for Mapping for Description File DataType to Control File DataType.
%irel_datatype = (
		"Not"           => "FILLER",
		"AscString"     => "CHAR",
		"AscInteger"    => "INTEGER EXTERNAL",
		"AscDecimal"    => "FLOAT EXTERNAL",
		"AscDateUnix"   => "INTEGER EXTERNAL"
	);

# Hash Values for the IREL Poid DataField and its DataType .
%irel_poid  = (
		1       =>	[ "_DB"    , "INTEGER EXTERNAL", "TERMINATED BY X'20'"],
		2       =>	[ "_TYPE"  , "CHAR", "TERMINATED BY X'20'"],
		3       =>	[ "_ID0"   , "INTEGER EXTERNAL", "TERMINATED BY X'20'"],
		4       =>	[ "_REV"   , "INTEGER EXTERNAL", ""],
	);

# Array - Fields Populated by REL For Event Class Tables.
@pop_rel= (
		["POID_ID0      INTEGER EXTERNAL"],
		["OBJ_ID0      	INTEGER EXTERNAL"],
		["OBJ_ID0      	INTEGER EXTERNAL", "REC_ID   	INTEGER EXTERNAL"],
		["OBJ_ID0      	INTEGER EXTERNAL", "REC_ID   	INTEGER EXTERNAL","ELEMENT_ID   INTEGER EXTERNAL"],
		["BALANCES_SMALL        CHAR(4000)","BALANCES_LARGE		CHAR(20000)","ACCOUNT_OBJ_ID0	INTEGER EXTERNAL"],
	);

# Array - Constant Fields for event_t Table.
@event_const_rel = (
        ["POID_REV"         ,"0"],
        ["READ_ACCESS"      ,"'L'"],
        ["WRITE_ACCESS"     ,"'L'"],
        ["NAME"             , "'Pre-rated Event'"],
        ["EARNED_START_T"   ,"0"],
        ["EARNED_END_T"     ,"0"],
        ["EARNED_TYPE"      ,"0"],
        ["ARCHIVE_STATUS"   ,"0"],	
        ["PROGRAM_NAME"     ,"'REL'"],
        ["CREATED_T"        ,"1044035814"],
        ["MOD_T"            ,"1044035814"],
        ["POID_DB"          ,"1"],
        ["POID_TYPE"        ,"'/event/delayed/session/gprs'"],
        ["SYS_DESCR"        ,"'/event/delayed/session/gprs'"],
        ["SESSION_OBJ_DB"   ,"1"],
        ["SESSION_OBJ_TYPE" ,"'/batch/rel'"],
        ["SESSION_OBJ_ID0"  ,"212566383975886336"],
        ["SESSION_OBJ_REV"  ,"0"],
        ["USERID_DB"        ,"1"],
        ["USERID_TYPE"      ,"'/service/pcm_client'"],
        ["USERID_ID0"       ,"1"],
        ["USERID_REV"       ,"1"],
	);

# Array - Constant Fields for Event Tax Jurisdictions Table.
@tax_const_rel = (
        ["AMOUNT_EXEMPT"  ,"0"],
        ["NAME"           ,"X'20'"],
	);

# Function - Prints The Potal Copyright Header for The Control Files 
sub printHeader($$)
{
	my $fh_Pin_Head = $_[0];
	my $print_Table = $_[1];


print $fh_Pin_Head <<"MyHead";
--
--       Copyright (c) 2005-2006 Oracle. All rights reserved.
--       This material is the confidential property of Oracle Corporation
--       or its licensors and may be used, reproduced, stored
--       or transmitted only in accordance with a valid Oracle license
--       or sublicense agreement.
--
MyHead
}


#
# Function to exit program with error code and error messages.
#
sub exit_err {
   $errCode = shift;
   $msg1 = shift;
   $msg2 = shift;

   print "$errCode : $msg1 : $msg2";
   exit( $errCode);
}

# Function - Prints The Control File Header 
sub printCtlHeader($$$)
{
	my $fh_Ctl_Head 	= $_[0];
	my $ctl_Tbl_Name 	= $_[1];
	my $head_Flg 		= $_[2];

print $fh_Ctl_Head <<"MyCtlHead";
UNRECOVERABLE
LOAD DATA
CHARACTERSET UTF8
APPEND
INTO TABLE $ctl_Tbl_Name
SINGLEROW
PARTITION (P_1D)
MyCtlHead

if ($head_Flg == 1){ 
print $fh_Ctl_Head <<"Head1";
FIELDS TERMINATED BY X'09'
(
Head1
}
if ($head_Flg == 2){ 
print $fh_Ctl_Head <<"Head2";
FIELDS TERMINATED BY X'09'
TRAILING NULLCOLS
(
Head2
}
if ($head_Flg == 3){ 
print $fh_Ctl_Head <<"Head3";
TRAILING NULLCOLS
(
Head3
}
	
}


#
# Parse command line flags.
#
($#ARGV != 0) && exit_err($USAGE_ERR, $USAGE);
$inFile = $ARGV[0];


# Loacl Variables For Control File Generation
my $fh 			= new FileHandle;
my $count 		= 0;
my $struct_Flg 	= "False";
my $table_Name 	= "";
my $file_Name 	= "";
my $cmn_Flg 	= "False";
my $print_Flg 	= "False";
my $print_Trm 	= "False";
my $file_Bk_Extn = ".bak." .time;


for $row (keys %IREL){
        
	$table_Name = $row;
	$file_Name 	= $row.".ctl";
	$file_Name 	= lc($file_Name);
	$file_Name_Bak = $file_Name . $file_Bk_Extn;

	# Backup the Control files  
	if ( -e $file_Name){
	   copy($file_Name, $file_Name_Bak);
	}


	$fh->open(">$file_Name") || exit_err( $CANT_OPEN_FILE, $file_Name, $!);
	&printHeader($fh, $table_Name);

	$cmn_Flg 	= "False";
	$print_Trm 	= "False";


	for $sub_row (sort keys %{$IREL{$row}}){
	
	if($IREL{$row}{$sub_row}[0] eq "HEADER"){
 		&printCtlHeader($fh, $table_Name, $IREL{$row}{$sub_row}[1] );
		if ($IREL{$row}{$sub_row}[1] == 3){ 
			$print_Trm = "True";
		}
	}

	if($IREL{$row}{$sub_row}[0] eq "POP_REL"){
		for $inner (0..$#{$pop_rel[$IREL{$row}{$sub_row}[1]]}){
			if (($cmn_Flg eq "True") && ($print_Trm eq "True")){ 
				print $fh "  TERMINATED BY X'09',\n";
			}
			elsif($cmn_Flg eq "True"){
				print $fh ",\n";
			}
            print $fh sprintf ("\t%-30s",$pop_rel[$IREL{$row}{$sub_row}[1]][$inner]);
			if ($cmn_Flg eq "False"){ $cmn_Flg = "True";}
        }
 	}
	elsif($IREL{$row}{$sub_row}[0] eq "CONSTANT"){
		my @const_rel = @{$IREL{$row}{$sub_row}[1]};
		for $outer (0..$#const_rel){
			if ($cmn_Flg eq "True"){ print $fh ",\n";}
        		print $fh sprintf ("\t%-30s %-10.20s %s",uc($const_rel[$outer][0]),
						uc($IREL{$row}{$sub_row}[0]),$const_rel[$outer][1]);
			if ($cmn_Flg eq "False"){ $cmn_Flg = "True";}
		}	
	}
	else{
		open(IN_FILE, $inFile) || exit_err( $CANT_OPEN_FILE, $inFile, $!);
		$line = <IN_FILE>;
		while($line)
		{
			chomp($line);
			if ( $line =~ /$IREL{$row}{$sub_row}[0]\(SEPARATED\)/)  {
			$struct_Flg = "True";
			}

			if ($struct_Flg =~ /True/){
			if (($count ==  1) && ($line =~ /\/\ IREL/)){
				# Identify The Data Type.
				$line =~ s/\(\)//g;
				# Identify The DataType and Field Name .
				$line           =~ s/\/\/ IREL //g;
				$line           =~ s/\[\]//g;
				@trim_line = split(/\s+/ ,$line);
		
				if (@trim_line[3] =~ /Not/){
					
					if (($cmn_Flg eq "True") && ($print_Trm eq "True"))	{ 
						print $fh "  TERMINATED BY X'09',\n";	
					}
					elsif($cmn_Flg eq "True")	{ 
						print $fh ",\n";	
					}
					
					if (((@trim_line[1] eq "RECORD_TYPE") || (@trim_line[1] eq "RECORD_NUMBER"))
							&& ($IREL{$row}{$sub_row}[0] ne "DETAIL")){
							@trim_line[1] = @trim_line[1]."2";
							print $fh sprintf("\t%-30s %-10.20s",uc(@trim_line[1]),
									uc($irel_datatype{@trim_line[3]}));
					}	
					else{	
						print $fh sprintf("\t%-30s %-10.20s",uc(@trim_line[1]),
									uc($irel_datatype{@trim_line[3]}));
					}
					if ($cmn_Flg eq "False"){ $cmn_Flg = "True";}
				}
				else{
					if ($line =~ $IREL{$row}{$sub_row}[1] )
					{
						@trim_line[2] =~ s/\;//g;
						$length = @trim_line;
						$frm_Trm = $print_Trm;

						for($i = 3; $i< $length ; $i++){
							if (@trim_line[$i] =~ $IREL{$row}{$sub_row}[1]){
							@trim_line[$i] =~ s/$IREL{$row}{$sub_row}[1]//g;
							@trim_line[$i] =~ s/,//g;
							if ((@trim_line[1] =~ /POID/) && (@trim_line[$i] !~ /\./)){
								for $poid_Row (sort keys (%irel_poid)){
									if ($cmn_Flg eq "True"){ print $fh ",\n";}
									$fld1 = uc(@trim_line[$i].$irel_poid{$poid_Row}[0]);
									$fld2 = uc($irel_poid{$poid_Row}[1]);
									$fld3 = uc($irel_poid{$poid_Row}[2]);
									print $fh sprintf ("\t%-30s %-10.20s %s ",$fld1,$fld2,$fld3);
									$print_Flg = "True";
									if ($cmn_Flg eq "False"){ $cmn_Flg = "True";}
								}
							}
							elsif(@trim_line[$i] !~ /\./){
								if (($cmn_Flg eq "True") && ($frm_Trm eq "True")){
									print $fh "  TERMINATED BY X'09',\n";	
								}
								elsif($cmn_Flg eq "True"){	
									print $fh ",\n";
								}
	
								if (((@trim_line[$i] eq "RECORD_TYPE") || (@trim_line[$i] eq "RECORD_NUMBER"))
										&& ($IREL{$row}{$sub_row}[0] ne "DETAIL")){ 
											@trim_line[$i] = @trim_line[$i]."2";
											print $fh sprintf("\t%-30s %-10.20s",uc(@trim_line[$i]),
														uc($irel_datatype{@trim_line[2]}));
								}	
								else{	
									$frm_Trm = "False";
									if (@trim_line[$i] =~ /\(/){
										$field_Type = @trim_line[$i];
										@field = split(/\(/,$field_Type);
										@field[1] = $irel_datatype{@trim_line[2]}."(".@field[1];
										print $fh sprintf("\t%-30s %-10.20s",uc(@field[0]),uc(@field[1]));
									}
									else{
										print $fh sprintf("\t%-30s %-10.20s",uc(@trim_line[$i]),
															uc($irel_datatype{@trim_line[2]}));
									}
								}
								$print_Flg = "True";
								if ($cmn_Flg eq "False"){ $cmn_Flg = "True";}
							}
							}
						}
						if ($print_Flg eq "False"){
						if (($cmn_Flg eq "True") && ($print_Trm eq "True")){ 
							print $fh "  TERMINATED BY X'09',\n";
						}
						elsif($cmn_Flg eq "True"){
						print $fh ",\n";
						}
						if (((@trim_line[1] eq "RECORD_TYPE")  || (@trim_line[1] eq "RECORD_NUMBER")) 
							&& ($IREL{$row}{$sub_row}[0] ne "DETAIL")){ 
								@trim_line[1] = @trim_line[1]."2";
								print $fh sprintf("\t%-30s %-10.20s",uc(@trim_line[1]),
												uc($irel_datatype{'Not'})); 
						}	
						else{	
							print $fh sprintf("\t%-30s %-10.20s",uc(@trim_line[1]),
										uc($irel_datatype{'Not'}));
						}
							if ($cmn_Flg eq "False"){ 
								$cmn_Flg = "True";
							}
						}

					}
					else{
						if (($cmn_Flg eq "True") && ($print_Trm eq "True")){ 
							print $fh "  TERMINATED BY X'09',\n";
						}
						elsif($cmn_Flg eq "True"){
							print $fh ",\n";
						}
						if (((@trim_line[1] eq "RECORD_TYPE") || (@trim_line[1] eq "RECORD_NUMBER"))
							&& ($IREL{$row}{$sub_row}[0] ne "DETAIL")){ 
								@trim_line[1] = @trim_line[1]."2";
								print $fh sprintf("\t%-30s %-10.20s",uc(@trim_line[1]),
												uc($irel_datatype{'Not'}));
						}	
						else{	
							print $fh sprintf("\t%-30s %-10.20s",uc(@trim_line[1]),
										uc($irel_datatype{'Not'}));
						}
						if ($cmn_Flg eq "False"){ 
							$cmn_Flg = "True";
						}
					}
					
				}

			}
				if ($line =~ /\{/ ){
				$count = $count + 1;
				}
				if ($line =~ /\}/){
				$count = $count - 1;
				if ($count == 0){
					$struct_Flg = "False";
				}
				}
			}

		  $print_Flg = "False";
		  $line = <IN_FILE>;
	   }  
		close(IN_FILE);
	}  
	}

	print $fh "\n)\n";
	$fh->close();
}  

# after the control files Generation.
print "Control files generated successfully \n";


