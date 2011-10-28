use Test::More tests => 2;

{
use strict;
use warnings;

use XML::LibXSLT;
use XML::LibXML;

my $xslt = XML::LibXSLT->new();
my $ext_uri = "urn:local";
XML::LibXSLT->register_function($ext_uri, "uc", sub { return uc shift; } );

my $stylesheet = $xslt->parse_stylesheet(XML::LibXML->load_xml(string => <<'EOF'));
<xsl:stylesheet version="1.0"
                extension-element-prefixes="exsl local"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common" 
                xmlns:local="urn:local">
  <xsl:template match="/">
    <xsl:variable name="foo"><foo a="foo"/></xsl:variable>
    <bar><xsl:value-of select="local:uc(exsl:node-set($foo)//@a)"/></bar>
  </xsl:template>
</xsl:stylesheet>
EOF

my $input = XML::LibXML->load_xml(string => "<input/>");
ok($stylesheet->transform($input)->toString =~ "<bar>FOO</bar>");

}
ok(1);
