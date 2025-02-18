Patch 22262207 
--------------
SR: 3-11581690731
BUG ID: 22119641
RELEASE: 7.5.0.11.0
OPERATING SYSTEM: LINUX
TITLE: Pipeline is assigning old item poid after service transfer


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

This patch package consists of Pipeline Packages.

ADDITIONAL INFORMATION:
----------------------
For Bug 22119641 :
------------------
Post service transfer When a usage is rated with timestamp after service 
transfer, old item (belonging to previous account) is getting picked up 
Reason is that on receiving LineTransfer event service object was not set
dirty. Service object is now made dirty so that correct item is fetched 
when we have flexible item assignment feature (items created by pipeline)


FILE  AFFECTED
--------------
IFW_HOME/lib/libDAT_AccountBatch64.so
IFW_HOME/releaseNotes/RELEASE_NOTES.DAT_AccountBatch


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
