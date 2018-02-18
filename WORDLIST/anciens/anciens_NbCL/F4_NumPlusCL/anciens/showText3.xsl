<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


	<xsl:param name="url_sound_wav" select="TEXT/url_sound"/>

	
	<!-- ******************************************************** -->
	<xsl:template match="/">
    
		<html>
			<head/>
			<body>
  
		<script src="showhide.js" type="text/javascript">.</script>
				
				<STYLE>
					/*****************************************************************************/     
					/* pour presenter un texte interlineaire                                    **/
					/*****************************************************************************/  
					table {
					width:60%;
					}
					
					table.it {
					border-collapse: separate;
					width:100%;
					}
					.transcriptTable { 
					border-collapse:collapse;
					vertical-align:middle;
					}
					
					.segmentInfo {
					background-color:#C4D7ED;
					vertical-align:top;
					width:3%;
					}
					
					.segmentContent {
					width:600px;
					}
					
					
					.sentence {
					border-collapse: separate ;
					display: inline;
					vertical-align:middle;
					text-align:left;
					}
					
					/*Couleur de la phrase de transcription*/
					.word_sentence{
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					border-collapse: separate ;
					display: inline;
					font-size:16px;
					text-align:left;
					font-weight: bold;
					}
					
					
					.translation1 {
					
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					text-align:left;
					/*font-weight: bold;*/ 	
					}
					
					.translation2 {
					
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					text-align:left;
					/*font-weight: bold;*/ 	
					
					}
					
					.translation3 {
					
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					text-align:left;
					/*font-weight: bold;*/ 	
					
					}
					.word                     { 
					border-collapse: separate ;
					display: inline;
					vertical-align:middle;
					text-align:left;
					
					}
					
					.word_tab                     { 
					vertical-align:middle;
					text-align:left;
					
					}
					.word_form {
					/*background-color:#FEF1D4;*/
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					font-weight: bold; 
					text-align:left;
					
					}
					.word_transl {
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					text-align:left;
					
					}
					.transcription {
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					text-align:left;
					display:inline;
					font-weight: bold; 
					}
					.transcription1 {
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					text-align:left;
					display:inline;
					font-weight: bold; 
					}
					.transcription2 {
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					text-align:left;
					display:inline;
					font-weight: bold; 
					}
					.transcription3 {
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					text-align:left;
					display:inline;
					font-weight: bold; 
					}
					.transcription4 {
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					text-align:left;
					display:inline;
					font-weight: bold; 
					}
					
				</STYLE>
				
		<div style="margin-left: 5px;">
			
    				
   						 <div>
							<xsl:call-template name="player-audio_wav">
								<xsl:with-param name="mediaUrl_wav" select="$url_sound_wav"/>
							</xsl:call-template>
     					</div>
   				
      
        
         <div>
         
         	<xsl:if test="TEXT/S/FORM[@kindOf='phono']">
         		
         		Phono : 
         		
         		
         		<input checked="checked" name="transcription1" onclick="javascript:showhide(this, 15, 'inline')"  type="checkbox"/>
         		
         	</xsl:if>
         	<xsl:if test="TEXT/S/FORM[@kindOf='ortho']">
         		
         		Ortho : 
         		
         		
         		<input checked="checked" name="transcription2" onclick="javascript:showhide(this, 16, 'inline')"  type="checkbox"/>
         		
         	</xsl:if>
         	<xsl:if test="TEXT/S/FORM[@kindOf='phone']">
         		
         		Phone : 
         		
         		
         		<input checked="checked" name="transcription3" onclick="javascript:showhide(this, 17, 'inline')"  type="checkbox"/>
         		
         	</xsl:if>
         	<xsl:if test="TEXT/S/FORM[@kindOf='transliter']">
         		
         		Transliter : 
         		
         		
         		<input checked="checked" name="transcription4" onclick="javascript:showhide(this, 18, 'inline')"  type="checkbox"/>
         		
         	</xsl:if>
         
         <xsl:if test="TEXT/S/W[TRANSL or M/TRANSL]">
    		
          
						
                        	Mot à mot :  
                        
                      
                    <input checked="checked" name="interlinear" onclick="javascript:showhide(this, 10, 'inline')" type="checkbox"/>
   			 
   		 </xsl:if>
         
         
		<xsl:if test="TEXT/S/TRANSL[@xml:lang='en']">
    		
                    	Translation (EN): 
    		 
            
            <input checked="checked" name="translation1" onclick="javascript:showhide(this, 7, 'block')"  type="checkbox"/>
   			
   		 </xsl:if>
         
         <xsl:if test="TEXT/S/TRANSL[@xml:lang='fr']">
    		
                        Traduction (FR):  
                  
    		 
            
            <input checked="checked" name="translation1" onclick="javascript:showhide(this, 8, 'block')"  type="checkbox"/>
   			
   		 </xsl:if>
			
            <xsl:if test="TEXT/S/TRANSL[@xml:lang!='fr' and @xml:lang!='en']">
    		
    
					
                        Traduction (OTHER):  
                    
                 
             
              <input checked="checked" name="translation1" onclick="javascript:showhide(this, 9, 'block')"  type="checkbox"/>
   			 
   		 </xsl:if>
                
         </div>
         
         
      
		</div>
		<xsl:apply-templates select=".//TEXT|.//WORDLIST"/>
			</body>
			</html>
	</xsl:template>	
	
	
	<xsl:template match="TEXT">
		<table width="100%" border="1"  bordercolor="#993300" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<table width="60%" border="0" cellpadding="5" cellspacing="0" bordercolor="#993300" class="it">
						<tbody>
                        <!-- Cree la numerotation des phrases : Si (phrase numero i)-->
							<xsl:for-each select="S">
								<tr class="transcriptTable">
									<td class="segmentInfo">S<xsl:value-of select="position()"/>
									</td>
									<td class="segmentContent" width="600px" id="position()">
										
          									
                                                        <a href="javascript:boutonStop()">
														<img src="stop.gif" alt="stop"/>
														</a>
														<a href="javascript:playFrom('{position()}')">
														<img src="play.gif" alt="écouter"/>
														</a>
                                           
                                        
											<!-- affiche le nom du locuteur si il y en a -->
											<xsl:if test="((@who) and (not(@who='')) and (not(@who=ancestor::TEXT/S[number(position())-1]/@who)))">
												<span class="speaker">
													<xsl:value-of select="@who"/><xsl:text>: </xsl:text>
												</span>
											</xsl:if>
											
									
                                       <!-- cas ou S contient la balise FORM -->
                                        <xsl:if test="FORM">
                                        	<div class="word_sentence">
                                        <!-- Recuperation de la phrase -->
                                        <xsl:for-each select="FORM">
                                        	<xsl:choose>
                                        		<xsl:when test="@kindOf">
                                        	<xsl:if test="@kindOf='phono'">
                                        		<div class="transcription1">
                                        		<xsl:value-of select="."/>
                                        		</div>
                                        		
                                        	</xsl:if>
                                        	<xsl:if test="@kindOf='ortho'">
                                        		<div class="transcription2">
                                        		<xsl:value-of select="."/>
                                        		</div>
                                        		
                                        	</xsl:if>
                                        	<xsl:if test="@kindOf='phone'">
                                        		<div class="transcription3">
                                        		<xsl:value-of select="."/>
                                        		</div>
                                        		
                                        	</xsl:if>
                                        	<xsl:if test="@kindOf='transliter'">
                                        		<div class="transcription4">
                                        		<xsl:value-of select="."/>
                                        		</div>
                                        		
                                        	</xsl:if>
                                        		</xsl:when>
                                        		<xsl:otherwise>
                                        			<xsl:value-of select="."/>
                                        		</xsl:otherwise>
                                        	</xsl:choose>
                                        	
                                        	<br />
                                        </xsl:for-each>
											</div>
                                         
                                        
                                        </xsl:if>
                                        
                                        
                                        <!-- Cas ou W ou M contiennent la balise FORM et ou S ne contient pas la balise FORM -->
                                        <xsl:if test="not(FORM) and (W/FORM or W/M/FORM)">
                                      	
                                       	
                                                    
                                        <!-- Recuperation des mots ou morphemes puis concatenation pour former une phrase --> 
                                        <xsl:for-each select="W">
											
                                        
                                            
                                        	<div class="word_sentence" >
															<xsl:choose>
																
																
																	<xsl:when test="FORM">
																		<xsl:value-of select="FORM"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:choose>
																			<xsl:when test="M/@class='i'">
																				<i>         
																					<xsl:for-each select="M/FORM">
																						<xsl:value-of select="."/>
																						<xsl:if test="position()!=last()">-</xsl:if>
																					</xsl:for-each>
																					
																				</i> 
																			</xsl:when>
																			<xsl:otherwise>  <xsl:value-of select="M/FORM"/>  </xsl:otherwise>
																		</xsl:choose>
																	</xsl:otherwise>
																	
															
																
															</xsl:choose>
														</div>
                                                        
                                                        
                                     
                                          </xsl:for-each>
                                     
                                      
											
                                        </xsl:if>
                                       
                                    <br />
                                     
                                    <xsl:if test="TRANSL">
                                       
                                    <!-- Recupere la traduction si il en existe une -->
                                        
									
                                      
                                      <xsl:for-each select="TRANSL[@xml:lang='en']">
											<div class="translation1">
												<xsl:value-of select="."/>
											</div>
                                          </xsl:for-each> 
                                          
                                          <xsl:for-each select="TRANSL[@xml:lang='fr']">
											<div class="translation2">
												<xsl:value-of select="."/>
											</div>
                                          </xsl:for-each> 
                                    
                                          
                                          <xsl:for-each select="TRANSL[@xml:lang!='fr' and @xml:lang!='en']">
											<div class="translation3">
												<xsl:value-of select="."/>
											</div>
                                        
                                          </xsl:for-each>
                                         
                                        </xsl:if>
                                        
                                        <br />
                                 
										<!-- Recupere les mots avec leur glose -->
                                        <xsl:if test="(W/FORM and W/TRANSL) or (W/M/FORM and W/M/TRANSL) ">
                                        	
                                       	<xsl:for-each select="W">
                                       
                                      
											<table class="word">
												<tbody>
													<tr>
														<td class="word_form">
													
										
															<xsl:choose>
																<xsl:when test="FORM">
																	<xsl:value-of select="FORM"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:choose>
																		<xsl:when test="M/@class='i'">
																			<i>
																				<xsl:for-each select="M/FORM">
																					<xsl:value-of select="."/>
																					<xsl:if test="position()!=last()">-</xsl:if>
																				</xsl:for-each>
																				
																			</i>
																		</xsl:when>
																		<xsl:otherwise>  
