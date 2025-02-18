# This package contains routines to parse an XML document using 
# the XML spec. 

# It is based on the spec of 17-Nov-97
#http://xml.coverpages.org/kvalePerlParse.html
#http://www.speech.cs.cmu.edu/~sburke/pub/xml_spec_decls.html

package XML::PerlParser;

# Make sure they have at least Perl 5.004_00
require 5.00400;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
#use XML::Char;
use Carp;

require Exporter;
require AutoLoader;


@ISA = qw(Exporter AutoLoader);
@EXPORT = qw( );
@EXPORT_OK = qw ( parse_xml parse_xml_file );
$VERSION = '1.00';

#my $DEBUG = 1;
my $DEBUG = 0;

#These are the pointers to the callback functions
my $sr_xmldecl;
my $sr_doctype;
my $sr_start;
my $sr_end;
my $sr_char;
my $sr_comment;
my $sr_cdata;
my $sr_reference;
my $sr_pi;

# create a new parser object
sub new
{
    my $class = shift;
    my $self = bless {'_buf' => ''}, $class;
    $self;
}

sub setHandlers {
    my ($self, @handler_pairs) = @_;
    if (int(@handler_pairs) & 1) {
        croak("Uneven number of arguments to setHandlers method.\n");
    }
        

    # Define the available callback subroutines
    my @types=("XMLDecl", "DocType","Start", "End", "Char", 
               "Comment", "CData", "Reference", "PI");
    
    while (@handler_pairs) {
        my $type = shift @handler_pairs;
        my $handler = shift @handler_pairs;

        # Make sure the caller passed in a legal name.
        my $found = 0;
        foreach my $typ(@types) {
            if ($type eq $typ) {
                $found = 1;
            }
        }
        unless ($found == 1) {
            croak ("Unknown Parser handler type: $type.\nValid types: @types\n");
        }

        # Assign the callback handler
        if      ($type eq $types[0]) { # XMLDecl
            $sr_xmldecl = $handler;
        } elsif ($type eq $types[1]) { # DocType
            $sr_doctype = $handler;
        } elsif ($type eq $types[2]) { # Start
            $sr_start = $handler;
        } elsif ($type eq $types[3]) { # End
            $sr_end = $handler;
        } elsif ($type eq $types[4]) { # Char
            $sr_char = $handler;
        } elsif ($type eq $types[5]) { # Comment
            $sr_comment = $handler;
        } elsif ($type eq $types[6]) { # CData
            $sr_cdata = $handler;
        } elsif ($type eq $types[7]) { # Reference
            $sr_reference = $handler;
        } elsif ($type eq $types[8]) { # PI
            $sr_pi = $handler;
        }
    }
    
}   # End of setHandlers

sub end_parse
{
    shift->parse_xml( undef );
}

# this is a wrapper which handles either filenames or file handles.

sub parse_xml_file
{
    my ($self, $file) = @_;
    no strict 'refs';  # so that a symbol ref as $file works
    local(*F);
    unless (ref($file) || $file =~ /^\*[\w:]+$/) {
	# Assume $file is a filename
	open(F, $file) || croak "Can't open $file: $!\n";
	   $file = \*F;
    }

    # ###########################################
    # Read all the data from the file into
    # a variable.  This parser was written
    # to parse an XML file in chunks to 
    # reduce memory requirements, however
    # It was not taken into account what
    # happens when a chunk ends with a 
    # part of a start tag or end tag.
    # Example:  If the last two bytes of a
    # chunk are </, the parser will die because
    # it is looking for more data after the / 
    # and there isn't any.  This parser really
    # needs to process an entire chunk of
    # data at once.
    # ###########################################
    my $chunk = '';
    my $data  = "";
    while(read($file, $chunk, 8192)) {
        $data .= $chunk;
    }
    close( $file );

    $self->parse_xml($data);
    $self->end_parse;
}

sub parse_xml
{
   my $self = shift;
   my $buf = \ $self->{'_buf'};
   unless (defined $_[0]) {
      # signals EOF (assume rest is plain text)
      $self->text($$buf) if length $$buf;
      $$buf = '';
      return $self;
   }
   $$buf .= $_[0];
   
   # Parse xml text in $$buf. 
   # Assume $$buf contains the whole document for now.
   # [1] document ::= prolog element Misc*
   # prolog may have zero length and still be valid.
   my $eaten = "";
   my $bite1 = "";
   $eaten = prolog($buf);
   if ($bite1 = element($buf)) {
      $eaten .= $bite1;
      while (1) {
         $bite1 = Misc($buf);
         if ($bite1) {
            $eaten .= $bite1;
         }
         else {
            last;
         }
      }
      return $self;
   }
   return "";
}

################ begin parse sub tree ##########################

# This is a recursive descent parser. Here are the conventions:
#   1) each non-terminal is a subroutine
#   2) each sub is passed $buf, a reference to the text buffer.
#   3) the $$buf is eaten as we go along
#   4) if a nonterminal is found, the sub returns $eaten != ""
#      and that part of $$buf is eaten
#   5) if a nonterminal is not found, the sub returns $eaten == ""
#      and the $$buf is unchanged

# Actually, some non terminals can match even if they have zero length
# matches, such as prolog. In this case, I will have to alter the test
# to take this into account...

# Non-regexp type production rules

sub prolog
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [23]      prolog ::= XMLDecl? Misc* (doctypedecl Misc*)?
   # note that everything here is optional
   $eaten = XMLDecl($buf);
   while ($bite1 = Misc($buf)) {
      $eaten .= $bite1;
   }
   if ($bite1 = doctypedecl($buf)) {
      $eaten .= $bite1;
      while ($bite1 = Misc($buf)) {
         $eaten .= $bite1;
      }
   }
   return $eaten;
}

sub element
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   my $bite3 = "";
   # [39]     element ::= EmptyElemTag | STag content ETag

   $eaten = EmptyElemTag($buf);
   unless ($eaten) {
      $bite1 = STag($buf);

      if ($bite1) {
         $bite2 = content($buf); # May return ""

         $bite3 = ETag($buf);
         if ($bite3){
            $eaten .= $bite1 . $bite2 . $bite3;
         }
      }
      else { # put back STag content ETag
         $$buf = $bite2 . $$buf if $bite2;
         $$buf = $bite1 . $$buf if $bite1;
         $eaten = "";
      }
   }
   return $eaten;
}

