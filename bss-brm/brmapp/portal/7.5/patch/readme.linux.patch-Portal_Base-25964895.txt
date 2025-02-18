Patch 25964895 
--------------
SR :3-14667111221 
BUG ID: 25942355 
RELEASE: 7.5.0.11.0
OPERATING SYSTEM: LINUX
TITLE:P-23230862 PIN_REL Procedure Failure


IMPORTANT
---------
Contact Oracle Support before downloading this patch to determine if
this patch is appropriate for your environment.  Do not download and
install this patch unless you have been advised by Oracle Support that
this patch is appropriate for your environment.


PATCH DESCRIPTION
-----------------
This patch is meant to be installed on Oracle Communications
Billing and Revenue Management Release 7.5 RTW + Patch Set 11(20286776)

This patch package consists of Portalbase Packages.

ADDITIONAL INFORMATION:
-----------------------

For Bug 25942355 :
------------------
New items creating for each record in CDR after service transfer. Changes 
made to re-use the item created for the first record(event).


FILES  AFFECTED
---------------
Portalbase_dir/apps/pin_rel/pin_rel_updater_sp_oracle.plb 

Post Installation Steps
-----------------------
After patch installation, Load pin_rel_updater_oracle.plb file from the patch 
into Database.


Important Notice:
-----------------
This patch has gone through our automated regression suite which
seeks to validate the product and reduce the likelihood of regressions.

Patches should not be put into a production environment without
additional testing. To ensure that this patch resolves the reported
problem, please provide feedback within five business days. Your
feedback will be used to ensure the success of this patch and provide
us the ability to enhance our processes related to the delivery of
patches.  We will make every effort to correct discrepancies brought to
our attention.

If you have any questions or problems, please contact 
Oracle Communications - Billing and Revenue Management Support Organization 
by submitting a SR through My Oracle Support or by referring to the Oracle website 
for the support contact information in your country. The Oracle support 
website is located at http://www.oracle.com/support/contact.html
