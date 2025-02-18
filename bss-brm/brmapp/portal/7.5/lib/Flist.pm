#
#       @(#) % %
#
#       Copyright (c) 1996 - 2006 Oracle. All rights reserved.
#      
#       This material is the confidential property of Oracle Corporation or its
#       licensors and may be used, reproduced, stored or transmitted only in
#       accordance with a valid Oracle license or sublicense agreement.
#

package Flist;

use strict;
use integer;
use pcmif;
use vars qw(@ISA @EXPORT_OK);

require Exporter;


@ISA = qw(Exporter);
@EXPORT_OK = qw(
	new
	to_string
	to_pointer
	get_field
	get_subflist
);


#
# Flist is a class meant to facilitate FLIST manipulation.  It also acts as a
# wrapper around FLIST pointers, the main pcmif type, taking advantage of Perl's
# garbage collection to free up the pointers.
#


my $_KEY_LINES = "lines";
my $_KEY_PTR = "pin_flist_tPtr";

my $TYPE = "type";
my $BRAC = "brac";
my $VALUE = "value";

my $_db = "0.0.0.1";
my $_ebuf = pcmif::pcm_perl_new_ebuf();

1;


#
# new FLISTPTR
# new STRINGREF
# new ARRAYREF
#
# Of Course the classname 'Flist' is implicit and not mentioned above.  FLISTPTR
# is a reference of type 'pin_flist_tPtr' returned by pcmif subroutines such as
# 'pin_perl_str_to_flist' and 'pcm_perl_op'.  STRINGREF is a reference to an
# FLIST string.  ARRAYREF is a reference to an array of FLIST lines.
#
sub new
{
	my $class = shift;
	my $arg = shift;
	my $self;

	if (ref($arg) eq $_KEY_PTR) {
		$$self{$_KEY_PTR} = $arg
	}
	else {
		my $lines_ref;
		if (ref($arg) eq "SCALAR") {
			my @lines = split(/^/m, $$arg);
			$lines_ref = \@lines;
		}
		elsif (ref($arg) eq "ARRAY") {
			$lines_ref = $arg;
		}

		if ($lines_ref and @$lines_ref) {
			$$self{$_KEY_LINES} = $lines_ref;
		}
	}

	bless($self, $class) if ($self);
	return $self;
}


#
# to_string
#
# Converts this object to string.  Returns the FLIST as a string.
#
sub to_string
{
	my $self = shift;
	my $lines_ref = $self->_get_lines();
	return join('', @$lines_ref);
}


#
# to_pointer
#
# Converts this object to a pointer.  Returns the FLIST as a reference of type
# 'pin_flist_tPtr'.
#
sub to_pointer
{
	my $self = shift;
	my $ptr = $$self{$_KEY_PTR};

	if ((not $ptr) and $$self{$_KEY_LINES}) {
		$ptr = pcmif::pin_perl_str_to_flist($self->to_string(), $_db, $_ebuf);
		$$self{$_KEY_PTR} = $ptr;
	}

	return $ptr;
}


#
# get_field FIELDPATH
# get_field FIELDPATH PATTERN
#
# Returns the line index and value of the first matching field in this object.
# FIELDPATH is a dot-delimited field path in an FLIST.  For example, if
# $flist->to_string() returns the following string:
#
# 0 PIN_FLD_POID                      POID [0] 0.0.0.1 /config/gl_chartaccts 10446 0
# 0 PIN_FLD_ACCOUNT_OBJ               POID [0] 0.0.0.1 /account 1 0
# 0 PIN_FLD_DESCR                      STR [0] ""
# 0 PIN_FLD_HOSTNAME                   STR [0] "-"
# 0 PIN_FLD_NAME                       STR [0] "1000"
# 0 PIN_FLD_PROGRAM_NAME               STR [0] "load_pin_glchartaccts"
# 0 PIN_FLD_GL_CHARTACCTS            ARRAY [1000] allocated 3, used 3
# 1     PIN_FLD_COA_ID                 STR [0] "1000"
# 1     PIN_FLD_COA_NAME               STR [0] "Primary COA"
# 1     PIN_FLD_GL_COA_ACCTS         ARRAY [0] allocated 4, used 4
# 2         PIN_FLD_ACCOUNT_CODE       STR [0] "0"
# 2         PIN_FLD_DESCR              STR [0] "undefined"
# 2         PIN_FLD_STATUS            ENUM [0] 1
# 2         PIN_FLD_TYPE              ENUM [0] 8
# 1     PIN_FLD_GL_COA_ACCTS         ARRAY [1] allocated 4, used 4
# 2         PIN_FLD_ACCOUNT_CODE       STR [0] "1"
# 2         PIN_FLD_DESCR              STR [0] "undefined"
# 2         PIN_FLD_STATUS            ENUM [0] 1
# 2         PIN_FLD_TYPE              ENUM [0] 16
# 1     PIN_FLD_GL_COA_ACCTS         ARRAY [2] allocated 4, used 4
# 2         PIN_FLD_ACCOUNT_CODE       STR [0] "49400"
# 2         PIN_FLD_DESCR              STR [0] "prepaid.off"
# 2         PIN_FLD_STATUS            ENUM [0] 1
# 2         PIN_FLD_TYPE              ENUM [0] 8
#
# then $flist->get_field("GL_CHARTACCTS.GL_COA_ACCTS.DESCR") will return
# (11, '"undefined"'), and
# $flist->get_field("GL_CHARTACCTS.GL_COA_ACCTS.DESCR", /paid/) will return
# (21, '"prepaid.off"').  Note that the "PIN_FLD_" prefix must be excluded from
# field names, and that the line index returned is zero-based.
#
# Returns null if no matching field is found.
#
sub get_field
{
	my $self = shift;
	my $field_path = shift;
	my $pattern = shift;
	my ($line, $level, $name, $type, $brackets, $value, $found);

	my @path = split(/\./, $field_path);
	my $path_level = 0;
	my $path_elem = $path[$path_level];
	my $line_count = -1;
	my $lines_ref = $self->_get_lines();
	foreach $line (@$lines_ref) {
		$line_count++;
		($level, $name, $type, $brackets, $value) = split(/\s+/, $line, 5);
		if ($level > $path_level) {
			next;
		}
		elsif ($level < $path_level) {
			$path_level = $level;
			$path_elem = $path[$path_level];
		}

		if ("PIN_FLD_$path_elem" eq $name) {
			$path_elem = @path[++$path_level];
			if ($path_elem) {
				next;
			}
			elsif ($pattern) {
				if ($value =~ $pattern) {
					$found = $value;
					chomp($found);
					last;
				}
			}
			else {
				$found = $value;
				chomp($found);
				last;
			}
		}
	}

	if ($found) {
		return $line_count, $found;
	}
	else {
		return ();
	}
}


