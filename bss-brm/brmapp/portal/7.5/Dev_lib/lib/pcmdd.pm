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
package pcmdd;
*pcmdd_connect = *pcmdd::pcmdd_connect;
1;

package pcmdd;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	
);
$VERSION = '0.01';

bootstrap pcmdd $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

pcmdd - Perl extension for PCM Data Dictionary Loader

=head1 SYNOPSIS

  use pcmdd;

  NOTE: only use this if you're sure you know what you're doing!

=head1 DESCRIPTION

This pcmdd extension is for a direct connection to the DM.
It should only be used at bootstrap time, to load the data dictionary.

=head1 AUTHOR

Gary Owens, glo@portal.com

=head1 SEE ALSO

pcmif(1) perl(1).

=cut