sub doctypedecl
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   # [29]  doctypedecl ::= '<!DOCTYPE' S Name (S ExternalID)? S? 
   #                      ('[' (markupdecl | PEReference | S)* ']' S?)? '>'
   if ($$buf =~ s/^(<\!DOCTYPE)// ){ 
      $eaten = $1;
      if ($bite1 = S($buf) and $bite2 = Name($buf)) {
         $eaten .= $bite1 . $bite2;
         $eaten .= ($bite1 = S($buf));
         if ($bite1 and $bite2 = ExternalID($buf)) {
            $eaten .= $bite2 . S($buf);
         }
         if ($$buf =~ s/^(\[)//) {
            $eaten .= $1;
            while (1) {
               unless ($bite1 = markupdecl($buf)) {
                  unless ($bite1 = PEReference($buf)) {
                     $bite1 = S($buf);
                  }
               }
               if ($bite1) {
                  $eaten .= $bite1;
               }
               else {
                  last;
               }
            }
            if ($$buf =~ s/^(\])//) {
               $eaten .= $1 . S($buf);
            }
            else { # No closing ] for [
               syntax_error( $eaten, $buf, "No closing ] for [");
            }
         }
         if ($$buf =~ s/^(>)//) {
            $eaten .= $1;
         }
         else { # No closing > for <\!DOCTYPE
            syntax_error( $eaten, $buf, "No closing > for <\!DOCTYPE");
         }
      }
      else { # <\!DOCTYPE, but no S Name
         syntax_error( $eaten, $buf, "<\!DOCTYPE, but no S Name");
      }
   }

   if ($eaten) {
      if ($DEBUG) {
         print ("DocType=$eaten\n");
      }
      if (defined($sr_doctype)) {
         $sr_doctype->($eaten); 
      }
   }

   return $eaten;   
}

# This is the main function that parses all the tags
# As a tag is hit, depending on what kind of tag is hit
# will satisfy the if loop.
sub content
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [43]      content ::= (element | CharData | Reference 
   #                                           | CDSect | PI | Comment)*
   do {
      $eaten .= $bite1;
      if    ($bite1 = element($buf)) { 
        # Do Nothing
      }
      ######## Char ###################
      elsif (($bite1 = CharData($buf)) || ($bite1 eq "0")) {
      #elsif ($bite1 = CharData($buf)) {
         #if ($bite1) {
            if ($DEBUG) {
               print "CharData=$bite1\n";
            }
            if (defined($sr_char)) {
               $sr_char->($bite1); 
            }
         #}
      }
      ######## Reference ###################
      # If you change anything here, 
      # change it in sub CharData as well.
      elsif ($bite1 = Reference($buf)) {
         if ($bite1) {
            if ($DEBUG) {
               print "Reference=$bite1\n";
            }
            if (defined($sr_reference)) {
               $sr_reference->($bite1); 
            }
         }
      }
      ######## CData ###################
      elsif ($bite1 = CDSect($buf)) {
         if ($bite1) {
            if ($DEBUG) {
               print "CData=$bite1\n";
            }
            if (defined($sr_cdata)) {
               $sr_cdata->($bite1); 
            }
         }
      }
      ######## PI ###################
      elsif ($bite1 = PI($buf)) {
         if ($bite1) {
            if ($DEBUG) {
               print "PI=$bite1\n";
            }
            if (defined($sr_pi)) {
               $sr_pi->($bite1); 
            }
         }
      }
      ######## Comment ###################
      elsif ($bite1 = Comment($buf)) {
         if ($bite1) {
            if ($DEBUG) {
               print "Comment=$bite1\n";
            }
            if (defined($sr_comment)) {
               $sr_comment->($bite1); 
            }
         }
      }
      else {
            # Empty data - Don't do anything.
            # We will get here if there are 
            # embedded < or > in the CharData section.
            # Not sure how to trap for this...
            # The parser immediately ends if we 
            # find these.
            $bite1 = "";
      }
   } while $bite1;
   return $eaten;
}

sub markupdecl
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [30]   markupdecl ::= elementdecl | AttlistDecl | EntityDecl 
   #                                 | NotationDecl | PI | Comment
   unless ($eaten = elementdecl($buf)) {
      unless ($eaten = AttlistDecl($buf)) {
         unless ($eaten = EntityDecl($buf)) {
            unless ($eaten = NotationDecl($buf)) {
               unless ($eaten = PI($buf)) {
                  $eaten = Comment($buf);
               }
            }
         }
      }
   }
   return $eaten;
}

sub elementdecl
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   my $bite3 = "";
   my $bite4 = "";
   # [45]   elementdecl ::= '<!ELEMENT' S Name S contentspec S? '>'
   if ($$buf =~ s/^(<\!ELEMENT)//){
      $eaten = $1;
      if ($bite1 = S($buf) and $bite2 = Name($buf) 
          and $bite3 = S($buf) and $bite4 = contentspec($buf)) {
         $eaten .= $bite1 . $bite2 . $bite3 . $bite4 . S($buf);
         if ($$buf =~ s/^(>)//) {
            $eaten .= $1;
         }
         else { # Need > for <!ELEMENT
            syntax_error( $eaten, $buf, "Need > for <!ELEMENT");            
         }
      }
      else { # Need S Name S contentspec for elementdecl
         syntax_error( $eaten, $buf, 
                       "Need S Name S contentspec for elementdecl");
      }
   }

   return $eaten;
}

sub contentspec
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [46]   contentspec ::= 'EMPTY' | 'ANY' | Mixed | children
   if ($$buf =~ s/^(EMPTY|ANY)//) {
      $eaten = $1;
   }
   else {
      unless ($eaten = Mixed($buf)) {
         $eaten = children($buf);
      }
   }
   return $eaten;
}

sub children
{
   my $buf = shift;
   my $eaten = "";
   # [47]      children ::= (choice | seq) ('?' | '*' | '+')?
   unless ($eaten = choice($buf)) {
      $eaten = seq($buf);
   }
   if ($eaten and $$buf =~ s/^([\?\*\+])//) {
      $eaten .= $1;
   }
   return $eaten;
}

sub choice
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   my $found_or = 0;
   # [49]   choice ::= '(' S? cp ( S? '|' S? cp )* S? ')'
   if ($$buf =~ s/^(\()//) {
      $eaten = $1 . S($buf);
      if ($bite1 = cp($buf)) {
         $eaten .= $bite1;
         while (1) {
            $bite1 = S($buf);
            if ($$buf =~ s/^(\|)//) {
               $bite1 .= $1 . S($buf);
               $found_or = 1;
               if ($bite2 = cp($buf)) {
                  $eaten .= $bite1 . $bite2;
               }
               else { # Expected a cp after the |
                  syntax_error( $eaten, $buf, "Expected a cp after the |");
               }
            }
            else { # put back S? and exit loop
               $$buf = $bite1 . $$buf;
               last;
            }
         }
         $eaten .= S($buf);
         if ($$buf =~ s/^(\))//) {
            $eaten .= $1;
         }
         else { # We didn't find a ), but it may be a seq...
            if($found_or) {
               syntax_error( $eaten, $buf, "Expected a closing )");
            }
            $$buf = $eaten . $$buf;
            $eaten = "";
         }
      }
      else { # Expected a cp after the (
         syntax_error( $eaten, $buf, "Expected a cp after the (");            
      }
   }
   return $eaten;
}

