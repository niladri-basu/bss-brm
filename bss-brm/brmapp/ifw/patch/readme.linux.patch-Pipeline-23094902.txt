Patch 23094902 
--------------
SR: 3-12454313361
BUG ID: 23043754
RELEASE: 7.5.0.11.0
OPERATING SYSTEM: LINUX
TITLE: Pipeline Performance Has Degraded Severely


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

This patch package consists of Pipeline(64bit) Packages.

ADDITIONAL INFORMATION:
----------------------
For Bug 23043754 :
------------------
In a scenario of a corporate/large account's where we would have large number
of services and associated balance groups, CDR processing throughput was very
bad. In order to improve CDR rating performance in such scenario's underlying 
data structures have been modified accordingly.

For Bug 23130237 :
------------------
During pipeline startup (while data loading) a vector was accessed out of
bound because of improper use of type variable. This caused an exception 
thrown by Roguewave library which made pipeline not to come up. Correct
variable type is used now which is solving this issue.


This patch also contains the following fixes:
---------------------------------------------
BugNumber        SRlist           Subject
---------        -------          --------
23130237         NONE       Pipeline does not come up on restarting pipeline after account creation


FILES  AFFECTED
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
