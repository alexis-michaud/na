<?xml version="1.0"  encoding="ISO-8859-1"?> 
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:oai_dc="http://purl.org/dc/elements/1.1/"
	xmlns:oai="http://www.openarchives.org/OAI/2.0/"
	xmlns:crdo="http://crdo.risc.cnrs.fr/schemas/"
	xmlns:h="http://www.w3.org/1999/xhtml"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"

	exclude-result-prefixes="xsi dcterms olac oai_dc oai"
	version="1.0">

	<xsl:output method="html" indent="yes"/>

	<xsl:variable name="exist_crdo" select="'http://crdo.risc.cnrs.fr/exist/crdo'"/>

<!-- ******************************************************** -->

<xsl:template match="/">
	<html>
		<head>
				<meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
				<meta http-equiv="Content-Language" content="fr" />
				<link href="http://crdo.risc.cnrs.fr/exist/crdo/styles/css/charteplus.css" type="text/css" rel="stylesheet"/>
				<link href="http://crdo.risc.cnrs.fr/exist/crdo/styles/css/common.css"     type="text/css" rel="stylesheet"/>
				<link href="http://crdo.risc.cnrs.fr/exist/crdo/styles/css/charte.css"     type="text/css" rel="stylesheet"/>

		</head>
		<body>
			<div>
				<h1>SOMMAIRE</h1>
				<xsl:for-each select="//crdo:item">
					<xsl:sort select="oai_dc:title"/>
					<div style="margin-left:20px">
						<a href="#{@crdo:id}"><xsl:value-of select="oai_dc:title"/></a>
					</div>
				</xsl:for-each>
			</div>
			<h1>LISTE DES RESSOURCES</h1>
			<xsl:apply-templates select="//crdo:item"/>
		</body>
	</html>
</xsl:template>


<xsl:template match="crdo:item">
	<h:div about="#texte" id="{@crdo:id}">
	<xsl:variable name="spec" select="crdo:spec"/>
		<h:table class="meta">
			<h:tr style="text-align:right; font-size:8pt">
				<h:td colspan="2">Identifiant OAI: oai:crdo.vjf.cnrs.fr:<xsl:value-of select="@crdo:id"/></h:td>
			</h:tr>
			<xsl:if test="@crdo:arkid">
				<h:tr style="text-align:right; font-size:8pt">
					<h:td colspan="2">Identifiant ARK: <xsl:value-of select="@crdo:arkid"/></h:td>
				</h:tr>
			</xsl:if>
			<h:tr style="text-align:right; font-size:8pt">
				<h:td colspan="2">Dernière modification: <xsl:value-of select="@crdo:datestamp"/></h:td>
			</h:tr>
			<xsl:if test="@crdo:version">
				<h:tr style="text-align:right; font-size:8pt">
					<h:td colspan="2">Version: <xsl:value-of select="@crdo:version"/></h:td>
				</h:tr>
			</xsl:if>
			<xsl:if test="@crdo:maj">
				<h:tr style="text-align:right; font-size:8pt">
					<h:td colspan="2">Mise à jour: <xsl:value-of select="@crdo:maj"/></h:td>
				</h:tr>
			</xsl:if>
			<xsl:call-template name="title"/>
			<xsl:call-template name="publisher"/>
			<xsl:call-template name="creator"/>
			<xsl:call-template name="contributor"/>
			<xsl:call-template name="description"/>
			<xsl:call-template name="coverage"/>
			<xsl:call-template name="date"/>
			<xsl:call-template name="source"/>
			<xsl:call-template name="type"/>
			<xsl:call-template name="subject"/>
			<xsl:call-template name="language"/>
			<xsl:call-template name="format"/>

			<xsl:call-template name="rights"/>
			<xsl:call-template name="identifier"/>
			<xsl:call-template name="relation"/>
		</h:table>
		<h:hr/>
	</h:div>
</xsl:template>

<!-- 
 ********************************************************
 *** General Description                              ***
 ********************************************************
 -->

<!--  normalement le titre est suppose unique mais on ne sais jamais
      Les titres alternatifs peuvent etre plusieurs dans des langues diverses -->
