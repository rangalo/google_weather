<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
    <xsl:include href="conditionsInclude.xslt"/>
    <xsl:output method="text" disable-output-escaping="yes" encoding="utf-8"/>
    <xsl:template match="weather">
        <xsl:apply-templates select="dayf"/>
    </xsl:template>

    <xsl:template match="dayf">
        <xsl:for-each select="//day[@d>0]">
            <xsl:choose>
                <xsl:when test="@d = 1">
                    <xsl:text>Tomorrow: </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@t"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>: </xsl:text>
            <xsl:text>Day:</xsl:text>
            <xsl:call-template name="get-condition-symbol">
                <xsl:with-param name="condition">
                    <xsl:value-of select="part[@p='d']/t"/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:text>     </xsl:text>
            <xsl:text>Night:</xsl:text>
            <xsl:call-template name="get-condition-symbol">
                <xsl:with-param name="condition">
                    <xsl:value-of select="part[@p='n']/t"/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