sub seq
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   # [50]            seq ::= '(' S? cp ( S? ',' S? cp )* S? ')'
   if ($$buf =~ s/^(\()//) {
      $eaten = $1 . S($buf);
      if ($bite1 = cp($buf)) {
         $eaten .= $bite1;
         while (1) {
            $bite1 = S($buf);
            if ($$buf =~ s/^(\,)//) {
               $bite1 .= $1 . S($buf);
               if ($bite2 = cp($buf)) {
                  $eaten .= $bite1 . $bite2;
               }
               else { # Expected a cp after the ,
                  syntax_error( $eaten, $buf, "Expected a cp after the ,");
               }
            }
            else { # put back S? and exit loop
               $$buf = $bite1 . $$buf;
               last;
            }
         }
         $eaten .= S($buf);
         if ($$buf =~ s/^(\))//) {
            $eaten .= $1;
         }
         else { # No closing ) for (
            syntax_error( $eaten, $buf, "No closing ) for (");
         }
      }
      else { # Expected a cp after the (
         syntax_error( $eaten, $buf, "Expected a cp after the (");            
      }
   }
   return $eaten;
}

sub cp
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [48]     cp ::= (Name | choice | seq) ('?' | '*' | '+')?
   unless ($eaten = Name($buf)) {
      unless ($eaten = choice($buf)) {
         $eaten = seq($buf);
      }
   }
   if ($eaten and $$buf =~ s/^([\?\*\+])//) {
      $eaten .= $1;
   }
   return $eaten;
}


# Regexp type production rules

# In theory, all these routines could be replaced by regexps for Misc,
# XMLDecl, EmptyElemTag, STag, ETag, Name, ExternalID, S, PEReference,
# CharData, Reference, CDSect, PI, Comment, AttlistDecl, EntityDecl,
# NotationDecl, and Mixed.

# In practice, the resulting regexps are big and hairy, so it is
# better to decompose them into manageable bits. Decomposition is also
# necessary if one wants to extract useful repeated elements, such as
# attributes. Thus we have a set of routines for the toplevel regexps
# above that form a forest and a set of leaves given by relatively
# simple Perl terminal regexps.

# Here is a list of my terminal regexps:
# S = [\ \n\r\t]+
# Char = [\n\r\t\x20-\xff]
# Name = [A-Za-z\_\:\xaa\xb5\xba\xc0-\xd6\xd8-\xf6\xf8-\xff][\w\.\-\:\xaa\xb5\xb7\xba\xc0-\xd6\xd8-\xf6\xf8-\xff]*
# Comment = <\!--([^\-]|-[^\-])*-->
# LatinName = [A-Za-z][\w\.\-]*
# Eq = [\ \n\r\t]*=[\ \n\r\t]*
# Encoding = [A-Za-z][\w\.\-]*
# VersionInfo = [\ \n\r\t]+version[\ \n\r\t]*=[\ \n\r\t]*("1\.0"|'1\.0')
# CharRef = &#\d+;|&#X[\da-fA-F]+;
# PubidLiteral = "[\ \n\r\ta-zA-Z\d\-\'\(\)\+\,\.\/\:\=\?]*"|'[\ \n\r\ta-zA-Z\d\-\(\)\+\,\.\/\:\=\?]*'
# PCData = [^<&]*
# CDSect = <\!\[CDATA\[.*?\]\]>
# Nmtoken = [\w\.\-\:\xaa\xb5\xb7\xba\xc0-\xd6\xd8-\xf6\xf8-\xff]+


sub Misc
{
   my $buf = shift;
   my $eaten = "";
   # [28]        Misc ::= Comment | PI | S
   unless ($eaten = Comment($buf)) {
      unless ($eaten = PI($buf)) {
         $eaten = S($buf);
      }
   }
   return $eaten;
}

sub XMLDecl
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [24]   XMLDecl ::= '<?xml' VersionInfo EncodingDecl? SDDecl? S? '?>'
   if ($$buf =~ s/^(<\?xml)//) {
      $eaten = $1;
      if ($bite1 = VersionInfo($buf)) {
         $eaten .= $bite1 . EncodingDecl($buf) . SDDecl($buf) . S($buf);
         if ($$buf =~ s/^(\?>)//) {
            $eaten .= $1;
         }
         else { # A closing ?> is needed for <?xml 
            syntax_error( $eaten, $buf, 
                          "A closing ?> is needed for <?xml");
         }      
      }
      else { # VersionInfo is required for an XML declaration
         syntax_error( $eaten, $buf, 
                       "VersionInfo is required for an XML declaration");
      }
   }

   if ($eaten) {
      if ($DEBUG) {
         print ("XMLDecl=$eaten\n");
      }
      if (defined($sr_xmldecl)) {
         $sr_xmldecl->($eaten); 
      }
   }

   return $eaten;   
}

sub EmptyElemTag
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   my $tag = "";
   my @atts;

   # [44]  EmptyElemTag ::= '<' Name (S Attribute)* S? '/>'
   if ($$buf =~ s/^(<)//) {
      $eaten = $1;
      if ($bite1 = Name($buf)) {
         $tag = $bite1;
         $eaten .= $bite1;
         while (1) {
            if ($bite1 = S($buf) and $bite2 = Attribute($buf)) {
               $eaten .= $bite1 . $bite2;
               push (@atts, $bite2); #Save each attribute
            }
            else { # didn't match S Attribute, exit
               last;
            }
         }
         if ($$buf =~ s/^(\/>)//) {
            $eaten .= $bite1;
         }
         else { #no /> (probably a start tag), so put the whole thing back
            $$buf = $eaten . $$buf;
            $eaten = "";
         }
      }
      else { # This is a not an empty tag, put back <
         $$buf = $eaten . $$buf;
         $eaten = "";
      }
   }

   if ($eaten) {
      if ($DEBUG) {
         print "Empty tag: $tag\n";
      }
      if (defined($sr_start)) {
         $sr_start->($tag, @atts); 
      }
      if (defined($sr_end)) {
         $sr_end->($tag); 
      }
   }

   return $eaten;
}

