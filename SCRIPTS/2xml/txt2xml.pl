# txt2xml.pl 
# Inserts XML markup in plain-text glossed documents. The format is that of the Pangloss Collection: see
# http://purl.org/poi/crdo.vjf.cnrs.fr/cocoon-49aefa90-8c1f-3ba8-a099-0ebefc6a2aa7
# https://pangloss.cnrs.fr/dtd/
# For more information about the Pangloss Collection:
# Michailovsky, Boyd, Martine Mazaudon, Alexis Michaud, Séverine Guillaume, 
# Alexandre François & Evangelia Adamou. 2014. "Documenting and researching endangered languages: 
# the Pangloss Collection." Language Documentation and Conservation 8. 119-135.
#
# This script was created by Alexis Michaud, taking up portions of Boyd Michailovsky's chk_spc6_new.pl
# (which was created in 2008 or earlier). "The LACITO project has benefited from open-source software, and all
# programs developed by the project are open-source. As more projects adhere to common standards, we
# expect that distributed development and interoperability of software for field linguistics and other speci-
# alities will become a reality." (Conclusion of: Jacobson, Michel, Boyd Michailovsky & John B. Lowe. 2001. Linguistic documents synchronizing sound and text. Speech Communication 33 [special issue: "Speech Annotation and Corpus Tools"]. 79–96, page 92.)
#
# This is version 9 of the script, produced in 2024. (Version 1 was produced in 2011.) New to version 9:
# time codes can be indicated in the same .txt file as the annotation, using a simple <beginning end> syntax
# (separator: space), thus:
# 406.79 414.70
#
# COMMANDLINE: perl txt2xml.pl
# Messages appear on screen.
# The program treats groups of lines in fixed order. 
# - transcription of sentence
# - words separated by spaces and/or tabs
# - gloss in up to three languages (e.g. English, Chinese and French)
# - notes: any paragraph starting with a percent sign % is a note. One possible setting consists in indicating the language code (two-letter) of the comment at the beginning of that line, right after the % sign, and separated from the following text by a space, as in the following example: 
## %zh 英雄的名字，/tsʰo˩ze˧ɭɯ˥ɣɯ˧/，F1发作tsʰo˩ze˧li˥ŋe˧
#Any paragraph beginning with three % signs (%%%) is copied as is into the XML: for instance if the user already compiled time codes in the final format, such as <AUDIO start="108.659" end="109.002"/>
# - translation of sentence in up to three languages
# Options concerning the number of languages, and their language code, must be set within the script below.
# Here is a sample of what the input should look like, including the header containing a short title, which is used in the identifier of each sentence in the XML.
#
# MUSHROOMS
#
# ə˧ʝi˧-ʂɯ˥ʝi˩-dʑo˩, | ə˩-gi˩! | mmm... dʑɯ˩nɑ˩mi˩-ʁo˩ ʈʂʰɯ˩-qo˥-dʑo˩, | mo˧-ʈʂʰɯ˧, | ə˩-gi˩! |
# %/mo˧-ʈʂʰɯ˧/: tons vérifiés; on peut également dire: /mo˧-ʈʂʰɯ˥/.
# Autrefois, n'est-ce pas! Sur la montagne, les champignons, n'est-ce pas! (=Je vais parler d'un des thèmes de la vie dans le temps, n'est-ce pas! Les champignons qu'on trouve sur la montagne, voilà de quoi je vais parler!)
# 在过去，是吗！在高山上，菌子的话……是吧！
#
# zo˩no˥, | mo˧-ʈʂʰɯ˧-dʑo˩, | qʰv̩˧-ɬi˧mi˧-kʰɤ˧ʂɯ˧ | tʰv̩˧-kv̩˧-ze˥-mæ˩! |
# %On pourrait également dire /mo˧-ʈʂʰɯ˥-dʑo˩/. Sur l'enregistrement, la réalisation est M.M.L: /mo˧-ʈʂʰɯ˧-dʑo˩/.
# Eh bien, les champignons, ils poussent à partir du sixième mois!
# 那么，菌子的话，六月份开始，会有了！
#
# Wish-list of further improvements to the script: 
# - checking that there are no punctuation marks inside word glosses (spaces, commas...)
# - sanity check on contents: checking that time codes are figures (and do not contain other symbols); checking that there is no blatant mismatch between language tags and contents, and thus, that there is no missing line.


