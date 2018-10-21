<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


	<xsl:param name="url_sound_wav" select="TEXT/url_sound | WORDLIST/url_sound"/>

	
	<!-- ******************************************************** -->
	<xsl:template match="/">
    
		<html>
			<head/>
			<body>
  
		<script src="../outils/showhide.js" type="text/javascript">.</script>
				
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
					.note{
					font-family:'charis SIL',sans-serif,'Arial Unicode MS';
					text-align:left;
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
		 
		 <table width="100%">
         <tr>
         
         	<xsl:if test="TEXT/S/FORM[@kindOf='phono'] | WORDLIST/W/FORM[@kindOf='phono']">
         		<td>
         		<table>
			<tr>
				<td align="center">      		
                   Phono     
         		</td>
      		</tr>
     		<tr>
      		<td align="center">
				<input checked="checked" name="transcription_ortho" onclick="javascript:showhide(this, 15, 'inline')"  type="checkbox"/>
         		</td>
             </tr>
         </table>
         		</td>
         	</xsl:if>
         	
         	<xsl:if test="TEXT/S/FORM[@kindOf='ortho'] | WORDLIST/W/FORM[@kindOf='ortho']">
         		<td>
         		<table>
			<tr>
				<td align="center">      		
                   Ortho     
         		</td>
      		</tr>
     		<tr>
      		<td align="center">
				<input checked="checked" name="transcription_ortho" onclick="javascript:showhide(this, 16, 'inline')"  type="checkbox"/>
         		</td>
             </tr>
         </table>
         		</td>
         	</xsl:if>
         	<xsl:if test=" TEXT/S/FORM[@kindOf='phone'] | WORDLIST/W/FORM[@kindOf='phone']">
         		<td>
         		<table>
			<tr>
				<td align="center">      		
                   Phone     
         		</td>
      		</tr>
     		<tr>
      		<td align="center">
				<input checked="checked" name="transcription_ortho" onclick="javascript:showhide(this, 17, 'inline')"  type="checkbox"/>
         		</td>
             </tr>
         </table>
         		</td>
         	</xsl:if>
         	<xsl:if test="TEXT/S/FORM[@kindOf='transliter'] | WORDLIST/W/FORM[@kindOf='transliter']">
         		<td>
         		<table>
			<tr>
				<td align="center">      		
                   Transliter    
         		</td>
      		</tr>
     		<tr>
      		<td align="center">
				<input checked="checked" name="transcription_ortho" onclick="javascript:showhide(this, 18, 'inline')"  type="checkbox"/>
         		</td>
             </tr>
         </table>
         		</td>
         	</xsl:if>
         
         <xsl:if test="TEXT/S/W[TRANSL or M/TRANSL] | WORDLIST/W[TRANSL or M/TRANSL]">
    		<td>
          
						
                        	<table>
			<tr>
				<td align="center">      		
                   Gloses   
         		</td>
      		</tr>
     		<tr>
      		<td align="center">
				<input checked="checked" name="transcription_ortho" onclick="javascript:showhide(this, 10, 'inline')"  type="checkbox"/>
         		</td>
             </tr>
         </table>
   			 </td>
   		 </xsl:if>
         
         
         	<xsl:if test="TEXT/S/TRANSL[@xml:lang='en' or @lang='en'] | WORDLIST/W/TRANSL[@xml:lang='en' or @lang='en']">
    		<td>
                    	<table>
			<tr>
				<td align="center">      		
                   Translation (EN)    
         		</td>
      		</tr>
     		<tr>
      		<td align="center">
				 <input checked="checked" name="translation1" onclick="javascript:showhide(this, 7, 'block')"  type="checkbox"/>
         		</td>
             </tr>
         </table>
    		 
            </td>
           
   			
   		 </xsl:if>
         
         	<xsl:if test="TEXT/S/TRANSL[@xml:lang='fr' or @lang='fr'] | WORDLIST/W/TRANSL[@xml:lang='fr' or @lang='fr']">
    		<td>
                      <table>
			<tr>
				<td align="center">      		
                   Translation (FR)   
         		</td>
      		</tr>
     		<tr>
      		<td align="center">
				  <input checked="checked" name="translation2" onclick="javascript:showhide(this, 8, 'block')"  type="checkbox"/>
         		</td>
             </tr>
         </table>
              </td>   
    		 
   		 </xsl:if>
			
         	<xsl:if test="TEXT/S/TRANSL[(@xml:lang!='fr' or @lang!='fr') and (@xml:lang!='en' or @lang!='en')] | WORDLIST/W/TRANSL[(@xml:lang!='fr' or @lang!='fr') and (@xml:lang!='en' or @lang!='en')]">
    		
         		<td>
					  <table>
			<tr>
				<td align="center">      		
                    Traduction (OTHER):   
         		</td>
      		</tr>
     		<tr>
      		<td align="center">
				 <input checked="checked" name="translation3" onclick="javascript:showhide(this, 9, 'block')"  type="checkbox"/>
         		</td>
             </tr>
         </table>
               </td>          
                    
                 </xsl:if>
             
              
   			 
			 
			 <xsl:if test="TEXT/S/NOTE  | WORDLIST/W/NOTE">
    		<td>
    <table>
			<tr>
				<td align="center">      		
                     Note :  
         		</td>
      		</tr>
     		<tr>
      		<td align="center">
				 <input checked="checked" name="note" onclick="javascript:showhide(this, 9, 'block')"  type="checkbox"/>
         		</td>
             </tr>
         </table>
					</td>
                  </xsl:if>      
                    
                 
             
              
   			 
   		 
		 </tr>  
         </table>
   		 
                
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
							
							
							<!--<tr class="transcriptTable">
								<td>
									
									<xsl:if test="FORM">
										<xsl:for-each select="FORM">
											<xsl:sort select="@xml:lang"/>
											
											<xsl:value-of select="."/>
										</xsl:for-each>
										<br/><br/>
									</xsl:if>
								</td>
								<tr class="transcriptTable">
									<td>
										<xsl:if test="TRANSL">
											<xsl:for-each select="TRANSL">
												<xsl:sort select="@xml:lang"/>
												
												<xsl:value-of select="."/>
											</xsl:for-each>
											
										</xsl:if>
									</td>
								</tr>
							</tr>-->							
							
                        <!-- Cree la numerotation des phrases : Si (phrase numero i)-->
							<xsl:for-each select="S">
								<tr class="transcriptTable">
									<td class="segmentInfo">S<xsl:value-of select="position()"/>
									</td>
									<td class="segmentContent" width="600px">
										
          									
                                                        <a href="javascript:boutonStop()">
                                                        	<img src="../outils/stop.gif" alt="stop"/>
														</a>
														<a href="javascript:playFrom('{position()}')">
															<img src="../outils/play.gif" alt="écouter"/>
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
                                        
									
                                      
                                      <xsl:for-each select="TRANSL[@xml:lang='en' or @lang='en']">
											<div class="translation1">
												<xsl:value-of select="."/>
											</div>
                                          </xsl:for-each> 
                                          
                                    	<xsl:for-each select="TRANSL[@xml:lang='fr' or @lang='fr']">
											<div class="translation2">
												<xsl:value-of select="."/>
											</div>
                                          </xsl:for-each> 
                                    
                                          
                                    	<xsl:for-each select="TRANSL[(@xml:lang!='fr' or @lang!='fr') and (@xml:lang!='en' or @lang!='fr')]">
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

																		<xsl:for-each select="M/FORM">
																					<xsl:value-of select="."/>
																					<xsl:if test="position()!=last()">-</xsl:if>
																				</xsl:for-each>

																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:otherwise>
																
															</xsl:choose>
                                              		</td>
													</tr>
													<tr>
                                                   
														<td class="word_transl">
														
															
															<xsl:choose>
																<xsl:when test="M/TRANSL[@xml:lang or @lang] or TRANSL[@xml:lang or @lang]">
															
															
																	<xsl:if test="M/TRANSL[@xml:lang='en' or @lang='en']">
																		<xsl:for-each select="M/TRANSL[@xml:lang='en' or @lang='en']">
																		<xsl:value-of select="."/>
																		<xsl:if test="position()!=last()">-</xsl:if>
																	</xsl:for-each>
																	<br/>
																</xsl:if>
																<xsl:if test="M/TRANSL[@xml:lang='fr']">
																	<xsl:for-each select="M/TRANSL[@xml:lang='fr' or @lang='fr']">
																		<xsl:value-of select="."/>
																		<xsl:if test="position()!=last()">-</xsl:if>
																	</xsl:for-each>
																	<br/>
																</xsl:if>
                                       						
																	<xsl:if test="not(M/TRANSL[@xml:lang='en' or @lang='en']) and not(M/TRANSL[@xml:lang='fr' or @lang='fr'])">
																		<xsl:for-each select="M/TRANSL">
																			<xsl:value-of select="."/>
																			<xsl:if test="position()!=last()">-</xsl:if>
																		</xsl:for-each>
																		<br/>
																<br/>
															</xsl:if>
																
																	
																	<xsl:if test="TRANSL[@xml:lang='en' or @lang='en']">
																		<xsl:value-of select="TRANSL[@xml:lang='en' or @lang='en']"/>
																	<br/>
																</xsl:if>
																	<xsl:if test="TRANSL[@xml:lang='fr' or @lang='fr']">
																		<xsl:value-of select="TRANSL[@xml:lang='fr' or @lang='fr']"/>
																	<br/>
																</xsl:if>
																	<xsl:if test="not(TRANSL[@xml:lang='en' or @lang='en']) and not(TRANSL[@xml:lang='fr' or @lang='fr'])">
																		<xsl:for-each select="TRANSL">
																			<xsl:value-of select="."/>
																			<xsl:if test="position()!=last()">-</xsl:if>
																		</xsl:for-each>
																		<br/>
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
	
	 <xsl:template match="WORDLIST">
   
		<table width="100%" border="1"  bordercolor="#993300" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<table width="100%" border="1" cellpadding="5" cellspacing="0" bordercolor="#993300" class="it">
						<tbody>
                       <!-- <th>
                        <xsl:for-each select="annot:W/annot:TRANSL[@xml:lang]">
                        <tr><xsl:value-of select="."/></tr>
                        </xsl:for-each>
                        </th>-->
							<xsl:for-each select="W">
								<tr class="transcriptTable">
									<td class="segmentInfo" width="25">W<xsl:value-of select="position()"/></td>
									<td>
                              		
                                        <a href="javascript:boutonStop()">
                                        	<img src="../outils/stop.gif" alt="stop"/>
										</a>
										<a href="javascript:playFrom('{position()}')">
											<img src="../outils/play.gif" alt="écouter"/>
										</a>
                                            
									</td>
									
									<td class="word_form">
									<xsl:for-each select="FORM">
									
										<xsl:sort select="@kindOf"/>
										
										
											<xsl:value-of select="."/><br/>
										
										
									</xsl:for-each>
								</td>
								
									<xsl:for-each select="TRANSL">
										<xsl:sort select="@xml:lang"/>
										<td class="translation">
											<xsl:value-of select="."/>
										</td>
									</xsl:for-each>
									<td class="note">
									<xsl:for-each select="NOTE">
										<!--<xsl:sort select="@xml:lang"/>-->
										
											<xsl:value-of select="@message"/><br/>
										
									</xsl:for-each>
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
		<script type="text/javascript" src="../outils/showhide.js">.</script>
		
		<script type="text/javascript" src="../outils/qtPlayerManager.js">.</script>
        
        </xsl:template>
        
  
   
    
</xsl:stylesheet>
