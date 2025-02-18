#
# @(#)%Portal Version: aes_template.pm:CUPmod7.3PatchInt:1:2006-Oct-17 02:13:11 %
#
#	Copyright (c) 2006  Oracle. All rights reserved.
# 
#	This material is the confidential property of Oracle Corporation or its
#	licensors and may be used, reproduced, stored or transmitted only in
#	accordance with a valid Oracle license or sublicense agreement.
#

# Alias all the functions to the right packages
# Only necessary really for the debug version, doesn't do anything for the 
# real one
package aes;
*psiu_perl_decrypt_pw =     *aes::psiu_perl_decrypt_pw;
*psiu_perl_encrypt_pw =     *aes::psiu_perl_encrypt_pw;
*pcm_new_charp =     *aes::pcm_new_charp;
*pcm_print_cipher_text =     *aes::pcm_print_cipher_text;
*pcm_print_plain_text =     *aes::pcm_print_plain_text;
1;

package aes;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	psiu_perl_encrypt_pw
	psiu_perl_decrypt_pw
	pcm_new_charp
	pcm_print_cipher_text
	pcm_print_plain_text
);
$VERSION = '0.01';

bootstrap aes $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

aes - Perl extension for encryption and decryption C library.

=head1 SYNOPSIS

  use lib '/opt/portal/<version>/lib' ;

  use aes;

  char*       psiu_perl_encrypt_pw(inp);
  char*       psiu_perl_decrypt_pw(inp);
  char*	      pcm_new_charp(inarg)
  void        pcm_print_cipher_text(outp)
  void        pcm_print_plain_text(outp)

=head1 DESCRIPTION

The aes perl extension is used to provide a means for perl scripts
to encrypt and decrypt a password.

These are mostly wrappers for the underlying C functions.
If the arguments are exactly the same, the name is also the same.
If the arguments are different, then for a C function named pin_foo(),
the Perl analogue is "pin_perl_foo()".

Function arguments are usually fairly similar, the main
exception being that the Perl functions tend to return useful things
instead of being of type void like most of the C functions.

Note that the other functions are to support the casting of operands in the
required form, or to print the encryted/decrypted values.

=head2 API DESCRIPTION

=over 4

=item char*  psiu_perl_encrypt_pw(inp);

This subroutine will encrypt the input text by calling the psiu_encrypt_pw() module in the existing C code.

=item char*  psiu_perl_decrypt_pw(inp);

This subroutine will decrypt the input text by calling the psiu_decrypt_pw() module in the existing C code.

=item char*  pcm_new_charp(inarg)

This subroutine declares a "pointer to char" C data type.

=item void  pcm_print_cipher_text(outp)

This subroutine prints the encrypted text.

=item void  pcm_print_plain_text(outp)

This subroutine prints the decrypted text.

=back

=head1 EXAMPLE USAGE

=head2 Simple Example

This example reads an input text and encrypts it using MD5 algorithm.
It then decrypts the encrypted value using the same algorithm.
It also prints the encrypted and decrypted texts.

=begin comment

Note: prefixed with two spaces so the following is verbatim example.

=end comment

  #!/opt/portal/6.0/bin/perl
  #
  # Encrypt/Decrypt a text
  #
  # requires pin.conf with secret code
  #
  # "use lib '<path>' only needed if NOT using the Perl shipped with Portal
  # use lib '.' ;

  use aes;

  ########################
  #Take the input argument and calculates its length.
  #
  $inarg = shift;
  $inarg_len = length($inarg);
  print "Input text -> $inarg\n";
  
  local ( $cipher, $cipher_length, $plain, $plain_length );
  
  ########################
  #Cast the input arguments to the format required by psiu_perl_encrypt() function.
  #
  $inp = aes::pcm_new_charp( $inarg );
  
  ########################
  #Encrypt the input text
  #
  $cipher = aes::psiu_perl_encrypt_pw( $inp);
  print "encryption text -> ";
  aes::pcm_print_cipher_text( $cipher);
  
  
  ########################
  #Decrypt the input text
  #
  $plain = aes::psiu_perl_decrypt_pw( $cipher);
  print "Decryption text -> ";
  aes::pcm_print_plain_text( $plain);

  print "Bye!!\n";

  exit(0);

=head1 AUTHOR

Netaji Goud Ediga, netaji.ediga@oracle.com

=head1 SEE ALSO

perl(1).

Portal Developers Documentation

=cut
