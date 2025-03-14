#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl

#=======================================================================
# @(#)$Id: pin_cmp_virtual_col.pl /cgbubrm_7.5.0.portalbase/2 2014/04/23 17:18:07 vivilin Exp $
#
# Copyright (c) 2013, 2014, Oracle and/or its affiliates. All rights reserved.
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_functions.pl";
   require "../pin_setup.values";

   &ReadIn_PinCnf( "pin_cnf_dm.pl" );

   &Configure_VirtCol_Cnf;
}

sub Configure_VirtCol_Cnf{
	local($PinConfFile) = $PIN_HOME."/apps/pin_virtual_columns/Infranet.properties";

	if (! -e $PinConfFile) {
		#
		# Adding configuration
		#
		if (open(PINCONFFILE, "> $PinConfFile")) {
			print PINCONFFILE "$VIRTCOL_PINCONF_HEADER\n\n";
			print PINCONFFILE "# Logging configuration\n";
			print PINCONFFILE "infranet.log.file = vcol.pinlog\n";
			print PINCONFFILE "infranet.log.level = 1\n";
			print PINCONFFILE "infranet.log.name = VCOL\n\n";

			print PINCONFFILE "# JDBC connection configuration\n";
			print PINCONFFILE "infranet.vcol.userid = $MAIN_DM{'db'}->{'user'}\n";
			print PINCONFFILE "infranet.vcol.password = $MAIN_DM{'db'}->{'password'}\n";
			print PINCONFFILE "infranet.vcol.dbname = $MAIN_DM{'db'}->{'alias'}\n\n";

			print PINCONFFILE "infranet.vcol.worker_threads = 10\n";

			close( PINCONFFILE );
		} else {
			print STDOUT "The file $PinConfFile could not be opened \n";
		}
	}
}
1;
