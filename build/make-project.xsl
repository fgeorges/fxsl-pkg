<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:files="http://expath.org/ns/file"
		xmlns:zip="http://expath.org/ns/zip"
		xmlns="http://expath.org/ns/pkg"
		version="2.0">

   <xsl:import href="http://expath.org/ns/file.xsl"/>
   <xsl:import href="http://expath.org/ns/zip.xsl"/>

   <xsl:output method="text"/>

   <!-- Must be applied to itself! (so the static base URI is the stylesheet) -->
   <xsl:variable name="project" as="xs:anyURI" select="resolve-uri('..', base-uri(.))"/>
   <xsl:variable name="build"   as="xs:anyURI" select="resolve-uri('build/', $project)"/>
   <xsl:variable name="xar"     as="xs:anyURI" select="resolve-uri('fxsl-1.0.xar', $build)"/>
   <xsl:variable name="src"     as="xs:anyURI" select="resolve-uri('src/', $project)"/>
   <xsl:variable name="src-f"   as="xs:anyURI" select="resolve-uri('f/', $src)"/>
   <xsl:variable name="files"   as="element(files:file)+" select="files:old-list($src-f)/*"/>

   <xsl:template match="/">
      <xsl:message>
         <xsl:text>Building project </xsl:text>
         <xsl:value-of select="$project"/>
      </xsl:message>
      <xsl:variable name="zip" as="element(zip:file)">
         <zip:file href="{ $xar }">
            <!-- the package descriptor -->
            <zip:entry name="expath-pkg.xml" method="xml" indent="yes">
               <xsl:call-template name="pkg"/>
            </zip:entry>
            <!-- the content of src/ is the package content -->
            <zip:dir name="fxsl">
               <zip:dir name="f">
                  <xsl:apply-templates select="$files" mode="src"/>
               </zip:dir>
            </zip:dir>
         </zip:file>
      </xsl:variable>
      <xsl:sequence select="zip:zip-file($zip)"/>
      <xsl:message>Generated XAR file build/fxsl-1.0.xar</xsl:message>
   </xsl:template>

   <xsl:template name="pkg">
      <package spec="1.0" abbrev="fxsl" version="1.0" name="http://fxsl.sf.net/">
         <title>FXSL for XSLT 2.0</title>
         <xsl:apply-templates select="$files" mode="pkg"/>
      </package>
   </xsl:template>

   <xsl:template match="files:file" mode="pkg">
      <xslt>
         <import-uri>
            <xsl:text>http://fxsl.sf.net/f/</xsl:text>
            <xsl:value-of select="@name"/>
         </import-uri>
         <file>
            <xsl:text>f/</xsl:text>
            <xsl:value-of select="@name"/>
         </file>
      </xslt>
   </xsl:template>

   <xsl:template match="files:file" mode="src">
      <zip:entry name="{ @name }" src="{ @href }"/>
   </xsl:template>

</xsl:stylesheet>
