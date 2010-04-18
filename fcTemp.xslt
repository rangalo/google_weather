<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
    <xsl:output method="text" disable-output-escaping="yes" encoding="utf-8"/>
    <xsl:template match="xml_api_reply">
        <xsl:apply-templates select="weather"/>
    </xsl:template>

    <xsl:template match="weather">
        <xsl:variable name="unit_system" select="forecast_information/unit_system/@data" />
        <xsl:variable name="celsius"><xsl:text>C</xsl:text></xsl:variable>
        <xsl:for-each select="forecast_conditions[position() >= 2 ]">
            <xsl:choose>
                <xsl:when test="$unit_system != 'SI'" >
                    <xsl:value-of select="round(((number(low/@data) - 32) * 5) div  9) "/> <xsl:value-of select="$celsius"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="round(((number(high/@data) - 32) * 5) div  9) "/> <xsl:value-of select="$celsius"/>
                </xsl:when>
                <xsl:otherwise>
                   <xsl:value-of select="low/@data"/> <xsl:value-of select="$celsius"/>
                   <xsl:text>/</xsl:text>
                   <xsl:value-of select="high/@data"/> <xsl:value-of select="$celsius"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="position() != 3">
                <xsl:text>         </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
