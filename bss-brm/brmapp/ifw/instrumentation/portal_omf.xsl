<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <!-- Revision date: 08/28/2006 -->
  
  <!-- Try to make the output look half decent -->
  <xsl:output method="html" indent="yes"/>
  
  <xsl:template match="InstrumentationProbe">
    <html>
      <head>
        <link REL="stylesheet" type="text/css" href="/cd.css" />
        <title>Oracle Communications Billing and Revenue Management (BRM) 7.5</title>
      </head>

      <body>
        <table border="0" cellspacing="2" width="100%">
          <tr align="left">
            <td colspan="2">
              <h1>Oracle Communications Billing and Revenue Management (BRM) 7.5</h1>
            </td>
            <td align="right">
              <img src="portal_omf.gif"></img>
            </td>
          </tr>   
        </table>
        <table border="0" cellspacing="2" width="53%"> 
          <tr>
            <td align="left">
              <b>Last Update Requested at:</b>
            </td>
            <td  align="left">
              <b><xsl:value-of select="LastUpdateTime"/></b>
            </td>
          </tr>
          <tr>
            <td align="left">
              <b>Status</b>
            </td>
            <td  align="left">
              <b style="color: green">Running</b>
            </td>
          </tr>
        </table>   
  
        <table border="1" cellspacing="4" width = "100%">
          <colgroup width="30%"/>
          <colgroup width="*"/>
          <thead>
            <th>
              Instrumented objects:
            </th>
            <th>
              <b><xsl:value-of select="Selected"/></b>
            </th>
          </thead>

          <tr>
            <td colspan="1" valign="top">
              <font face="Lucida Console" size="2">            
                <a href="/">Refresh</a><br/>
                <xsl:apply-templates select="RegisteredObjectList"/>
              </font>
            </td>
            <td colspan="1" valign="top">

            <!-- Display Instrumented Object data if exists -->
            <xsl:if test="InstrumentedObject">
              <xsl:apply-templates select="InstrumentedObject"/>
            </xsl:if>

            <!-- Display Message data if exists -->
            <xsl:if test="Message">
              <xsl:apply-templates select="Message"/>
            </xsl:if>

            </td>
          </tr>
        </table>

        <!-- Copyright info at footer -->
        <font face="Arial" size="1">
 Copyright (c) 1996, 2012, Oracle and/or its affiliates. All rights reserved. 
        </font>
      </body>
    </html>

  </xsl:template>

  <xsl:template match="RegisteredObjectList">
    <xsl:apply-templates select="RegisteredObject"/>
  </xsl:template>

  <xsl:template match="RegisteredObject">
    <xsl:param name="yes">Yes</xsl:param>
    <xsl:param name="no">No</xsl:param>
    <xsl:choose>
      <xsl:when test="IsInstrumented = $yes">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="Reference"/>
          </xsl:attribute>
          <xsl:value-of select="Name"/>
        </a><br/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="Name"/><br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="RegisteredObject"/>
  </xsl:template>

  <xsl:template match="InstrumentedObject">
    <!-- Display Attribute data if exists -->
    <xsl:if test="Attribute">
      <xsl:apply-templates select="Attribute"/>
    </xsl:if>

    <!-- Display Group data if exists -->
    <xsl:if test="Group">
      <xsl:apply-templates select="Group"/>
    </xsl:if>

    <!-- Display Table data if exists -->
    <xsl:if test="Table">
      <xsl:apply-templates select="Table"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Attribute">
    <b><xsl:value-of select="Description"/></b>: <xsl:value-of select="Value"/>&#x20;<xsl:value-of select="Unit"/><br/>
  </xsl:template>

  <xsl:template match="Group">
    <br/>
    <b><xsl:value-of select="Description"/>: </b><br/>
    <xsl:apply-templates select="AttributeList"/>
  </xsl:template>

  <xsl:template match="AttributeList">
    <table border="1">
      <xsl:for-each select="Attribute">
        <tr>
          <td><b><xsl:value-of select="Description"/></b></td>
          <td><xsl:value-of select="Value"/>&#x20;<xsl:value-of select="Unit"/></td>
         </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="Table">
    <br/>
    <b><xsl:value-of select="Description"/>: </b><br/>
    <xsl:apply-templates select="GroupList"/>
  </xsl:template>

  <xsl:template match="GroupList">
    <table border="1">
      <xsl:for-each select="Group">
        <!-- Display table header only once -->
        <xsl:variable name="count" select="position()"/>
          <xsl:choose>
            <xsl:when test="$count = 1">
              <tr>
                <!-- td><b>Name</b></td -->
                <xsl:for-each select="AttributeList/Attribute">
                  <td><b><xsl:value-of select="Description"/></b></td>
                </xsl:for-each>
              </tr>
            </xsl:when>
          </xsl:choose>

        <!-- Display table data from each Group -->
        <!-- here we assume has uniform format -->
        <!-- i.e. sharing the same header -->
        <tr>
          <!-- td><b><xsl:value-of select="Description"/></b></td -->
          <xsl:for-each select="AttributeList/Attribute">
            <td><pre><xsl:value-of select="Value"/>&#x20;<xsl:value-of select="Unit"/></pre></td>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="Message">
    <xsl:value-of select="Value"/><br/>
  </xsl:template>

</xsl:stylesheet>
