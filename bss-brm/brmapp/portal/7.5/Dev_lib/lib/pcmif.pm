#
#       @(#) % %
#
#       Copyright (c) 1996 - 2006 Oracle. All rights reserved.
#      
#       This material is the confidential property of Oracle Corporation or its
#       licensors and may be used, reproduced, stored or transmitted only in
#       accordance with a valid Oracle license or sublicense agreement.
#

# Alias all the functions to the right packages
# Only necessary really for the debug version, doesn't do anything for the 
# real one
package pcmif;
*pcm_perl_new_ebuf =     *pcmif::pcm_perl_new_ebuf;
*pcm_perl_destroy_ebuf = *pcmif::pcm_perl_destroy_ebuf;
*pcm_perl_is_err =       *pcmif::pcm_perl_is_err;
*pin_set_err =           *pcmif::pin_set_err;
*pcm_perl_ebuf_to_str =  *pcmif::pcm_perl_ebuf_to_str;
*pcm_perl_print_ebuf =   *pcmif::pcm_perl_print_ebuf;
*pcm_perl_connect =      *pcmif::pcm_perl_connect;
*pcm_perl_context_open = *pcmif::pcm_perl_context_open;
*pcm_context_close =     *pcmif::pcm_context_close;
*pin_perl_str_to_flist = *pcmif::pin_perl_str_to_flist;
*pin_perl_flist_to_str = *pcmif::pin_perl_flist_to_str;
*pin_flist_destroy =     *pcmif::pin_flist_destroy;
*pcm_perl_op =           *pcmif::pcm_perl_op;
*pin_flist_sort =        *pcmif::pin_flist_sort;
*pcm_perl_get_userid =   *pcmif::pcm_perl_get_userid;
*pcm_perl_get_session =  *pcmif::pcm_perl_get_session;
*pin_perl_time =         *pcmif::pin_perl_time;
1;

package pcmif;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	pcm_perl_new_ebuf
	pcm_perl_destroy_ebuf
	pcm_perl_is_err
	pin_set_err
	pcm_perl_ebuf_to_str
	pcm_perl_print_ebuf
	pcm_perl_connect
	pcm_perl_context_open
	pcm_context_close
	pin_perl_str_to_flist
	pin_perl_flist_to_str
	pin_flist_destroy
	pcm_perl_op
	pin_flist_sort
	pcm_perl_get_userid
	pcm_perl_get_session
	pin_perl_time
);
$VERSION = '0.01';

bootstrap pcmif $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

pcmif - Perl extension for Infranet PCM library.

=head1 SYNOPSIS

  use lib '/opt/portal/<version>/lib' ;

  use pcmif;

  pin_errbuf_t *pcm_perl_new_ebuf();
  void pcm_perl_destroy_ebuf(ebufp);
  int pcm_perl_is_err(ebufp);
  void pin_set_err(ebufp, location, errclass, pin_err, field, recid, resvd);
  char *pcm_perl_ebuf_to_str(ebufp);
  void pcm_perl_print_ebuf(ebufp);
  pcm_context_t *pcm_perl_connect(db_no, ebufp);
  pcm_context_t *pcm_perl_context_open(login_flistp, db_no, ebufp);
  void pcm_context_close(ctxp, how, ebufp);
  pin_flist_t *pin_perl_str_to_flist(str, db_no, ebufp);
  char *pin_perl_flist_to_str(flistp, ebufp);
  void pin_flist_destroy(flistp);
  pin_flist_t *pcm_perl_op(ctxp, op, flags, in_flp, ebufp);
  void pin_flist_sort(flistp, sort_flistp, reverse, sort_default, ebufp);
  char *pcm_perl_get_userid(ctxp);
  char *pcm_perl_get_session(ctxp);
  time_t pin_perl_time();

=head1 DESCRIPTION

The pcmif perl extension is used to provide a means for perl scripts
to perform Infranet operations.  These include:

	* opening/closing PCM connections
	* creating/destroying PIN errbufs
	* converting textual flists to/from (opaque) binary flists
	* sending PCM operations to a CM

These are mostly wrappers for the underlying C functions.
If the arguments are exactly the same, the name is also the same.
If the arguments are different, then for a C function named pin_foo(),
the Perl analogue is "pin_perl_foo()".

