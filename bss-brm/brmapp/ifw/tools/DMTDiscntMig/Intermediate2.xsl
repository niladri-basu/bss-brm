<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output    method="xml"    indent="yes"    encoding="UTF-8"/>
<xsl:key name="keycode_key" match="discountmodel" use="@KEY-CODE"/>
<xsl:key name="rateplancode_key" match="discountmodel" use="concat(@KEY-CODE,@RATEPLANNAME)"/>
<xsl:template match="/">    
<output>
    <xsl:for-each select="output/discountmodel">    
        <xsl:variable name="start_tm"><xsl:value-of select="@VALID_FROM"/></xsl:variable> 
        <xsl:variable name="id_1" select="generate-id()"></xsl:variable>
        <xsl:variable name="id_2" select="key('keycode_key',@KEY-CODE)"></xsl:variable>
        <xsl:variable name="id_3" select="generate-id($id_2)"></xsl:variable>
        <xsl:variable name="id_4" select="key('rateplancode_key',concat(@KEY-CODE,@RATEPLANNAME))"></xsl:variable>
        <xsl:variable name="id_5" select="generate-id($id_4)"></xsl:variable>
        <xsl:if test="$id_1=$id_3">
            <discount>
                <xsl:variable name="cascading"><xsl:value-of select="@CASCADING"/></xsl:variable> 
                <xsl:attribute name="type">subscription</xsl:attribute>
                <xsl:attribute name="mode">
                <xsl:choose>
                    <xsl:when test='$cascading=0'><xsl:text>parallel</xsl:text></xsl:when>
                    <xsl:when test='$cascading=1'><xsl:text>cascading</xsl:text></xsl:when>
                    <xsl:otherwise><xsl:text>parallel</xsl:text></xsl:otherwise>
                </xsl:choose>
                </xsl:attribute>
                <discount_name>
                    <xsl:text>Discount-</xsl:text><xsl:value-of select="@CODE"/><xsl:text>-</xsl:text><xsl:value-of select="@SERVICECODE"/><xsl:text>-</xsl:text><xsl:value-of select="@VERSION"/>
                </discount_name>
                <description>
                    <xsl:text>Discount-</xsl:text><xsl:value-of select="@CODE"/><xsl:text>-</xsl:text><xsl:value-of select="@SERVICECODE"/><xsl:text>-</xsl:text><xsl:value-of select="@VERSION"/>
                </description>
                <xsl:call-template name="date_time">
                    <xsl:with-param name="start_time"><xsl:value-of select="$start_tm"/></xsl:with-param>
                </xsl:call-template>
                <permitted><xsl:value-of select="@PIN_SERVICETYPE"/></permitted>
                <discount_usage_map discount_flags="discount_inactivated" snowball_flag="no">
                    <event_type>
                        <xsl:value-of select="@REF_PARAM"/> 
                    </event_type>
                    <discount_model>
                        <xsl:value-of select="@CODE"/> 
                    </discount_model>
                </discount_usage_map>
            </discount>
            <xsl:variable name="cntr"><xsl:value-of select="count(rollover)"/></xsl:variable>
            <xsl:if test="$cntr>0">
                <product type="subscription" partial="no">
                    <product_name>
                        <xsl:text>Product-Roll-</xsl:text><xsl:value-of select="@CODE"/><xsl:text>-</xsl:text><xsl:value-of select="@SERVICECODE"/><xsl:text>-</xsl:text><xsl:value-of select="@VERSION"/>
                    </product_name>
                    <priority>0.0</priority>
                    <xsl:call-template name="date_time">
                        <xsl:with-param name="start_time"><xsl:value-of select="$start_tm"/></xsl:with-param>
                    </xsl:call-template>        
                    <permitted><xsl:value-of select="@PIN_SERVICETYPE"/></permitted>
                    <event_rating_map tod_mode="start_time" timezone_mode="server" min_unit="none" incr_unit="none" rounding_rule="nearest">
                        <event_type>/event/billing/cycle/rollover/monthly</event_type>
                        <rum_name>Occurrence</rum_name>
                        <min_quantity>1.0</min_quantity>
                        <incr_quantity>1.0</incr_quantity>
                        <rate_plan_name>Monthly Cycle Rollover Event</rate_plan_name>
                    </event_rating_map>
                    <rollover relative_start_unit="second" relative_end_unit="second" date_range_type="absolute">
                        <rollover_name>Monthly Cycle Rollover Event</rollover_name>
                        <description>Monthly Cycle Rollover Event</description>
                        <relative_start_offset>0</relative_start_offset>
                        <relative_end_offset>0</relative_end_offset>
                        <xsl:for-each select="child::rollover">
                            <balance_impact prorate_first="prorate" prorate_last="prorate">
                                 <resource_id><xsl:value-of select="@RESOURCE_ID"/></resource_id>
                                 <rollover_max_units><xsl:value-of select="@ROLLOVER_MAX"/></rollover_max_units>
                                 <rollover_units><xsl:value-of select="@ROLLOVER_UNITS"/></rollover_units>
                                 <rollover_max_cycles><xsl:value-of select="@ROLLOVER_MONTHS"/></rollover_max_cycles>
                            </balance_impact>            
                        </xsl:for-each>
                    </rollover>
                </product>
            </xsl:if>        
            <deal ondemand_billing="no" customization_flag="optional">
                <deal_name>
                    <xsl:text>Deal-</xsl:text><xsl:value-of select="@CODE"/><xsl:text>-</xsl:text><xsl:value-of select="@SERVICECODE"/><xsl:text>-</xsl:text><xsl:value-of select="@VERSION"/>
                </deal_name>
                <description>
                    <xsl:text>Deal-</xsl:text><xsl:value-of select="@CODE"/><xsl:text>-</xsl:text><xsl:value-of select="@SERVICECODE"/><xsl:text>-</xsl:text><xsl:value-of select="@VERSION"/>
                </description>
                <permitted>
                    <xsl:value-of select="@PIN_SERVICETYPE"/>
                </permitted>
                <xsl:if test="$cntr>0">
                    <deal_product status="active">
                        <product_name>
                            <xsl:text>Product-Roll-</xsl:text><xsl:value-of select="@CODE"/><xsl:text>-</xsl:text><xsl:value-of select="@SERVICECODE"/><xsl:text>-</xsl:text><xsl:value-of select="@VERSION"/>
                        </product_name>
                        <quantity>1.0</quantity>
                        <purchase_start unit="day">0</purchase_start>
                        <purchase_end unit="day">0</purchase_end>
                        <purchase_discount>0.0</purchase_discount>
                        <cycle_start unit="day">0</cycle_start>
                        <cycle_end unit="day">0</cycle_end>
                        <cycle_discount>0.0</cycle_discount>
                        <usage_start unit="day">0</usage_start>
                        <usage_end unit="day">0</usage_end>
                        <usage_discount>0.0</usage_discount>
                    </deal_product>         
                </xsl:if>
                <deal_discount status="active">
                    <discount_name>
                        <xsl:text>Discount-</xsl:text><xsl:value-of select="@CODE"/><xsl:text>-</xsl:text><xsl:value-of select="@SERVICECODE"/><xsl:text>-</xsl:text><xsl:value-of select="@VERSION"/>
                    </discount_name>
                    <quantity>1.0</quantity>
                    <purchase_start unit="day">0</purchase_start>
                    <purchase_end unit="day">0</purchase_end>
                    <cycle_start unit="day">0</cycle_start>
                    <cycle_end unit="day">0</cycle_end>
                    <usage_start unit="day">0</usage_start>
                    <usage_end unit="day">0</usage_end>
                </deal_discount>
            </deal>
        </xsl:if>
        <xsl:if test="$id_1=$id_5">    
            <addon-deal>
                <rateplanname>
                    <xsl:value-of select="@RATEPLANNAME"/>
                </rateplanname>
                <discountmodelcode>
                    <xsl:value-of select="@CODE"/>
                </discountmodelcode>
                <deal-name>
                    <xsl:text>Deal-</xsl:text><xsl:value-of select="@CODE"/><xsl:text>-</xsl:text><xsl:value-of select="@SERVICECODE"/><xsl:text>-</xsl:text><xsl:value-of select="@VERSION"/>
                </deal-name>
                <servicecode>
                    <xsl:value-of select="@PIN_SERVICETYPE"/>
                </servicecode>
            </addon-deal>
        </xsl:if>
    </xsl:for-each>
