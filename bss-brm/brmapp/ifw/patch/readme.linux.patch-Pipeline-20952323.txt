Patch 20952323 
--------------
SR: 3-10445099231
BUG ID: 20918727
RELEASE: 7.5.0.11.0
OPERATING SYSTEM: LINUX
TITLE: Group by is not working in PCM_OP_SEARCH


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

This patch package consists of Portalbase and Pipeline Packages.


THIS PATCH ALSO CONTAINS THE FOLLOWING FIXES :
----------------------------------------------
BugNumber  SRlist                          Subject
 20961479  3-10644208231                   GetEdrVersion Error While Recycling Suspended CDR

FILE  AFFECTED
--------------

PortalBase:
-----------
PortalBase_dir/sys/dm_oracle/dm_oracle11g64.so
PortalBase_dir/jars/rel.jar

Pipeline:
---------
IFW_HOME/releaseNotes/RELEASE_NOTES.INP_Recycle
IFW_HOME/lib/libEDR64.so
IFW_HOME/lib/libINP_Recycle64.so


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