Function arguments are usually fairly similar, the main
exception being that the Perl functions tend to return useful things
instead of being of type void like most of the C functions.

Note that the I<pcmif> extension is a sub-set of the Infranet C API.
It does provide enough functionality to perform Infranet operations.

=head2 API DESCRIPTION

=over 4

=item pin_errbuf_t *pcm_perl_new_ebuf();

Create and clear a new (opaque) ebuf structure.

=item void pcm_perl_destroy_ebuf(ebufp);

Destroy a previously created ebuf structure;

=item int pcm_perl_is_err(ebufp);

Return the integer value of the error code in the ebuf.
0 means "no error", otherwise see the errors (PIN_ERR_xxx) in pin_errs.h.

=item void pin_set_err(ebufp, loc, class, err, field, recid, resvd);

Set an ebuf with the indicated parameters.

=item char *pcm_perl_ebuf_to_str(ebufp);

Return a (static) string with a printable representation of an ebuf.
If ebufp is NULL, returns a null pointer.

=item void pcm_perl_print_ebuf(ebufp);

Does a printf of the printable representation of an ebuf.
Will print "pcm_perl_print_ebuf(): NULL ptr" if ebufp is NULL.

=item pcm_context_t *pcm_perl_connect(db_no, ebufp);

Performs a pcm_connect() to the Infranet indicated via the pin.conf file
in "." or "/etc" ("pin.cnf" and "." for NT).
Returns an opaque pointer to the PCM context and
the database number is set into db_no.
Any errors are returned via the ebufp.

=item pcm_context_t *pcm_perl_context_open(login_flistp, db_no, ebufp);

Performs a pcm_context_open() to Infranet.
The login_flist must have a dummy PIN_FLD_POID,
a valid login type in PIN_FLD_TYPE, the PIN_FLD_LOGIN and
any other fields required for the given type (usually PIN_FLD_PASSWD_CLEAR).
The CM will be indicated EITHER via the pin.conf file
in "." or "/etc" ("pin.cnf" and "." for NT), or
by one or more PIN_FLD_CM_PTRS on the login_flist.
See the Infranet documentation for the opcode spec
for PCM_CONTEXT_OPEN.input for more details.
Returns an opaque pointer to the PCM context and
the database number is set into db_no.
Any errors are returned via the ebufp.

=item void pcm_context_close(ctxp, how, ebufp);

Close the PCM context connection on the given context.
If "how" is 1 (PCM_CONTEXT_CLOSE_FD_ONLY in pcm.h),
only the underlying socket is closed - useful for forking things.
Otherwise the context itself is also cleaned up.

=item pin_flist_t *pin_perl_str_to_flist(str, db_no, ebufp);

This converts the printable flist contained in the string "str"
into an opaque flist and returns a pointer to the flist.
The db_no is a string containing an Infranet database number
in dotted decimal format that is used to set the default database 
for parsing the flist.  It may be NULL, since it is often easier
in Perl to just set $DB_NO and use "$DB_NO" in here documents
containing flists.

=item char *pin_perl_flist_to_str(flistp, ebufp);

This converts an opaque flist into a printable string representation.

=item void pin_flist_destroy(flistp);

This destroys an opaque flist.

=item pin_flist_t *pcm_perl_op(ctxp, op, flags, in_flp, ebufp);

This performs the indicated PCM operation with the given flags
and input flist.  It returns the result flist.
Any errors are indicated via the ebufp.
The "op" may be a number or a symbolic opcode name if it was
known to Infranet: ie one may use "354" or "PCM_OP_TERM_IP_DIALUP_AUTHORIZE".

=item void pin_flist_sort(flistp, sort_flistp, reverse, sort_default, ebufp);

Runs pin_flist_sort() on the given (opaque) flist.

=item char *pcm_perl_get_userid(ctxp);

Obtains the userid (set after login) as a printable poid and returns
as a string.

=item char *pcm_perl_get_session(ctxp);

Obtains the session id (set after login) as a printable poid and returns
as a string.

=item time_t pin_perl_time();

Returns the time from pin_time() as a time_t value.
		
=back

=head1 EXAMPLE USAGE

=head2 Simple Example

