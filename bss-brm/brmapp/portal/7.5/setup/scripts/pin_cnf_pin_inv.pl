#=======================================================================
#  @(#)%Portal Version: pin_cnf_pin_inv.pl:InstallVelocityInt:1:2005-Mar-25 18:12:51 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
%PIN_INV_PINCONF_ENTRIES = (
	"pin_inv_accts_db_description", <<END
#************************************************************************
# Configuration File for Portal Invoicing Applications
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
#
#========================================================================
# Entries for pin_inv_accts
#
# These entries are used for pin_inv_accts configuration only.
#
# Note: Enable these entries only if you want different applications
#       configured differently.
#========================================================================
#
#- pin_inv_accts        children        5
#- pin_inv_accts        per_batch       500
#- pin_inv_accts        per_step        1000
#- pin_inv_accts        fetch_size      5000
#- pin_inv_accts        hotlist         hot_list
#- pin_inv_accts        monitor         monitor
#- pin_inv_accts        max_errs        1
#- pin_inv_accts        multi_db        0
#
#========================================================================
# Default database number
#
# Specifies the default database number for searching.
#========================================================================
END
	,"pin_inv_accts_db", "- pin_inv_accts database $DM{'db_num'} /search 0"
	,"pin_inv_upgrade_db_description", <<END
#========================================================================
# Entries for pin_inv_upgrade
#
# These entries are used for pin_inv_upgrade configuration only.
#
# Note: Enable these entries only if you want different applications
#       configured differently.
#========================================================================
#
#- pin_inv_upgrade        children        5
#- pin_inv_upgrade        per_batch       500
#- pin_inv_upgrade        per_step        1000
#- pin_inv_upgrade        fetch_size      5000
#- pin_inv_upgrade        hotlist         hot_list
#- pin_inv_upgrade        monitor         monitor
#- pin_inv_upgrade        max_errs        1
#- pin_inv_upgrade        multi_db        0
#
#========================================================================
# Default database number
#
# Specifies the default database number for searching.
#========================================================================
END
	,"pin_inv_upgrade_db", "- pin_inv_upgrade database $DM{'db_num'} /search 0" 
	,"pin_inv_send_db_description", <<END
#========================================================================
# Entries for pin_inv_send
#
# These entries are used for pin_inv_send configuration only.
#
# Note: Enable these entries only if you want different applications
#       configured differently.
#========================================================================
#
#- pin_inv_send        children        5
#- pin_inv_send        per_batch       500
#- pin_inv_send        per_step        1000
#- pin_inv_send        fetch_size      5000
#- pin_inv_send        hotlist         hot_list
#- pin_inv_send        monitor         monitor
#- pin_inv_send        max_errs        1
#- pin_inv_send        multi_db        0
#
#========================================================================
# pin_inv_send header information
#
# (UNIX only) Specifies the email subject and the name and email address
# of the sender.
#
# Note: When you configure Windows NT, you might have to change the
#       dm_email configuration file to modify the mailbox entry.
#
# Note: The "from" entry seems to have higher priority than the "sender" 
#       entry; that is, if you configure the "from" entry, only the "From"
#       email address will be shown, regardless of whether you have
#       configured the "sender" entry.
#========================================================================
#- pin_inv_send          sender          Portal Software Inc.
#- pin_inv_send          from            billing
#- pin_inv_send          subject         Invoice - Online Service
#
#========================================================================
# pin_inv_send invoice format
#
# Specifies one of these four formats:
#
#    text/pin_flist
#    text/xml
#    text/html (Default)
#    text/doc1 (Raw file)
#
# You can also specify an arbitrary mime type, such as text/xslt.
# In this case, the mime type must be understood by the formatting opcode.
#========================================================================
#- pin_inv_send       invoice_fmt     text/html
#
#========================================================================
# Invoice data format for non-invoice accounts
#
# Specifies, for non-invoice accounts, whether to print or email the
# invoice data.
#
# This entry works for non-invoice accounts only. The value for this
# entry can be:
#
#    0       = email
#    Nonzero = (Default) print
#========================================================================
#- pin_inv_send delivery_preference  1
#
#========================================================================
# Email format for invoice accounts
#
# Specifies, for invoice accounts, whether to attach the invoice in the
# email or to include it in the email body.
#
# The value for this entry can be:
#
#    0       = (Default) Include invoice in email body.
#    Nonzero = Attach the invoice
#========================================================================
#- pin_inv_send         email_option      0
#
#========================================================================
# Customized email message
#
# If you choose to send invoices as email attachments, you can include a
# customized message in the email body. This entry specifies the path to
# a text file containing that customized message.
#
# Note: This option takes effect only if the email format for invoice
#       accounts (pin_inv_send email_option, above) is set to 1.
#========================================================================
#- pin_inv_send         email_body      ./letter
#
#========================================================================
# Default database number
#
# Specifies the default database number for searching.
#========================================================================
END
	,"pin_inv_send_db", "- pin_inv_send database $DM{'db_num'} /search 0" 
	,"pin_inv_export_db_description", <<END
#========================================================================
# Entries for pin_inv_export
#
# These entries are used for pin_inv_export configuration only.
#
# Note: Enable these entries only if you want different applications
#       configured differently.
#========================================================================
#
#- pin_inv_export        children        5
#- pin_inv_export        per_batch       500
#- pin_inv_export        per_step        1000
#- pin_inv_export        fetch_size      5000
#- pin_inv_export        hotlist         hot_list
#- pin_inv_export        monitor         monitor
#- pin_inv_export        max_errs        1
#- pin_inv_export        multi_db        0
#
#========================================================================
# Export format
#
# Specifies one of these formats for exported files:
#
#    text/plain
#    text/pin_flist
#    text/xml
#    text/html (Default)
#    text/doc1 (Raw file)
#
# You can also specify an arbitrary mime type, such as text/xslt.
# In this case, the mime type must be understood by the formatting opcode.
#========================================================================
#- pin_inv_export       invoice_fmt     text/html
#
#========================================================================
# Invoice directory
#
# Specifies the directory for exporting invoices
#========================================================================
#- pin_inv_export       export_dir      ./invoice_dir
#
#========================================================================
# Default database number
#
# Specifies the default database number for searching.
#========================================================================
END
	,"pin_inv_export_db", "- pin_inv_export database $DM{'db_num'} /search 0"
 );
