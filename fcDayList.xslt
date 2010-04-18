<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
    <xsl:output method="text" disable-output-escaping="yes" encoding="utf-8"/>
    <xsl:template match="xml_api_reply">
        <xsl:apply-templates select="weather"/>
    </xsl:template>

    <xsl:template match="weather">
        <xsl:for-each select="forecast_conditions/day_of_week">
            <!--            <xsl:value-of select="@data"/>
            <xsl:text>        </xsl:text>  -->
            <xsl:choose>
                <xsl:when test="position() = 1">
                    <xsl:text></xsl:text>
                </xsl:when>
                <xsl:when test="position() = 2">
                    <xsl:text>Tomorrow</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>          </xsl:text>
                    <xsl:value-of select="@data"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
