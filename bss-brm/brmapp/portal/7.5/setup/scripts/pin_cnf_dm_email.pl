# @(#)%Portal Version: pin_cnf_dm_email.pl:InstallVelocityInt:3:2005-Mar-23 20:57:01 %
#=============================================================
#
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or
#       sublicense agreement.
#
# Resource file for Infranet Base Installation perl scripts
# Language: English
#=============================================================
##
## Also requires QM pin cnf entries
##

%DM_EMAIL_PINCONF_ENTRIES = (
       "unix_sendmail_command_description",<<END
#======================================================================
# unix_sendmail_command
#
# (unix only) the sendmail string and command line options used
#
# Warning: Edit this string only if you are a sendmail expert and
# know what you are doing.Wrong usage could result in mail errors
#======================================================================
END
        ,"unix_sendmail_command", "- dm_email      unix_sendmail_command       /usr/lib/sendmail -t"
	,"db_no_description", <<END
#======================================================================
# db_no
#
# Number of the database to which the Email Data Manager connects.
#
# The format is 0.0.0.n  / 0  where n is your database number. The
# default number is 3.
# 
# You must also include the database number in the dm_pointer 
# Connection Manger configuration file entry.
#======================================================================
END
	,"db_no", "- dm_email db_no $DM_EMAIL{'db_num'} / 0"
	,"mail_profile_description", <<END
#======================================================================
# mail_profile
#
# (Windows NT only) Name of the mail profile you are using with
# the Email Data Manager.
#
# You can view existing profiles and create new ones by using the 
# Mail Control Panel in Windows NT. 
#======================================================================
END
	,"mail_profile", "- dm_email mail_profile $DM_EMAIL{'mail_profile'}"
	,"mail_mailbox_description", <<END
#======================================================================
# mail_mailbox
#
# (Windows NT only) Name of the mailbox associated with the mail 
# profile you are using with the Email Data Manager.
#
# This name appears as the From address in the email you send your 
# customers. You can create a mailbox name as part of creating the 
# mail profile in the Mail Control Panel in Windows NT.
#======================================================================
END
	,"mail_mailbox", "- dm_email mail_mailbox $DM_EMAIL{'mailbox'}" 
	,"mail_html2ps_description", <<END
#======================================================================
# html2ps
#
# Path to the html2ps script to convert HTML invoices into PS files
# for printing.
#
#======================================================================
END
	,"mail_html2ps", "- dm_email html2ps html2ps" 
	,"mail_printer_description", <<END
#======================================================================
# printer
#
# Name of the printer for printing invoices.
#
# The printer name might be different on unix or on NT.
#======================================================================
END
	,"mail_printer", "- dm_email printer $DM_EMAIL{'printer'}" 
	,"mail_tmp_dir_description", <<END
#======================================================================
# tmp_dir
#
# Path to the html2ps script to convert HTML invoices into PS files
# for printing.
#
#======================================================================
END
	,"mail_tmp_dir", "- dm_email tmp_dir $DM_EMAIL{'pin_conf_location'}/invoice_dir" );

%DM_EMAIL_CM_PINCONF_ENTRIES = (
  "dm_email_dm_pointer_description", <<END
#========================================================================
# dm_email_dm_pointer
#=======================================================================
END
  , "dm_email_dm_pointer", <<END
- cm dm_pointer $DM_EMAIL{'db_num'} ip $HOSTNAME $DM_EMAIL{'port'}
END

  , "fm_required_description", <<END
#=======================================================================
# fm_required
#=======================================================================
END
  , "fm_required", <<END
- cm fm_module \$\{PIN_HOME\}/lib/fm_delivery\$\{LIBRARYEXTENSION\} fm_delivery_config$FM_FUNCTION_SUFFIX - pin
END

);
