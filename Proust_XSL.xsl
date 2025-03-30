<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    
    <xsl:output method="html"/>
    
    <!--HEADER-->
    <xsl:variable name="head">
        <head>
            <title><xsl:value-of select="//titleStmt/title"/></title>
            <link rel="icon" type="image/x-icon" href="madeleine.ico"/>
            <link href="proust.css" rel="stylesheet"/>
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/> 
        </head>
    </xsl:variable>

    <!--NAVBAR-->
    <xsl:variable name="navbar">
        <nav>
            <ul>
                <li><a href="home.html">Accueil</a></li>
                <xsl:for-each select="//body/div">
                    <xsl:sort select="./@when"/>
                    <!--mettre les dates dans l'ordre chronologique-->
                    <li><a href="{concat('lettre', ./@when, '.html')}">Lettre du <xsl:value-of select="format-date(./@when, '[D01]-[M01]-[Y]')"/></a></li>
                    <!--permet de formater correctement la date en dd/mm/yyyy-->
                </xsl:for-each>
                <li><a href="index_noms.html">Index des noms de personnes</a></li>
                <li><a href="index_oeuvres.html">Index des oeuvres</a></li>
                <li><a href="index_pastiches.html">Index des pastiches</a></li>
            </ul>
        </nav>
    </xsl:variable>
    
    <!--TITRE EN HAUT DES PAGES-->
    <xsl:variable name="top">
        <h1><xsl:value-of select="//titleStmt/title"/></h1>
    </xsl:variable>
    
    <!--FOOTER-->
    <xsl:variable name="footer">
        <footer>
            <div id="block1">
                <p>Contactez-nous :</p>
                <ul>
                    <li><xsl:value-of select="//address/addrLine[1]"/></li>
                    <li><xsl:value-of select="//address/addrLine[2]"/></li>
                    <li><xsl:value-of select="//address/addrLine[3]"/></li>
                </ul>
            </div>
            <div id="block2">
                <p>À propos :</p>
                <ul>
                    <li>Responsable de publication : <xsl:value-of select="//respStmt/name"/></li>
                    <li>Direction scientifique : <xsl:value-of select="//respStmt/name"/></li>
                    <li>Webmaster : <xsl:value-of select="//respStmt/name"/></li>
                </ul>
            </div>
            <p id="bas">
                Ce site et son contenu sont disponibles sous licence 
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="//availability/licence/@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="//availability/licence"/>
                </a>
            <br/>Ils ont été créés dans le cadre du devoir de XSLT du Master 2 TNAH.</p>
        </footer>
    </xsl:variable>
    
    <!--JAVASCRIPT pour faire apparaitre Proust a cote des references aux pastiches a partir de la page d'index-->
    <xsl:variable name="js">
        <script>
            document.addEventListener("DOMContentLoaded", function () {
            let hash = window.location.hash.substring(1); 
            
            if (hash) {
            let pastiche = document.getElementById(hash); 
            
            if (pastiche) {
            pastiche.style.background = "url('proust_mini.png') left no-repeat";
            pastiche.style.paddingLeft = "17px";
            pastiche.style.textAlign = "center";
            pastiche.style.fontStyle = "italic";
            pastiche.style.textDecoration = "underline";
            console.log("Matched and styled:", pastiche.textContent.trim()); 
            } else {
            console.log("No matching element found for hash:", hash);
            }
            }
            });
        </script>
    </xsl:variable>
    
    <!--APPEL DES TEMPLATES-->
    <xsl:template match="/">
        <xsl:call-template name="home"/>
        <xsl:call-template name="chapitres"/>
        <xsl:call-template name="index_noms"/>
        <xsl:call-template name="index_oeuvres"/>
        <xsl:call-template name="index_pastiches"/>
    </xsl:template>
    
    
    <!--PAGE PRINCIPALE-->
    <xsl:template name="home">
        <xsl:result-document href="out/home.html" method="html" indent="yes">
            <html lang="fr">
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$navbar"/>
                    <main>
                    <xsl:copy-of select="$top"/>
                    <article>
                        <p>Le projet <xsl:value-of select="//titleStmt/title"/> vise à éditer la correspondance échangée entre Marcel Proust et Montesquiou.</p>
                        <p>Marcel Proust et Robert de Montesquiou, figures emblématiques des salons parisiens de la fin du XIXe et du début du XXe siècle, ont entretenu une amitié de longue date pendant près de trente ans, jusqu'à la mort de Montesquiou.</p>
                        <p>Marcel Proust doit ses débuts sur la scène littéraire parisienne à Montesquiou, qui l'invita à l'une de ses soirées exclusives et lui demanda d'en rédiger un compte rendu en 1894. Plus tard, Proust écrivit et publia un pastiche dans le style de l'écriture de Saint-Simon, faisant référence à Montesquiou, intitulé L'affaire Lemoine, qui fut publié dans le journal Le Figaro en 1908. Marcel Proust échangea plusieurs lettres avec Montesquiou à propos de ce pastiche et de la mention de Montesquiou dans celui-ci.</p>
                    </article>
                    </main>
                    <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    
    <!--TEMPLATE POUR LES LETTRES-->
    <xsl:template name="chapitres">
        <xsl:for-each select="//body/div">
            <xsl:result-document href="{concat('out/lettre', ./@when, '.html')}" method="html" indent="yes">
                <html lang="fr">
                    <xsl:copy-of select="$head"/>
                    <body>
                        <xsl:copy-of select="$navbar"/>
                        
                        <main>
                        <xsl:copy-of select="$top"/>
                        
                        <!--CORPS DE LA LETTRE-->
                        <article>
                            <h2>Lettre du <xsl:value-of select="format-date(./@when, '[D01]-[M01]-[Y]')"/></h2>
                            <!--permet de formater correctement la date en dd/mm/yyyy-->
                            
                            <!--copier le corps de la lettre-->
                            <xsl:apply-templates select="./opener"/>
                            <xsl:apply-templates select="./p"/>
                            <xsl:apply-templates select="./closer"/>
                            <xsl:if test="./postscript">
                                <xsl:apply-templates select="postscript"/>
                            </xsl:if>
                            <!--s'il y a un postscript à la lettre, y affecter le template plus bas-->
                        </article>
                        </main>
                        <xsl:copy-of select="$footer"/>
                        <xsl:copy-of select="$js"/>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
        <!--remplacer les lb par des br-->
        <xsl:template match="lb">
            <br/>
        </xsl:template>
        
        <!--id autoincrémental pour les pastiches-->
        <xsl:template match="pastiche">
            <xsl:element name="span">
            <xsl:attribute name="id">
                <xsl:number
                    count="pastiche" 
                    level="any" 
                    format="1"/>
            </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:template>
        
        <!--afficher les p et opener-->
        <xsl:template match="p">
            <p>
                <xsl:apply-templates/>
            </p>
        </xsl:template>
        
        <!--mettre le contenu d'opener et de salute dans deux p qui se suivent-->
        <xsl:template match="opener">
            <p>
                <xsl:apply-templates select="text()"/>
            </p>
            <xsl:apply-templates select="salute"/>
        </xsl:template>
        <xsl:template match="salute">
            <p><xsl:apply-templates/></p>
        </xsl:template>
       
       <!--même chose pour le closer-->
        <xsl:template match="closer">
            <p>
                <xsl:apply-templates select="text()"/>
            </p>
            <xsl:apply-templates select="signed"/>
        </xsl:template>
        <xsl:template match="signed">
            <p><xsl:apply-templates/></p>
        </xsl:template>
    
        <xsl:template match="postscript">
            <p>
                <xsl:apply-templates/>
            </p>
        </xsl:template>

    <!--TEMPLATE POUR L'INDEX DES NOMS DE PERSONNES-->
    <xsl:template name="index_noms">
        <xsl:result-document href="out/index_noms.html" method="html" indent="yes">
            <html lang="fr">
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$navbar"/>
                    <main>
                    <xsl:copy-of select="$top"/>
                    
                    <article>
                        <h2>Index des noms de personnes</h2>
                        <div>
                            <ul>
                                <xsl:for-each select="//listPerson/person">
                                    <xsl:sort select="./persName"/>
                                    <!--faire la liste des personnes dans l'ordre alphabetiqueà-->
                                    <li>
                                        <xsl:choose>
                                            <xsl:when test="./idno">
                                                <xsl:value-of select="./persName"/>, identifiant wikidata : <a href="{concat('https://www.wikidata.org/wiki/', ./idno)}"><xsl:value-of select="./idno"/></a>
                                                <!--permet de lier l'identifiant wikidata présent dans le xml à la page wikidata correspondante-->
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="./persName"/>, pas de page wikidata
                                                <!--dans le cas où l'identifiant wikidata n'existe pas-->
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:if test="position()!= last()"> ;
                                        </xsl:if><xsl:if test="position() = last()">.</xsl:if>
                                        <!--ponctuation-->
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </div>
                    </article>
                    </main>
                    <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <!--TEMPLATE POUR L'INDEX DES TITRES D'OEUVRES-->
    <xsl:template name="index_oeuvres">
        <xsl:result-document href="out/index_oeuvres.html" method="html" indent="yes">
            <html lang="fr">
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$navbar"/>
                    <main>
                    <xsl:copy-of select="$top"/>
                        
                    <article>
                        <h2>Index des titres d'oeuvres</h2>
                        <div>
                            <ul>
                                <xsl:for-each select="//p/title">
                                    <xsl:sort select="upper-case(.)"/>
                                    <!--liste affichee dans l'ordre alphabetique, meme s'il y a des majuscules et des miniscules melangees-->
                                    <li>
                                        <a href="{concat('lettre', ancestor::div/@when, '.html')}">
                                            <xsl:value-of select="."/>
                                        </a>
                                        <!--trouver la date correspondant à la div, ancêtre de p-->
                                        <xsl:if test="position()!= last()"> ;
                                        </xsl:if><xsl:if test="position() = last()">.</xsl:if>
                                        <!--ponctuation-->
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </div>
                    </article>
                    </main>
                    <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <!--TEMPLATE POUR L'INDEX DES PASTICHES-->
    <xsl:template name="index_pastiches">
        <xsl:result-document href="out/index_pastiches.html" method="html" indent="yes">
            <html lang="fr">
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$navbar"/>
                    <main>
                    <xsl:copy-of select="$top"/>
                    <article>
                        <h2>Index des pastiches mentionnées dans la correspondance</h2>
                        <div>
                            <ul>
                            <xsl:for-each select="//div">
                                <xsl:sort select="./@when"/>
                                <li>
                                    Lettre du <xsl:value-of select="format-date(@when, '[D01]-[M01]-[Y]')"/> : 
                                    <!--formatage de la date-->
                                        <ul>
                                            <xsl:for-each select="./p/pastiche|postscript/pastiche"><li>
                                            <a href="{concat('lettre', ancestor::div/@when, '.html#', number(count(preceding::pastiche) + 1))}">
                                                <xsl:value-of select="."/>
                                            </a>
                                            <!--s'arranger pour relier à l'id de la pastiche-->
                                            <!--et créer le lien avec la date de la lettre, div ancêtre de p et postscript-->
                                            <xsl:if test="position()!= last()">,
                                            </xsl:if><xsl:if test="position() = last()"> ;</xsl:if></li>
                                            <!--ponctuation-->
                                            </xsl:for-each>
                                        </ul>
                                </li>
                            </xsl:for-each>
                            </ul>
                        </div>
                    </article>
                    </main>
                    <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>