#
# get_subflist FIELDPATH PATTERN
#
# Searches for the first field matching FIELDPATH and PATTERN by calling
# 'get_field'.  If found, it returns a new Flist object constructing it from
# the subset of this Flist that is at the level and below where the matching
# field was found.  Given the FLIST in the 'get_field' example, calling
# $flist->get_subflist("GL_CHARTACCTS.GL_COA_ACCTS.DESCR", /paid/) will return
# an Flist object whose string value is:
#
# 0 PIN_FLD_ACCOUNT_CODE       STR [0] "49400"
# 0 PIN_FLD_DESCR              STR [0] "prepaid.off"
# 0 PIN_FLD_STATUS            ENUM [0] 1
# 0 PIN_FLD_TYPE              ENUM [0] 8
#
# and calling $flist->get_subflist("GL_CHARTACCTS.COA_NAME", /[Pp]rim/) will
# return an Flist object whose string value is:
#
# 0 PIN_FLD_COA_ID                 STR [0] "1000"
# 0 PIN_FLD_COA_NAME               STR [0] "Primary COA"
# 0 PIN_FLD_GL_COA_ACCTS         ARRAY [0] allocated 4, used 4
# 1     PIN_FLD_ACCOUNT_CODE       STR [0] "0"
# 1     PIN_FLD_DESCR              STR [0] "undefined"
# 1     PIN_FLD_STATUS            ENUM [0] 1
# 1     PIN_FLD_TYPE              ENUM [0] 8
# 0 PIN_FLD_GL_COA_ACCTS         ARRAY [1] allocated 4, used 4
# 1     PIN_FLD_ACCOUNT_CODE       STR [0] "1"
# 1     PIN_FLD_DESCR              STR [0] "undefined"
# 1     PIN_FLD_STATUS            ENUM [0] 1
# 1     PIN_FLD_TYPE              ENUM [0] 16
# 0 PIN_FLD_GL_COA_ACCTS         ARRAY [2] allocated 4, used 4
# 1     PIN_FLD_ACCOUNT_CODE       STR [0] "49400"
# 1     PIN_FLD_DESCR              STR [0] "prepaid.off"
# 1     PIN_FLD_STATUS            ENUM [0] 1
# 1     PIN_FLD_TYPE              ENUM [0] 8
#
# Returns null if no matching field is found.
#
sub get_subflist
{
	my $self = shift;
	my $field_path = shift;
	my $pattern = shift;

	my ($line_index, $value) = $self->get_field($field_path, $pattern);
	if (not $value) {
		return ();
	}

	# iterate backward through flist until indentation level decreases
	my $lines_ref = $self->_get_lines();
	my ($i, $level, $mark_level);
	for ($i = $line_index; $i >= 0; $i--) {
		($level) = split(/\s+/, $$lines_ref[$i], 2);
		if (not defined($mark_level)) {
			$mark_level = $level;
		}
		if ($level < $mark_level) {
			$i++;
			last;
		}
	}

	my @result_lines;
	my $lines_count = $#$lines_ref;
	for (; $i < $lines_count; $i++) {
		($level) = split(/\s+/, $$lines_ref[$i], 2);
		if ($level < $mark_level) {
			last;
		}
		else {
			push(@result_lines, $$lines_ref[$i]);
			$result_lines[$#result_lines] =~ s/^\s*\d/$&-$mark_level/e;
		}
	}

	return new Flist(\@result_lines);
}


#
# Frees the FLIST pointer associated with this object, if any.
#
sub DESTROY
{
	my $self = shift;

	my $ptr = $$self{$_KEY_PTR};
	if (defined($ptr)) {
		pcmif::pin_flist_destroy($ptr);
	}
}


#
# Private method returns a reference for the array of FLIST lines for this
# object.
#
sub _get_lines
{
	my $self = shift;

	if ((not $$self{$_KEY_LINES}) and $$self{$_KEY_PTR}) {
		my $params = pcmif::pin_perl_flist_to_str($$self{$_KEY_PTR}, $_ebuf);
		my @lines = split(/^/m, $params);
		$$self{$_KEY_LINES} = \@lines;
	}

	return $$self{$_KEY_LINES};
}
