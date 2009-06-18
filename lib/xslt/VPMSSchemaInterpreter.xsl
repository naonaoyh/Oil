<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
	<xsl:output method="xml" encoding="ISO-8859-1" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:key match="xs:element" name="allElements" use="@name"/>
	<xsl:key match="xs:element" name="prevElements" use="concat(../../../../../../../../../@name,../../../../../../@name,../../../@name,@name)"/>
	
	<xsl:template match="/">
		<xsl:call-template name="differentiateSchemaNodes">
			<xsl:with-param name="ns" select="xs:schema"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="differentiateSchemaNodes">
		<xsl:param name="ns"/>
		<xsl:for-each select="$ns/xs:element[count(. | key('allElements', @name)[1]) = 1]">
			<xsl:apply-templates select="." mode="organiseSchemaNode">
				<xsl:with-param name="ns" select="$ns"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*" mode="organiseSchemaNode">
		<xsl:param name="ns"/>
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:if test="count(xs:complexType/xs:sequence)">
				<xs:complexType>
					<xs:sequence>
					<xsl:call-template name="differentiateNodes">
						<xsl:with-param name="ns" select="$ns/xs:element/xs:complexType/xs:sequence"/>
					</xsl:call-template>
				</xs:sequence>
					</xs:complexType>
			</xsl:if>
		</xsl:copy>
	</xsl:template>	
	
	<xsl:template name="differentiateNodes">
		<xsl:param name="ns"/>
<!--
		nodes in differentiate nodes is: <xsl:value-of select="count($ns/xs:element)"/>
		nodeset in differentiate nodes is:
		<xsl:copy-of select="$ns"/>
		end nodeset
-->
		<xsl:for-each select="$ns/xs:element[count(. | key('allElements', @name)[1]) = 1]">
			<xsl:apply-templates select="." mode="organiseNode">
				<xsl:with-param name="ns" select="$ns"/>
				<xsl:with-param name="nn" select="@name"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*" mode="organiseNode">
		<xsl:param name="ns"/>
		<xsl:param name="nn"/>
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:if test="count(xs:complexType/xs:sequence)">
				<xs:complexType>
				<xs:sequence>
				<!-- each unique child do 
				<xsl:value-of select="count($ns/xs:element[@name=$nn])"/>
				<xsl:value-of select="count($ns/xs:element[@name=$nn]/xs:complexType/xs:sequence/xs:element[count(. | key('prevElements', concat(../../../../../../@name,../../../@name,@name))[1]) = 1])"/>
				-->
					
					<xsl:for-each select="$ns/xs:element[@name=$nn]/xs:complexType/xs:sequence/xs:element[count(. | key('prevElements', concat(../../../../../../../../../@name,../../../../../../@name,../../../@name,@name))[1]) = 1]">
					<xsl:apply-templates select="." mode="organiseNode">
						<xsl:with-param name="ns" select="$ns/xs:element[@name=$nn]/xs:complexType/xs:sequence"/>
						<xsl:with-param name="nn" select="@name"/>
						</xsl:apply-templates>
				</xsl:for-each>

					</xs:sequence>
				</xs:complexType>
			</xsl:if>
		</xsl:copy>
	</xsl:template>	

	<xsl:template match="xs:element" mode="trackPath"><xsl:value-of select="@name"/></xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
