<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
    <xsl:output method="text" disable-output-escaping="yes" encoding="utf-8"/>
    <xsl:template match="xml_api_reply">
        <xsl:apply-templates select="data"/>
    </xsl:template>

    <xsl:template match="data">
        <xsl:variable name="celsius"><xsl:text>C</xsl:text></xsl:variable>
        <xsl:for-each select="weather[position() >= 2 ]">
            <xsl:value-of select="tempMaxC"/> <xsl:value-of select="$celsius"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="tempMinC"/> <xsl:value-of select="$celsius"/>
            <xsl:if test="position() != 3">
                <xsl:text>         </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
