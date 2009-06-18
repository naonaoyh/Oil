<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
	
	<xsl:output method="xml" encoding="ISO-8859-1" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="/">
		<xsl:apply-templates select="xs:schema"/>
	</xsl:template>

	<xsl:template match="xs:schema">
		<xsl:copy-of select="node()"/>
	</xsl:template>
	
</xsl:stylesheet>
