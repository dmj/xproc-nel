<p:declare-step version="1.0"
		xmlns:pica="info:srw/schema/5/picaXML-v1.0"
		xmlns:c="http://www.w3.org/ns/xproc-step"
		xmlns:p="http://www.w3.org/ns/xproc">

  <p:serialization port="html" method="html" version="4.0"/>

  <p:option name="nea"      required="true"/>
  <p:option name="nel"      required="true"/>
  <p:option name="timespan" required="true"/>

  <p:output port="html" primary="true" sequence="false"/>

  <p:variable name="sruUri" select="'http://sru.gbv.de/opac-de-23'"/>
  <p:variable name="sruParams" select="'operation=searchRetrieve&amp;maximumRecords=1000&amp;recordSchema=picaxml'"/>
  <p:variable name="sruQuery" select="concat('pica.nea=&quot;', $nea, '&quot; and pica.nel=&quot;', $nel, '&quot;')"/>

  <p:load>
    <p:with-option name="href" select="concat($sruUri, '?', $sruParams, '&amp;query=', encode-for-uri($sruQuery))"/>
  </p:load>

  <p:viewport name="make-mods" match="pica:record">
    <p:xslt>
      <p:input port="stylesheet">
	<p:document href="pica2mods/src/xslt/pica2mods.xsl"/>
      </p:input>
      <p:input port="parameters">
	<p:empty/>
      </p:input>
    </p:xslt>
  </p:viewport>

  <p:xslt name="make-html">
    <p:with-param name="timespan" select="$timespan"/>
    <p:input port="source">
      <p:pipe step="make-mods" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="nel.xsl"/>
    </p:input>
  </p:xslt>

  <p:xslt name="make-xsl">
    <p:input port="source">
      <p:pipe step="make-mods" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="nelfo.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>

  <p:xsl-formatter name="fo2pdf" href="public/sddlist.pdf" content-type="application/pdf">
    <p:input port="source">
      <p:pipe step="make-xsl" port="result"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xsl-formatter>

</p:declare-step>