<xsl:template name="title">
	<xsl:if test="oai_dc:title">
		<h:tr>
			<h:td class="descripteur">Title:</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:title">
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
	<xsl:if test="dcterms:alternative">
		<h:tr>
			<h:td class="descripteur">Alternate Title(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="dcterms:alternative">
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>
<xsl:template name="publisher">
	<xsl:if test="oai_dc:publisher">
		<h:tr>
			<h:td class="descripteur">Publisher(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:publisher">
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>
<xsl:template name="creator">
	<xsl:if test="oai_dc:creator">
		<h:tr>
			<h:td class="descripteur">Creator(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:creator">
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>
<xsl:template name="personId">
	<xsl:param name="id" />
	<xsl:text> [</xsl:text>
		<xsl:for-each select="//contributor[@personId=$id]/*">
		<xsl:value-of select="local-name(.)"/>=<xsl:apply-templates select="."/><xsl:if test="position()!=last()">; </xsl:if>
	</xsl:for-each>
	<xsl:text>]</xsl:text>
</xsl:template>
<xsl:template name="contributor">
	<xsl:if test="oai_dc:contributor">
		<h:tr>
			<h:td class="descripteur">Contributor(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:contributor">
					<xsl:apply-templates select="."/>
					<xsl:if test="@personId">
						<xsl:call-template name="personId">
							<xsl:with-param name="id" select="@personId" />
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>
<!-- les descriptions peuvent aussi etre des abstract et des tableOfContents -->
<xsl:template name="description">
	<xsl:if test="(oai_dc:description) or (dcterms:abstract) or (dcterms:tableOfContents)">
		<h:tr>
			<h:td class="descripteur">Description(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:description|dcterms:abstract|dcterms:tableOfContents">
					<xsl:if test="not(local-name(.)='description')">[<xsl:value-of select="local-name(.)"/>] </xsl:if>
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>

<!-- les coverage peuvent aussi etre des spatial et des temporal -->
<xsl:template name="coverage">
	<xsl:if test="(oai_dc:coverage) or (dcterms:spatial) or (dcterms:temporal)">
		<h:tr>
			<h:td class="descripteur">Coverage:</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:coverage|dcterms:spatial|dcterms:temporal">
					<xsl:if test="not(local-name(.)='coverage')">[<xsl:value-of select="local-name(.)"/>] </xsl:if>
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()">; </xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>
<!-- les date peuvent aussi etre des modified available created dateAccepted dateCopyrighted dateSubmitted issued valid -->
<xsl:template name="date">
	<xsl:if test="(oai_dc:date) 
		or (dcterms:modified)
		or (dcterms:available)
		or (dcterms:created)
		or (dcterms:dateAccepted)
		or (dcterms:dateCopyrighted)
		or (dcterms:dateSubmitted)
		or (dcterms:issued)
		or (dcterms:valid)">
		<h:tr>
			<h:td class="descripteur">Date(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:date|dcterms:modified|dcterms:available|dcterms:created|dcterms:dateAccepted|dcterms:dateCopyrighted|dcterms:dateSubmitted|dcterms:issued|dcterms:valid">
					<xsl:value-of select="local-name(.)"/>: <xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>
<xsl:template name="source">
	<xsl:if test="oai_dc:source">
		<h:tr>
			<h:td class="descripteur">Source(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:source">
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>


<!-- 
 ********************************************************
 *** Linguistic or reccording Description             ***
 ********************************************************
 -->
<xsl:template name="type">
	<xsl:if test="oai_dc:type">
		<h:tr>
			<h:td class="descripteur">Type(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:type">
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>
<xsl:template name="subject">
	<xsl:if test="oai_dc:subject">
		<h:tr>
			<h:td class="descripteur">Subject(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:subject">
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>
<xsl:template name="language">
	<xsl:if test="oai_dc:language">
		<h:tr>
			<h:td class="descripteur">Language(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:language">
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()">, </xsl:if>
				</xsl:for-each>
				(for translations and/or glosses)
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>
<xsl:template name="format">
	<xsl:if test="(oai_dc:format) or (dcterms:extent) or (dcterms:medium)">
		<h:tr>
			<h:td class="descripteur">Format(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:format|dcterms:extent|dcterms:medium">
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>




<!-- 
 ********************************************************
 *** Access Description                               ***
 ********************************************************
 -->
<xsl:template name="rights">
   <xsl:if test="(oai_dc:rights) or (dcterms:accessRights) or (dcterms:license)">
       <h:tr>
           <h:td class="descripteur">Rights:</h:td>
           <h:td class="valeur">
               <xsl:for-each select="oai_dc:rights|dcterms:accessRights|dcterms:license">
                   <xsl:if test="(local-name(.)='accessRights') and (contains(.,'restricted'))">
                       <h:img src="/exist/crdo/img/lock.gif" alt="accès protégé"/>
                   </xsl:if>
                   <xsl:apply-templates select="."/>
                   <xsl:if test="position()!=last()"><h:br/></xsl:if>
               </xsl:for-each>
           </h:td>
           </h:tr>
   </xsl:if>
</xsl:template>  
<xsl:template name="identifier">
	<xsl:if test="(oai_dc:identifier) or (dcterms:bibliographicCitation) or (dcterms:identifier)">
		<h:tr>
			<h:td class="descripteur">Identifier:</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:identifier|dcterms:bibliographicCitation|dcterms:identifier">
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>
<xsl:template name="relation">
	<xsl:if test="(oai_dc:relation) 
		or (dcterms:conformsTo) 
		or (dcterms:hasFormat) 
		or (dcterms:isFormatOf) 
		or (dcterms:hasPart) 
		or (dcterms:hasVersion) 
		or (dcterms:isPartOf) 
		or (dcterms:isReferencedBy)
		or (dcterms:isReplacedBy)
		or (dcterms:isRequiredBy)
		or (dcterms:isVersionOf)
		or (dcterms:references)
		or (dcterms:replaces)
		or (dcterms:requires)">     
		<h:tr>
			<h:td class="descripteur">Relation(s):</h:td>
			<h:td class="valeur">
				<xsl:for-each select="oai_dc:relation|dcterms:conformsTo|dcterms:hasFormat|dcterms:isFormatOf|dcterms:hasPart|dcterms:hasVersion|dcterms:isPartOf|dcterms:isReferencedBy|dcterms:isReplacedBy|dcterms:isRequiredBy|dcterms:isVersionOf|dcterms:references|dcterms:replaces|dcterms:requires">
					<xsl:if test="not(local-name(.)='relation')">[<xsl:value-of select="local-name(.)"/>] </xsl:if>
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>


<!-- 
 ********************************************************
 *** Comments                                         ***
 ********************************************************
 -->
<xsl:template name="comments">
	<xsl:if test="(crdo:comment)">
		<h:tr><h:td class="rubrique" colspan="2">Comments:</h:td></h:tr>
		<h:tr>
			<h:td colspan="2" class="comment">
				<xsl:for-each select="crdo:comment"> 
					<xsl:apply-templates select="."/>
					<xsl:if test="position()!=last()"><h:br/></xsl:if>
				</xsl:for-each>
			</h:td>
		</h:tr>
	</xsl:if>
</xsl:template>

<!-- 
 ********************************************************
 *** encoding schemes                                 ***
 ********************************************************
-->
<xsl:template match="*">
	<xsl:if test="(@xml:lang) and not(@xml:lang='en')">[<xsl:value-of select="@xml:lang"/>] </xsl:if>
	<xsl:variable name="content"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
	<xsl:variable name="about">#texte</xsl:variable>
	<xsl:choose>
		<xsl:when test="@xsi:type='dcterms:DCMIType'">
			<h:span datatype="{@xsi:type}" property="{name()}"><xsl:value-of select="$content"/></h:span>
		</xsl:when>
		<xsl:when test="@xsi:type='dcterms:Point'">
			Point:<h:a target="_blank" href="{$exist_crdo}/googlemaps.xq?lg={ancestor::crdo:item/oai_dc:subject/text()}&amp;{translate($content,'; ','&amp;')}">

				<xsl:variable name="east1"><xsl:value-of select="substring-after($content,'east=')"/></xsl:variable>
				<xsl:variable name="east">
					<xsl:choose>
						<xsl:when test="contains($east1, ';')">
							<xsl:value-of select="substring-before($east1,';')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$east1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="north1"><xsl:value-of select="substring-after($content,'north=')"/></xsl:variable>
				<xsl:variable name="north">
					<xsl:choose>
						<xsl:when test="contains($north1, ';')">
							<xsl:value-of select="substring-before($north1,';')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$north1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<h:meta about="{$about}" property="geo:lat" content="{$north}"/>
				<h:meta about="{$about}" property="geo:long" content="{$east}"/>

				<xsl:value-of select="$content"/>
			</h:a>
		</xsl:when>
		<xsl:when test="@xsi:type='dcterms:TGN'">
			TGN:<h:a target="_blank" href="http://www.getty.edu/vow/TGNFullDisplay?find=*&amp;place=&amp;nation=&amp;prev_page=1&amp;english=Y&amp;subjectid={normalize-space(.)}">
				<h:span about="{$about}" datatype="{@xsi:type}" property="{name()}"><xsl:value-of select="$content"/></h:span>
			</h:a>
		</xsl:when>
		<xsl:when test="@xsi:type='dcterms:URI'">
			<xsl:choose>
				<xsl:when test="starts-with($content,'http://creativecommons.org')">
					This file is licensed under a 
					<h:a target="_blank" href="{$content}" rel="license">Creative Commons License
						<h:img src="http://creativecommons.org/images/public/somerights20.png" 
							alt="Creative Commons License"/>
					</h:a>
				</xsl:when>
				<xsl:when test="starts-with($content,'oai:crdo.vjf.cnrs.fr:')">
					<h:a href="{$exist_crdo}/meta/{substring-after($content,'oai:crdo.vjf.cnrs.fr:')}">
						<h:span about="{$about}" rel="{name()}" resource="{$content}"><xsl:value-of select="'oai:crdo.vjf.cnrs.fr:'"/><xsl:value-of select="substring-after($content,'oai:crdo.vjf.cnrs.fr:')"/></h:span>
					</h:a>
				</xsl:when>
				<xsl:when test="starts-with($content,$exist_crdo) and (ancestor-or-self::oai_dc:identifier)">
					<h:a target="_blank" href="{$content}">
						<h:span about="{$about}" rel="{name()}" resource="{$content}"><xsl:value-of select="$content"/></h:span>
					</h:a>
				</xsl:when>
				<xsl:when test="ancestor-or-self::dcterms:isFormatOf">
					<xsl:choose>
						<xsl:when test="contains($content,'.xhtml')">
							(<h:a about="{$about}" rel="{name()}" resource="{$content}" href="{$content}">html browsing</h:a>)
						</xsl:when>
						<xsl:when test="starts-with($content, 'http://video.rap.prd.fr/cnrs/risc/')">
							(<h:a about="{$about}" rel="{name()}" resource="{$content}" target="_blanck" href="{$content}">streaming-format</h:a>)
						</xsl:when>
						<xsl:otherwise>
							<h:a about="{$about}" rel="{name()}" resource="{$content}" target="_blanck" href="{$content}"><xsl:value-of select="$content"/></h:a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<h:a target="_blank" href="{$content}">
						<h:span about="{$about}" rel="{name()}" resource="{$content}"><xsl:value-of select="$content"/></h:span>
					</h:a>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="@xsi:type='dcterms:W3CDTF'">
			<h:span property="{name()}" datatype="{@xsi:type}"><xsl:value-of select="$content"/></h:span>
		</xsl:when>
		<!-- aujourd'hui on n'a que audio/mpeg audio/x-wav application/pdf text/xml -->
		<xsl:when test="@xsi:type='dcterms:IMT'">
			(IANA MIME Media Type: <h:a target="_blank" href="http://www.iana.org/assignments/media-types/{substring-before($content, '/')}">
				<h:span about="{$about}" datatype="{@xsi:type}" property="{name()}"><xsl:value-of select="$content"/></h:span>
			</h:a>)
		</xsl:when>
		<xsl:when test="local-name()='extent'">
			duration: <h:span datatype="xsd:duration" property="{name()}" content="{$content}"><xsl:value-of select="translate($content, 'PTMS', '0::')"/></h:span>
		</xsl:when>
		<xsl:when test="(local-name()='subject') and (.='')"/>
		<xsl:when test="local-name()='type'"/>
		<xsl:otherwise>
			<h:span property="{name()}" xml:lang="{@xml:lang}"><xsl:value-of select="$content"/></h:span>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="@xsi:type='olac:language'">
			<xsl:choose>
				<xsl:when test="string-length(@olac:code) = 3">
					(Ethnologue: <h:a target="_blank" href="http://www.sil.org/iso639-3/documentation.asp?id={@olac:code}">
						<h:span about="{$about}" datatype="olac:ISO639" property="{name()}"><xsl:value-of select="@olac:code"/></h:span>
					</h:a>)
				</xsl:when>
				<xsl:otherwise>
					(iso639: <h:a target="_blank" href="http://www.ethnologue.com/14/show_iso639.asp?code={@olac:code}">
						<h:span about="{$about}" datatype="olac:ISO639" property="{name()}"><xsl:value-of select="@olac:code"/></h:span>
					</h:a>)
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="@xsi:type='olac:discourse-type'">
			<h:a target="_blank" href="http://www.language-archives.org/REC/discourse.html#{@olac:code}"> (<h:span about="{$about}" datatype="olac:olac-discourse-type" property="{name()}"><xsl:value-of select="@olac:code"/></h:span>)</h:a>
		</xsl:when>
		<xsl:when test="@xsi:type='olac:role'"> 
			<h:a target="_blank" href="http://www.language-archives.org/REC/role.html#{@olac:code}"> (<xsl:value-of select="@olac:code"/>)</h:a>
		</xsl:when>
		<xsl:when test="@xsi:type='olac:linguistic-field'">
			<h:a target="_blank" href="http://www.language-archives.org/REC/field.html#{@olac:code}"> (<h:span about="{$about}" datatype="olac:olac-linguistic-field" property="{name()}"><xsl:value-of select="@olac:code"/></h:span>)</h:a>
		</xsl:when>
		<xsl:when test="@xsi:type='olac:linguistic-type'">
			<h:a target="_blank" href="http://www.language-archives.org/REC/type.html#{@olac:code}"> (<h:span about="{$about}" datatype="olac:olac-linguistic-type" property="{name()}"><xsl:value-of select="@olac:code"/></h:span>)</h:a>
		</xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
