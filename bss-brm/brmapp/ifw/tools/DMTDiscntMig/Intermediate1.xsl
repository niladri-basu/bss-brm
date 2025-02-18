<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output    method="xml"    indent="yes"    encoding="UTF-8"/>
<xsl:template match="/">    
<output>
    <xsl:for-each select="output/discount/row">
        <discountmodel>
            <xsl:attribute name="VALID_FROM"><xsl:value-of select="@VALID_FROM"/></xsl:attribute>
            <xsl:attribute name="REF_PARAM"><xsl:value-of select="@REF_PARAM"/></xsl:attribute>
            <xsl:attribute name="PIN_SERVICETYPE"><xsl:value-of select="@PIN_SERVICETYPE"/></xsl:attribute>
            <xsl:attribute name="SERVICECODE"><xsl:value-of select="@SERVICECODE"/></xsl:attribute>
            <xsl:attribute name="RATEPLANNAME"><xsl:value-of select="@RATEPLANNAME"/></xsl:attribute>
            <xsl:attribute name="CODE"><xsl:value-of select="@CODE"/></xsl:attribute>
            <xsl:attribute name="VERSION"><xsl:value-of select="@VERSION"/></xsl:attribute>
            <xsl:attribute name="CASCADING"><xsl:value-of select="@CASCADING"/></xsl:attribute>
            <xsl:attribute name="KEY-CODE"><xsl:value-of select="@CODE"/><xsl:value-of select="@SERVICECODE"/></xsl:attribute>
            <xsl:apply-templates select="ancestor::output/rollover/row">
                <xsl:with-param name="dsccode"><xsl:value-of select="@CODE"/></xsl:with-param>
                <xsl:with-param name="version"><xsl:value-of select="@VERSION"/></xsl:with-param>
            </xsl:apply-templates>    
        </discountmodel>
    </xsl:for-each>
</output>
</xsl:template>

<xsl:template match="output/rollover/row"> 
    <xsl:param name="dsccode"/>
    <xsl:param name="version"/>
    <xsl:variable name="rollcode"><xsl:value-of select="@CODE"/></xsl:variable>
    <xsl:variable name="rollcodever"><xsl:value-of select="@VERSION"/></xsl:variable>
    <xsl:if test='$rollcode=$dsccode'>
      <xsl:if test='$rollcodever=$version'>
        <xsl:element name="rollover">
            <xsl:attribute name="DISCOUNTMODEL"><xsl:value-of select="@DISCOUNTMODEL"/></xsl:attribute>
            <xsl:attribute name="DISCOUNTRULE"><xsl:value-of select="@DISCOUNTRULE"/></xsl:attribute>
            <xsl:attribute name="ROLLOVER_UNITS"><xsl:value-of select="@ROLLOVER_UNITS"/></xsl:attribute>
            <xsl:attribute name="ROLLOVER_MAX"><xsl:value-of select="@ROLLOVER_MAX"/></xsl:attribute>
            <xsl:attribute name="ROLLOVER_MONTHS"><xsl:value-of select="@ROLLOVER_MONTHS"/></xsl:attribute>
            <xsl:attribute name="ROLLOVER_PERIOD"><xsl:value-of select="@ROLLOVER_PERIOD"/></xsl:attribute>
            <xsl:attribute name="RESOURCE_ID"><xsl:value-of select="@RESOURCE_ID"/></xsl:attribute>
            <xsl:attribute name="CODE"><xsl:value-of select="@CODE"/></xsl:attribute>
            <xsl:attribute name="VERSION"><xsl:value-of select="@VERSION"/></xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:if>
</xsl:template>
</xsl:stylesheet>