</output>
</xsl:template>

<xsl:template name="date_time">
    <xsl:param name="start_time"/>
    <xsl:variable name="start_tm_len" select="string-length(normalize-space($start_time))"/>
    <xsl:if test="$start_tm_len > 0">
        <start_time>
            <datetime>
                <date>
                    <xsl:attribute name="yyyy">
                         <xsl:value-of select="substring($start_time,1,4)"/>
                    </xsl:attribute>
                    <xsl:attribute name="mm">
                         <xsl:value-of select="substring($start_time,5,2)"/>
                    </xsl:attribute>
                    <xsl:attribute name="dd">
                         <xsl:value-of select="substring($start_time,7,2)"/>
                    </xsl:attribute>
                </date>
                <time>
                    <xsl:attribute name="hh">
                         <xsl:value-of select="substring($start_time,9,2)"/>
                    </xsl:attribute>
                    <xsl:attribute name="mm">
                         <xsl:value-of select="substring($start_time,11,2)"/>
                    </xsl:attribute>
                    <xsl:attribute name="ss">
                         <xsl:value-of select="substring($start_time,13,2)"/>
                    </xsl:attribute>
                    <xsl:attribute name="tzhr">-5</xsl:attribute>
                    <xsl:attribute name="tzmn">-30</xsl:attribute>
                </time> 
            </datetime>
        </start_time>
    </xsl:if>
</xsl:template>
</xsl:stylesheet>