sub STag
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   my $tag = "";
   my @atts;

   # [40]  STag ::= '<' Name (S Attribute)* S? '>'
   if ($$buf =~ s/^(<)//) {
      $eaten = $1;
      if ($bite1 = Name($buf)) {
         $tag = $bite1;
         $eaten .= $bite1;
         while (1) {
            if ($bite1 = S($buf) and $bite2 = Attribute($buf)) {
               $eaten .= $bite1 . $bite2;
               push (@atts, $bite2); #Save each attribute
            }
            else { # didn't match S Attribute, exit
               last;
            }
         }
         if ($$buf =~ s/^(>)//) {
            $bite1 = $1;
            $eaten .= $bite1;
         }
         else { # Closing > required for a start tag. May be an empty tag.
            $$buf = $eaten . $$buf;
            $eaten = "";
         }
      }
      else { # This is not a start tag, put back <
         $$buf = $eaten . $$buf;
         $eaten = "";
      }
   }

   if ($eaten) {
      if ($DEBUG) {
         print "Start tag: $tag\n";
      }
      if (defined($sr_start)) {
         $sr_start->($tag, @atts); 
      }
   }
   
   return $eaten;
}

sub ETag
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $tag = "";

   # [42]     ETag ::= '</' Name S? '>'
   if ($$buf =~ s/^(<\/)//) {
      $eaten = $1;
      if ($bite1 = Name($buf)) {
         $tag = $bite1;
         $eaten .= $bite1 . S($buf);
         if ($$buf =~ s/^(>)//) {
            $eaten .= $1;
         }
         else { # Closing > needed for end tag
            syntax_error( $eaten, $buf, "Closing > needed for end tag");
         }
      }
      else { # Name required immediately after the </
         syntax_error( $eaten, $buf, 
                       "Name required immediately after the </");
      }
   }

   if ($eaten) {
      if ($DEBUG) {
         print "End tag: $tag\n";
      }
      if (defined($sr_end)) {
         $sr_end->($tag); 
      }
   }

   return $eaten;
}

sub Comment
{
   my $buf = shift;
   my $eaten = "";
   # [16]  Comment ::= '<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'
   if ($$buf =~ s/^(<!--.*?--)//s) {
      $eaten = $1;
      if ($$buf =~ s/^(>)//) {
         $eaten .= $1;
      }
      else { # double hyphen -- not allowed in a comment
         syntax_error( $eaten, $buf, 
                       "double hyphen '--' not allowed in a comment");         
      }
   }
   return $eaten;
}

sub PI
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [17]   PI ::= '<?' PITarget (S (Char* - (Char* '?>' Char*)))? '?>'
   if ($$buf =~ s/^(<\?)//) {
      $eaten = $1;
      if ($bite1 = PITarget($buf)) {
         $eaten .= $bite1 . S($buf);
         if ($$buf =~ s/^(.*?\?>)//) {
            $eaten .= $1;
         }
         else { # Need a closing ?> for the proccesing instruction.
            syntax_error( $eaten, $buf, 
                          "Need a closing ?> for the proccesing instruction");
         }
      }
      else { # Name required immediately after the <?
         syntax_error( $eaten, $buf, 
                       "Name required immediately after the <?");          
      }
   }
   return $eaten;
}

sub S
{
   my $buf = shift;
   # [3]  S ::= (#x20 | #x9 | #xD | #xA)+
   #      S   = terminal regexp
   return $1 if $$buf =~ s/^([\ \n\r\t]+)//;
   return "";
}

sub VersionInfo
{
   my $buf = shift;
   # [25]  VersionInfo ::= S 'version' Eq ('"VersionNum"' | "'VersionNum'")
   #       VersionInfo   = terminal regexp
   return $1 if $$buf =~ s/^([\ \n\r\t]+version[\ \n\r\t]*=[\ \n\r\t]*("[\w\.\:\-]+"|'[\w\.\:\-]+'))//;
   return "";
}

sub EncodingDecl
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   # [81] EncodingDecl ::= S 'encoding' Eq '"' EncName '"' | "'" EncName "'"
   if ($eaten = S($buf)) {
      if ($$buf =~ s/^(encoding)//) {
         $eaten .= $1;
         if ($bite1 = Eq($buf)) {
            $eaten .= $bite1;
            if ($$buf =~ s/^("[A-Za-z][\w\.\-]+")//) {
               $eaten .= $bite1;
            }
            elsif ($$buf =~ s/^('[A-Za-z][\w\.\-]+')//) {
               $eaten .= $bite1;
            }
            else { # Need a single or double quoted encoding name
               syntax_error( $eaten, $buf, 
                             "Need a single or double quoted encoding name");
            }
         }
         else { # Need an Eq 
            syntax_error( $eaten, $buf, 
                          "Need an equals sign after 'encoding'");
         }
      }
      else { # no encoding decl, put back space
         $$buf = $eaten . $$buf;
         $eaten = "";
      }
   }
   return $eaten;
}

sub SDDecl
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [32]       SDDecl ::=   S 'standalone' Eq "'" ('yes' | 'no') "'"
   #                       | S 'standalone' Eq '"' ('yes' | 'no') '"'
   $eaten = S($buf);
   if ($eaten and $$buf =~ s/^(standalone)//) {
      $eaten .= $1;
      if ($bite1 = Eq($buf)) {
         $eaten .= $bite1;
         if ($$buf =~ s/^('(yes|no)'|"(yes|no)")//) {
            $eaten .= $1;
         }
         else { # Need a yes or no 
            syntax_error( $eaten, $buf, "Need a yes or no");
         }
      }
      else { # Need an equal sign here
            syntax_error( $eaten, $buf, 
                          "Need an equal sign after 'standalone'");
      }
   }
   else { # no standalone, put back space
      $$buf = $eaten . $$buf;
      $eaten = "";
   }
   return $eaten;
}

sub Name 
{
   my $buf = shift;
   # [5]   Name ::= (Letter | '_' | ':') (NameChar)*
   #       Name   = terminal regexp
   return $1 if $$buf =~ s/^([A-Za-z\_\:\xaa\xb5\xba\xc0-\xd6\xd8-\xf6\xf8-\xff][A-Za-z0-9\.\-\_\:\xaa\xb5\xb7\xba\xc0-\xd6\xd8-\xf6\xf8-\xff]*)//;
   return "";   
}

sub ExternalID
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   my $bite3 = "";
   my $bite4 = "";
   # [76]   ExternalID ::=  'SYSTEM' S SystemLiteral
   #                      | 'PUBLIC' S PubidLiteral S SystemLiteral
   if ($$buf =~ s/^(SYSTEM)//) {
      $eaten = $1;
      if ($bite1 = S($buf) and $bite2 = SystemLiteral($buf)) {
         $eaten .= $bite1 . $bite2;
      }
      else { # Need an S SystemLiteral
         syntax_error( $eaten, $buf, "Need an S SystemLiteral");
      }
   }
   elsif ($$buf =~ s/^(PUBLIC)//) {
      $eaten = $1;
      if ($bite1 = S($buf) and $bite2 = PubidLiteral($buf) 
         and $bite3 = S($buf) and $bite4 = PubidLiteral($buf)) {
         $eaten .= $bite1 . $bite2 . $bite3 . $bite4;
      }
      else { # Need an S PubidLiteral S SystemLiteral
         syntax_error( $eaten, $buf, 
                       "Need an S PubidLiteral S SystemLiteral");
      }
   }
   else {}
   return $eaten;
}