<!--  ajouté d'ici-->	
																		<xsl:for-each select="M/FORM">
																					<xsl:value-of select="."/>
																					<xsl:if test="position()!=last()">-</xsl:if>
																				</xsl:for-each>
<!-- jusqu'ici + écrasé la ligne prochaine  -->
<!--  <xsl:value-of select="M/FORM"/>  -->
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:otherwise>
																
															</xsl:choose>
                                              		</td>
													</tr>
													<tr>
                                                   
														<td class="word_transl">
														
															
															<xsl:choose>
																<xsl:when test="M/TRANSL[@xml:lang] or TRANSL[@xml:lang]">
															
															
															<xsl:if test="M/TRANSL[@xml:lang='en']">
																	<xsl:for-each select="M/TRANSL[@xml:lang='en']">
																		<xsl:value-of select="."/>
																		<xsl:if test="position()!=last()">-</xsl:if>
																	</xsl:for-each>
																	<br/>
																</xsl:if>
																<xsl:if test="M/TRANSL[@xml:lang='fr']">
																	<xsl:for-each select="M/TRANSL[@xml:lang='fr']">
																		<xsl:value-of select="."/>
																		<xsl:if test="position()!=last()">-</xsl:if>
																	</xsl:for-each>
																	<br/>
																</xsl:if>
																
																	
																<xsl:if test="TRANSL[@xml:lang='en']">
																	<xsl:value-of select="TRANSL[@xml:lang='en']"/>
																	<br/>
																</xsl:if>
																<xsl:if test="TRANSL[@xml:lang='fr']">
																	<xsl:value-of select="TRANSL[@xml:lang='fr']"/>
																	<br/>
																</xsl:if>
																	<xsl:if test="not(TRANSL[@xml:lang='en']) and not(TRANSL[@xml:lang='fr'])">
																		<xsl:value-of select="TRANSL"/>
																		<br/>
																	</xsl:if>
															</xsl:when>
																	<xsl:otherwise>
																	<xsl:if test="M/TRANSL">
																		<xsl:for-each select="M/TRANSL[1]">
																			<xsl:value-of select="."/>
																			<xsl:if test="position()!=last()">-</xsl:if>
																		</xsl:for-each>
																		<br/>
																	</xsl:if>
																		<xsl:if test="TRANSL">
																			<xsl:value-of select="TRANSL[1]"/>
																			<br/>
																		</xsl:if>
																	</xsl:otherwise>
															</xsl:choose>
													</td>
													</tr>
												</tbody>
											</table>
												
													</xsl:for-each>
                                                   
                                                 
                                        </xsl:if>
                                        
                                        
                                        
                                        
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	 

	<xsl:template name="player-audio_wav">
		<xsl:param name="mediaUrl_wav" select="$url_sound_wav"/>
		<script language="Javascript">
			<xsl:text>var IDS    = new Array(</xsl:text>
			<xsl:for-each select="//TEXT/S|//WORDLIST/W">
	   			"<xsl:value-of select="position()"/>"
	  	 		<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
			</xsl:for-each>
			<xsl:text>);</xsl:text>
			
			<xsl:text>var STARTS = new Array(</xsl:text>
			<xsl:for-each select="//TEXT/S/AUDIO|//WORDLIST/W/AUDIO">
	   			"<xsl:value-of select="@start"/>"
	   			<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
			</xsl:for-each>
			<xsl:text>);</xsl:text>
			
			<xsl:text>var ENDS   = new Array(</xsl:text>
			<xsl:for-each select="//TEXT/S/AUDIO|//WORDLIST/W/AUDIO">
	  	 		"<xsl:value-of select="@end"/>"
	  	 		<xsl:if test="position()!=last()"><xsl:text>,</xsl:text></xsl:if>
			</xsl:for-each>
			<xsl:text>);</xsl:text>
		</script>
		
		<object id="player" width="350" height="16" classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab">
			<param name="AUTOPLAY" value="false"/>
			<param name="CONTROLLER" value="true"/>
			<embed width="350pt" height="16px" pluginspace="http://www.apple.com/quicktime/download/" controller="true" src="{$url_sound_wav}" name="player" autostart="false" enablejavascript="true">
			</embed>
		</object>
		
 
		<span style="margin-left:10px"> Lecture en continu: </span><input id="karaoke" name="karaoke" checked="checked" type="checkbox"/>
		<script type="text/javascript" src="showhide.js">.</script>
		
		<script type="text/javascript" src="qtPlayerManager.js">.</script>
        
        </xsl:template>
        
  
   
    
</xsl:stylesheet>
