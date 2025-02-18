<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:op="http://www.portal.com/schemas/BusinessOpcodes"
                xmlns="http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="global"/>
  <xsl:template match="/">
    <xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                targetNamespace="http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes"
                elementFormDefault="qualified" >  

      <xsl:comment>Copyright (c) 2007 Oracle. All rights reserved.

        This material is the confidential property of Oracle Corporation or
        its licensors and may be used, reproduced, stored or transmitted only
        in accordance with a valid Oracle license or sublicense agreement.</xsl:comment>

      <xsl:variable name="IOFlag" select="'IN'"/>
      <xsl:variable name="NoIOFlag" select="'OUT'"/>

      <!-- Parses the input for fields and calls respective Templates-->      

      <!-- Parses the input for Extension Substructs to generate Includes -->
      <xsl:for-each select="op:Opcode/op:Input/op:Fields">
        <xsl:call-template name="generate_includes_from_dd_schema"/>
      </xsl:for-each>

      <!-- Parses the Output for Extension Substructs to generate Includes -->
      <xsl:for-each select="op:Opcode/op:Output/op:Fields">
        <xsl:call-template name="generate_includes_from_dd_schema"/>
      </xsl:for-each>

      <!-- Parses Input for all fields to generate input Schema -->
      <!-- Generates Schema with root Tag as __OPCODE_NAME__ +input/outputFList-->
      <xsl:for-each select="op:Opcode">
        <xsl:variable name="OpcodeName" select="@name"/>
        <xsl:for-each select="op:Input/op:Fields">
          <xsl:call-template name="generate_input_schema">
            <xsl:with-param name="Opcode" select="$OpcodeName"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>

      <!-- Parses Input for all arrays to generate Complex types -->
      <xsl:for-each select="op:Opcode">
        <xsl:variable name="OpcodeName" select="@name"/>
        <xsl:for-each select="op:Input/op:Fields">
          <xsl:call-template name="generate_array_types">
            <xsl:with-param name="Opcode" select="$OpcodeName"/>
            <xsl:with-param name="IOFlag" select="$IOFlag"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>

      <!-- Parses Input for all substructs to generate Complex types -->
      <xsl:for-each select="op:Opcode">
        <xsl:variable name="OpcodeName" select="@name"/>
        <xsl:for-each select="op:Input/op:Fields">
          <xsl:call-template name="generate_substruct_types">
            <xsl:with-param name="Opcode" select="$OpcodeName"/>            
            <xsl:with-param name="IOFlag" select="$IOFlag"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>

      <!-- Parses Input for all fields to generate output Schema -->
      <!-- Generates Schema with root Tag as __OPCODE_NAME__ +input/outputFList-->
      <xsl:for-each select="op:Opcode">
        <xsl:variable name="OpcodeName" select="@name"/>
        <xsl:for-each select="op:Output/op:Fields">
          <xsl:call-template name="generate_output_schema">
            <xsl:with-param name="Opcode" select="$OpcodeName"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>

      <!-- Parses Output for all arrays to generate Complex types -->
      <xsl:for-each select="op:Opcode">
        <xsl:variable name="OpcodeName" select="@name"/>
        <xsl:for-each select="op:Output/op:Fields">
          <xsl:call-template name="generate_array_types">
            <xsl:with-param name="Opcode" select="$OpcodeName"/>            
            <xsl:with-param name="IOFlag" select="$NoIOFlag"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>

      <!-- Parses Output for all substructs to generate Complex types -->
      <xsl:for-each select="op:Opcode">
        <xsl:variable name="OpcodeName" select="@name"/>
        <xsl:for-each select="op:Output/op:Fields">
          <xsl:call-template name="generate_substruct_types">
            <xsl:with-param name="Opcode" select="$OpcodeName"/>            
            <xsl:with-param name="IOFlag" select="$NoIOFlag"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>

      <!-- Template which generates the Buffer base type -->
      <xsl:for-each select="op:Opcode">
        <xsl:variable name="OpcodeName" select="@name"/>
        <xsl:call-template name="generate_buffer_type">
          <xsl:with-param name="Opcode" select="$OpcodeName"/>
        </xsl:call-template>
      </xsl:for-each>

      <!-- Template which generates the Union Type of Empty+Decimal -->
      <xsl:for-each select="op:Opcode">
        <xsl:variable name="OpcodeName" select="@name"/>
        <xsl:call-template name="generate_union_type">
          <xsl:with-param name="Opcode" select="$OpcodeName"/>
        </xsl:call-template>
      </xsl:for-each>

      <!-- This is not be Required keeping as place holder just in case we may need -->
      <!-- <xsl:call-template name="generate_types"/>-->
    </xsd:schema>
  </xsl:template>

  <!-- Template to generate the includes schema of dd  -->
  <xsl:template name="generate_includes_from_dd_schema">
    <xsl:for-each select="*">
        <xsl:if test="(name() = 'Array' or name()= 'Substruct') ">
          <xsl:for-each select="op:Fields">
                <xsl:call-template name="generate_includes_from_dd_schema"/>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="(name() = 'Any') ">
            <xsl:variable name="pattern">
              <xsl:text>obj://</xsl:text>
            </xsl:variable>
            <xsl:variable name="poid_type_pattern" select="substring-after(@baseClassName, $pattern)"/>
            <xsl:variable name="place_holder_poid_type">
              <xsl:choose>
                <xsl:when test="contains($poid_type_pattern,'.')">
                  <xsl:value-of select="substring-before($poid_type_pattern, '.')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$poid_type_pattern"/>
                </xsl:otherwise>
              </xsl:choose>
	    </xsl:variable>
            <xsl:variable name="poid_type_for_file_name" select="concat($place_holder_poid_type,'.xsd')"/>
            <xsl:variable name="xs_include">
              <xsl:text>xsd:include</xsl:text>
            </xsl:variable>
            <xsl:element name="{$xs_include}">
              <xsl:attribute name="schemaLocation">
                <xsl:value-of select="$poid_type_for_file_name"/>
              </xsl:attribute>              
            </xsl:element>
            <!-- Add Scema reference to DD here -->
        </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Template to generate the input flist schema -->
  <xsl:template name="generate_input_schema">
    <xsl:param name="Opcode"/>
    <xsl:variable name="rootTag" select="concat($Opcode,'_inputFlist')"/>
    <xsd:element name="{$rootTag}">
      <xsd:complexType>
        <xsd:choice minOccurs="0" maxOccurs="unbounded">
          <xsl:call-template name="sort">
            <xsl:with-param name="Opcode" select="$Opcode"/>
          </xsl:call-template>
        </xsd:choice>
      </xsd:complexType>
    </xsd:element>
  </xsl:template>

  <!-- Template to generate the output flist schema -->
  <xsl:template name="generate_output_schema">
    <xsl:param name="Opcode"/>
    <xsl:variable name="rootTag" select="concat($Opcode,'_outputFlist')"/>
    <xsd:element name="{$rootTag}">
      <xsd:complexType>
        <xsd:choice minOccurs="0" maxOccurs="unbounded">
          <xsl:call-template name="sort">
            <xsl:with-param name="Opcode" select="$Opcode"/>
          </xsl:call-template>
        </xsd:choice>
      </xsd:complexType>
    </xsd:element>
  </xsl:template>

  <!-- Template to sort -->
  <xsl:template name="sort">
    <xsl:param name="Opcode"/>
    <xsl:for-each select="*">
      <xsl:sort select="@name"/>
      <xsl:choose>
        <xsl:when test="(name() = 'Poid')">
          <xsl:call-template name="process_poid"/>
        </xsl:when>
        <xsl:when test="(name() = 'Int') or (name() = 'String') or (name() = 'Decimal')">
          <xsl:call-template name="process_int_string_decimal">
            <xsl:with-param name="Opcode" select="$Opcode"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="(name() = 'Enum')">
          <xsl:call-template name="process_enum"/>
        </xsl:when>
        <xsl:when test="(name() = 'Array')">
          <xsl:call-template name="process_array">
            <xsl:with-param name="Opcode" select="$Opcode"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="(name() = 'Substruct')">
          <xsl:call-template name="process_substruct">          
            <xsl:with-param name="Opcode" select="$Opcode"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="(name() = 'Buf')">
          <xsl:call-template name="process_Buf">
            <xsl:with-param name="Opcode" select="$Opcode"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="(name() = 'Binstr')">
          <xsl:call-template name="process_Binstr_Tstamp"/>
        </xsl:when>
        <xsl:when test="(name() = 'Timestamp')">
          <xsl:call-template name="process_Binstr_Tstamp"/>
        </xsl:when> <!--      
        <xsl:when test="(name() = 'Any')">
          <xsl:call-template name="process_any"/>
        </xsl:when>-->
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Template to Process the POID type -->
  <xsl:template name="process_poid">
    <xsl:variable name="use">
      <xsl:choose>
        <xsl:when test="@use='required'">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="maxOccursValue">
      <xsl:text>1</xsl:text>
    </xsl:variable>
    <!-- Use short name in case of PORTAL fields and use as it is in case of 
         Custom Fields -->
    <xsl:variable name="fld_name">
      <xsl:choose>
        <xsl:when test="starts-with(@name,'PIN_FLD_')">
          <xsl:value-of select="substring-after(@name,'PIN_FLD_')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="simple_type">
      <xsl:text>xsd:simpleType</xsl:text>
    </xsl:variable>
    <xsl:variable name="restriction">
      <xsl:text>xsd:restriction</xsl:text>
    </xsl:variable>
    <xsl:variable name="pattern_type">
      <xsl:text>xsd:pattern</xsl:text>
    </xsl:variable>
      <xsl:variable name="element_name">
        <xsl:text>xsd:element</xsl:text>
      </xsl:variable>
      <xsl:variable name="data_type">
        <xsl:text>xsd:string</xsl:text>
      </xsl:variable>
      <xsl:variable name="pattern">
        <xsl:text>obj://</xsl:text>
      </xsl:variable>
      <xsl:element name="{$element_name}">
        <xsl:attribute name="name">
          <xsl:value-of select="$fld_name"/>
        </xsl:attribute><!--
        <xsl:attribute name="type">
          <xsl:value-of select="$data_type"/>
        </xsl:attribute>-->
        <xsl:attribute name="minOccurs">
          <xsl:value-of select="$use"/>
        </xsl:attribute>
        <xsl:attribute name="maxOccurs">
          <xsl:value-of select="$maxOccursValue"/>
        </xsl:attribute>
        <xsl:element name="{$simple_type}">
          <xsl:element name="{$restriction}">
            <xsl:attribute name="base">
              <xsl:value-of select="$data_type"/>
            </xsl:attribute>
            <xsl:for-each select="op:ClassRef">
              <xsl:variable name="poid_type_pattern"
                    select="substring-after(node(), $pattern)"/>
              <xsl:variable name="poid_place_holder" select="translate($poid_type_pattern, '.', '/')"/>
              <xsl:variable name="var">
              <xsl:choose>
                <xsl:when test="@mode='complete'">
                  <xsl:value-of select="concat('([0-9]*\.)+[0-9]*(\s)+(((/)*|(/)(', 