sub PEReference
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [69]  PEReference ::= '%' Name ';'
   if ($$buf =~ s/^(%)//) {
      $eaten = $1;
      if ($bite1 = Name($buf)) {
         $eaten .= $bite1;
         if ($$buf =~ s/^(\;)//) {
            $eaten .= $1;
         }
         else { # PEReference needs a closing ;
            syntax_error( $eaten, $buf, 
                          "PEReference needs a closing ;");
         }
      }
      else { # PEReference needs a Name
         syntax_error( $eaten, $buf, 
                       "PEReference needs a Name");
      }
   }
   return $eaten;
}

sub Attribute
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";

   # [41]    Attribute ::= Name Eq AttValue 
   if ($eaten = Name($buf)) {
      if ($bite1 = Eq($buf) and $bite2 = AttValue($buf)) {
         $eaten .= $bite1 . $bite2;
      }
      else { # Attribute needs an Eq AttValue
         syntax_error( $eaten, $buf, "Attribute needs an Eq AttValue");
      }
   }
   
   return $eaten;
}

sub Attribute2
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   my @attvl;

   # [41]    Attribute ::= Name Eq AttValue 
   if ($eaten = Name($buf)) {
      if ($bite1 = Eq($buf) and $bite2 = AttValue($buf)) {
         $eaten .= $bite1 . $bite2;
         push (@attvl, $bite2);
      }
      else { # Attribute needs an Eq AttValue
         syntax_error( $eaten, $buf, "Attribute needs an Eq AttValue");
      }
   }
   
   push (@_, $eaten);
   push (@_, @attvl);
   return @_;
}

sub CharData
{
    my $buf = shift;
    my $eaten = "";
    my $bite1 = "";
    my $ptr   = "";

    # [15]   CharData ::= [^<&]* - ([^<&]* ']]>' [^<&]*)
    if ($$buf =~ s/^([^<&]*\]\]>[^<&]*)//) {
        $eaten = $1;
        syntax_error( $eaten, $buf, 
                    "Character data is not allowed to have a ']]>' embedded in it");
    } else {
        if ($$buf =~ s/^([^<]*)//) {
            $eaten = $1;
            # Now check to see if there are any references inside the data.
            $bite1 = $eaten;
            $ptr   = $bite1;
            if ($bite1 =~ s/^([^&]*)//) {
                while ($bite1) {
                    $ptr   = $bite1;
                    ######## Reference ###################
                    # If you change anything here,
                    # change it in sub content as well
                    if ($bite1 = Reference(\$ptr)) {
                        if ($bite1) {
                            if ($DEBUG) {
                                print "Reference=$bite1\n";
                            }
                            if (defined($sr_reference)) {
                                $sr_reference->($bite1); 
                            }
                            # Note: Don't copy this to sub content.
                            # This is only for this function.
                            $bite1 = $ptr;
                            $bite1 =~ s/^([^&]*)//;
                        }
                    }
                }
            }
        }
    }
    return $eaten;
}


sub Reference
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [67]    Reference ::= EntityRef | CharRef
   unless ($eaten = EntityRef($buf)) {
      $eaten = CharRef($buf);
   }
   return $eaten;
}

sub CDSect
{
   my $buf = shift;
   # [19]   CDSect ::= CDStart CData CDEnd
   #        CDSect   = terminal regexp
   return $1 if $$buf =~ s/^(<\!\[CDATA\[.*?\]\]>)//s;
   return "";
}

sub PITarget
{
   my $buf = shift;
   my $eaten = "";
   # [18]     PITarget ::= Name - (('X' | 'x') ('M' | 'm') ('L' | 'l'))
   if ($$buf =~ s/^(xml)//i) {
      $eaten = $1;
      syntax_error( $eaten, $buf, 
                    "'xml' is reserved and cannot begin a PI name");      
   }
   else {
      $eaten = Name($buf);
   }
   return $eaten;
}

sub Eq
{
   my $buf = shift;
   # [26]   Eq ::= S? '=' S?
   #        Eq   = terminal regexp 
   return $1 if $$buf =~ s/^([\ \n\r\t]*=[\ \n\r\t]*)//;
   return "";
}

sub SystemLiteral
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [11] SystemLiteral ::= SkipLit = ('"' [^"]* '"') | ("'" [^']* "'")
   #      SystemLiteral   = terminal regexp
   return $1 if $$buf =~ s/^(\"[^\"]*\"|\'[^\']*\')//; # \" is for emacs
   return "";
}

sub PubidLiteral
{
   my $buf = shift;
   # [12]  PubidLiteral ::= '"' PubidChar* '"' | "'" (PubidChar - "'")* "'"
   #       PubidLiteral   = terminal regexp
   return $1 if $$buf =~ s/^("[\ \n\r\ta-zA-Z\d\-\'\(\)\+\,\.\/\:\=\?]*"|'[\ \n\r\ta-zA-Z\d\-\(\)\+\,\.\/\:\=\?]*')//;
   return "";
}

sub AttlistDecl
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   # [52]   AttlistDecl ::= '<!ATTLIST' S Name AttDef* S? '>'
   if ($$buf =~ s/^(<!ATTLIST)//) {
      $eaten = $1;
      if ($bite1 = S($buf) and $bite2 = Name($buf)) {
         $eaten .= $bite1 . $bite2;
         while ($bite1 = AttDef($buf)) {
            $eaten .= $bite1;
         }
         $eaten .= S($buf);
         if ($$buf =~ s/^(>)//) {
            $eaten .= $1;
         }
         else { # Need a closing > for the attribute list
            syntax_error( $eaten, $buf, 
                          "Need a closing > for the attribute list");
         }
      }
      else { # Need S Name for the attribute list
         syntax_error( $eaten, $buf, "Need 'S Name' for the attribute list");
      }
   }
   return $eaten;
}

sub EntityDecl
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   my $pedecl = 0;
   # [70]    EntityDecl ::= GEDecl | PEDecl
   # [71]        GEDecl ::=   '<!ENTITY' S Name S EntityDef S? '>'
   # [72]        PEDecl ::= | '<!ENTITY' S '%' S Name S PEDef S? '>'
   #         EntityDecl   =  '<!ENTITY' S       Name S EntityDef S? '>'
   #                       | '<!ENTITY' S '%' S Name S PEDef     S? '>'
   if ($$buf =~ s/^(<!ENTITY)//) {
      $eaten = $1;
      if ($bite1 = S($buf)) {
         $eaten .= $bite1;
         if ($$buf =~ s/^(%[\ \n\r\t]+)//) {
            $eaten .= $1;
            $pedecl = 1;
         }
         if ($bite1 = Name($buf) and $bite2 = S($buf)) {
            $eaten .= $bite1 . $bite2;
            if ($pedecl){
               if ($bite1 = EntityDef($buf)) {
                  $eaten .= $bite1 . S($buf);
               }
               else { # general entity decl needs an entity definition
                  syntax_error( $eaten, $buf, 
                                "General entity decl needs an entity definition");
               }
            }
            else {
               if ($bite1 = PEDef($buf)) {
                  $eaten .= $bite1 . S($buf);
               }
               else { # Parameter entity decl needs an entity definition
                  syntax_error( $eaten, $buf, 
                                "Parameter entity decl needs an entity definition");
               }               
            }
            if ($$buf =~ s/^(>)//) {
               $eaten .= $1;
            }
            else { # Entity declaration needs a closing >
               syntax_error( $eaten, $buf, 
                             "Entity declaration needs a closing >");
            }
         }
         else { # Entity declaration needs a Name S
            syntax_error( $eaten, $buf, 
                          "Entity declaration needs a 'Name S'");
         }
      }
      else { # Need a space after the <!ENTITY
            syntax_error( $eaten, $buf, "Need a space after the <!ENTITY");
      }
   }
   return $eaten;
}

