use Test;
BEGIN { plan tests => 1 }

use XML::LibXML;
use XML::LibXSLT;
for my $p (qw(
  XML::LibXML::VERSION
  XML::LibXSLT::VERSION
 )) {
  printf "%s: %s\n", $p, $$p;
}
use strict;

my $parser = XML::LibXML->new();
my $xslt = XML::LibXSLT->new();

# $parser->expand_entities(1);

my $source = $parser->parse_string(qq{<?xml version="1.0" encoding="UTF-8"?>
<root>foo</root>});
my $style_doc = $parser->parse_string('<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
<!ENTITY ouml   "&#246;">
]>

<xsl:stylesheet
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     version="1.0">
 <xsl:output method="xml" />

 <xsl:template match="/">
  <out>foo&ouml;bar</out>
 </xsl:template>

</xsl:stylesheet>
');

print $style_doc->toString;

my $stylesheet = $xslt->parse_stylesheet($style_doc);

my $results = $stylesheet->transform($source);

print $results->toString;

my $content = $stylesheet->output_string($results);

print $content, "\n";

ok($content, qr/foo(?:.|&#xF6;)bar/i);