# Declaration of modules used in this script
use Encode qw(encode decode);		# to decode UTF-8
use utf8; 			# UTF-8 coding for Unicode. 
# "UTF-8 treats the first 128 codepoints, 0..127, the same as ASCII. They take only one byte per character. 
# All other characters are encoded as two or more (up to six) bytes using a complex scheme. 
# Fortunately, Perl handles this for us, so we don't have to worry about this."
use strict; 			# All variables must be declared
use warnings; 

##################################################
################## User parameters #################
##################################################

## indicating language code
# For Yongning Na: my $EthnologueCode = 'NRU';
my $EthnologueCode = 'NRU';
# Selecting whether there are glosses at the word level, in languages 1 and 2 and 3 (e.g. English, French and Chinese)  (if yes: value: 1; if no: value: 0)
my $gloss_lg1 = 0;
my $gloss_lg2 = 0;
my $gloss_lg3 = 0;
# Selecting whether there are translations of the entire sentence (if yes: value: 1; if no: value: 0), for languages 2 and 3. (There has to be at least 1 translation for the sentence level.) 
my $transl_lg2 = 1;
my $transl_lg3 = 0;
# Selecting whether there is an extra line of transcription: orthography, narrow phonetic notation... (if yes: value: 1; if no: value: 0)
my $extratranscrlevel = 0;
# The type of transcriptions is currently set inside this script, by writing <phono>, <ortho>, <phonemic> or <phonetic> in the relevant lines: for instance substituting <phonemic> for <phonetic> in the line below: 
##print  XOUT "\t<FORM kindOf=\"phonetic\">$extraformline</FORM>\n";

# Indicating whether notes in the source file have an associated language indicated (thus: %fr Une note en français, %en A note in English, %zh 中国话注释). If so: value set at one. Otherwise: zero.
my $note_lg_code_yn = 1;

### Input file:
## Syntax on GNU Linux systems:
my $input = '/home/pakazo/Dropbox/GitHub/na/TEXT/F4/en_prep/crdo-NRU_F4_BENEVOLENCE.txt';
#my $input = '/home/pakazo/Dropbox/GitHub/na/TEXT/F4/en_prep/crdo-NRU_F4_SISTER5.txt';
## Syntax on Windows:
#my $input = '\home\pakazo\Dropbox\GitHub\na\TEXT\F4\en_prep\crdo-NRU_F4_SISTER5.txt';

# If there is a file containing times codes for the sentences: indicate below (if yes: value: 1; if no: value: 0)
## Syntax on GNU Linux:
my $regionslistyn = 1;
my $regionsinfile = '/home/pakazo/Dropbox/GitHub/na/TEXT/F4/en_prep/crdo-NRU_F4_BENEVOLENCE_REGIONS.txt';
## Syntax on Windows:
#my $regionsinfile = 'C:\Dropbox\Alexis_Roselle_shared\MothersBirthday\MothersBirthday_REGIONS.txt';

# Output file: 
my $outputfile = '/home/pakazo/Dropbox/GitHub/na/TEXT/F4/en_prep/crdo-NRU_F4_BENEVOLENCE.xml';

# Declaration of a function: converting from hh::mm::ss,ms (e.g. 00:00:01,160) to seconds. 
sub RegionsToSec {
	my($time) = @_; #value sent in
	$time = reverse($time);
	my $n = 0;
	my $seconds = "";
	my $chrfin = "";
	# milliseconds:
	while ($n<3) {
		$n++;
		$chrfin = chop($time);
		$seconds = "$chrfin$seconds"; 
	}
	# seconds: replacing the full stop by a colon
	$chrfin = chop($time); 
	$seconds = ".$seconds"; 
	# then adding the 2 figures for seconds
	$chrfin = chop($time); 
	$seconds = "$chrfin$seconds"; 
	$chrfin = chop($time); 
	$seconds = "$chrfin$seconds"; 

	# minutes : 
	$chrfin = chop($time); 
	my $mn2 = chop($time);
	my $mn1 = chop($time);
	my $mn = "$mn1$mn2";
	# Conversion from minutes to seconds
	$mn = (60*$mn);

	# Hours: 
	$chrfin = chop($time); 
	my $h2 = chop($time);
	my $h1 = chop($time);
	my $h = "$h1$h2";
	# Conversion from hours to seconds
	$h = (3600*$h);
	# Sum
	$time = ($h + $mn + $seconds);
	# Returning this value
	return($time);
}