$poid_place_holder,')((/)*([a-zA-Z_]*))*))(\s)+[0-9]+(\s)+[0-9]*')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat('([0-9]*\.)+[0-9]*(\s)+(((/)*|(/)(', 
$poid_place_holder,')((/)*([a-zA-Z_]*))*))(\s)+[\-]*[0-9]+(\s)+[0-9]*')"/>
                </xsl:otherwise>
              </xsl:choose>
              </xsl:variable>
              <xsl:element name="{$pattern_type}">
                <xsl:attribute name="value">
                  <xsl:value-of select="$var"/>
                </xsl:attribute>
              </xsl:element>
              </xsl:for-each>
              <xsl:element name="{$pattern_type}">
                <xsl:attribute name="value">
                  <xsl:text></xsl:text>
                </xsl:attribute>
              </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
  </xsl:template>
  
  <!-- Template to Process the Int/String/Decimal -->
  <xsl:template name="process_int_string_decimal">
    <xsl:param name="Opcode"/>
    <xsl:variable name="element_name">
      <xsl:text>xsd:element</xsl:text>
    </xsl:variable>
    <xsl:variable name="maxLength_name">
      <xsl:text>xsd:maxLength</xsl:text>
    </xsl:variable>
    <xsl:variable name="simple_type">
      <xsl:text>xsd:simpleType</xsl:text>
    </xsl:variable>
    <xsl:variable name="restriction">
      <xsl:text>xsd:restriction</xsl:text>
    </xsl:variable>
    <xsl:variable name="data_type">
      <xsl:choose>
        <xsl:when test="(name() = 'Int')">
          <xsl:text>xsd:int</xsl:text>
        </xsl:when>
        <xsl:when test="(name() = 'Decimal')">
          <xsl:variable name="union_type">
            <xsl:text>UNION</xsl:text>_<xsl:value-of select="$Opcode"/>
          </xsl:variable>
          <xsl:value-of select="$union_type"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>xsd:string</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Use short name in case of PORTAL fields and use as it is in case of 
         Custom Fields -->
    <xsl:variable name="fld_name">
      <xsl:choose>
        <xsl:when test="starts-with(@name,'PIN_FLD_')">
          <xsl:value-of select="substring-after(@name,'PIN_FLD_')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="maxlen" select="@maxlen"/>
    <xsl:variable name="use">
      <xsl:choose>
        <xsl:when test="@use='required'">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$element_name}">
      <xsl:attribute name="name">
        <xsl:value-of select="$fld_name"/>
      </xsl:attribute>
      <xsl:if test="name()='Int' or name()='Decimal'">
      <xsl:attribute name="type">
        <xsl:value-of select="$data_type"/>
      </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="minOccurs">
        <xsl:value-of select="$use"/>
      </xsl:attribute>
      <xsl:attribute name="maxOccurs">
        <xsl:value-of select="1"/>
      </xsl:attribute>
      <xsl:if test="@maxlen">
        <xsl:element name="{$simple_type}">
          <xsl:element name="{$restriction}">
            <xsl:attribute name="base">
              <xsl:value-of select="$data_type"/>
            </xsl:attribute>
            <xsl:element name="{$maxLength_name}">
              <xsl:attribute name="value">
                <xsl:value-of select="$maxlen"/>
              </xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <!-- Template to Process the Enum type -->
  <xsl:template name="process_enum">
    <xsl:variable name="element_name">
      <xsl:text>xsd:element</xsl:text>
    </xsl:variable>
    <xsl:variable name="data_type">
      <xsl:text>xsd:string</xsl:text>
    </xsl:variable>
    <xsl:variable name="enum_type">
      <xsl:text>xsd:enumeration</xsl:text>
    </xsl:variable>
    <xsl:variable name="simple_type">
      <xsl:text>xsd:simpleType</xsl:text>
    </xsl:variable>
    <xsl:variable name="restriction">
      <xsl:text>xsd:restriction</xsl:text>
    </xsl:variable>
    <!-- Use short name in case of PORTAL fields and use as it is in case of 
         Custom Fields -->
    <xsl:variable name="fld_name">
      <xsl:choose>
        <xsl:when test="starts-with(@name,'PIN_FLD_')">
          <xsl:value-of select="substring-after(@name,'PIN_FLD_')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="use">
      <xsl:choose>
        <xsl:when test="@use='required'">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$element_name}">
      <xsl:attribute name="name">
        <xsl:value-of select="$fld_name"/>
      </xsl:attribute><!--
      <xsl:attribute name="type">
        <xsl:value-of select="$data_type"/>
      </xsl:attribute>-->
      <xsl:attribute name="minOccurs">
        <xsl:value-of select="$use"/>
      </xsl:attribute>
      <xsl:attribute name="maxOccurs">
        <xsl:value-of select="1"/>
      </xsl:attribute>
      <xsl:element name="{$simple_type}">
        <xsl:element name="{$restriction}">
          <xsl:attribute name="base">
            <xsl:value-of select="$data_type"/>
          </xsl:attribute>
          <xsl:for-each select="op:Values/op:Value">
            <xsl:element name="{$enum_type}">
              <xsl:attribute name="value">
                <xsl:value-of select="."/>
              </xsl:attribute>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- Template to Process the Array type -->
  <xsl:template name="process_array">
  <xsl:param name="Opcode"/>
    <xsl:variable name="use">
      <xsl:choose>
        <xsl:when test="@use='required'">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="element_name">
      <xsl:text>xsd:element</xsl:text>
    </xsl:variable>
    <!-- $fld_link refers back to the field details in the docs -->
    <xsl:variable name="fld_link">
      <xsl:number level="multiple" count="*" from="/"/>
    </xsl:variable>
    <!-- Use short name in case of PORTAL fields and use as it is in case of 
         Custom Fields -->
    <xsl:variable name="fld_name">
      <xsl:choose>
        <xsl:when test="starts-with(@name,'PIN_FLD_')">
          <xsl:value-of select="substring-after(@name,'PIN_FLD_')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="data_type">
      <xsl:value-of select="$fld_name"/>_<xsl:value-of select="translate(name(), 
		  'abcdefghijklmnopsqrtuvwxyz', 
		  'ABCDEFGHIJKLMNOPSQRTUVWXYZ')"/>_<xsl:value-of select="$Opcode"/>_<xsl:value-of select="$fld_link"/>
    </xsl:variable>
    <xsl:variable name="maxElements">
      <xsl:choose>
        <xsl:when test="@maxElements">
          <xsl:value-of select="@maxElements"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>unbounded</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$element_name}">
      <xsl:attribute name="name">
        <xsl:value-of select="$fld_name"/>
      </xsl:attribute>
      <xsl:attribute name="minOccurs">
        <xsl:value-of select="$use"/>
      </xsl:attribute>
      <xsl:attribute name="maxOccurs">
        <xsl:value-of select="$maxElements"/>
      </xsl:attribute>      
      <xsd:complexType>
        <xsd:complexContent>
            <xsd:extension base="{$data_type}">
                <xsd:attribute name="elem" type="xsd:string"/>
            </xsd:extension>
        </xsd:complexContent>
      </xsd:complexType><!--
      
      <xsl:attribute name="type">
        <xsl:value-of select="$data_type"/>
      </xsl:attribute>-->
    </xsl:element>
  </xsl:template>
  
  <!-- Template to generate complex type for Array types -->
  <xsl:template name="generate_array_types">
  <xsl:param name="Opcode"/>
  <xsl:param name="IOFlag"/>
    <xsl:for-each select="op:Array">
      <xsl:variable name="element_name">
        <xsl:text>xsd:element</xsl:text>
      </xsl:variable>
      <xsl:variable name="use">
        <xsl:choose>
          <xsl:when test="@use='required'">
            <xsl:text>1</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- Use short name in case of PORTAL fields and use as it is in case of 
           Custom Fields -->
      <xsl:variable name="fld_name">
        <xsl:choose>
	  <xsl:when test="starts-with(@name,'PIN_FLD_')">
	    <xsl:value-of select="substring-after(@name,'PIN_FLD_')"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@name"/>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- $fld_link refers back to the field details in the docs -->
      <xsl:variable name="fld_link">
        <xsl:number level="multiple" count="*" from="/"/>
      </xsl:variable>
      <xsl:variable name="type">
        <xsl:choose>
          <xsl:when test="(name() = 'Array') or (name() = 'Substruct')">
            <xsl:value-of select="$fld_name"/>_<xsl:value-of select="translate(name(), 
		  'abcdefghijklmnopsqrtuvwxyz', 
		  'ABCDEFGHIJKLMNOPSQRTUVWXYZ')"/>_<xsl:value-of select="$Opcode"/>_<xsl:value-of select="$fld_link"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate(@name, 
		  'abcdefghijklmnopsqrtuvwxyz', 
		  'ABCDEFGHIJKLMNOPSQRTUVWXYZ')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="./descendant::op:Fields">
          <xsd:complexType name="{$type}"><!--
            <xsd:complexContent>
              <xsd:extension> base="Array">-->
            <xsd:choice minOccurs="0" maxOccurs="unbounded">
              <xsl:for-each select="op:Fields">
                <xsl:call-template name="sort">
                  <xsl:with-param name="Opcode" select="$Opcode"/>
                </xsl:call-template>
              </xsl:for-each>
              <xsl:for-each select="op:Fields/op:Any">
                <xsl:choose>
                  <xsl:when test="($IOFlag = 'IN')">
                    <xsl:call-template name="process_any"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsd:any minOccurs="0" maxOccurs="unbounded"
                             namespace="http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes"
                             processContents="skip"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsd:choice>
            <!--
              </xsd:extension>
            </xsd:complexContent>-->
          </xsd:complexType>
          <xsl:for-each select="op:Fields">
            <xsl:call-template name="generate_array_types">
              <xsl:with-param name="Opcode" select="$Opcode"/>
              <xsl:with-param name="IOFlag" select="$IOFlag"/>
            </xsl:call-template>
            <xsl:call-template name="generate_substruct_types">
              <xsl:with-param name="Opcode" select="$Opcode"/>
              <xsl:with-param name="IOFlag" select="$IOFlag"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsd:complexType name="{$type}"><!--
            <xsd:complexContent>
              <xsd:extension base="Array">-->
               <xsd:choice minOccurs="0" maxOccurs="unbounded">
                <xsd:any minOccurs="0" maxOccurs="unbounded" namespace="http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes" processContents="skip"/>
                </xsd:choice><!--
              </xsd:extension>
            </xsd:complexContent>-->
          </xsd:complexType>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Template to Process the Substruct type -->
  <xsl:template name="process_substruct">
  <xsl:param name="Opcode"/>
    <xsl:variable name="use">
      <xsl:choose>
        <xsl:when test="@use='required'">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Use short name in case of PORTAL fields and use as it is in case of 
         Custom Fields -->
    <xsl:variable name="fld_name">
      <xsl:choose>
        <xsl:when test="starts-with(@name,'PIN_FLD_')">
          <xsl:value-of select="substring-after(@name,'PIN_FLD_')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="element_name">
      <xsl:text>xsd:element</xsl:text>
    </xsl:variable>
    <!-- $fld_link refers back to the field details in the docs -->
    <xsl:variable name="fld_link">
      <xsl:number level="multiple" count="*" from="/"/>
    </xsl:variable>  
           
    <xsl:variable name="data_type" >
      <xsl:choose>
        <xsl:when test="(@name = 'PIN_FLD_INHERITED_INFO' or @name= 'PIN_FLD_EXTENDED_INFO')">
          <xsl:choose>
            <xsl:when test="./descendant::op:Fields/op:Any">
              <xsl:for-each select="op:Fields">
                <xsl:for-each select="*">
                  <xsl:variable name="pattern">
                    <xsl:text>obj://</xsl:text>
                  </xsl:variable>
                  <xsl:variable name="poid_type_pattern" select="substring-after(@baseClassName, $pattern)"/>
                  <xsl:variable name="place_holder_poid_type" select="translate($poid_type_pattern, '.', '_')"/>
                  <xsl:value-of select="concat($place_holder_poid_type,'ExtensionType')"/>
                </xsl:for-each>               
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$fld_name"/>_<xsl:value-of select="translate(name(), 
		  'abcdefghijklmnopsqrtuvwxyz', 
		  'ABCDEFGHIJKLMNOPSQRTUVWXYZ')"/>_<xsl:value-of select="$Opcode"/>_<xsl:value-of select="$fld_link"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$fld_name"/>_<xsl:value-of select="translate(name(), 
		  'abcdefghijklmnopsqrtuvwxyz', 
		  'ABCDEFGHIJKLMNOPSQRTUVWXYZ')"/>_<xsl:value-of select="$Opcode"/>_<xsl:value-of select="$fld_link"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$element_name}">
      <xsl:attribute name="name">
        <xsl:value-of select="$fld_name"/>
      </xsl:attribute>
      <xsl:attribute name="type">
        <xsl:value-of select="$data_type"/>
      </xsl:attribute>
      <xsl:attribute name="minOccurs">
        <xsl:value-of select="$use"/>
      </xsl:attribute>
      <xsl:attribute name="maxOccurs">
        <xsl:text>1</xsl:text>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  
  <!-- Template to generate complex type for Substruct types -->
  <xsl:template name="generate_substruct_types">
  <xsl:param name="Opcode"/>
  <xsl:param name="IOFlag"/>
    <xsl:for-each select="op:Substruct">
     <xsl:if test="((not(@name = 'PIN_FLD_INHERITED_INFO')) or (not(@name= 'PIN_FLD_EXTENDED_INFO')))">
      <xsl:variable name="element_name">
        <xsl:text>xsd:element</xsl:text>
      </xsl:variable>
      <xsl:variable name="use">
        <xsl:choose>
          <xsl:when test="@use='required'">
            <xsl:text>1</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="maxElements">
        <xsl:value-of select="@maxElements"/>
      </xsl:variable>
      <xsl:variable name="idSignificant">
        <xsl:value-of select="@elemIdMode"/>
      </xsl:variable>
      <!-- Use short name in case of PORTAL fields and use as it is in case of 
           Custom Fields -->
      <xsl:variable name="fld_name">
        <xsl:choose>
          <xsl:when test="starts-with(@name,'PIN_FLD_')">
            <xsl:value-of select="substring-after(@name,'PIN_FLD_')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@name"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- $fld_link refers back to the field details in the docs -->
      <xsl:variable name="fld_link">
        <xsl:number level="multiple" count="*" from="/"/>
      </xsl:variable>
      <xsl:variable name="type">
        <xsl:choose>
          <xsl:when test="(name() = 'Array') or (name() = 'Substruct')">
            <xsl:value-of select="$fld_name"/>_<xsl:value-of select="translate(name(), 
		  'abcdefghijklmnopsqrtuvwxyz', 
		  'ABCDEFGHIJKLMNOPSQRTUVWXYZ')"/>_<xsl:value-of select="$Opcode"/>_<xsl:value-of select="$fld_link"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate(@name, 
		  'abcdefghijklmnopsqrtuvwxyz', 
		  'ABCDEFGHIJKLMNOPSQRTUVWXYZ')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
          <xsl:when test="./descendant::op:Fields">
            <xsd:complexType name="{$type}">
              <!--
            <xsd:complexContent>
              <xsd:extension> base="Substruct">-->
              <xsd:choice minOccurs="0" maxOccurs="unbounded">
                <xsl:for-each select="op:Fields">
                  <xsl:call-template name="sort">
                    <xsl:with-param name="Opcode" select="$Opcode"/>
                  </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="op:Fields/op:Any">
                  <xsl:choose>
                    <xsl:when test="($IOFlag='IN')">
                      <xsl:call-template name="process_any"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsd:any minOccurs="0" maxOccurs="unbounded"
                               namespace="http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes"
                               processContents="skip"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsd:choice>
              <!--
              </xsd:extension>
            </xsd:complexContent>-->
            </xsd:complexType>
            <xsl:for-each select="op:Fields">
              <xsl:call-template name="generate_array_types">
                <xsl:with-param name="Opcode" select="$Opcode"/>
                <xsl:with-param name="IOFlag" select="$IOFlag"/>
              </xsl:call-template>
              <xsl:call-template name="generate_substruct_types">
                <xsl:with-param name="Opcode" select="$Opcode"/>
                <xsl:with-param name="IOFlag" select="$IOFlag"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
          <xsd:complexType name="{$type}"><!-- Not Sure If this needs to be there in place
            <xsl:attribute name="minOccurs">
              <xsl:value-of select="$use"/>
            </xsl:attribute>
            <xsl:attribute name="maxOccurs">
              <xsl:value-of select="$maxElements"/>
            </xsl:attribute>
            <xsd:complexContent>
              <xsd:extension base="Substruct">-->
                <xsd:choice minOccurs="0" maxOccurs="unbounded">
                <xsd:any minOccurs="0" maxOccurs="unbounded" namespace="http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes" processContents="skip"/>
                </xsd:choice><!--
              </xsd:extension>
            </xsd:complexContent>-->
          </xsd:complexType>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Template to Process the Binstr/Buf/TimeStamp  -->
  <xsl:template name="process_Binstr_Tstamp">
    <xsl:variable name="element_name">
      <xsl:text>xsd:element</xsl:text>
    </xsl:variable>
    <xsl:variable name="maxLength_name">
      <xsl:text>xsd:maxLength</xsl:text>
    </xsl:variable>
    <xsl:variable name="simple_type">
      <xsl:text>xsd:simpleType</xsl:text>
    </xsl:variable>
    <xsl:variable name="pattern_type">
      <xsl:text>xsd:pattern</xsl:text>
    </xsl:variable>
    <xsl:variable name="restriction">
      <xsl:text>xsd:restriction</xsl:text>
    </xsl:variable>
    <xsl:variable name="data_type">
      <xsl:choose>
        <xsl:when test="(name() = 'Timestamp')">
          <xsl:text>xsd:dateTime</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>xsd:string</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Use short name in case of PORTAL fields and use as it is in case of 
         Custom Fields -->
    <xsl:variable name="fld_name">
      <xsl:choose>
        <xsl:when test="starts-with(@name,'PIN_FLD_')">
          <xsl:value-of select="substring-after(@name,'PIN_FLD_')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="maxlen" select="@maxlen"/>
    <xsl:variable name="use">
      <xsl:choose>
        <xsl:when test="@use='required'">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$element_name}">
      <xsl:attribute name="name">
        <xsl:value-of select="$fld_name"/>
      </xsl:attribute><!--
      <xsl:attribute name="type">
        <xsl:value-of select="$data_type"/>
      </xsl:attribute>-->
      <xsl:attribute name="minOccurs">
        <xsl:value-of select="$use"/>
      </xsl:attribute>
      <xsl:attribute name="maxOccurs">
        <xsl:value-of select="1"/>
      </xsl:attribute>
      <xsl:element name="{$simple_type}">
        <xsl:element name="{$restriction}">
          <xsl:attribute name="base">
            <xsl:value-of select="$data_type">
            </xsl:value-of>
          </xsl:attribute>
          <xsl:if test="@maxlen">
            <xsl:element name="{$maxLength_name}">
              <xsl:attribute name="value">
                <xsl:value-of select="$maxlen"/>
              </xsl:attribute>              
            </xsl:element>
          </xsl:if><!--
          <xsl:if test="(name() = 'Timestamp')">
            <xsl:element name="{$pattern_type}">
              <xsl:attribute name="value">
                <xsl:value-of select="'[0-9]+'"/>
              </xsl:attribute>
            </xsl:element>
          </xsl:if>-->
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>  
  
  <!-- Template to Process the Any type -->
  <xsl:template name="process_any">
    <xsl:variable name="use">
      <xsl:choose>
        <xsl:when test="@use='required'">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="element_name">
      <xsl:text>xsd:element</xsl:text>
    </xsl:variable><!--
    <xsl:variable name="fld_name">
      <xsl:value-of select="substring-after(@name,'PIN_FLD_')"/>
    </xsl:variable>-->
    <xsl:variable name="data_type">
      <xsl:variable name="pattern">
        <xsl:text>obj://</xsl:text>
      </xsl:variable>
      <xsl:variable name="poid_type_pattern" select="substring-after(@baseClassName, $pattern)"/>
      <xsl:variable name="place_holder_poid_type" select="translate($poid_type_pattern, '.', '_')"/>
      <xsl:value-of select="concat($place_holder_poid_type,'Extension')"/>
    </xsl:variable>
    <xsl:element name="{$element_name}"><!--
      <xsl:attribute name="name">
        <xsl:value-of select="@name"/>
      </xsl:attribute>-->
      <xsl:attribute name="ref">
        <xsl:value-of select="$data_type"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- Template to Process the Buf  -->
  <xsl:template name="process_Buf">
  <xsl:param name="Opcode"/>
    <xsl:variable name="element_name">
      <xsl:text>xsd:element</xsl:text>
    </xsl:variable>
    <xsl:variable name="data_type">
      <xsl:text>BUFFER</xsl:text>_<xsl:value-of select="$Opcode"/>
    </xsl:variable>
    <!-- Use short name in case of PORTAL fields and use as it is in case of 
         Custom Fields -->
    <xsl:variable name="fld_name">
      <xsl:choose>
        <xsl:when test="starts-with(@name,'PIN_FLD_')">
          <xsl:value-of select="substring-after(@name,'PIN_FLD_')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="use">
      <xsl:choose>
        <xsl:when test="@use='required'">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$element_name}">
      <xsl:attribute name="name">
        <xsl:value-of select="$fld_name"/>
      </xsl:attribute>
      <xsl:attribute name="minOccurs">
        <xsl:value-of select="$use"/>
      </xsl:attribute>
      <xsl:attribute name="maxOccurs">
        <xsl:value-of select="1"/>
      </xsl:attribute>
      <xsl:attribute name="type">
        <xsl:value-of select="$data_type"></xsl:value-of>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
 
  <!-- Template to generate the Buffer Base type --> 
  <xsl:template name="generate_buffer_type">
  <xsl:param name="Opcode"/>
    <xsl:variable name="buf_type">
      <xsl:text>BUFFER</xsl:text>_<xsl:value-of select="$Opcode"/>
    </xsl:variable>
    <xsd:complexType name="{$buf_type}">
      <xsd:simpleContent>
        <xsd:extension base="xsd:hexBinary">
          <xsd:attribute name="flags" type="xsd:string" use="optional"/>
          <xsd:attribute name="size" type="xsd:string" use="optional"/>
          <xsd:attribute name="offset" type="xsd:string" use="optional"/>
        </xsd:extension>
      </xsd:simpleContent>
    </xsd:complexType>
  </xsl:template>

  <!-- Template to generate the Union of Decimal and Empty Type -->
  <xsl:template name="generate_union_type">
    <xsl:param name="Opcode"/>
    <xsl:variable name="empty_type">
      <xsl:text>EMPTY</xsl:text>_<xsl:value-of select="$Opcode"/>
    </xsl:variable>
    <xsd:simpleType name="{$empty_type}">
      <xsd:restriction base="xsd:string">
        <xsd:length value="0"/>
      </xsd:restriction>
    </xsd:simpleType>
    <xsl:variable name="union_type">
      <xsl:text>UNION</xsl:text>_<xsl:value-of select="$Opcode"/>
    </xsl:variable>
    <xsd:simpleType name="{$union_type}">
      <xsd:union memberTypes="xsd:decimal {$empty_type}"/>
    </xsd:simpleType>
  </xsl:template>
