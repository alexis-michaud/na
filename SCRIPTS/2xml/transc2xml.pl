# transc2xml.pl 
# This is a 'light' version of txt2xml.pl; it inserts basic XML markup in plain-text transcriptions without any glossed documents. The format is that of the Pangloss Collection: see
# Michailovsky, Boyd, Martine Mazaudon, Alexis Michaud, Séverine Guillaume, Alexandre François & Evangelia Adamou. 2014. Documenting and researching endangered languages: the Pangloss Collection. Language Documentation and Conservation 8. 119–135.
#
# The program only treats transcriptions of sentences, in successive lines.
#
# COMMANDLINE: perl -w transc2xml.pl

# Declaration of modules used in this script
use Encode;		# to decode UTF-8
use utf8; 			# UTF-8 coding for Unicode. 
# "UTF-8 treats the first 128 codepoints, 0..127, the same as ASCII. They take only one byte per character. 
# All other characters are encoded as two or more (up to six) bytes using a complex scheme. 
# Fortunately, Perl handles this for us, so we don't have to worry about this."
use strict; 			# All variables must be declared
use warnings; 	

##################################################
################## User parameters #################
##################################################

# indicating language code
my $EthnologueCode = 'TYJ';

# Input file: 
my $input = 'C:\Dropbox\7_Matlab_Perl\perl\temp_test_ajeter\test.txt';

# If there is a file containing times codes for the sentences: indicate below (if yes: value: 1; if no: value: 0)
my $regionslistyn = 1;
my $regionsinfile = 'C:\Dropbox\7_Matlab_Perl\perl\temp_test_ajeter\input_tyj_narrative5_REGIONS.txt';

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
my $textname = my $ortholine = my $formline = my $glossline = my $extraformline = my $transline = my $line = my $word =  my $morph = my $mgloss = my $testchr = my $testchrlong = my $note = my $transline_lg2 = my $glossline_lg2 = my $text_lg1 = my $text_lg2 = my $transline_lg3 = my $text_lg3 = ""; 
my @words = my @glosses = my @morphs = my @mglosses = my @glosses_lg2 = ();

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
open XOUT, ">xmlout.xml";

# Reading first line of text, to serve as title.
$textname=<INPUT>;
# Keeping count of the number of lines of text read, for ease of reference to input text file
$nblines = 1;
# Removing line break.
chomp ($textname);
# and removing 'high point' somehow read by error at beginning of text. That requires some care.
# Removing line feed
chomp($textname);
# Reversing the text name, so that the problematic part at beginning now becomes the end of the string (easier to handle).
$textname = reverse $textname;
# Testing the last character
my $last_chr = chop($textname);
# If the value is 239: this is a telltale sign of the presence of unwanted code. Three characters are then suppressed.
if ( ord($last_chr) == 239) 
		{ $textname = substr($textname, 0, -2); 
		}
# Finally: revert back to normal order of string.
$textname = reverse $textname;

# Writing header of file
## Old version (before 2013):
# print  XOUT "<xml version=\"1.0\"  encoding=\"utf-8\">\n";
# print  XOUT "<xml-stylesheet type=\"text/xsl\" href=\"showText3.xsl\">\n";
# print  XOUT "<TEXT id=\"crdo-NBF_$textname\" xml:lang=\"nbf\">\n";
# print  XOUT "<HEADER>\n";
# print  XOUT "<TITLE xml:lang=\"fr\">$textname</TITLE>\n";
# print  XOUT "<SOUNDFILE href=\"xxx.wav\"/>\n";
# print  XOUT "</HEADER>\n";

# Writing header of file. The information in the header allows the resulting file to be read locally for checking before it is placed online.
print  XOUT "<xml version=\"1.0\"  encoding=\"utf-8\">\n";
print  XOUT "<xml-stylesheet type=\"text/xsl\" href=\"view_text.xsl\">\n";
print  XOUT "<TEXT id=\"crdo-$EthnologueCode"."_$textname\" xml:lang=\"$EthnologueCode\">\n";
print  XOUT "<HEADER>\n";
print  XOUT "<SOUNDFILE  href=\"../audio/crdo-$EthnologueCode"."_$textname.wav\"</SOUNDFILE>\n";
print  XOUT "<TITLE xml:lang=\"eng\">$textname</TITLE>\n";

print  XOUT "</HEADER>\n";
# Jump empty line between title and contents
$ortholine=<INPUT>;

# Treat glossed lines. Count starts at 1.
while ($ortholine=<INPUT>) {
		# incrementing counter of sentences in output file
		$textlineno++;
		# formatting glossed-line count
		$sno = sprintf ("%03u", $textlineno);
		# incrementing counter of lines read in source file
		$nblines++;		
		# removing end-of-line at end of input line
		chomp $ortholine;
		# replacing angle brackets < > by an explicit description: even the corresponding XML formulas cause problems with the SoundIndex software, so other labels are used. Note: the g at the end of the expression tells Perl to replace globally (=as many times as there are occurrences of the pattern).
		# $ortholine =~ s{<}{&lt;}g;
		# $ortholine =~ s{>}{&gt;}g;
		$ortholine =~ s{<}{CHEVRONGAUCHE}g;
		$ortholine =~ s{>}{CHEVRONDROIT}g;

		# writing the sentence header into the XML file
		print  XOUT "<S id=\"$textname", "_S$sno\">\n\t";

		# Adding time alignment, if provided
		if ($regionslistyn == 1)
		{
			$regionsline = <REGIONS>;
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
			
		# Printing out the form of the sentence
		print  XOUT "\t<FORM kindOf=\"ortho\">$ortholine</FORM>\n";
		print XOUT "</S>\n";
		$nblines++;	
}

print XOUT "</TEXT>\n";
unlink ("foobar");

close (INPUT);
close (REGIONS);