This example connects to Infranet, logging in with the parameters
set in the config section.  Thus the pin.conf only needs a (dummy)
userid entry.  If given an argument, it will use that as the
poid id of the data object to read, otherwise it will default
to poid id 1.  It then does a PCM_OP_READ_OBJ using the poid id
and displays the result flist.

=begin comment

Note: prefixed with two spaces so the following is verbatim example.

=end comment

  #!/opt/portal/6.0/bin/perl
  #
  # test a readobj of /data N (defaults to 1)
  #
  # use pcm_context_open(), so requires pin.conf with userid only
  #
  #

  # "use lib '<path>' only needed if NOT using the Perl shipped with Infranet
  # use lib '.' ;

  use pcmif;

  ############
  # config
  #
  #
  $LOGIN_DB = "0.0.0.1";
  $LOGIN_NAME = "root";
  $LOGIN_PASSWD = "password";
  $CM_HOST = "somehost";
  $CM_PORT = "11960";

  #####################
  # setup and connect
  #
  $ebufp = pcmif::pcm_perl_new_ebuf();

  $f1 = <<"XXX"
  0 PIN_FLD_POID           POID [0] $LOGIN_DB /service/pcm_client 1 0
  0 PIN_FLD_TYPE            INT [0] 1
  0 PIN_FLD_LOGIN           STR [0] "$LOGIN_NAME"
  0 PIN_FLD_PASSWD_CLEAR    STR [0] "$LOGIN_PASSWD"
  0 PIN_FLD_CM_PTRS	ARRAY [0]
  1     PIN_FLD_CM_PTR	      STR [0] "ip $CM_HOST $CM_PORT"
  XXX
  ;
  $login_flistp = pcmif::pin_perl_str_to_flist($f1, $LOGIN_DB, $ebufp);
  if (pcmif::pcm_perl_is_err($ebufp)) {
  	print "flist conversion failed\n";
  	pcmif::pcm_perl_print_ebuf($ebufp);
  	exit(1);
  }

  $pcm_ctxp = pcmif::pcm_perl_context_open($login_flistp, $db_no, $ebufp);

  if (pcmif::pcm_perl_is_err($ebufp)) {
  	pcmif::pcm_perl_print_ebuf($ebufp);
  	exit(1);
  } else {
  	$my_session = pcmif::pcm_perl_get_session($pcm_ctxp);
  	$my_userid = pcmif::pcm_perl_get_userid($pcm_ctxp);

  	print "back from pcmdd_context_open()\n";
  	print "    DEFAULT db is: $db_no \n";
  	print "    session poid is: ", $my_session, "\n";
  	print "    userid poid is: ", $my_userid, "\n";
  }

  ###################
  # see if we should default to 1, or get a number

  if ($#ARGV >= 0) {
  	$obj_id = $ARGV[0];
  } else {
  	$obj_id = 1;
  }

  ###################
  # build an flist
  $f1 = <<"XXX"
  0 PIN_FLD_POID           POID [0] $db_no /data $obj_id 0
  XXX
  ;
  $flistp = pcmif::pin_perl_str_to_flist($f1, $db_no, $ebufp);
  if (pcmif::pcm_perl_is_err($ebufp)) {
  	print "flist conversion failed\n";
  	pcmif::pcm_perl_print_ebuf($ebufp);
  	exit(1);
  }
  $out = pcmif::pin_perl_flist_to_str($flistp, $ebufp);
  print "IN flist is:\n";
  print $out;

  $out_flistp = pcmif::pcm_perl_op($pcm_ctxp, "PCM_OP_READ_OBJ", 0,
      $flistp, $ebufp);
  if (pcmif::pcm_perl_is_err($ebufp)) {
  	print "robj failed\n";
  	pcmif::pcm_perl_print_ebuf($ebufp);
  	exit(1);
  }

  $out = pcmif::pin_perl_flist_to_str($out_flistp, $ebufp);
  print "OUT flist is:\n";
  print $out;


  pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);
  if (pcmif::pcm_perl_is_err($ebufp)) {
  	print "BAD close\n",
  	    pcmif::pcm_perl_ebuf_to_str($ebufp), "\n";
  	exit(1);
  }
  exit(0);

=head1 AUTHOR

Gary Owens, glo@portal.com

=head1 SEE ALSO

perl(1).

Infranet Developers Documentation

=cut