# initializing variables
my $textlineno = my $sno = my $wordsnb = my $i = my $nblines = 0;
my $textname = my $ortholine = my $formline = my $glossline = my $extraformline = my $transline = my $line = my $word =  my $morph = my $mgloss = my $testchr = my $testchr2 = my $testchrlong = my $note = my $transline_lg2 = my $glossline_lg2 = my $glossline_lg3 = my $text_lg1 = my $text_lg2 = my $transline_lg3 = my $text_lg3 = "";
my @words = my @glosses = my @morphs = my @mglosses = my @glosses_lg2 = my @glosses_lg3 = ();

my $regionsline = ();
my $timebegin = my $timeend = 0;


# opening regions list
if ($regionslistyn == 1) 
	{
	open (REGIONS, "$regionsinfile") or die "Can't open $regionsinfile: $!";     # open input time (regions) file for reading
	# Reading first lines of Regions file: the first 4 lines are a header.
	<REGIONS>;
	<REGIONS>;
	<REGIONS>;
	<REGIONS>;
	}

open (INPUT, "$input") or die "Can't open $input: $!";     # open input vocabulary file for reading
# opening a text file for output
open (XOUT,">$outputfile");

# Reading first line of text, to serve as title.
$textname=<INPUT>;
# replacing angle brackets < > by the corresponding XML formulas (otherwise they result in messy markup). Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
$textname =~ s{<}{&lt;}g;
$textname =~ s{>}{&gt;}g;
# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
$textname =~ s{"}{''}g;

# Keeping count of the number of lines of text read, for ease of reference to input text file
$nblines++;		

# Removing line break.
chomp ($textname);

# Writing header of file
## Old version (before 2013):
# print  XOUT "<xml version=\"1.0\"  encoding=\"utf-8\">\n";
# print  XOUT "<xml-stylesheet type=\"text/xsl\" href=\"showText3.xsl\">\n";
# print  XOUT "<TEXT id=\"crdo-NBF_$textname\" xml:lang=\"nbf\">\n";
# print  XOUT "<HEADER>\n";
# print  XOUT "<TITLE xml:lang=\"fr\">$textname</TITLE>\n";
# print  XOUT "<SOUNDFILE href=\"xxx.wav\"/>\n";
# print  XOUT "</HEADER>\n";

# New version (2013): 
# print  XOUT "<xml-stylesheet type=\"text/xsl\" href=\"view_text.xsl\">\n";
print  XOUT "<?xml version=\"1.0\"  encoding=\"utf-8\"?>\n";
print  XOUT "<?xml-stylesheet type=\"text/xsl\" href=\"view_text.xsl\"?>\n";
print  XOUT "<TEXT id=\"crdo-$EthnologueCode"."_$textname\" xml:lang=\"$EthnologueCode\">\n";
print  XOUT "<HEADER>\n";
print  XOUT "<SOUNDFILE  href=\"../audio/crdo-$EthnologueCode"."_$textname.wav\"/>\n";
print  XOUT "<TITLE xml:lang=\"en\">$textname</TITLE>\n";

print  XOUT "</HEADER>\n";
# Treat glossed lines. Count starts at 1.
while ($line=<INPUT>) {
		# incrementing counter of lines read in source file
		$nblines++;		
		# incrementing counter of sentences in output file
		$textlineno++;
		# formatting glossed-line count
		$sno = sprintf ("%03u", $textlineno);
		print "Treating S $sno.\n";
		$ortholine=<INPUT>;#full sentence ("orthography")
		# removing end-of-line at end of input line
		chomp $ortholine;
		# replacing angle brackets < > by an explicit description: even the corresponding XML formulas cause problems with the SoundIndex software, so other labels are used. Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
		$ortholine =~ s{<}{&lt;}g;
		$ortholine =~ s{>}{&gt;}g;
		# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
		$ortholine =~ s{"}{''}g;

		# writing the sentence header into the XML file
		print  XOUT "<S id=\"$textname"."_S$sno\">\n\t";
		
		# Adding time alignment, if provided
		if ($regionslistyn == 1)
		{
			print "Reading region from RegionsList.\n";
			$regionsline = <REGIONS>;
			print "Regions line for S $sno: $regionsline \n";
			#Parsing from the end, and recovering two values. If parsing from beginning: problem with lines whose tags include spaces.
			$regionsline = reverse($regionsline);
			my @regions = split /\s+/, $regionsline;
			$timebegin = $regions[3];
			$timeend = $regions[2];
			
			# Calling function to convert times from Regions List format to seconds
			$timebegin = &RegionsToSec ($timebegin);
			$timeend = &RegionsToSec ($timeend);
			print XOUT "<AUDIO start=\"$timebegin\" end=\"$timeend\"\/>\n";
		}
		else
		{
			print "Reading time codes from single input text file.\n";
			$regionsline = <INPUT>;
			#Parsing from the end, and recovering two values. If parsing from beginning: problem with lines whose tags include spaces.
			my @regions = split /\s/, $regionsline;
			$timebegin = $regions[0];
			$timeend = $regions[1];

			print XOUT "<AUDIO start=\"$timebegin\" end=\"$timeend\"\/>\n";
		}

		# Printing out the form of the sentence. Modify type as necessary: ortho, phono...
		print  XOUT "\t<FORM kindOf=\"phono\">$ortholine</FORM>\n";
		
		# if there is an extra level of transcription: integrating it, with special mention
		if ($extratranscrlevel == 1) {
			$extraformline=<INPUT>; # extra level of transcription
			# incrementing counter of lines read in source file
			$nblines++;		
			chomp $extraformline;
			# replacing angle brackets < > by an explicit description: even the corresponding XML formulas cause problems with the SoundIndex software, so other labels are used. Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
			$extraformline =~ s{<}{&lt;}g;
			$extraformline =~ s{>}{&gt;}g;
			# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
			$extraformline =~ s{"}{''}g;
			print  XOUT "\t<FORM kindOf=\"phonetic\">$extraformline</FORM>\n";
		} # end of condition on presence of extra level of transcription
		
		if ($gloss_lg1 == 1) {
			$formline=<INPUT>;#reading the line that contains the morphophonological breakup into words
			# incrementing counter of lines read in source file
			$nblines++;		
			# replacing angle brackets < > by the corresponding XML formulas (otherwise they result in messy markup). Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
			$formline =~ s{<}{&lt;}g;
			$formline =~ s{>}{&gt;}g;
			# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
			$formline =~ s{"}{''}g;
			chomp $formline;
			
			$glossline=<INPUT>;	# French glosses
			# incrementing counter of lines read in source file
			$nblines++;		
			chomp $glossline;
			# replacing angle brackets < > by the corresponding XML formulas (otherwise they result in messy markup). Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
			$glossline =~ s{<}{&lt;}g;
			$glossline =~ s{>}{&gt;}g;
			# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
			$glossline =~ s{"}{''}g;

			# 2nd language glosses: only if the $gloss_lg2 variable was set to 1 above.
			if ($gloss_lg2 == 1) {
				$glossline_lg2=<INPUT>;# Chinese glosses
				# incrementing counter of lines read in source file
				$nblines++;		
				chomp $glossline_lg2;
				# replacing angle brackets < > by the corresponding XML formulas (otherwise they result in messy markup). Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
				$glossline_lg2 =~ s{<}{&lt;}g;
				$glossline_lg2 =~ s{>}{&gt;}g;
				# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
				$glossline_lg2 =~ s{"}{''}g;

			# parsing this line (after replacing spaces by tabs, in case the user mistakenly used spaces instead of tabs)
				$glossline_lg2 =~ s/\s/\t/g;
				@glosses_lg2 = split /\t+/, $glossline_lg2;
			} # end of condition on presence of Chinese glosses

			
			# 3rd language glosses: only if the $gloss_lg3 variable was set to 1 above.
			if ($gloss_lg3 == 1) {
				$glossline_lg3=<INPUT>;# Chinese glosses
				$nblines++;		
				chomp $glossline_lg3;
				# replacing angle brackets < > by the corresponding XML formulas (otherwise they result in messy markup). Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
				$glossline_lg3 =~ s{<}{&lt;}g;
				$glossline_lg3 =~ s{>}{&gt;}g;
				# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
				$glossline_lg3 =~ s{"}{''}g;

			# parsing this line (after replacing spaces by tabs, in case the user mistakenly used spaces instead of tabs)
				$glossline_lg3 =~ s/\s/\t/g;
				@glosses_lg3 = split /\t+/, $glossline_lg3;
			} # end of condition on presence of Chinese glosses
		} # end of condition on presence of word-level glosses
		
		$transline=<INPUT>;# French translation of sentence -- or comment
		$nblines++; 		
		chomp $transline;
		# replacing angle brackets < > by the corresponding XML formulas (otherwise they result in messy markup). Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
		$transline =~ s{<}{&lt;}g;
		$transline =~ s{>}{&gt;}g;
		# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
		$transline =~ s{"}{''}g;

		# Loop for the case in which there are comments. At this point there may be any number of comments. Furthermore, any paragraph beginning with three % signs is copied as is into the XML: for instance if the user already compiled time codes in the final format, such as <AUDIO start="108.659" end="109.002"/>
		# Procedure: retrieve first character in line and see if it's a %.
		$testchr = substr($transline,0,1);
		while ($testchr eq '%') {
			# substracting the first character of that line: the %. This is done inelegantly.
			$note = reverse $transline;
			chop $note;
			$note=reverse $note;
			# Testing whether all three first characters are %.
			$testchrlong = substr($transline,0,3);
			if ($testchrlong eq '%%%') {
				# subtracting the first three characters
				$note = reverse $transline;
				chop $note;
				chop $note;
				chop $note;
				$note=reverse $note;
				# Writing the note into the output XML file.
				print  XOUT "\t$note\n";
						}
			else {
				# Writing the note into the XML file.

				# If the author indicated the language then this is reflected in the XML. Otherwise, the language is hard-coded for all notes.
				if ($note_lg_code_yn == 1) {
					# getting the code: two first letters
					my $note_lg_code = substr($transline,1,2);
					# removing those from the string; also the preceding % sign and the following space. This is done inelegantly.
					$note = reverse $transline;
					chop $note;
					chop $note;
					chop $note;
					chop $note;
					$note=reverse $note;
					# replacing angle brackets < > by the corresponding XML formulas (otherwise they result in messy markup). Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
					$note =~ s{<}{&lt;}g;
					$note =~ s{>}{&gt;}g;
					# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
					$note =~ s{"}{''}g;
					# printing to XML	
					print  XOUT "\t<NOTE xml:lang=\"$note_lg_code\" message = \"$note\"/>\n";
				}
				else {
					# removing an initial space from the string. This is done inelegantly.
					$testchr2 = substr($transline,0,1);
					if ($testchr2 eq '\s') {
						# substracting the first character of that line: the space. This is done inelegantly.
						$note = reverse $transline;
						chop $note;
						$note=reverse $note;
						}
					# printing the note
					print  XOUT "\t<NOTE xml:lang=\"fr\" message = \"$note\"/>\n";
				}
			}
			# Reading a new line, and deleting its final return
			$transline=<INPUT>;
			$nblines++;
			chomp $transline;
			$testchr = substr($transline,0,1);
		}
		# replacing angle brackets < > by the corresponding XML formulas (otherwise they result in messy markup). Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
		$transline =~ s{<}{&lt;}g;
		$transline =~ s{>}{&gt;}g;
		# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
		$transline =~ s{"}{''}g;
		# Writing out the translation line. It is assumed that the language is French. Substitute 'en', etc for 'fr' in the line below, as necessary. xxxx
		print  XOUT "\t<TRANSL xml:lang=\"fr\">$transline</TRANSL>\n";
		
#		print  XOUT "\t<TRANSL xml:lang=\"zh\">$transline</TRANSL>\n";
		# For Pianding Naxi data: the line before the Chinese translation is orthography (Naxi Pinyin).
#		print  XOUT "\t<FORM kindOf=\"ortho\">$transline</FORM>\n";
		# adding the translation of the sentence to a translation of the whole text, to be manually edited later and to serve as a free translation at the text level
		$text_lg1 = "$text_lg1$transline ";

		# Chinese translation of sentence: only if the $transl_lg2 variable was set to 1 above.
		if ($transl_lg2 == 1) {
			$transline_lg2=<INPUT>;# Chinese translation of sentence
			$nblines++;	
			chomp $transline_lg2;
			# replacing angle brackets < > by the corresponding XML formulas (otherwise they result in messy markup). Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
			$transline_lg2 =~ s{<}{&lt;}g;
			$transline_lg2 =~ s{>}{&gt;}g;
			# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
			$transline_lg2 =~ s{"}{''}g;

			print  XOUT "\t<TRANSL xml:lang=\"zh\">$transline_lg2</TRANSL>\n";      # "zh" for Chinese xxxx
			# adding the translation of the sentence to a translation of the whole text, to be manually edited later and to serve as a free translation at the text level
			$text_lg2 = "$text_lg2$transline_lg2\n";
		}
		
		# English translation of sentence: only if the $transl_lg3 variable was set to 1 above.
		if ($transl_lg3 == 1) {
			$transline_lg3=<INPUT>;# English translation of sentence
			$nblines++;	
			chomp $transline_lg3;
			# replacing angle brackets < > by the corresponding XML formulas (otherwise they result in messy markup). Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
			$transline_lg3 =~ s{<}{&lt;}g;
			$transline_lg3 =~ s{>}{&gt;}g;
			# Likewise, any " symbol in the message must be replaced, otherwise it will count as end of message.
			$transline_lg3 =~ s{"}{''}g;

			print  XOUT "\t<TRANSL xml:lang=\"en\">$transline_lg3</TRANSL>\n";
			# adding the translation of the sentence to a translation of the whole text, to be manually edited later and to serve as a free translation at the text level
			$text_lg3 = "$text_lg3$transline_lg3\n";
		}

		# Splitting the lines with the words and their glosses. First, tabs are substituted for spaces: this takes charge of cases where the user has not used a tab between two words, which are thus separated only by a space (or several spaces) and is not parsed properly.
		$formline =~ s/\s/\t/g;
		$glossline =~ s/\s/\t/g;
		@words = split /\t+/, $formline;
		@glosses = split /\t+/, $glossline;
		if (@words != @glosses) {
			print "spaces mismatch line $textlineno  corresponding to input file line $nblines \n";
			print XOUT "@words\n";
			print XOUT "@glosses\n";
		}
		else{
			$wordsnb = @words; 
			print "Number of words in sentence $textlineno: $wordsnb \n";
			# Loop for providing the glosses of words
			while ($i < $wordsnb) {
					print XOUT "\t\t<W>\n";
					print XOUT "\t\t\t<FORM>$words[$i]</FORM>\n"; 
					print XOUT  "\t\t\t<TRANSL xml:lang=\"fr\">$glosses[$i]</TRANSL>\n";
					if ($gloss_lg2 == 1) {
						print XOUT  "\t\t\t<TRANSL xml:lang=\"en\">$glosses_lg2[$i]</TRANSL>\n";
					}
					if ($gloss_lg3 == 1) {
						print XOUT  "\t\t\t<TRANSL xml:lang=\"zh\">$glosses_lg3[$i]</TRANSL>\n";
					}
					print XOUT "\t\t</W>\n";
					$i++;
			}
			# Setting counter back to zero for next sentence
			$i = 0;
		}
		print XOUT "</S>\n";
		$nblines++;	
}
# Adding free translation of entire text at end
print XOUT  "\t<TRANSL xml:lang=\"fr\">$text_lg1</TRANSL>\n";
print XOUT  "\t<TRANSL xml:lang=\"zh\">$text_lg2</TRANSL>\n";
print XOUT  "\t<TRANSL xml:lang=\"en\">$text_lg3</TRANSL>\n";
print XOUT "</TEXT>\n";
unlink ("foobar");

close (INPUT);
close (REGIONS);
