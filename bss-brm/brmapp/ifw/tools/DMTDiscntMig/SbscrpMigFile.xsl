<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output    method="text"   encoding="utf-8"   media-type="text/plain"  indent="yes"/>
<xsl:template match="/">
        <xsl:for-each select="output/addon-deal">
            <xsl:value-of select="rateplanname"/>
            <xsl:text>|</xsl:text>
            <xsl:value-of select="deal-name"/>
            <xsl:text>|</xsl:text>
            <xsl:value-of select="servicecode"/>
            <xsl:text>|</xsl:text>
            <xsl:value-of select="discountmodelcode"/>
             <xsl:text>
</xsl:text>
        </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