</xsl:stylesheet>

 
  <!-- Template to generate the types -->
  <!-- This is not required now, keeping as place holder just in case we may need it-->
  <!--
  <xsl:template name="generate_types">
    <xsl:comment>Portal Types</xsl:comment>
    <xsd:complexType name="Array">
      <xsd:complexContent>
        <xsd:extension base="xsd:anyType">
          <xsd:attribute name="elem" use="required">
            <xsd:simpleType>
              <xsd:restriction base="xsd:int"/>
            </xsd:simpleType>
          </xsd:attribute>
        </xsd:extension>
      </xsd:complexContent>
    </xsd:complexType>
    <xsd:complexType name="Substruct">
      <xsd:complexContent>
        <xsd:extension base="xsd:anyType">
          <xsd:attribute name="elem" use="optional">
            <xsd:simpleType>
              <xsd:restriction base="xsd:int"/>
            </xsd:simpleType>
          </xsd:attribute>
        </xsd:extension>
      </xsd:complexContent>
    </xsd:complexType>
    <xsd:complexType name="BINSTR">
      <xsd:simpleContent>
        <xsd:extension base="xsd:string"></xsd:extension>
      </xsd:simpleContent>
    </xsd:complexType>
    <xsd:complexType name="BUF">
      <xsd:simpleContent>
        <xsd:extension base="xsd:string"></xsd:extension>
      </xsd:simpleContent>
    </xsd:complexType>
    <xsd:complexType name="DECIMAL">
      <xsd:simpleContent>
        <xsd:extension base="xsd:decimal"></xsd:extension>
      </xsd:simpleContent>
    </xsd:complexType>
    <xsd:complexType name="ENUM">
      <xsd:simpleContent>
        <xsd:extension base="xsd:int"></xsd:extension>
      </xsd:simpleContent>
    </xsd:complexType>
    <xsd:complexType name="INT">
      <xsd:simpleContent>
        <xsd:extension base="xsd:int"></xsd:extension>
      </xsd:simpleContent>
    </xsd:complexType>
    <xsd:complexType name="POID">
      <xsd:simpleContent>
        <xsd:extension base="xsd:string"></xsd:extension>
      </xsd:simpleContent>
    </xsd:complexType>
    <xsd:complexType name="STR">
      <xsd:simpleContent>
        <xsd:extension base="xsd:string"></xsd:extension>
      </xsd:simpleContent>
    </xsd:complexType>
    <xsd:complexType name="TSTAMP">
      <xsd:simpleContent>
        <xsd:extension base="xsd:string"></xsd:extension>
      </xsd:simpleContent>
    </xsd:complexType>
  </xsl:template>
  -->
