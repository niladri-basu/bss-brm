#=======================================================================
# 
# Copyright (c) 2007, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$ADU_PINCONF_HEADER  =  <<END 
#************************************************************************
# Configuration File for Account Dump Utility (ADU)
#
#
# This configuration file is automatically installed and configured with
# default values during Portal installation. You can edit this file to:
#   -- change the default values of the entries.
#   -- disable an entry by inserting a crosshatch (#) at the start of
#        the line.
#   -- enable a commented entry by removing the crosshatch (#).
# 
# Before you make any changes to this file, save a backup copy.
#
# When editing this file, follow the instructions in each section.
# For more information on the general syntax of configuration entries,
# see "Reference Guide to Portal Configuration Files" in the Portal
# online documentation.
#************************************************************************
END
;

%ADU_CM_PINCONF_ENTRIES = (
  "adu_fm_module_description", <<END
#========================================================================
# adu_fm_module
#
# Required Facilities Modules (FM) configuration entries
#
# The entries below specify the required FMs that are linked to the CM when
# the CM starts. The FMs required by the CM are included in this file when
# you install Portal. 
#
# Caution: DO NOT modify these entries unless you need to change the
#          location of the shared library file. DO NOT change the order of
#          these entries, because certain modules depend on others being
#          loaded before them.
#=======================================================================
END
  , "adu_fm_module", <<END
- cm fm_module \$\{PIN_HOME\}/lib/fm_adu\$\{LIBRARYEXTENSION\} fm_adu_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_adu_pol\$\{LIBRARYEXTENSION\} fm_adu_pol_config$FM_FUNCTION_SUFFIX - pin
END

);

%ADU_PINCONF_ENTRIES = (
  "adu_params_description", <<END
#======================================================================
# ADU Parameters
# 
#  -- input_file:	 Name of the ADU input file. This file contains
#			 the account search specification.
#  -- output_dir:	 Name of the folder where ADU should write the
#			 output files.
#  -- out_file_ext:	 ADU output file extension.
#  -- obj_list:		 List of objects for which dump has been requested.
#  -- obj_flds:		 List of specific fields under an object for which
#			 dump has been requested instead of whole object. 
#
#  The following parameters represent the date range from which the 
#  frequently updated objects in BRM system need to be selected. These
#  values should be in UTC format.
#  -- dump_start_time
#  -- dump_end_time
#
#  The following parameters represent the static and dynamic validation
#  scenarios of ADU. To enable a particular validation scenario, change
#  its value to 1.
#  -- struct_valid_01
#  -- struct_valid_02
#  -- struct_valid_03
#  -- struct_valid_04
#  -- struct_valid_05
#  -- dynamic_valid_01
#======================================================================
END
  , "adu_params", <<END

- pin_adu input_file 		$ADU{'location'}/in/input.txt
- pin_adu output_dir 		$ADU{'location'}/out
- pin_adu out_file_ext 		.xml
- pin_adu obj_list 		/account, /service/ip, /billinfo, /payinfo/invoice
- pin_adu obj_flds		/account: PIN_FLD_NAMEINFO; /service/ip: PIN_FLD_POID, PIN_FLD_SERVICE_IP.PIN_FLD_IPADDR; /payinfo/invoice: PIN_FLD_INV_INFO;

- pin_adu dump_start_time	0
- pin_adu dump_end_time		0

- pin_adu struct_valid_01       0
- pin_adu struct_valid_02       0
- pin_adu struct_valid_03       0
- pin_adu struct_valid_04       0
- pin_adu struct_valid_05       0
- pin_adu dynamic_valid_01      0

END
);