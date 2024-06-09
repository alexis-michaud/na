<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xsl:output method="text" encoding="utf-8" indent="yes"/>

<xsl:variable name="couleurdéf">Gray</xsl:variable>
<xsl:variable name="couleurnru">Blue</xsl:variable>
<xsl:variable name="couleurfra">OliveGreen</xsl:variable>
<xsl:variable name="couleureng">Sepia</xsl:variable>
<xsl:variable name="couleurcmn">black</xsl:variable>
<xsl:variable name="couleurlat">CadetBlue</xsl:variable>
<xsl:variable name="couleurpartiedudiscours">PineGreen</xsl:variable>
<xsl:variable name="couleurlocuteur">Mahogany</xsl:variable>
<xsl:variable name="couleurphonologie">Purple</xsl:variable>

<!-- <xsl:include href="annexes.xsl"/> -->

<xsl:template match="RessourceLexicale">
% !TEX program = lualatex

\documentclass[type=book]{dictionnaire lexica}
\RequireVersions{
    *{application}{luaTeX} {0000/00/00 v1.18.0}
    *{package}{ctex} {2022/07/14 v2.5.10}
}
\ConfigurerLangue[main]{fra}{}
\ConfigurerLangue{eng}{}
\ConfigurerLangue{}{}[nru]
\ConfigurerLangue{api}{}
\ConfigurerLangue{cmncn}{}
\ConfigurerLangue{pinyin}{}
\ConfigurerLangue{lat}{}
\title{\Huge <xsl:value-of select="InformationsGénérales/Titre"/>}
\author{<xsl:value-of select="InformationsGénérales/Auteur"/>}
\usepackage{changepage}
\babelpatterns[nru]{}
\addbibresource{bibliographie.bib}
\usepackage{ifthen}
\usepackage{graphicx}
\usepackage{tocloft}
\RenewDocumentCommand \cftsecfont {} {\selectlanguage{nru}}
\usepackage[fit]{truncate}
\setmainfont{EBGaramond}
\NewDocumentCommand \pdéf { m } {\textesymbolique{\textcolor{<xsl:value-of select="$couleurnru"/>}{#1}}}
\NewDocumentCommand \pnru { m } {\textenru{\textcolor{<xsl:value-of select="$couleurnru"/>}{#1}}}
\NewDocumentCommand \papi { m } {\texteapi{#1}}
\NewDocumentCommand \pfra { m } {\textefra{\textcolor{<xsl:value-of select="$couleurfra"/>}{#1}}}
\NewDocumentCommand \peng { m } {\texteeng{\textcolor{<xsl:value-of select="$couleureng"/>}{#1}}}
\NewDocumentCommand \pcmn { m } {\textecmncn{\textcolor{<xsl:value-of select="$couleurcmn"/>}{#1}}}
\NewDocumentCommand \plat { m } {\textelat{\emph{\textcolor{<xsl:value-of select="$couleurlat"/>}{#1}}}}
\RenewDocumentCommand \vedetteentête { m } {\pnru{#1}}
\RenewDocumentCommand \vedetteentêtecourte { m } {\truncate{5cm}{\pnru{#1}}}
\RenewDocumentCommand \vedette { m } {\pnru{\textbf{#1}}}
\RenewDocumentEnvironment {définitions} { } {\unskip\enskip\pdéf{►}}{}
\RenewDocumentEnvironment {variantes} {} {\enskip\pdéf{(}\ignorespaces} {\unskip\pdéf{)}\ignorespacesafterend}
\RenewDocumentEnvironment {usages} {} {\unskip\pcmn{【用法】}} {\ignorespacesafterend}
\RenewDocumentEnvironment {étymologie} {} {\unskip\pcmn{【词源】}}{\ignorespacesafterend}
\NewDocumentCommand \formedesurface { m } {\enskip\pdéf{/}\pnru{#1}\pdéf{/}}
\NewDocumentCommand \orthographe { m } {\enskip\papi{#1}}
\NewDocumentCommand \ton { m } {\enskip\pcmn{本调：}\papi{#1}}
\RenewDocumentCommand \partiedudiscours { m } {\pcmn{\textcolor{<xsl:value-of select="$couleurpartiedudiscours"/>}{#1}}}
\RenewDocumentCommand \variante { m m } {\locuteur{#2} : \pnru{#1}}
\NewDocumentCommand \locuteur { m } {\pdéf{\textcolor{<xsl:value-of select="$couleurlocuteur"/>}{#1}}}
\NewDocumentCommand \référence { m } {(\locuteur{#1})}
\RenewDocumentCommand \classificateur { m m } {\pcmn{【量词】}#1#2}
\RenewDocumentCommand \champclassificateur { m } {（#1）}
\RenewDocumentCommand \formeclassificateur { m } {\pnru{#1}}
\RenewDocumentCommand \relationsémantique { m m } {\unskip\pcmn{【#1】}\pnru{#2}}
\RenewDocumentCommand \étymon { m } {\unskip\papi{#1}}
\RenewDocumentCommand \emprunt { m m } {\pcmn{（#2）#1}}
\NewDocumentCommand \commentaire { m } {\emph{#1}}
\NewDocumentCommand \notegénérale { m }{\pcmn{（#1）}}
\RenewDocumentCommand \note { m m }{\pfra{(#1 : #2)}}
\RenewDocumentCommand \lien { m m } {\hyperlink{#2}{\pnru{#1}}}
\RenewDocumentCommand \lienbrisé { m } {\pnru{\textcolor{Red}{#1}}}
\RenewDocumentCommand \stylefv { m } {\pnru{#1}}
\RenewDocumentCommand \stylefn { m } {\pcmn{#1}}
\RenewDocumentCommand \stylefi { m } {\plat{#1}}
\NewDocumentCommand \stylefg { m } {\textsc{\textcolor{<xsl:value-of select="$couleurpartiedudiscours"/>}{#1}}}
<!-- \setlength{\marginparsep}{1.5em} -->
\NewDocumentCommand \phonologie { m }{\textcolor{<xsl:value-of select="$couleurphonologie"/>}{\papi{/#1/}}}
\NewDocumentCommand \phonologiebis { m }{\textcolor{<xsl:value-of select="$couleurphonologie"/>}{\papi{#1}}}

\begin{document}

\pagenumbering{roman}

\premièrepage{\pcmn{<xsl:value-of select="InformationsGénérales/Titre"/>}}{<xsl:value-of select="InformationsGénérales/Auteur"/>}

\deuxièmepage{
    titre = {\pcmn{<xsl:value-of select="InformationsGénérales/Titre"/>}},
    auteur = {<xsl:value-of select="InformationsGénérales/Auteur"/>},
    codesource = {\url{https://gitlab.com/BenjaminGalliot/JLexika/-/tree/maîtresse/exemples/japhug}},
    ISBNnumérique = 978-2-490768-15-8,
    ISBNpapier = 978-2-490768-14-1,
    datedépôt = {09/2022},
    dateimpression = {09/2023},
    numéro = {3},
    polices = {
        \begin{itemize}
            \item script~latin :~EB~Garamond~12\\\url{https://github.com/octaviopardo/EBGaramond12} ;
            \item script~CJC~(chinois-japonais-coréen) :~\pcmn{方正新楷体} ;
            \item API :~Gentium~Plus\\\url{https://software.sil.org/gentium}.
        \end{itemize}
    }
}

\frontmatter

\begin{introduction}
\input{introduction chinoise.tex}
\end{introduction}

\nocite{*}
\bibliographie

\mainmatter

\begin{dictionnaire*}
<xsl:apply-templates select="InformationsLexicographiques"/>
\end{dictionnaire*}

\backmatter

\tabledesmatières

\end{document}

</xsl:template>

<xsl:template match="InformationsLexicographiques">
    <xsl:apply-templates select="OrdreLexicographique"/>
</xsl:template>

<xsl:template match="OrdreLexicographique">
    <xsl:apply-templates select="Élément"/>
</xsl:template>

<xsl:template match="Élément">
    <xsl:variable name="lettrine" select="if (Élément) then string-join(Élément, ' – ') else ."/>
    <xsl:variable name="expression_rationnelle_graphèmes">
        <xsl:call-template name="créer_expression_rationnelle_graphèmes">
            <xsl:with-param name="graphèmes" select="."/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="bloc_entrées">
        <xsl:apply-templates select="/RessourceLexicale/Dictionnaire/EntréesLexicales">
            <xsl:with-param name="expression_rationnelle_graphèmes" select="$expression_rationnelle_graphèmes"/>
        </xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="$bloc_entrées != ''">
        <xsl:if test="not(position() = 1)">
            <xsl:text>\cleardoublepage</xsl:text>
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        <xsl:text>\begin{bloclettrine}{</xsl:text>
        <xsl:value-of select="$lettrine"/>
        <xsl:text>}</xsl:text>
        <xsl:text>&#10;&#10;</xsl:text>
        <xsl:value-of select="$bloc_entrées"/>
        <xsl:text>\end{bloclettrine}</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match="*[@print='n']">
</xsl:template>

<xsl:template match="EntréesLexicales">
    <xsl:param name="expression_rationnelle_graphèmes"/>
    <xsl:apply-templates select="EntréeLexicale[matches(replace(Lemme/Forme, '[_†=-]', ''), $expression_rationnelle_graphèmes, 'i;j')]"/>
</xsl:template>

<xsl:template match="EntréeLexicale">
    <xsl:text>\begin{entrée}</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates select="Lemme/Forme"/>
    <xsl:text>}{</xsl:text>
    <xsl:value-of select="NuméroDHomonyme"/>
    <xsl:text>}{</xsl:text>
    <xsl:value-of select="@identifiant"/>
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select="Lemme/FormeDeSurface"/>
    <xsl:apply-templates select="Lemme/Orthographe"/>
    <xsl:apply-templates select="Lemme/Variantes"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\newline</xsl:text>
    <xsl:apply-templates select="PartieDuDiscours"/>
    <xsl:apply-templates select="Lemme/Ton"/>
    <xsl:apply-templates select="ListeDeSens"/>
    <xsl:apply-templates select="Étymologie"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\end{entrée}</xsl:text>
    <xsl:text>&#10;&#10;</xsl:text>
</xsl:template>

<!-- <xsl:template match="Variantes">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{variantes}</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="Variante">
        <xsl:apply-templates select="."/>
        <xsl:if test="not(position() = last())">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\end{variantes}</xsl:text>
</xsl:template> -->

<xsl:template match="Variantes">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{variantes}</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each-group select="Variante" group-by="Forme">
        <xsl:sort select="if (current-grouping-key() = 'ID.') then '0' else '1'"/>
        <xsl:text>\variante{</xsl:text>
        <xsl:call-template name="traduire">
            <xsl:with-param name="expression" select="current-grouping-key()"/>
        </xsl:call-template>
        <xsl:text>}{</xsl:text>
        <xsl:for-each select="current-group()">
            <xsl:apply-templates select="Locuteur"/>
            <xsl:if test="not(position() = last())">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>}</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:if test="not(position() = last())">
            <xsl:text>\unskip , </xsl:text>
        </xsl:if>
    </xsl:for-each-group>
    <xsl:text>\end{variantes}</xsl:text>
</xsl:template>

<xsl:template match="Locuteur">
    <xsl:text>\locuteur{</xsl:text>
    <xsl:call-template name="remplacer_locuteur">
        <xsl:with-param name="expression" select="."/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
</xsl:template>

<!-- <xsl:template match="Variante">
    <xsl:text>\variante{</xsl:text>
    <xsl:call-template name="traduire">
        <xsl:with-param name="expression" select="Forme"/>
    </xsl:call-template>
    <xsl:text>}{</xsl:text>
    <xsl:call-template name="remplacer_locuteur">
        <xsl:with-param name="expression" select="Locuteur"/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
</xsl:template> -->

<xsl:template match="Ton">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\ton{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="FormeDeSurface">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\formedesurface{</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="Orthographe">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\orthographe{</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="PartieDuDiscours">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\partiedudiscours{</xsl:text>
    <xsl:call-template name="traduire">
        <xsl:with-param name="expression" select="."/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="Notes">
    <xsl:apply-templates select="Note"/>
</xsl:template>

<xsl:template match="Note">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\note{</xsl:text>
    <xsl:apply-templates select="Type"/>
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates select="Texte"/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="Note[Texte = 'PHONO' or Texte = 'PROVERBE']">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\notegénérale{</xsl:text>
    <xsl:call-template name="traduire">
        <xsl:with-param name="expression" select="Texte"/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="Classificateurs">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{classificateurs}</xsl:text>
    <xsl:for-each select="Classificateur">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\classificateur{</xsl:text>
        <xsl:text>\formeclassificateur{</xsl:text>
        <xsl:apply-templates select="Forme"/>
        <xsl:text>}}{</xsl:text>
        <xsl:apply-templates select="ChampDApplication[@langue = 'cmn']"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="not(position() = last())">
            <xsl:text>\pcmn{、}</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="Commentaire"/>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\end{classificateurs}</xsl:text>
</xsl:template>

<xsl:template match="ChampDApplication">
    <xsl:text>\champclassificateur{</xsl:text>
    <xsl:call-template name="adapter_langue"/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="Commentaire">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\commentaire{</xsl:text>
    <xsl:call-template name="adapter_langue"/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="ListeDeSens">
    <xsl:apply-templates select="Sens"/>
</xsl:template>

<xsl:template match="Sens">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{sens}</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="NuméroDeSens"/>
    <xsl:text>}{</xsl:text>
    <xsl:value-of select="@identifiant"/>
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select="Définitions"/>
    <!-- <xsl:apply-templates select="Gloses"/> -->
    <xsl:apply-templates select="Usages"/>
    <xsl:apply-templates select="InformationsEncyclopédiques"/>
    <xsl:apply-templates select="Exemples"/>
    <xsl:apply-templates select="RelationsSémantiques"/>
    <xsl:apply-templates select="Classificateurs"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\end{sens}</xsl:text>
</xsl:template>

<xsl:template match="NuméroDeSens">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\numérodesens{</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="Définitions">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{définitions}</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="Définition">
        <xsl:sort select="index-of(('cmn', 'eng', 'fra'), @langue)"/>
        <xsl:apply-templates select="."/>
        <xsl:if test="not(position() = last())">
            <xsl:text>&#10;</xsl:text>
            <xsl:text>\pdéf{•}</xsl:text>
        </xsl:if>
        <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>\end{définitions}</xsl:text>
</xsl:template>

<xsl:template match="Définition">
    <xsl:text>\définition{</xsl:text>
    <xsl:call-template name="adapter_langue"/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="Gloses">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{gloses}</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="Glose">
        <xsl:sort select="index-of(('cmn', 'eng', 'fra'), @langue)"/>
        <xsl:apply-templates select="."/>
        <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>\end{gloses}</xsl:text>
</xsl:template>

<xsl:template match="Glose">
    <xsl:text>\glose{</xsl:text>
    <xsl:call-template name="adapter_langue"/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="Exemples">
    <xsl:apply-templates select="Exemple"/>
</xsl:template>

<xsl:template match="Exemple">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{exemple}</xsl:text>
    <xsl:apply-templates select="Notes/Note[Texte = 'PHONO' or Texte = 'PROVERBE']"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="Original"/>
    <xsl:apply-templates select="Référence"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="Traduction">
        <xsl:sort select="index-of(('cmn', 'eng', 'fra'), @langue)"/>
        <xsl:apply-templates select="."/>
        <xsl:if test="not(position() = last())">
            <xsl:text>&#10;</xsl:text>
            <xsl:text>\pdéf{•}</xsl:text>
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates select="Notes/Note[Texte != 'PHONO' and Texte != 'PROVERBE']"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\end{exemple}</xsl:text>
</xsl:template>

<xsl:template match="Référence">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\référence{</xsl:text>
    <xsl:call-template name="remplacer_locuteur">
        <xsl:with-param name="expression" select="."/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="InformationsEncyclopédiques">
    <xsl:apply-templates select="InformationEncyclopédique"/>
</xsl:template>

<xsl:template match="InformationEncyclopédique">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{informationencyclopédique}</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="Original"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="Traduction">
        <xsl:sort select="index-of(('cmn', 'eng', 'fra'), @langue)"/>
        <xsl:apply-templates select="."/>
        <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>\end{informationencyclopédique}</xsl:text>
</xsl:template>

<xsl:template match="Usages">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{usages}</xsl:text>
    <xsl:apply-templates select="Usage"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\end{usages}</xsl:text>
</xsl:template>

<xsl:template match="Usage">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{usage}</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="Original|Traduction">
        <xsl:apply-templates select="."/>
        <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>\end{usage}</xsl:text>
</xsl:template>

<xsl:template match="Original">
    <xsl:text>\original{</xsl:text>
    <xsl:call-template name="adapter_langue"/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="Traduction">
    <xsl:text>\traduction{</xsl:text>
    <xsl:call-template name="adapter_langue"/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="RelationsSémantiques">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{relationssémantiques}</xsl:text>
    <xsl:for-each-group select="RelationSémantique" group-by="Type">
        <xsl:sort select="index-of(('renvoi', 'synonyme', 'antonyme'), current-grouping-key())"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\relationsémantique{</xsl:text>
        <xsl:text>\typerelationsémantique{</xsl:text>
        <xsl:call-template name="traduire">
            <xsl:with-param name="expression" select="current-grouping-key()"/>
        </xsl:call-template>
        <xsl:text>}}{</xsl:text>
        <xsl:for-each select="current-group()/Cible">
            <xsl:text>\ciblerelationsémantique{</xsl:text>
            <xsl:variable name="expression">
                <xsl:apply-templates/>
            </xsl:variable>
            <xsl:value-of select="replace($expression, '\s*(\d+)', ' \\numérodhomonyme{$1}')"/>
            <xsl:text>}{</xsl:text>
            <xsl:value-of select="./@identifiant"/>
            <xsl:text>}</xsl:text>
            <xsl:if test="not(position() = last())">
                <xsl:text>\pcmn{、}</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>}</xsl:text>
    </xsl:for-each-group>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\end{relationssémantiques}</xsl:text>
</xsl:template>

<xsl:template match="Étymologie">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{étymologie}</xsl:text>
    <xsl:apply-templates select="Étymon"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\end{étymologie}</xsl:text>
</xsl:template>

<xsl:template match="Étymon">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\étymon{</xsl:text>
    <xsl:apply-templates select="Forme"/>
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select="Commentaire"/>
</xsl:template>

<xsl:template match="Étymon/Forme">
    <xsl:call-template name="convertir_liens"/>
</xsl:template>

<xsl:template match="Forme">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="Étymologie[Étymon[Emprunt]]">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\emprunt{</xsl:text>
    <xsl:value-of select="Étymon/Emprunt"/>
    <xsl:text>}{</xsl:text>
    <xsl:choose>
        <xsl:when test="Étymon/Emprunt[@langue='cmn']">
            <xsl:text>汉语借词</xsl:text>
        </xsl:when>
        <xsl:when test="Étymon/Emprunt[@langue='bod']">
            <xsl:text>藏语借词</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>借词</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="lien">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\lien{</xsl:text>
    <xsl:value-of select="@identifiant"/>
    <xsl:text>}{</xsl:text>
    <xsl:call-template name="convertir_liens"/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="style">
    <xsl:text>\style</xsl:text>
    <xsl:value-of select="@type"/>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="style[@type='fv']">
    <xsl:text>\style</xsl:text>
    <xsl:value-of select="@type"/>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="convertir_liens">
    <xsl:param name="expression" select="."/>
    <xsl:value-of select="replace($expression, '\s*(\d+)', ' \\numérodhomonyme{$1}')"/>
</xsl:template>

<xsl:template name="convertir_catégories_tonales">
    <xsl:param name="expression" select="."/>
    <xsl:value-of select="replace(replace(replace($expression, 'α', '\\textsubscript{a}'), 'β', '\\textsubscript{b}'), 'γ', '\\textsubscript{c}')"/>
</xsl:template>

<xsl:template match="text()">
    <xsl:variable name="expression">
        <xsl:call-template name="convertir_caractères_spéciaux">
            <xsl:with-param name="expression" select="."/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="expression">
        <xsl:call-template name="convertir_catégories_tonales">
            <xsl:with-param name="expression" select="$expression"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$expression"/>
</xsl:template>

<xsl:template name="convertir_caractères_spéciaux">
    <xsl:param name="expression" select="."/>
    <xsl:value-of select="replace(replace($expression, '[#$]', '\\$0'), '[~〜]', '\\textasciitilde{}')"/>
</xsl:template>

<xsl:template name="adapter_langue">
    <xsl:text>\p</xsl:text>
    <xsl:value-of select="@langue"/>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="remplacer_locuteur">
    <xsl:param name="expression"/>
    <xsl:choose>
        <xsl:when test="$expression='F4'">
            <xsl:text>La</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='F5'">
            <xsl:text>Gi</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='M18'">
            <xsl:text>Da</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='M21'">
            <xsl:text>Jj</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='M23'">
            <xsl:text>Dd</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$expression"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="traduire">
    <xsl:param name="expression"/>
    <xsl:choose>
        <xsl:when test="$expression='adj'">
            <xsl:text>形容词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='adv'">
            <xsl:text>助词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='clf'">
            <xsl:text>量词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='clitic'">
            <xsl:text>附着词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='cnj'">
            <xsl:text>连接词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='disc.PTCL'">
            <xsl:text>语气助词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='ideophone'">
            <xsl:text>状貌词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='intj'">
            <xsl:text>感叹词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='lnk'">
            <xsl:text>连词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='n'">
            <xsl:text>名词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='neg'">
            <xsl:text>否定词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='num'">
            <xsl:text>数词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='postp'">
            <xsl:text>后置词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='pref'">
            <xsl:text>前缀</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='prep'">
            <xsl:text>介词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='pro'">
            <xsl:text>代词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='suff'">
            <xsl:text>后缀</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='v'">
            <xsl:text>动词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='classifier'">
            <xsl:text>量词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='PHONO'">
            <xsl:text>音系资料</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='PROVERBE'">
            <xsl:text>谚语</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='archaic'">
            <xsl:text>古词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='renvoi'">
            <xsl:text>参考</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='synonyme'">
            <xsl:text>同义词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='antonyme'">
            <xsl:text>反义词</xsl:text>
        </xsl:when>
        <xsl:when test="$expression='ID.'">
            <xsl:text>\pcmn{同}</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$expression"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="créer_expression_rationnelle_graphèmes">  <!-- forme : ^(x|y|z) -->
    <xsl:param name="graphèmes"/>
    <xsl:text>^</xsl:text>
    <xsl:call-template name="exclure_graphèmes_chevauchants">
        <xsl:with-param name="graphèmes" select="$graphèmes"/>
    </xsl:call-template>
    <xsl:text>(</xsl:text>
    <xsl:choose>
        <xsl:when test="Élément">
            <xsl:for-each select="$graphèmes/Élément">
                <xsl:value-of select="."/>
                <xsl:if test="not(position() = last())">
                    <xsl:text>|</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$graphèmes"/>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template name="exclure_graphèmes_chevauchants">  <!-- forme : ^(?!xz|yz)(x|y) (attention : nécessite le drapeau « ;j » dans la fonction « matches » pour que « ?! » soit accepté par Saxon) -->
    <xsl:param name="graphèmes"/>
    <xsl:variable name="graphèmes_chevauchants">
        <xsl:call-template name="trouver_graphèmes_chevauchants">
            <xsl:with-param name="graphèmes" select="$graphèmes"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$graphèmes_chevauchants != ''">
        <xsl:text>(?!</xsl:text>
        <xsl:for-each select="$graphèmes_chevauchants//Graphème">
            <xsl:value-of select="."/>
            <xsl:if test="not(position() = last())">
                <xsl:text>|</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template name="trouver_graphèmes_chevauchants">  <!-- exemple : x et xz -->
    <xsl:param name="graphèmes"/>
    <xsl:element name="Graphèmes">
        <xsl:for-each select="//OrdreLexicographique//Élément[not(Élément)]">  <!-- chaque graphème utilisé dans l'ordre lexicographique -->
            <xsl:variable name="graphème_comparé" select="."/>
            <xsl:for-each select="$graphèmes/Élément|$graphèmes[not(Élément)]">  <!-- chaque graphème formant la lettrine (formant un bloc d'entrées) -->
                <xsl:if test="starts-with($graphème_comparé, .) and $graphème_comparé != .">
                    <Graphème>
                        <xsl:value-of select="$graphème_comparé"/>
                    </Graphème>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:element>
</xsl:template>

</xsl:stylesheet>
