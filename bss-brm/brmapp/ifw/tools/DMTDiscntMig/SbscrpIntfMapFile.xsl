<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output    method="xml"    indent="yes"    encoding="UTF-8"/>
<xsl:template match="/">    
    <deal_list> 
        <xsl:for-each select="output/*">
        <xsl:choose>
            <xsl:when test='name()="addon-deal"'>
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:for-each>
    </deal_list>        
</xsl:template>
</xsl:stylesheet>
