<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:exslt="http://exslt.org/common" xmlns:regexp="http://exslt.org/regular-expressions">
    <xsl:output method="text" encoding="utf-8" indent="yes"/>
    
    <xsl:variable name="languev">nru</xsl:variable>
    <xsl:variable name="langue1">cmn</xsl:variable>
    <xsl:variable name="langue2">fra</xsl:variable>
    <xsl:variable name="langue3">eng</xsl:variable>
    
    <xsl:variable name="nombres" select="'0123456789'"/>
    <xsl:variable name="indices" select="'₀₁₂₃₄₅₆₇₈₉'"/>

    <xsl:variable name="couleurfra">OliveGreen</xsl:variable>
    <xsl:variable name="couleureng">Sepia</xsl:variable>
    <xsl:variable name="couleurcmn">black</xsl:variable>
    <xsl:variable name="couleurnru">Blue</xsl:variable>
    <xsl:variable name="couleurbod">black</xsl:variable>
    <!--<xsl:variable name="fra">black</xsl:variable>-->
    <!--<xsl:variable name="eng">black</xsl:variable>-->
    <!--<xsl:variable name="cmn">black</xsl:variable>-->
    <!--<xsl:variable name="nru">black</xsl:variable>-->
    <!--<xsl:variable name="bod">black</xsl:variable>-->

    <xsl:variable name="langues">
        <langue><xsl:value-of select="$languev"/></langue>
        <langue><xsl:value-of select="$langue1"/></langue>
        <langue><xsl:value-of select="$langue2"/></langue>
        <langue><xsl:value-of select="$langue3"/></langue>
    </xsl:variable>   
             
    <xsl:template match="RessourceLexicale">
        \documentclass[twoside,11pt]{article}
        \title{�titre}
        \author{�auteur}
        \usepackage[paperwidth=185mm,paperheight=260mm,top=16mm,bottom=16mm,left=15mm,right=20mm]{geometry}
        \usepackage{multicol}
        \setlength{\columnseprule}{1pt}
        \setlength{\columnsep}{1.5cm}
        \usepackage{changepage}
        \usepackage[dvipsnames,table]{xcolor}
        \usepackage{fancyhdr}
        \pagestyle{fancy}
        \fancyheadoffset{3.4em}
        \fancyhead[LE,LO]{\rightmark}
        \fancyhead[RE,RO]{\leftmark}
        \usepackage{hyperref}
        \hypersetup{pdftex,bookmarks=true,bookmarksnumbered,bookmarksopenlevel=5,bookmarksdepth=5,xetex,colorlinks=true,linkcolor=blue,citecolor=blue}
        \usepackage[all]{hypcap}
        \usepackage{fontspec}
        \usepackage{natbib}
        \usepackage{booktabs}
        \usepackage{polyglossia}
        \setdefaultlanguage{english}
        \setotherlanguages{french,english}
        \setmainfont{Charis SIL}
        \usepackage{media9}
        \usepackage{totcount}
        \newcounter{compteur}
        \setcounter{compteur}{0}
        \regtotcounter{compteur}
        \newfontfamily{\prin}[Mapping=tex-text,Ligatures=Common,Scale=MatchUppercase]{Gentium}
        \newfontfamily{\nru}[Mapping=tex-text,Ligatures=Common,Scale=MatchUppercase]{Charis SIL}
        \newfontfamily{\fra}[Mapping=tex-text,Ligatures=Common,Scale=MatchUppercase]{EB Garamond}
        \newfontfamily{\cmn}[Mapping=tex-text,Ligatures=Common,Scale=MatchUppercase]{AR PL UMing CN}
		<!--\newfontfamily{\eng}[Mapping=tex-text,Ligatures=Common,Scale=MatchUppercase]{Liberation Serif}-->
		\newfontfamily{\eng}[Mapping=tex-text,Ligatures=Common,Scale=MatchUppercase]{Calibri}
        \newfontfamily{\bod}[Mapping=tex-text,Ligatures=Common,Scale=MatchUppercase]{Gentium}
        \newcommand{\pprin}[1]{\begin{<xsl:value-of select="$langue1"/>}{\prin #1}\end{<xsl:value-of select="$langue1"/>}}
        \newcommand{\pnru}[1]{{\nru\textcolor{<xsl:value-of select="$couleurnru"/>}{#1}}}
        \newcommand{\pfra}[1]{\begin{french}{\fra\textcolor{<xsl:value-of select="$couleurfra"/>}{#1}}\end{french}}
        \newcommand{\pcmn}[1]{{\cmn\textcolor{<xsl:value-of select="$couleurcmn"/>}{#1}}}
        \newcommand{\peng}[1]{\begin{english}{\eng\textcolor{<xsl:value-of select="$couleureng"/>}{#1}}\end{english}}
        \newcommand{\pbod}[1]{{\bod\textcolor{<xsl:value-of select="$couleurbod"/>}{#1}}}
        \newcommand{\cerclé}[1]{\raisebox{0pt}{\textcircled{\raisebox{-0.5pt} {\footnotesize{\pnru{#1}}}}}}
        \newcommand{\caractère}[1]{\phantomsection\addcontentsline{toc}{section}{#1}{\begin{center}\textbf{\Large\pnru{#1}}\end{center}}}
        \newenvironment{entrée}[3]{\hypertarget{#3}{}\phantomsection\addcontentsline{toc}{subsection}{#1\homonyme{#2}}\hspace*{-0.5cm}\textbf{\Large\pnru{#1 \homonyme{#2}}}\markright{#1 \homonyme{#2}}}{\stepcounter{compteur}\newline}
        \newenvironment{sous-entrée}[3]{\par\hypertarget{#3}{}\phantomsection\addcontentsline{toc}{subsubsection}{#1 \homonyme{#2}}\begin{adjustwidth}{0.3cm}{}\pprin{■} \textbf{\Large\pnru{#1\homonyme{#2}}}}{\end{adjustwidth}}
        \newcommand{\homonyme}[1]{#1}
        \newcommand{\formedesurface}[1]{\hspace{0.5cm}/\pnru{#1}/\hspace{0.5cm}}
        \newcommand{\orthographe}[1]{\hspace{0.5cm}\pprin{#1}\hspace{0.5cm}}
        \newcommand{\formephonétique}[1]{\pnru{\textit{#1}}}
        \newcommand{\ton}[1]{\peng{Tone:~}\prin{#1}\hspace{0.5cm}}
        \newcommand{\classe}[1]{\peng{\textcolor{OliveGreen}{\textsc{#1}}}}
        \newcommand{\usage}[1]{\peng{#1}}
        \newcommand{\commentaire}[1]{\peng{({#1})}}
        \newcommand{\paradigme}[2]{\peng{#1}\pnru{#2}}
        \newcommand{\relationsémantique}[2]{\peng{#1}\pnru{#2}}
        \newcommand{\sens}[1]{ \cerclé{#1} }
        \newenvironment{définition}{}{\hspace{5pt}}
        \newenvironment{déclaration}{}{}
        \newenvironment{exemple}{\pprin{¶} }{\hspace{5pt}}        
        \newenvironment{forme-mot}{}{}
        \newcommand{\étiquette}[1]{\peng{~Synonym:~\pnru{#1}}}
        \newcommand{\synonyme}[1]{\peng{~Synonym:~\pnru{#1}}}
        \newcommand{\antonyme}[1]{\peng{~Antonym:~\pnru{#1}}}
        \newcommand{\confer}[1]{\peng{~See:~\pnru{#1}}}
        \newcommand{\emprunt}[1]{\peng{~Loanword:~#1}}
        \newcommand{\étymologie}[1]{\peng{~Etymology:~\pnru{#1}}}
        \newcommand{\utilisation}[1]{\peng{~Usage: #1}}
        \newcommand{\grammaire}[1]{\textsc{#1}}
        \newcommand{\lien}[2]{\hyperlink{#1}{\pnru{#2}}}
        \newcommand{\stylefv}[1]{\pnru{#1}}
        \newcommand{\stylefn}[1]{\pcmn{#1}}
        \newcommand{\stylefi}[1]{\textit{#1}}
        \newcommand{\stylefg}[1]{\textsc{#1}}
        \XeTeXlinebreaklocale "zh"
        \XeTeXlinebreakskip = 0pt plus 1pt
        \ExplSyntaxOn
        % Code spécial pour la gestion générique des césures applicable aux formes de surface
        \RenewDocumentCommand{\formedesurface}{m}
        {
            % nouvelle variable « expression »
            \tl_set:Nn \expression { #1 }
            % remplace ˩˧˥ par ˩˧˥\-
            \regex_replace_all:nnN { (\B[˩˧˥]) } { \1\c{-} } \expression
            % renvoie la séquence totale
            {\tl_use: {\hspace{0.5cm}/\pnru{\expression}/\hspace{0.5cm}}}
        }
        \ExplSyntaxOff
        <xsl:text>&#xd;</xsl:text>
        \begin{document}
        �introduction
        \pagenumbering{arabic}
        \setcounter{page}{1}
        \setlength{\parindent}{0pt}
        \begin{multicols}{2}
        \lhead{\firstmark}
        \rhead{\botmark}
        <xsl:apply-templates/>
        \end{multicols}
        \end{document}
    </xsl:template>
    
    <xsl:template match="InformationsGlobales">
    </xsl:template>

    <xsl:template name="lettrine">
    </xsl:template>
        
    <xsl:template name="index">
    </xsl:template>

    <xsl:template match="Dictionnaire">
        <xsl:for-each select="EntréeLexicale">
            <xsl:variable name="caractère" select="substring(translate(Lemme/FormeÉcrite, '_^-‐‑*=', ''), 1, 1)"/>
            <xsl:if test="$caractère != substring(translate(preceding-sibling::EntréeLexicale[1]/Lemme/FormeÉcrite, '_^-‐‑*=', ''), 1, 1)">
                <xsl:text>\newpage</xsl:text>
                <xsl:text>\caractère{</xsl:text>
                <xsl:value-of select="$caractère"/>
                <xsl:text>}</xsl:text>
                <xsl:text>&#xa;&#xd;</xsl:text>
            </xsl:if>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
      
    </xsl:template>

    <xsl:template match="EntréeLexicale">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\begin{entrée}</xsl:text>
        <xsl:text>{</xsl:text>
            <xsl:apply-templates select="Lemme/FormeÉcrite"/>
        <xsl:text>}{</xsl:text>
        <xsl:if test="NuméroDHomonyme">                        
            <xsl:apply-templates select="NuméroDHomonyme"/>
        </xsl:if>
        <xsl:text>}{</xsl:text>
        <xsl:value-of select="@identifiant"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="Lemme/FormeDeSurface">                        
            <xsl:apply-templates select="Lemme/FormeDeSurface"/>
        </xsl:if>
        <xsl:if test="Lemme/FormePhonétique">                        
            <xsl:apply-templates select="Lemme/FormePhonétique"/>
        </xsl:if>
        <xsl:if test="Lemme/Orthographe">                        
            <xsl:apply-templates select="Lemme/Orthographe"/>
        </xsl:if>
        <xsl:text>\newline</xsl:text>
        <xsl:if test="ClasseGrammaticale">                   
            <xsl:apply-templates select="ClasseGrammaticale"/>
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        <xsl:if test="Lemme/Ton">
            <xsl:apply-templates select="Lemme/Ton"/>
        </xsl:if>
        <xsl:if test="ÉtiquetteDUsage">                   
            <xsl:apply-templates select="ÉtiquetteDUsage"/>
        </xsl:if>
        <xsl:apply-templates select="Sens"/>
        <xsl:apply-templates select="Paradigme"/>
        <xsl:apply-templates select="Étymologie"/>
        <xsl:text>\end{entrée}</xsl:text>
        <xsl:text>&#xa;&#xd;</xsl:text>
    </xsl:template>

    <xsl:template match="NuméroDHomonyme">
        <xsl:value-of select="translate(., $nombres, $indices)"/>
    </xsl:template>
    
    <xsl:template match="FormeDeSurface">
        <xsl:text>\formedesurface{</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="Orthographe">
        <xsl:text>\orthographe{</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>}</xsl:text>
    </xsl:template>
            
    <xsl:template match="ClasseGrammaticale">
        <xsl:text>&#10;\classe{</xsl:text>
        <xsl:call-template name="traduction">
            <xsl:with-param name="expression" select="."/>
        </xsl:call-template>
        <xsl:text>}</xsl:text>
    </xsl:template>
        
    <xsl:template match="Ton">
        <xsl:text>\ton{</xsl:text>
        <xsl:call-template name="remplacer_grec">
            <xsl:with-param name="expression" select="."/>
        </xsl:call-template>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="ÉtiquetteDUsage">
        <xsl:text>&#10;\usage{</xsl:text>
        <xsl:call-template name="traduction">
            <xsl:with-param name="expression" select="."/>
        </xsl:call-template>
        <xsl:text>}</xsl:text>
    </xsl:template>
                    
    <xsl:template match="Sens">
        <xsl:if test="NuméroDeSens">
            <xsl:apply-templates select="NuméroDeSens"/>
        </xsl:if>
        <xsl:apply-templates select="Définition"/>
        <xsl:apply-templates select="Exemple"/>
        <xsl:apply-templates select="RelationSémantique"/>
        <xsl:apply-templates select="Paradigme"/>
    </xsl:template>
       
    <xsl:template match="NuméroDeSens"> 
        <xsl:text>\sens{</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>}</xsl:text>
    </xsl:template>
        
    <xsl:template match="Définition">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\begin{définition}</xsl:text>
        <xsl:text>\p</xsl:text>
        <xsl:value-of select="ReprésentationDeTexte/@langue"/>
        <xsl:text>{</xsl:text>
        <xsl:apply-templates select="ReprésentationDeTexte"/>
        <xsl:text>}</xsl:text>
        <xsl:apply-templates select="Déclaration"/>
        <xsl:text>\end{définition}</xsl:text>
    </xsl:template>
        
    <xsl:template match="Exemple">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\begin{exemple}</xsl:text>
        <xsl:if test="CommentaireDExemple">
            <xsl:apply-templates select="CommentaireDExemple"/>
        </xsl:if>
        <xsl:for-each select="ReprésentationDeTexte">
            <xsl:text>\p</xsl:text>
            <xsl:value-of select="@langue"/>
            <xsl:text>{</xsl:text>
            <xsl:apply-templates select="."/>
            <xsl:text>}</xsl:text>
            <xsl:if test="not(position() = last())">
                <xsl:text>\hspace{5pt}</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>\end{exemple}</xsl:text>        
    </xsl:template>
    
    <xsl:template match="CommentaireDExemple">
        <xsl:if test=". = 'PHONO' or . = 'PROVERBE'">
            <xsl:text>\commentaire{</xsl:text> 
            <xsl:call-template name="traduction">
                <xsl:with-param name="expression" select="."/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
        </xsl:if>
    </xsl:template>
        
    <xsl:template match="Paradigme">
        <xsl:text>\paradigme{</xsl:text> 
        <xsl:call-template name="traduction">
            <xsl:with-param name="expression" select="CatégorieParadigmatique"/>
        </xsl:call-template>
        <xsl:text>}{</xsl:text>
            <xsl:value-of select="ReprésentationDeForme"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
            
    <xsl:template match="RelationSémantique">
        <xsl:text>\relationsémantique{</xsl:text>
        <xsl:call-template name="traduction">
            <xsl:with-param name="expression" select="Type"/>
        </xsl:call-template>
        <xsl:text>}{\lien{</xsl:text>
        <xsl:value-of select="Cible/@cible"/>
        <xsl:text>}{</xsl:text>
        <xsl:value-of select="translate(Cible, $nombres, $indices)"/>
        <xsl:text>}}</xsl:text>
    </xsl:template>
    
    <xsl:template match="Étymologie">
        <xsl:text>\étymologie{</xsl:text> 
            <xsl:apply-templates select="Étymon"/>
        <xsl:text>}</xsl:text> 
    </xsl:template>

    <xsl:template match="Étymon">
        <xsl:apply-templates select="FormeÉcrite"/>
    </xsl:template>

    <xsl:template match="FormeÉcrite">
        <xsl:call-template name="remplacer_grec">
            <xsl:with-param name="expression" select="."/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="remplacer_grec">
        <xsl:param name="expression"/>
        <xsl:value-of select="regexp:replace(regexp:replace(regexp:replace($expression, 'α', 'g', '\\textsubscript{a}'), 'β', 'g', '\\textsubscript{b}'), 'γ', 'g', '\\textsubscript{c}')"/>
    </xsl:template>
    
    <xsl:template match="lien">
        <xsl:text>\lien{</xsl:text>
        <xsl:value-of select="@cible|@target"/>
        <xsl:text>}{</xsl:text>
        <xsl:value-of select="translate(., $nombres, $indices)"/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="style">
        <xsl:text>\style</xsl:text>
        <xsl:value-of select="@type"/>
        <xsl:text>{</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>}</xsl:text>
    </xsl:template>
        
    <xsl:template name="traduction">
        <xsl:param name="expression"/>
        <xsl:choose>
            <xsl:when test="$expression='adj'">
                <xsl:text>adjective</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='adv'">
                <xsl:text>adverb</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='clf'">
                <xsl:text>classifier</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='clitic'">
                <xsl:text>clitic</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='cnj'">
                <xsl:text>conjunction</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='disc.PTCL'">
                <xsl:text>discourse particle</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='ideophone'">
                <xsl:text>ideophone</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='intj'">
                <xsl:text>interjection</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='lnk'">
                <xsl:text>linker</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='n'">
                <xsl:text>noun</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='neg'">
                <xsl:text>negation</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='num'">
                <xsl:text>numeral</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='post'">
                <xsl:text>postposition</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='pref'">
                <xsl:text>prefix</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='prep'">
                <xsl:text>preposition</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='pro'">
                <xsl:text>pronoun</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='suff'">
                <xsl:text>suffix</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='v'">
                <xsl:text>verb</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='classifier'">
                <xsl:text>▪ Commonly used classifier: </xsl:text>
            </xsl:when>
            <xsl:when test="$expression='PHONO'">
                <xsl:text>Phonological elicitation</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='PROVERBE'">
                <xsl:text>Proverb</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='archaic'">
                <xsl:text>Archaic</xsl:text>
            </xsl:when>
            <xsl:when test="$expression='renvoi'">
                <xsl:text>See: </xsl:text>
            </xsl:when>
            <xsl:when test="$expression='synonyme'">
                <xsl:text>Synonym: </xsl:text>
            </xsl:when>
            <xsl:when test="$expression='antonyme'">
                <xsl:text>Antonym: </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$expression"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
