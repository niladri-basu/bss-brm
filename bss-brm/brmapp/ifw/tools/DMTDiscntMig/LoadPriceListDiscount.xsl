<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output    method="xml"    indent="yes"    encoding="UTF-8"  standalone="no"/>
<xsl:template match="/">
<xsl:text disable-output-escaping="yes">
&lt;price_list xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="price_list.xsd" version="7.2"&gt;
</xsl:text>
    <xsl:for-each select="output/*">
        <xsl:variable name="deal" select="name()"/>
        <xsl:choose>
            <xsl:when test='$deal = "addon-deal"'>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
<xsl:text disable-output-escaping="yes">
&lt;/price_list&gt;
</xsl:text>
</xsl:template>
</xsl:stylesheet>
