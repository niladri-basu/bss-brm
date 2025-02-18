#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=======================================================================
#  @(#)%Portal Version: pin_crt_idx.pl:InstallVelocityInt:1:2005-Mar-25 18:12:01 %
# 
# Copyright (c) 2003, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
#
# Create Portal indexes
#
require "pin_res.pl";
require "pin_functions.pl";
require "../pin_setup.values";
require "pin_tables.values";

$path = "$MAIN_DM{'location'}/data/create_indexes.source";


%DB  = %{%MAIN_DM->{'db'}};

local( $vendor_func );
 
( $vendor = $DB{'vendor'} ) =~ tr/A-Z/a-z/;
$vendor_func = "pin_".$vendor."_functions.pl";
eval qq!require "$vendor_func"!;

&ExecuteSQL_Statement_From_File( "$path", 
				  TRUE, 
                                  TRUE, 
                                  %DB );