sub NotationDecl
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   my $bite3 = "";
   # [83]  NotationDecl ::= '<!NOTATION' S Name S 
   #                                   (ExternalID |  PublicID) S? '>'
   if ($$buf =~ s/^(<!NOTATION)//) {
      $eaten = $1;
      if ($bite1 = S($buf) and $bite2 = Name($buf) 
          and $bite3 = S($buf)) {
         $eaten .= $bite1 . $bite2 . $bite3;
         unless ($bite1 = ExternalID($buf)) {
            $bite1 = PublicID($buf);
         }
         if ($bite1) {
            $eaten .= $bite1;
            if ($$buf =~ s/^(>)//) {
               $eaten .= $1;
            }
            else { # Notation declaration needs a closing >
               syntax_error( $eaten, $buf, 
                             "Notation declaration needs a closing >");
            }      
         }
         else { # Need an ExternalID or PublicID after the name
            syntax_error( $eaten, $buf, 
                          "Need an ExternalID or PublicID after the name");
         }
      }
      else { # Notation declaration needs S Name S
         syntax_error( $eaten, $buf, 
                       "Notation declaration needs 'S Name S'");
      }
   }
   return $eaten;
}

sub AttValue
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";

   # [10]      AttValue ::=   '"' ([^<&"] | Reference)* '"'
   #                       |  "'" ([^<&'] | Reference)* "'"
   if ($$buf =~ s/^(\")//) {
      $eaten = $1;
      while (1) {
         if ($$buf =~ s/^([^<&\"])//) {
            $eaten .= $1;
         }
         elsif ($bite1 = Reference($buf)) {
            $eaten .= $bite1;
         }
         else {
            last;
         }
      }
      if ($$buf =~ s/^(\")//) {
         $eaten .= $1;
      }
      else { # Need a closing " for the attribute value
         syntax_error( $eaten, $buf, 
                       "Need a closing \" for the attribute value");
      }
   }
   elsif ($$buf =~ s/^(\')//) {
      $eaten = $1;
      while (1) {
         if ($$buf =~ s/^([^<&\'])//) {
            $eaten .= $1;
         }
         elsif ($bite1 = Reference($buf)) {
            $eaten .= $bite1;
         }
         else {
            last;
         }
      }
      if ($$buf =~ s/^(\')//) {
         $eaten .= $1;
      }
      else { # Need a closing ' for the attribute value
         syntax_error( $eaten, $buf, 
                       "Need a closing \' for the attribute value");
      }
   }
   else {}
   return $eaten;
}

sub AttValue2
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $atval = "";

   # [10]      AttValue ::=   '"' ([^<&"] | Reference)* '"'
   #                       |  "'" ([^<&'] | Reference)* "'"
   if ($$buf =~ s/^(\")//) {
      $eaten = $1;
      while (1) {
         if ($$buf =~ s/^([^<&\"])//) {
            $eaten .= $1;
            $atval = $1;
         }
         elsif ($bite1 = Reference($buf)) {
            $eaten .= $bite1;
            $atval = $bite1;
         }
         else {
            last;
         }
      }
      if ($$buf =~ s/^(\")//) {
         $eaten .= $1;
      }
      else { # Need a closing " for the attribute value
         syntax_error( $eaten, $buf, 
                       "Need a closing \" for the attribute value");
      }
   }
   elsif ($$buf =~ s/^(\')//) {
      $eaten = $1;
      while (1) {
         if ($$buf =~ s/^([^<&\'])//) {
            $eaten .= $1;
         }
         elsif ($bite1 = Reference($buf)) {
            $eaten .= $bite1;
         }
         else {
            last;
         }
      }
      if ($$buf =~ s/^(\')//) {
         $eaten .= $1;
      }
      else { # Need a closing ' for the attribute value
         syntax_error( $eaten, $buf, 
                       "Need a closing \' for the attribute value");
      }
   }
   else {}
   return $eaten;
}

sub EntityRef
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [68]     EntityRef ::= '&' Name ';'
   if ($$buf =~ s/^(&)//) {
      $eaten = $1;
      if ($bite1 = Name($buf)) {
         $eaten .= $bite1;
         if ($$buf =~ s/^(;)//) {
            $eaten .= $1;
         }
         else { # Entity reference needs a closing ;
         syntax_error( $eaten, $buf, "Entity reference needs a closing ;");
         }
      }
      else { # This may be a character reference
         $$buf = $eaten . $$buf;
         $eaten = "";
      }
   }
   return $eaten;
}

sub CharRef
{
   my $buf = shift;
   # [66]       CharRef ::= '&#' [0-9]+ ';' | '&#x' [0-9a-fA-F]+ ';' 
   #            CharRef   = terminal regexp
   return $1 if $$buf =~ s/^(&\#\d+;|&\#[xX][\da-fA-F]+;)//;
   return "";
}

sub AttDef
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   my $bite3 = "";
   my $bite4 = "";
   my $bite5 = "";
   # [53]        AttDef ::= S Name S AttType S Default
   if ($eaten = S($buf) and $bite1 = Name($buf) and $bite2 = S($buf) 
       and $bite3 = AttType($buf) and $bite4 = S($buf) 
       and $bite5 = Default($buf)) {
      $eaten .= $bite1 . $bite2 . $bite3 . $bite4 . $bite5;
   }
   else {
      $$buf = $eaten . $bite1 . $bite2 . $bite3 . $bite4 . $$buf;
      $eaten = "";
   }
   return $eaten;
}

sub PublicID
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [84]      PublicID ::= 'PUBLIC' S PubidLiteral
   if ($$buf =~ s/^()//) {
      $eaten = $1;
      if ($bite1 = S($buf)) {
         $eaten .= $bite1;
         if ($bite1 = PubidLiteral($buf)) {
            $eaten .= $bite1;
         }
         else { # Need a literal expression for the PublicID
            syntax_error( $eaten, $buf, 
                          "Need a literal expression for the PublicID");
         }
      }
      else { # Need a space after PUBLIC
         syntax_error( $eaten, $buf, "Need a space after PUBLIC");
      }
   }
   return $eaten;
}

sub Mixed 
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   my $alt_flag = 2; # flag alternative for use later in the regexp
   # [51]     Mixed ::=  '(' S? '#PCDATA' (S? '|' S? Name)* S? ')*'
   #                   | '(' S? '#PCDATA'                   S? ')'
   if ($$buf =~ s/^(\()//) {
      $eaten = $1 . S($buf);
      if ($$buf =~ s/^(\#PCDATA)//) {
         $eaten .= $1;
         while (1) {
            $bite1 = S($buf);
            if ($$buf =~ s/^(\|)//) {
               $alt_flag = 1; # | indicates the first alternative
               $bite1 .= $1 . S($buf);
               if ($bite2 = Name($buf)) {
                  $eaten .= $bite1 . $bite2;
               }
               else { # Mixed requires a name after the |
                  syntax_error( $eaten, $buf, 
                                "Mixed requires a name after the |");
               }              
            }
            else {
               last;
            }
         }
         if ($alt_flag == 1) {
            if ($$buf =~ s/^(\)\*)//) {
               $eaten .= $1;
            }
            else { # Mixed component with names requires a closing )*
               syntax_error( $eaten, $buf, 
                          "Mixed component with names requires a closing )*");
            }
         }
         else {
            if ($$buf =~ s/^(\))//) {
               $eaten .= $1;
            }
            else { # Mixed component requires a closing )
               syntax_error( $eaten, $buf, 
                             "Mixed component requires a closing )");
            }            
         }
      }
      else { # children may also start with a paren, so just put it back
         $$buf = $eaten . $$buf;
         $eaten = "";
      }
   }
   return $eaten;
}

sub AttType
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [54]   AttType ::= StringType | TokenizedType | EnumeratedType
   unless ($eaten = StringType($buf)) {
      unless ($eaten = TokenizedType($buf)) {
         $eaten = EnumeratedType($buf);
      }
   }
   return $eaten;
}

sub Default
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [60]   Default ::= '#REQUIRED' | '#IMPLIED' | (('#FIXED' S)? AttValue)
   if ( $$buf =~ s/^(\#REQUIRED|\#IMPLIED)//) {
      $eaten = $1;
   }
   else {
      if ($$buf =~ s/^(\#FIXED)//) {
         $eaten = $1;
         if ($bite1 = S($buf)) {
            $eaten .= $bite1;
            if ($bite1 = AttValue($buf)) {
               $eaten .= $bite1;
            }
            else { # Need an attribute values after #FIXED
            syntax_error( $eaten, $buf, 
                          "Need an attribute values after #FIXED");
            }
         }
         else { # Need a space after #FIXED
            syntax_error( $eaten, $buf, 
                          "Need a space after #FIXED");
         }
      }
   }
   return $eaten;
}

sub EntityDef
{
   my $buf = shift;
   my $eaten = "";
   # [73]     EntityDef ::= EntityValue | ExternalDef
   unless ($eaten = EntityValue($buf)) {
      $eaten = ExternalDef($buf);
   }
   return $eaten;
}

sub PEDef
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [74]         PEDef ::= EntityValue | ExternalID
   unless ($eaten = EntityValue($buf)) {
      $eaten = ExternalID($buf);
   }
   return $eaten;
}

sub StringType
{
   my $buf = shift;
   # [55]     StringType ::= 'CDATA'
   return $1 if $$buf =~ s/^(CDATA)//;
   return "";
}

sub TokenizedType
{
   my $buf = shift;
   # [56]  TokenizedType ::=  'ID' | 'IDREF' | 'IDREFS' | 'ENTITY' 
   #                        | 'ENTITIES' | 'NMTOKEN' | 'NMTOKENS'
   return $1 if $$buf =~ s/^(IDREFS|IDREF|ID|ENTITY|ENTITIES|NMTOKENS|NMTOKEN)//;
   return "";
}

sub EnumeratedType
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [57] EnumeratedType ::= NotationType | Enumeration
   unless ($eaten = NotationType($buf)) {
      $eaten = Enumeration($buf);
   }
   return $eaten;
}

sub EntityValue
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   # [9] EntityValue ::=   '"' ([^%&"] | PEReference | Reference)* '"'
   #                     | "'" ([^%&'] | PEReference | Reference)* "'"
   if ($$buf =~ s/^(\")//) {
      $eaten = $1;
      while (1) {
         if ($$buf =~ s/^([^%&\"])//) {
            $eaten .= $1;
         }
         elsif ($bite1 = PEReference($buf)) {
            $eaten .= $bite1;
         }
         elsif ($bite1 = Reference($buf)) {
            $eaten .= $bite1;
         }
         else {
            last;
         }
      }
      if ($$buf =~ s/^(\")//) {
         $eaten .= $1;
      }
      else { # Need a closing " for the entity value
         syntax_error( $eaten, $buf, 
                       "Need a closing \" for the entity value");
      }
   }
   elsif ($$buf =~ s/^(\')//) {
      $eaten = $1;
      while (1) {
         if ($$buf =~ s/^([^%&\'])//) {
            $eaten .= $1;
         }
         elsif ($bite1 = PEReference($buf)) {
            $eaten .= $bite1;
         }
         elsif ($bite1 = Reference($buf)) {
            $eaten .= $bite1;
         }
         else {
            last;
         }
      }
      if ($$buf =~ s/^(\')//) {
         $eaten .= $1;
      }
      else { # Need a closing ' for the entity value
         syntax_error( $eaten, $buf, 
                       "Need a closing \' for the entity value");
      }
   }
   else {}
   return $eaten;
}

sub ExternalDef
{
   my $buf = shift;
   my $eaten = "";
   # [75] ExternalDef ::= ExternalID NDataDecl?
   if ($eaten = ExternalID($buf)) {
      $eaten .= NDataDecl($buf);
   }
   return $eaten;
}

sub NotationType
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   # [58]   NotationType ::= 'NOTATION' S '(' S? Name (S? '|' Name)* S? ')'
   if ($$buf =~ s/^(NOTATION)//) {
      $eaten = $1;
      if ($bite1 = S($buf) and $$buf =~ s/^(\()//) {
         $eaten .= $bite1 . $1 . S($buf);
         if ($bite1 = Name($buf)) {
            $eaten .= $bite1;
            while (1) {
               $bite1 = S($buf);
               if ($$buf =~ s/^(\|)//) {
                  $bite1 .= $1 . S($buf);
                  if ($bite2 = Name($buf)) {
                     $eaten .= $bite1 . $bite2;
                  }
                  else { # Name needed after |
                     syntax_error( $eaten, $buf, "Name needed after |");
                  }
               }
               else {
                  last;
               }
            }
            if ($$buf =~ s/^(\))//) {
               $eaten .= $1;
            }
            else { # Need a closing ) for notation type
               syntax_error( $eaten, $buf, 
                             "Need a closing ) for notation type");
            }
         }
         else { # Need a name here 
            syntax_error( $eaten, $buf, "Need a name here");
         }
      }
      else { # Need a space ( after NOTATION
         syntax_error( $eaten, $buf, 
                       "Need a space ( after NOTATION");
      }
   }
   return $eaten;
}

sub Enumeration
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   # [59]    Enumeration ::=  '(' S? Nmtoken (S? '|' S? Nmtoken)* S? ')'
   if ($$buf =~ s/^(\()//) {
      $eaten = $1 . S($buf);
      if ($bite1 = Nmtoken($buf)) {
         $eaten .= $bite1;
         while (1) {
            $bite1 = S($buf);
            if ($$buf =~ s/^(\|)//) {
               $bite1 .= $1 . S($buf);
               if ($bite2 = Nmtoken($buf)) {
                  $eaten .= $bite1 . $bite2;
               }
               else { # Need a name token after the |
                  syntax_error( $eaten, $buf, 
                                "Need a name token after the |");
               }
            }
            else {
               last;
            }
         }
         if ($$buf =~ s/^(\))//) {
            $eaten .= $1;
         }
         else { # Need a closing ) for the enumeration
            syntax_error( $eaten, $buf, 
                          "Need a closing ) for the enumeration");
         }
      }
      else { # Enumeration requires a name token
         syntax_error( $eaten, $buf, "Enumeration requires a name token");
      }
   }
   return $eaten;
}

sub NDataDecl
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";
   my $bite2 = "";
   # [77]      NDataDecl ::= S 'NDATA' S Name
   if ($bite1 = S($buf) and $$buf =~ s/^(NDATA)//) {
      $eaten = $bite1 . $1;
      if ($bite1 = S($buf) and $bite2 = Name($buf)) {
         $eaten .= $bite1 . $bite2;
      }
      else { # Need an S name after the NDATA
         syntax_error( $eaten, $buf, 
                       "Need an S name after the NDATA");
      }
   }
   else { # not an  NDataDecl, put back space
      $$buf = $eaten . $$buf;
      $eaten = "";
   }
   return $eaten;
}

sub Nmtoken
{
   my $buf = shift;
   # [7]   Nmtoken ::= (NameChar)+
   return $1 if $$buf =~ s/^([\w\.\-\:\xaa\xb5\xb7\xba\xc0-\xd6\xd8-\xf6\xf8-\xff]+)//;
   return "";
}

sub dummy
{
   my $buf = shift;
   my $eaten = "";
   my $bite1 = "";

   return $eaten;
}

sub syntax_error
{
   my ($eaten, $buf, $message) = @_;
   my $subname = (caller(1))[3];
   my $errstr = "";
   
   $errstr = "Syntax error while processing a $subname:\n";
   $errstr .= "\t$message\n";
   $errstr .= "text before: " . substr($eaten, -40, 40) . "\n";
   $errstr .= "text after:  " . substr($$buf, 0, 40) . "\n";

   croak($errstr);
}

########## end parse_rd hierarchy #####################


# These subs are hooks into the parser, from which you can define `actions'
# Here, they are all placeholder subroutines which do nothing

sub text
{
   my($self, $text) = @_;
}

#sub declaration
#{
#    # my($self, $decl) = @_;
#}

#sub comment
#{
#    # my($self, $comment) = @_;
#}

#sub start
#{
#    my($self, $tag, $attr, $attrseq, $origtext) = @_;
#    # $attr is reference to a HASH, $attrseq is reference to an ARRAY
#}

#sub end
#{
#    my($self, $tag) = @_;
#}

1;
__END__
=head1 NAME

XML::Parser - Parses an XML document

=head1 SYNOPSIS

  use XML::Parser;
  $p = XML::Parser->new;  # should really a be subclass
  $p->parse($chunk1);
  $p->parse($chunk2);
  #...
  $p->end_parse;                 # signal end of document

  # Parse directly from file
  $p->parse_file("foo.xml");
  # or
  open(F, "foo.xml") || die;
  $p->parse_file(\*F);

=head1 DESCRIPTION

XML::Parser checks an XML document against both the XML spec and the DTD.

$p->parse() - will tokenize an arbitrary chunk of XML
              document. Returns a reference to the parser object.

$p->end_parse()   - ends the document and flushes remaining text

$p->parse_file() - parses text from a file. May be passed a filename
                   or an already opened filehandle. Returns a
                   reference to the parser object.

In order to make the parser do anything interesting, you must make a
subclass where you override one or more of the following methods as
appropriate:

=over 4

=item $self->declaration($decl)

This method is called when a I<markup declaration> has been
recognized.  For typical HTML documents, the only declaration you are
likely to find is <!DOCTYPE ...>.  The initial "<!" and ending ">" is
not part of the string passed as argument.  Comments are removed and
entities have B<not> been expanded yet.

=item $self->start($tag, $attr, $attrseq, $origtext)

This method is called when a complete start tag has been recognized.
The first argument is the tag name (in lower case) and the second
argument is a reference to a hash that contain all attributes found
within the start tag.  The attribute keys are converted to lower case.
Entities found in the attribute values are already expanded.  The
third argument is a reference to an array with the lower case
attribute keys in the original order.  The fourth argument is the
original HTML text.


=item $self->end($tag)

This method is called when an end tag has been recognized.  The
argument is the lower case tag name.

=item $self->text($text)

This method is called when plain text in the document is recognized.
The text is passed on unmodified and might contain multiple lines.
Note that for efficiency reasons entities in the text are B<not>
expanded.  You should call HTML::Entities::decode($text) before you
process the text any further.

=item $self->comment($comment)

This method is called as comments are recognized.  The leading and
trailing "--" sequences have been stripped off the comment text.

=back

The default implementation of these methods does nothing, I<i.e.,> the
tokens are just ignored.

There is really nothing in the basic parser that is HTML specific, so
it is likely that the parser can parse many kinds of SGML documents,
but SGML has many obscure features (not implemented by this module)
that prevent us from renaming this module as C<SGML::Parse>.

=head1 SEE ALSO

L<XML::WellFormed>, L<XML::Validate>, 

=head1 COPYRIGHT

Copyright 1997 Mark Kvale. All rights reserved.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 AUTHOR

Mark Kvale <kvale@phy.ucsf.edu>

=cut
