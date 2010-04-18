<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
    <xsl:include href="conditionsInclude.xslt"/>
    <xsl:output method="text" disable-output-escaping="yes" encoding="utf-8"/>
    <xsl:template match="xml_api_reply">
        <xsl:apply-templates select="weather"/>
    </xsl:template>

    <xsl:template match="weather">
     <xsl:call-template name="get-condition-symbol">
        <xsl:with-param name="condition">
            <xsl:value-of select="current_conditions/condition/@data"/>
        </xsl:with-param>
     </xsl:call-template>

    </xsl:template>
</xsl:stylesheet>
