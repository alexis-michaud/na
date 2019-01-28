# Program for generating surface-phonological tone patterns for Yongning Na. Reference speaker: F4. Data from fieldwork 2006-2012. Contact: alexis.michaud@cnrs.fr
# Begun in September 2011.

# This program is based on a set of functions, which serve to: 
# (i) retrieve the tone pattern for a given combination (numeral plus classifier, object plus verb...) through table lookup; the information on tonal morphosyntax is encoded within the program; 
# (ii) apply an abstract tone pattern to a string of syllables, to yield a surface-phonological string.

# Declaration of modules used in this script
use Encode;		# to decode UTF-8
use encoding 'utf-8-strict';
# Previously used simply the following declaration: 
# use utf8; 			# This should in principle suffice for ensuring UTF-8 coding for Unicode characters. But there were problems of malformed UTF-8 characters (missing 1 bit). The strict coding fixed this problem. 
# "UTF-8 treats the first 128 codepoints, 0..127, the same as ASCII. They take only one byte per character. 
# All other characters are encoded as two or more (up to six) bytes using a complex scheme. 
# Fortunately, Perl handles this for us, so we don't have to worry about this."
use strict; 			# declaration of all variables	
use warnings; 
use Switch; 		# for sets of conditions; used to avoid a large number of if/elsif/elsif... 

###############################################################################################
# Declaration of a function that applies a tone pattern to a string of syllables. UtoS: Underlying tone to Surface tone string. 
# To call the function: 
# &UtoS($stringofsyllables, $tonalcat);
sub UtoS {
	open XOUT, ">log_UtoS.txt"; 		# For testing purposes: messages are written into a log file.
	# declaring the variable that will host the output. It is a scalar, containing all variants. Name: $output. The variable $phrase hosts one of the variants that go to make the final output. The list @U_vars is for underlying tones.
	my $output = ''; my $phrase = ''; my @U_vars = ();
	# declaring lists for syllables making up the nucleus
	my @syll_part_one = (); my @syll_part_two = ();

	my $segments = $_[0]; 	#first value sent in: the string of syllables. Polysyllabic input should be divided by means of symbols indicating junctures. The symbol # precedes suffixes; the symbol $ precedes final particles; and the symbol ° indicates a juncture within a phrase: the boundary between the two components of a compound noun; the boundary between tens and units in numeral-plus-classifier phrases... Thus: FirstPartOfCoreElement°SecondPartOfCoreElement#Affixes$FinalParticles. Simple syllable boundaries are indicated by dots. 
	#Examples: 
	# 'ɲi.tsi°ɖɯ.kʰwɤ', for the phrase 'twenty-one pieces (of something)'. Here the ° symbol stands for the boundary between tens and units, which plays a role in tonal assignment.
	# 'bo°sɤ' for 'pig blood'; the ° stands for the boundary between determiner and determined.
	# 'gi.zɯ' for 'little brother'; just a syllabic boundary.

	# Removing white spaces: 
	$segments=~s/\s//g;
	
	# Step 1: dividing input syllabic string into syllables, taking note of junctures. There are at most ONE EACH of the symbols °, # and $; as a consequence, split /°/ etc is used, and not split /°+/ etc.

	# First the particles are separated from the rest.
	my @array_of_particles = ();
	my @firstdiv = split /\$/, $segments;
	#Checking whether there are any. The size of the array is: $#firstdiv + 1, since Perl counts from zero.
	if (($#firstdiv + 1) == 2) {
		# Full array of particles:
		@array_of_particles = split /\./, $firstdiv[1];
		# In the final phrase, particles must be preceded by a space. In order to obtain this, a roundabout procedure must be adopted, since additional spaces are suppressed towards the end of the treatment of the entire expression. A special symbol is added, and later transformed into a space.
		for (my $m=0; $m < $#array_of_particles + 1; $m++) {
			$array_of_particles[$m] = "è$array_of_particles[$m]";
		}
	}
	elsif (($#firstdiv + 1) > 2) {
		error('Error in input: there must be at most one $ symbol, separating final particles from what precedes.');
	}

	# Next, separating suffixes.
	my $suffixes = '';
	my @seconddiv = split /\#/, $firstdiv[0]; my @array_of_suffixes = ();
	#Checking whether there are any:
	if (($#seconddiv + 1) == 2) {
		$suffixes = $seconddiv[1];
		# Full array of suffixes: 
		@array_of_suffixes = split /\./, $suffixes;
		my $nb_of_suffixes = $#array_of_suffixes;
		# Adding a hyphen to each of the suffixes, following current transcription conventions.
		# As for the juncture transcribed as °, it corresponds to a syntactic juncture in some but not all cases: in the case of a compound noun, it is a syntactic juncture; in the case of a numeral-plus-classifier phrase, when it falls mid-way through the numeral, it is not.
		for (my $n=0; $n < $nb_of_suffixes + 1; $n++) {
			$array_of_suffixes[$n] = "\-$array_of_suffixes[$n]";
		}
		print XOUT "after addition of hyphen: @array_of_suffixes\n";

		# Placing the rest of the string in the $segments variable
		$segments = $seconddiv[0];
	}
	elsif (($#seconddiv + 1) > 2) {
		error('Error in input: there must be at most one # symbol, separating suffixes from the root.');
	}
	
	# Finally, distinguishing the two halves of the lexical word if there is a ° in the input.
	my $complexlexical = 0; # Valeur à zéro si 1 seule partie; s'il y a une deuxième partie, cette variable prend la valeur n, indice de la première syllabe de la 2e partie.
	my @thirddiv = split /°/, $segments;
	print XOUT "Third division from input: @thirddiv\n";
	my @nucleus = (); 
	#Checking whether there is such a division:
	if (($#thirddiv + 1) == 2) {
		@syll_part_one = split /\./, $thirddiv[0];
		$complexlexical = $#syll_part_one + 1;
		print XOUT "Beginning of second half of the nucleus: at $complexlexical\n";
		@syll_part_two = split /\./, $thirddiv[1];
		# In earlier versions of the program, a hyphen was added to the beginning of the second part, thus: 
		# $syll_part_two[0] = "\-$syll_part_two[0]";
		#But there is no systematic correspondence between the ° juncture in the final surface-phonological transcription and a syntactic boundary. So necessary hyphens are now added in the input to the function, not within the function, which simply does the phonological job.
		
		# Recreating full string of syllables
		@nucleus = (@syll_part_one, @syll_part_two);
		print XOUT "All the syllables of the nucleus: @nucleus\n";
	}
	elsif (($#thirddiv + 1) == 1) {
		@nucleus = split /\./, $thirddiv[0];
	}
	elsif (($#thirddiv + 1) > 2) {
		error('Error in input: there must be at most one ° symbol, distinguishing the two parts of a complex word/phrase.');
	}
	
	# Creating a list with all the syllables, which at this point have no tones. It is kept unchanged in what follows, so as to serve again for the other variants. 
	my @full_string_notone = (@nucleus, @array_of_suffixes, @array_of_particles);
	
	# From this, the index of the first syllable following the nucleus can be computed. 
	my $indexpostlex = ''; my $indexofparticles = '';
	if ($#full_string_notone > $#nucleus) {
		$indexpostlex = $#nucleus + 1 ;
		print XOUT "The post-nucleus portion begins at index $indexpostlex\n";
	}
	if ($#full_string_notone > $#nucleus+$#array_of_suffixes +1) {
		print XOUT "Suffixes: @array_of_suffixes\n";
		print XOUT "Last index of suffix: $#array_of_suffixes\n";
		$indexofparticles = $indexpostlex + $#array_of_suffixes + 1 ;
		print XOUT "The particles begin at index $indexofparticles\n";
	}

	########################################################################################################
	# Step 2: dividing input tone into its elements. This includes : (i) variants, separated by slashes; at most 2 variants in the data observed so far, and hence in the present version of the script; (ii) for each variant: at most 2 components separated by °, e.g.: L#°#H / L#°.
	my $U = $_[1]; 	#second value sent in: type in which tonal category the classifier belongs. U for Underlying. E.g. 'H$', '#H', 'L+MH#'; includes specifications on anchoring respective to junctures, e.g. 'L#°'.
	# First any spaces in the expression are removed. 
	$U=~s/\s//g;
	#Then the variants are separated.
	my $variant_yn = 0; 
	# Attempt to fix a bug by reinitializing @U_vars
	@U_vars = ();
	@U_vars = split /\//, $U; 	# variable name @vars : for VARiant-S
	if (($#U_vars + 1) > 2) {
		error('Error in input: there must be at most one slash /, separating variants.');
	}
	# test: 
	print XOUT "Variants: @U_vars\n";
	print XOUT "Index of last variant (starting from zero): $#U_vars\n";

	#Opening a loop for the treatment of the expression(s) (all called "variants" here, for the sake of simplicity).
	#The phrase $#U_vars refers to the length of @U_vars.
	for (my $i=0; $i < ($#U_vars + 1); $i++) {
		my @full_string = @full_string_notone;
		my $Utreatedvariant = $U_vars[$i];
		print XOUT "Treated variant: $Utreatedvariant\n";
		# dividing the expression if it comprises a '°' sign
		my $dividedtone_yn = 0;
		if ( $Utreatedvariant =~ /\°/ ) { $dividedtone_yn = 1; }
		my @U_halves = split /\°/, $Utreatedvariant; 	
		print XOUT "Found the following tonal halves (separated by \°): @U_halves\n";
		
		# Opening a loop for the treatment of halves.
		my @treatedindices = ();
		for (my $j=0; $j < ($#U_halves + 1); $j++) {
			my $U_treatedhalf = $U_halves[$j];
			print XOUT "Treating tone portion $U_treatedhalf\n";
			# First part:
			if ($j == 0) {
				# If there is no indication of a division of the tone expression (symbol: °): the expression is treated as a whole, and the indices cover the whole nucleus
				if (($#U_halves == 0) && ($dividedtone_yn == 0)) {
					@treatedindices = (0..$#nucleus);
					print XOUT "Entire expression makes up one tonal unit. Indices: @treatedindices\n";
				}
				else {
					@treatedindices = (0..$#syll_part_one);
					print XOUT "Expression consists of two parts. Part one: $#syll_part_one\n";
					print XOUT "syllables of part 1: @syll_part_one\n";
				}
				print XOUT "Treating syllables of indices @treatedindices\n";
			}
			# Second part:
			elsif ($j == 1) {
				@treatedindices = ($complexlexical..$complexlexical + $#syll_part_two);
				print XOUT "Treating syllables of indices @treatedindices\n";
				# Technical adjustment at this point: if there is a tonal assignment for the second part of the expression (i.e. if the $U_treatedhalf variable is not empty), that part of the expression must be stripped of any tones that it received from previous assignment. 
				my $temp = '';
				if ($U_treatedhalf ne '') {
					# if there are tone marks: if there is an H, and a further specification for the second half, this is a mistake, as a H tone projected onto the second part of the word forces following L tones.
					$temp = $full_string[$treatedindices[$#treatedindices]];
					print XOUT "Syllable that is going to be tested for the presence of tones: $temp\n";
					$temp = chop($temp);
					if ($temp eq '˥') {
						error('Error: incorrect tonal input. A H tone is projected onto the last syllable; therefore there should be no distinct underlying tonal specification for that part of the phrase.')
					}
					elsif ($temp eq '˩') {
						# Removing all tone marks, by removing last character of each syllable:
						print XOUT "Before removal of tone marks: @full_string[@treatedindices]\n";
						chop(@full_string[@treatedindices]);
		#				@full_string[@treatedindices] =~ s /˩^˧^˥//g ;
		#				@full_string[@treatedindices] =~ s{˩}{}g;
						print XOUT "After removal of tone marks: @full_string[@treatedindices]\n";				
					}
				}
			}
						
			# At this point the tone pattern is applied.
			switch ($U_treatedhalf) {
				case ('') {
					# In case the specification is empty: it corresponds to M. Importantly, for the second part of a phrase, tones are assigned automatically on the basis of the tone of the first part; in that case, the tones must not be overwritten by default M tones. Technical choice: only assign M tones to the first part; default assignment to the second part, when necessary, is conducted on the basis of the tone of the first part.
					if ($treatedindices[0] == 0) {
						map {$_ .= '˧'} @full_string [@treatedindices];
					}
					print XOUT "after default assignment of M tones to first half: @full_string\n";
				}
				case ('M') {
					# suffixing a mid tone, ˧, to each syllable
					map {$_ .= '˧'} @full_string [@treatedindices];
					print XOUT "expression entière : @full_string\n";
				} 
				case ('#H') {
					print XOUT "entering condition for tone #H\n";
					# This type of tone requires writing into what follows: suffixing a mid tone, ˧, to each syllable of the portion being processed, and a high tone, ˥, to the next syllable, if available.
					map {$_ .= '˧'} @full_string [@treatedindices];
					print XOUT "After assignment of default M tones: @full_string\n";
					# Where to place the High tone: 
					my $indexHtone = $treatedindices[$#treatedindices] + 1;
					print XOUT "Where the High tone would belong -- if there is such a syllable to host it: $indexHtone\n";
					# Condition: there must be such a syllable.
					if ($indexHtone <= $#full_string) {
						$full_string [$indexHtone] = "$full_string[$indexHtone]˥";
						# All following tones are set to L: 
						if ($indexHtone < $#full_string) {
							map {$_ .= '˩'} @full_string [($indexHtone+1)..$#full_string];
						}
						print XOUT "ce que ca donne après assignation du ton H: @full_string\n";
					}
					else { print XOUT "Floating High tone remains unassigned/is deleted.\n"; }
				} 
				case ('H$') {
					print XOUT "now treating tone H\$\n";
					# Suffixing a mid tone, ˧, to each syllable of the half being processed, except the last, which gets a high tone, ˥.
					if ($#treatedindices > 0) {
						map {$_ .= '˧'} @full_string [($treatedindices[0]..$treatedindices[$#treatedindices - 1])];
					}
					# Pour ne pas alourdir les expressions, utilisation de variables de transit
					my $indexHtone = $treatedindices[$#treatedindices];
					my $transitory = $full_string [$indexHtone];
					# @full_string [$indexHtone] = "@full_string [$indexHtone].'˥'";
					$full_string [$indexHtone] = "${transitory}˥";
					# All following tones are set to L: 
					if ($indexHtone < $#full_string) {
						map {$_ .= '˩'} @full_string [($indexHtone+1)..$#full_string];
					}
					
				} 
				case ('MH#') {
					print XOUT "now treating tone MH#\n";
					my $indexHtone = ''; # Declaring a variable to indicate where to place the H tone
					# Suffixing a mid tone, ˧, to each syllable
					map {$_ .= '˧'} @full_string [($treatedindices[0]..$treatedindices[$#treatedindices])];
					# Adding a High tone to the last syllable if there are no suffixes or particles; otherwise to the syllable that follows. First the index where to add the High tone is calculated.
					if ($treatedindices[$#treatedindices] < $#full_string) {
						$indexHtone = $treatedindices[$#treatedindices] + 1;
						}
					else {
						$indexHtone = $treatedindices[$#treatedindices];
					}
					# Then the ˥ symbol is added.
					my $transitory = $full_string [$indexHtone];
					$full_string [$indexHtone] = "${transitory}˥";
					# All following tones are set to L: 
					if ($indexHtone < $#full_string) {
						map {$_ .= '˩'} @full_string [($indexHtone+1)..$#full_string];
					}
				} 
				case ('L') {
					print XOUT "now treating tone L\n";
					print XOUT "This is what we get before addition of L tones: @full_string\n";
					# Suffixing a Low tone, ˩, to all the syllables up to the end of the nucleus.
					map {$_ .= '˩'} @full_string [($treatedindices[0]..$#nucleus)];
					print XOUT "This is what we get after addition of L tones: @full_string\n";
				} 
				case ('L#') {
					print XOUT "now treating tone L#\n";
					# Suffixing a Mid tone, ˧, to each syllable of treated portion, except the last. In case there is just one syllable, this does not apply.
					if ($treatedindices[$#treatedindices] - $treatedindices[0] > 0) {
						map {$_ .= '˧'} @full_string [($treatedindices[0]..$treatedindices[$#treatedindices - 1])];
						print XOUT "after addition of Mid tone to first syllables: @full_string\n";
					}
					# Adding a Low tone, ˩, to the last syllable. Index: is the last.
					my $indexLtone = $treatedindices[$#treatedindices];
					# Then the ˩ symbol is added.
					my $transitory = $full_string [$indexLtone];
					$full_string [$indexLtone] = "${transitory}˩";
					print XOUT "after addition of Low tone in final position: @full_string\n";
					# All following tones are set to L: 
					print XOUT "index where the Low tone was inserted: ${indexLtone}\n";
					print XOUT "full length of string: $#full_string\n";
					if ($indexLtone < $#full_string) {
						print XOUT "Now adding L tones to what follows\n";
						map {$_ .= '˩'} @full_string [($indexLtone+1)..$#full_string];
						print XOUT "with the following result: @{full_string}\n";
					} # End of condition on length (for assignment of final Ls)
				} 
				case ('L+MH#') {
					print XOUT "now treating tone L+MH\#\n";
					# Suffixing a Low tone, ˩, to the first syllable
					my $transitory = $full_string [$treatedindices[0]];
					$full_string [$treatedindices[0]] = "${transitory}˩";
					# If there are more than two syllables: intervening syllables get a Mid tone.
					my $distancebetweenbeginandend = $treatedindices[$#treatedindices] - $treatedindices[0] ;
					print XOUT "Difference of indices: is it more than 1? It is: $distancebetweenbeginandend\n";
					if ( $treatedindices[$#treatedindices] - $treatedindices[0] > 1) {
						map {$_ .= '˧'} @full_string [($treatedindices[0] + 1)..($treatedindices[$#treatedindices] - 1)];
					}
					# Assigning MH to last syllable if this is the last syllable of the string, or if the following syllables have a tonal specification of their own.
					if (($treatedindices[$#treatedindices] == $#full_string) or (($j < $#U_halves) and ($U_halves[$#U_halves] ne ''))) {
						my $transitory = $full_string [$treatedindices[$#treatedindices]];
						$full_string [$treatedindices[$#treatedindices]] = "${transitory}˧˥";
					}
					else {
						# assignment of H, and setting following syllables to L. xxxx to be continued to take into account various types of association.
						my $transitory = $full_string [$treatedindices[$#treatedindices] + 1];
						$full_string [$treatedindices[$#treatedindices] + 1] = "${transitory}˥";
						if ( ($treatedindices[$#treatedindices] + 1) <  $#full_string) {
							map {$_ .= '˩'} @full_string [($treatedindices[$#treatedindices] + 2)..$#full_string];
						}
					}
				}
				case ('LM+#H') {
					print XOUT "now treating tone LM+\#H\n";
					# Suffixing a Low tone, ˩, to the first syllable
					my $transitory = $full_string [$treatedindices[0]];
					$full_string [$treatedindices[0]] = "${transitory}˩";
					# If there is more than one syllable: syllables after the first get a Mid tone.
					if ( $treatedindices[$#treatedindices] - $treatedindices[0] > 0) {
						map {$_ .= '˧'} @full_string [$treatedindices[1]..$treatedindices[$#treatedindices]];
					}
					# If there are no syllables following: the H tone remains unassigned. Otherwise the next syllable gets H, and those that follow get L.
					if ($treatedindices[$#treatedindices] < $#full_string) {
						my $transitory = $full_string [$treatedindices[$#treatedindices] + 1];
						$full_string [$treatedindices[$#treatedindices] + 1] = "${transitory}˥";
						if ( ($treatedindices[$#treatedindices] + 1) <  $#full_string) {
							map {$_ .= '˩'} @full_string [($treatedindices[$#treatedindices] + 2)..$#full_string];
						}
					}
				} 
				case ('LM') {
					print XOUT "now treating tone LM\n";
					# Suffixing a Low tone, ˩, to the first syllable
					my $transitory = $full_string [$treatedindices[0]];
					$full_string [$treatedindices[0]] = "${transitory}˩";
					# If there is more than one syllable: syllables after the first get a Mid tone.
					if ( $treatedindices[$#treatedindices] - $treatedindices[0] > 0) {
						map {$_ .= '˧'} @full_string [$treatedindices[1]..$treatedindices[$#treatedindices]];
					}
				} 
				case ('LML') {
					print XOUT "now treating tone LML\n";
					# Suffixing a Low tone, ˩, to the first syllable
					my $transitory = $full_string [$treatedindices[0]];
					$full_string [$treatedindices[0]] = "${transitory}˩";
					# Suffixing a Mid tone, ˧, to the second syllable
					$transitory = $full_string [$treatedindices[1]];
					$full_string [$treatedindices[1]] = "${transitory}˧";
					# If there are more than two syllables: syllables after the second get a Low tone.
					if ( $#full_string > $treatedindices[1] ) {
						map {$_ .= '˩'} @full_string [($treatedindices[1]+1)..$#full_string];
					}
				} 
				case ('H#') {
					print XOUT "now treating tone H\#\n";
					# Suffixing a Mid tone, ˧, to each syllable of treated portion, except the last. In case there is just one syllable, this does not apply.
					if ($treatedindices[$#treatedindices] - $treatedindices[0] > 0) {
						map {$_ .= '˧'} @full_string [($treatedindices[0]..$treatedindices[$#treatedindices - 1])];
						print XOUT "after addition of Mid tone to first syllables: @full_string\n";
					}
					# Adding a High tone to the last syllable. Index: is the last.
					my $indexHtone = $treatedindices[$#treatedindices];
					# Then the ˥ symbol is added.
					my $transitory = $full_string [$indexHtone];
					$full_string [$indexHtone] = "${transitory}˥";
					# All following tones are set to L: 
					if ($indexHtone < $#full_string) {
						map {$_ .= '˩'} @full_string [($indexHtone+1)..$#full_string];
					} # End of condition on length (for assignment of final Ls)
				} # End of the case of tone H#
				case ('L+H#') {
					# This type is not found in lexical disyllables. It appears e.g. in numeral-plus-classifier phrases.
					print XOUT "now treating tone L+H\#\n";
					# Suffixing a Low tone, ˩, to each syllable of treated portion, except the last
					map {$_ .= '˩'} @full_string [($treatedindices[0]..$treatedindices[$#treatedindices - 1])];
					# Adding a High tone to the last syllable. Index: is the last.
					my $indexHtone = $treatedindices[$#treatedindices];
					# There the ˥ symbol is added.
					my $transitory = $full_string [$indexHtone];
					$full_string [$indexHtone] = "${transitory}˥";
					# All following tones are set to L: 
					if ($indexHtone < $#full_string) {
						map {$_ .= '˩'} @full_string [($indexHtone+1)..$#full_string];
					} # End of condition on length (for assignment of final Ls)
				} # End of the case of tone 
				case ('L+H$') {
					# This type is not found in lexical disyllables. It appears e.g. in numeral-plus-classifier phrases.
					print XOUT "now treating tone L+H\$\n";
					# Suffixing a Low tone, ˩, to each syllable of treated portion, except the last
					map {$_ .= '˩'} @full_string [($treatedindices[0]..$treatedindices[$#treatedindices - 1])];
					# If there is no syllable after the end of the nucleus, add a High tone to the last syllable.
					if ($treatedindices[$#treatedindices] == $#full_string) {
						my $indexHtone = $treatedindices[$#treatedindices];
						# There the ˥ symbol is added.
						my $transitory = $full_string [$indexHtone];
						$full_string [$indexHtone] = "${transitory}˥";
					}
					# Otherwise that syllable gets ˧, as do all the following ones. xxxx
					else {
						map {$_ .= '˧'} @full_string [($treatedindices[$#treatedindices])..$#full_string];
					}
				} # End of the case of tone
			} # End of SWITCH portion (range of cases for lexical tones)
		print XOUT "**** END OF ONE PART OF THE EXPRESSION ****\n "; 
		} # End of loop for halves of expression
		######################## Postlexical treatment ###############
		# Adding a postlexical High tone, ˥, if at least one of the following conditions is fulfilled: (i) the entire expression only has Low tones throughout; (ii) the expression has a L tone on its second part.
		# A borderline case: 20, 30... plus classifier. In that case there is no postlexical tone. Unexpected.
		my $mustaddpostlex = 0;
		if ($#U_halves > 0) {	
			if ($U_halves[1] eq 'L') { $mustaddpostlex = 1;}
			# In case there is more than one half, and the second half is not L, there is at least one M or H tone in the expression, so no need for further processing.
		}
		else {
			# If there is just one half in the expression, it may be that it is just a Low tone on the first part, in which case a postlexical tone is necessary. A test is conducted.
			if (( "@full_string" =~ /˧/ ) or ( "@full_string" =~ /˥/ )) {
				print XOUT "There is already either a H or a M tone in the expression, and the second half is not specified for a L tone; no need to add a postlexical tone.\n "; 
			}
			# Otherwise: a postlexical tone must be added.
			else { $mustaddpostlex = 1;}
		}
			
		if ($mustaddpostlex == 1) {
			if ($#nucleus == $#full_string) {
				print XOUT "A postlexical tone is required.\n "; 
				my $transitory = $full_string [$#full_string];
				print XOUT "Before addition: $transitory\n "; 
				# @full_string [$indexHtone] = "@full_string [$indexHtone].'˥'";
				$full_string [$#full_string] = "${transitory}˥";
				$transitory = $full_string [$#full_string];
				print XOUT "After addition: $transitory\n "; 
			}
			else {
				# xxxx If there are syllables after the nucleus: continue from here to see where to put the postlexical tone, depending on the type of relationship.
			} # End of condition for assignment of postlexical tone
		}
		# Concatenation of the list of syllables into a string. Perl separates elements with white spaces.
		$phrase = "@full_string";
		# Removing white spaces: 
		$phrase=~s/\s//g;
		# Converting the è symbol before final particles to a space
		$phrase =~ s/è/ /g;
		print XOUT "End of loop: $phrase\n";
		# Adding this variant to the entire expression to be sent up by the function at the end
		my $prefix = '';
		if ($i > 0) { $prefix = ' Variant: '; }
#		$output[$i] = "${prefix}${phrase} (surface phonological representation); underlying tone: ${Utreatedvariant}.";
		$output = "${output}${prefix}${phrase} (surface phonological representation); underlying tone: ${Utreatedvariant}.";
	} # End of loop for variants

	print XOUT "What is finally sent up by function: $output\n";
	close (XOUT);
	return($output);
}

###############################################################################################
# Declaration of a function: generating tone patterns for numeral-plus-classifier phrases. To call the function: 
# &NumCL($segments, $tonalcat, $number);
# where (i) the segments are in IPA, without slashes or other punctuation, (ii) the tonal category is indicated by an Arabic numeral, and (iii) the number with which to associate the classifier is given as an Arabic numeral.

sub NumCL {
	my $segments = $_[0]; #first value sent in: segments of the classifier, e.g. /kʰɯ/ or /ʁwɤ/. The slashes should not be included in the input.
	# A hyphen is added before the classifier, to indicate this morphosyntactic boundary.
	$segments = "\-$segments";
	my $tonalcat = $_[1]; #second value sent in: type in which tonal category the classifier belongs. It must be one of: H1; H2; MH1; MH2; M1; M2; L1; L2; L3.
	my $num = $_[2]; #third value sent in: numeral.
	
	# Translating the name of the tone pattern into a number from 1 to 9: 
	# 1 for H1; 2 for H2; 3 for MH1; 4 for MH2; 5 for M1; 6 for M2; 7 for L1; 8 for L2; 9 for L3
	my $tonalcatnb = 0;
	if ($tonalcat eq 'H1') {
		$tonalcatnb = 1;
	}
	elsif ($tonalcat eq 'H2') {
		$tonalcatnb = 2;
	}
	elsif ($tonalcat eq 'MH1') {
		$tonalcatnb = 3;
	}
	elsif ($tonalcat eq 'MH2') {
		$tonalcatnb = 4;
	}
	elsif ($tonalcat eq 'M1') {
		$tonalcatnb = 5;
	}
	elsif ($tonalcat eq 'M2') {
		$tonalcatnb = 6;
	}
	elsif ($tonalcat eq 'L1') {
		$tonalcatnb = 7;
	}
	elsif ($tonalcat eq 'L2') {
		$tonalcatnb = 8;
	}
	elsif ($tonalcat eq 'L3') {
		$tonalcatnb = 9;
	}
	else {
	error('Input tonal category must be one of the following: H1; H2; MH1; MH2; M1; M2; L1; L2; L3.');
	}
	
	# Data on the segments of numerals
	my @numerals = ('ɖɯ', 'ɲi', 'so', 'ʐv̩', 'ŋwɤ', 'qʰv̩', 'ʂɯ', 'hũ', 'gv̩', 'tsʰe');
	
	# Data on the tone patterns. Order: 1 to 9, i.e. H1; H2; MH1; MH2; M1; M2; L1; L2; L3. 
	# Two-dimensional: 9 classes of classifiers; for each class, 100 numerals. The tone patterns are indicated by means of the abstract notation developed for Yongning Na: three level tones, L, M and H, and indications on the syllabic anchoring of tones.
	# A more elegant and economical presentation would consist in encoding only once the identical numeral-runs: [40..49] and [50..59], and [60..69] and [80.89]. Further 'data compression' would be possible by adopting a more abstract notation (e.g. numbering the abstract tone patterns), but that would be at the expense of transparency. In the present version, all tone patterns from 1 to 100 are encoded separately, facilitating reference.
	my @NumCL = (
	# H1
	['H$', 'H$', 'L', '#H', '#H', 'H$', '#H', 'H$', '#H', 'L', 'L', 'L', 'L', 'L+H$', 'L+H$', 'L+H$', 'L', 'L+H$', 'L+H$', '#H', 'H$', 'H$', '°L', '#H', '#H', 'H$', '#H', 'H$', '#H', '#H', 'H$', 'H$', '°L', '#H', '#H', 'H$', '#H', 'H$', '#H', 'L#°', 'L#°H$/L#°', 'L#°H$/L#°', 'L#', 'L#°#H/L#°', 'L#°#H/L#°', 'L#°H$', 'L#°#H', 'L#°H$', 'L#°#H/L#°L', 'L#°', 'L#°H$/L#°', 'L#°H$/L#°', 'L#°L', 'L#°#H/L#°', 'L#°#H/L#°', 'L#°H$', 'L#°#H', 'L#°H$', 'L#°#H/L#°', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°H$/LM°#H', 'LM°#H/LM°L', 'LM°#H', 'LM°H$', 'LM°#H', 'LM°H$', 'LM°#H', 'L#°', 'L#°H$/L#°', 'L#°H$/L#°', 'L#°L', 'L#°#H', 'L#°#H', 'L#°H$', 'L#°#H', 'L#°H$', 'L#°#H/L#°L', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°#H', 'LM°#H', 'LM°H$', 'LM°#H', 'LM°H$', 'LM°#H', 'L#°', 'L#°H$', 'L#°H$', 'L#°L', 'L#°#H', 'L#°#H', 'L#°H$', 'L#°#H', 'L#°H$', 'L#°L', '#H'], 
	# H2
	['H$', 'H$', 'L', '#H', '#H', 'H$', '#H', 'H$', '#H', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', '#H', 'H$', '#H', '°L', '#H', '#H', 'H$', '#H', 'H$', '#H', '#H', 'H$', '#H', '°L', '#H', '#H', 'H$', '#H', 'H$', '#H', 'L#°', 'L#°H$/L#°', 'L#°#H/L#°', 'L#°L/L#°', 'L#°#H/L#°', 'L#°#H/L#°', 'L#°H$', 'L#°#H', 'L#°H$', 'L#°#H/L#°', 'L#°', 'L#°H$/L#°', 'L#°#H/L#°', 'L#°', 'L#°#H/L#°', 'L#°#H/L#°', 'L#°H$', 'L#°#H', 'L#°H$', 'L#°#H/L#°', 'LM°H$', 'LM°H$', 'LM°#H', 'LM°H$/LM°L', 'LM°#H', 'LM°#H', 'LM°H$', 'LM°#H', 'LM°H$', 'LM°L', 'L#°', 'L#°H$/L#°', 'L#°#H/L#°', 'L#°L/L#°', 'L#°#H/L#°', 'L#°#H/L#°', 'L#°H$/L#°', 'L#°#H/L#°', 'L#°H$/L#°', 'L#°#H/L#°', 'LM°H$', 'LM°H$', 'LM°#H', 'LM°H$/LM°L', 'LM°H$', 'LM°#H', 'LM°H$', 'LM°#H', 'LM°H$', 'LM°#H', 'L#°', 'L#°H$', 'L#°#H', 'L#°L', 'L#°#H', 'L#°#H', 'L#°H$', 'L#°#H', 'L#°H$', 'L#°#H', '#H'], 
	# MH1
	['MH#', 'MH#', 'L', 'L#', 'L#', 'H#', 'MH#', 'H#', 'L#', 'L', 'L', 'L', 'L', 'L+H#', 'L+H#', 'L+H#', 'L', 'L+H#', 'L+H#', 'MH#', 'MH#', 'MH#', '°L', '°L#', '°L#', 'H#', 'MH#', 'H#', '°L#', 'MH#', 'MH#', 'MH#', '°L', '°L#', '°L#', 'H#', 'MH#', 'H#', '°L#', 'L#°', 'L#°MH#/L#°', 'L#°MH#/L#°', 'L#°L', 'L#°L#', 'L#°L#', 'L#°H#', 'L#°MH#', 'L#°H#', 'L#°L#', 'L#°', 'L#°MH/L#°', 'L#°MH/L#°', 'L#°L', 'L#°L#', 'L#°L#', 'L#°H#', 'L#°MH#', 'L#°H#', 'L#°L#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'L#°', 'L#°MH#/L#°', 'L#°MH#/L#°', 'L#°L', 'L#°MH#/L#°', 'L#°MH#/L#°', 'L#°H#/L#°', 'L#°MH#/L#°', 'L#°H#/L#°', 'L#°L#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'L#°', 'L#°MH#/L#°', 'L#°MH#/L#°', 'L#°L', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°H#/L#°', 'L#°MH#/L#°', 'L#°H#/L#°', 'L#°L#/L#°', 'MH#'], 
	# MH2
	['M', 'MH#', 'L', 'L', 'L', 'H$', 'MH#', 'H$', 'L', 'L', 'M', 'L', 'L', 'L+H#', 'L+H#', 'L+H#', 'L', 'L+H#', 'L+H#', 'MH#', 'M', 'MH#', '°L', '°L', '°L', 'H$', 'MH#', 'H$', '°L', 'MH#', 'M', 'MH#', '°L', '°L', '°L', 'H$', 'MH#', 'H$', '°L', 'L#°', 'L#°M', 'L#°MH#', 'L#°L', 'L#°L', 'L#°L', 'L#°H$', 'L#°MH#', 'L#°H$', 'L#°L', 'L#°', 'L#°M', 'L#°MH#', 'L#°L', 'L#°L', 'L#°L', 'L#°H$', 'L#°MH#', 'L#°H$', 'L#°L', 'LM°H#', 'LM°#H', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'L#°', 'L#°M/L#°', 'L#°MH#', 'L#°L', 'L#°L', 'L#°L', 'L#°H#', 'L#°MH#', 'L#°H#', 'L#°L', 'LM°H#', 'LM°#H', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'L#°', 'L#°M/L#°', 'L#°MH#/L#°', 'L#°L', 'L#°L', 'L#°L', 'L#°H#/L#°', 'L#°MH#/L#°', 'L#°H#/L#°', 'L#°L', 'MH#'], 
	# M1
	['M', 'M', 'M', 'L', 'L', 'H#', 'M', 'H#', 'L', 'M', 'M', 'M', 'M', 'L+H#', 'L+H#', 'L+H#', 'M', 'L+H#', 'L+H#', 'M', 'M', 'M', '°L/M', '°L', '°L', 'H#', 'M', 'H#', '°L', 'M', 'M', 'M', '°L', '°L', '°L', 'H#', 'M', 'H#', '°L', 'L#°', 'L#°', 'L#°', 'L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°', 'L#°', 'L#°', 'L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'LM°H#', 'LM°H#/L+MH#°M', 'LM°H#/L+MH#°M', 'LM°H#/L+MH#°M', 'LM°H#/L+MH#°L', 'LM°H#/L+MH#°L', 'LM°H#', 'LM°H#/L+MH#°M', 'LM°H#', 'LM°H#/L+MH#°L', 'L#°', 'L#°/L#°M', 'L#°/L#°M', 'L#°/L#°M', 'L#°/L#°H#', 'L#°/L#°H#', 'L#°H#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°L/L#°H#', 'LM°H#', 'LM°H#/L+MH#°M', 'LM°H#/L+MH#°M', 'LM°H#/L+MH#°M', 'LM°H#/L+MH#°L', 'LM°H#/L+MH#°L', 'LM°H#', 'LM°H#/L+MH#°M', 'LM°H#', 'LM°H#/L+MH#°L', 'L#°/L#°', 'L#°M/L#°', 'L#°M/L#°', 'L#°M/L#°', 'L#°L/L#°H#', 'L#°L/L#°H#', 'L#°H#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°L/L#°H#', 'M'], 
	# M2
	['M', 'M', 'M', 'L', 'L', 'H$', 'M', 'H$', 'L', 'M', 'M', 'M', 'M', 'L', 'L', 'L', 'M', 'L', 'L', 'M', 'M', 'M', 'M/°L', '°L', '°L', 'H$', 'M', 'H$', '°L', 'M', 'M', 'M', '°L', '°L', '°L', 'H$', 'L', 'H$', '°L', 'L#°', 'L#°M/L#°', 'L#°M/L#°', 'L#°M/L#°', 'L#°', 'L#°', 'L#°H$/L#°', 'L#°M/L#°', 'L#°H$/L#°', 'L#°L', 'L#°', 'L#°M/L#°', 'L#°M/L#°', 'L#°M/L#°', 'L#°', 'L#°', 'L#°H$/L#°', 'L#°M/L#°', 'L#°H$/L#°', 'L#°L', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°#H', 'LM°H$', 'LM°H$/LM°L', 'L#°', 'L#°M/L#°', 'L#°M/L#°', 'L#°M/L#°', 'L#°L', 'L#°L', 'L#°H$/L#°', 'L#°M/L#°', 'L#°H$/L#°', 'L#°L', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°H$', 'LM°#H', 'LM°H$', 'LM°H$/LM°L', 'L#°', 'L#°M/L#°', 'L#°M/L#°', 'L#°M/L#°', 'L#°', 'L#°', 'L#°H$/L#°', 'L#°M/L#°', 'L#°H$/L#°', 'L#°L', 'M'], 
	# L1
	['L#', 'L#', 'L', 'H#', 'H#', 'H#', 'L#', 'H#', 'H#', 'L', 'L#', 'L#', 'L#', 'L+H#', 'L+H#', 'L+H#', 'L#', 'L+H#', 'L+H#', '°L', '°L#', '°L#', '°L', 'H#', 'H#', 'H#', '°L#', 'H#', 'H#', '°L#', '°L#', '°L#', '°L', 'H#', 'H#', 'H#', '°L#', 'H#', 'H#/°L#', 'L#°', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°M/L#°L', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°L#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°M/L#°L', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°L#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'L#°', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°L/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°L#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'L#°', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#', 'L#°L#/L#°', 'L#°H#', 'L#°H#', 'L#'], 
	# L2
	['L#', 'L#', 'M', 'H#', 'H#', 'H#', 'L#', 'H#', 'H#/L#', 'M', 'L#', 'L#', 'L#', 'L+H#', 'L+H#', 'L+H#', 'L#', 'L+H#', 'L+H#', '°L', '°L#', '°L#', '°L', 'H#', 'H#', 'H#', '°L#', 'H#', '°L#/H#', '°L', '°L#', '°L#', '°L', 'H#', 'H#', 'H#', '°L#', 'H#', 'H#/°L#', 'L#°', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°L#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°L#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'L#°', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°L#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'L#°', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°L#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#'], 
	# L3
	['L#', 'L#', 'M', 'H#', 'H#', 'H#', 'L#', 'H#', 'H#', 'L', 'L#', 'L#', 'L#', 'L+H#', 'L+H#', 'L+H#', 'L#', 'L+H#', 'L+H#', '°L', '°L#', '°L#', '°L', 'H#', 'H#', 'H#', '°L#', 'H#', 'H#', '°L#', '°L#', '°L#', '°L', 'H#', 'H#', 'H#', '°L#', 'H#', 'H#/°L#', 'L#°', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°L#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°L#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'L#°', 'L#°L#/L#°', 'L#°L#/L#°', 'L#°M/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'L#°L#/L#°', 'L#°H#/L#°', 'L#°H#/L#°', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'LM°H#', 'L#°', 'L#°L#', 'L#°L#', 'L#°M/L#°', 'L#°H#', 'L#°H#', 'L#°H#', 'L#°L#', 'L#°H#', 'L#°H#/L#', 'L#']);

	#Tone category MH2: only one example, /kv/ - /v/. This calls for special treatment. The slots for '1', '11' etc are filled with the values for the classifier for individuals, /v̩/. A separate set is provided again below in case a further check were necessary. It corresponds to the tones for '1', '11', '21', '31', '41', '51', '61', '71', '81', and '91'.
	my @NumCLIndividuals = ('M', 'M', 'M', 'MH#', 'L#°M', 'L#°M', 'LM°#H', 'L#°M / L#°', 'LM°#H', 'L#°M / L#°');
	
	# Selecting the relevant tone pattern. Indications provided: first, the category; then, the numeral. Both minus one, as Perl counts from zero.
	my $tonepattern = $NumCL[$tonalcatnb - 1][$num - 1]; 
	
	# Assembling the segmental contents of the numeral part of the phrase. At this point the information on boundaries is added: a dot between syllables; or a ° for a boundary after tens (or hundreds).
		my $syll = '';
		# Special case for '100'.
		if ($num == 100) {
		$syll = "ɖɯ.ɕi°$segments";
	}
	elsif ($num < 11) {
		#1 to 10: no ° boundary.
		$syll = "$numerals[$num - 1].$segments";
	}
	elsif (($num > 10) && ($num < 20)) {
		#11 to 19: /tsʰe/ followed by '1' to '9'. No ° boundary.
		my $lastdigit = chop($num);
		$syll = "$numerals[9].$numerals[$lastdigit - 1].$segments";
	}
	elsif (($num > 19) && ($num < 30)) {
		my $lastdigit = chop($num);
		my $firstdigit = $num;
		# Form of the word for 'tens': form in the range [20..29]: /tsi/. 
		# Special condition for 'zero'.
		# Initializing a variable for the last syllable: 
		my $lastsyll = '';
		if ($lastdigit == 0) {
			$syll = "${numerals[$firstdigit - 1]}.tsi°$segments";
		}
		else { 
			$lastsyll = $numerals[$lastdigit - 1];
			$syll = "${numerals[$firstdigit - 1]}.tsi°$lastsyll.$segments"; 
		}
	}
	elsif (($num > 29) && ($num < 100)) {
		my $lastdigit = chop($num);
		my $firstdigit = $num;
		# Form of the word for 'tens': form in the range [30..99]: /tsʰi/. 
		# Special condition for 'zero'.
		if ($lastdigit != 0) {
			my $lastsyll = $numerals[$lastdigit - 1];
			$syll = "$numerals[$firstdigit - 1].tsʰi°$lastsyll.$segments";
		}
		else { 
			$syll = "$numerals[$firstdigit - 1].tsʰi°$segments"; }
	}
	else {
		error('Numeral must be between 1 and 100.');
	}
	# Temporary check
	# my $phrase = $syll;

	# Now we have both the abstract (underlying) tone pattern, and the sequence of syllables with indications on junctures. We want to launch the UtoS function to calculate the surface-phonological tones.
	my $output = &UtoS($syll, $tonepattern);
	# Returning this value
	return($output);
}

#####################################################################################
############### Function for prohibitive constructions: prohibitive morpheme + verb
#####################################################################################
sub Prohib {
	my $segments = $_[0]; #first value sent in: segments of the verb, e.g. /bi/ or /ʈʂʰæ/. The slashes should not be included in the input.
	my $tonalcat = $_[1]; #second value sent in: type in which tonal category the verb belongs.
	
	#Data on tone of verb in prohibitive constructions
	my @surfacetone = ('˥', '˧', '˧', '˩', '˩', '˧˥');
	
	#Prohibitive morpheme: always has the same tone.
	my $phrase = "tʰɑ˧-$segments$surfacetone[$tonalcat - 1]";

	# Returning this value
	return($phrase);
}

#####################################################################################
############### Function for generating the tone patterns of compound nouns
#####################################################################################
sub compound {
	my $det = $_[0]; #first value sent in: segments of the det[erminer] noun, e.g. /ʐwæ/ or /ʐwæ.mi/. The slashes should not be included in the input.
	my $head = $_[1]; #second value sent in: segments of the head noun, e.g. /ʐwæ/ or /ʐwæ.mi/.
	
	#Data on tone patterns in determinative compounds. Order: LM, M, L, H, MH
	my @mono_mono = (
	# LM
	['LM', 'LM', 'LM', 'LM+#H', 'L+MH#'], 
	# M
	['L#', '#H', 'L#', '#H', 'L#'], 
	# L
	['L', 'L', 'L', 'L', 'L'], 
	# H
	['H#', '#H', '#H', '#H', '°L'], 
	# MH
	['H#', 'H#', 'H#', 'H$', 'H$']);
	
	my $phrase = "";

	# Returning this value
	return($phrase);
}

#####################################################################################
############### Function for generating hypotheses about the tones of the members of a compound
#####################################################################################

# Must take into account equivalences between notations. Example: °L and #L for a 1+1 or 2+1 compound.

#########################################
############## End of the set of functions ####
#########################################

# # To use the NumCL function: 
# my $NumCLphrase = &NumCL("kv̩", "MH1", 95);
# #Writing output (test phase).
# print XOUT "$NumCLphrase";

# my $cl_na = 'kʰwɤ';
# my $tonecat = 'H1';
# my $number = 40;
# my $NumCLphrase = &NumCL($cl_na, $tonecat, $number);

# open XOUT, ">natone.txt";
# print XOUT "$NumCLphrase\n";
# close (XOUT);

my $NumCLphrase = '';  my $NumCLphrases = '';
my $text = '';
my @beginend = (20, 20);
for (my $m=($beginend[0]); $m <= $beginend[1]; $m++) {
	$NumCLphrase = '';
	$NumCLphrase = &NumCL("mæ", "L1", $m);
	$NumCLphrases = $NumCLphrases . $NumCLphrase;
	$NumCLphrases = "${NumCLphrases}\n\n";
	

	$text = "${text}${NumCLphrase}\n${m} morceaux\n${m} pieces\/chunks\n${m} 块\n\n";
}
open XOUT, ">natone.txt";
print XOUT "Here are the phrases as they come out of the function: \n$NumCLphrases\n\n";

print XOUT "FINAL OUTPUT: \n$text\n";

my $testoutput = &UtoS('ɲi.tsi°mæ', '°L');
open XOUT, ">natone.txt";
print XOUT "calcul manuel: $testoutput";

close (XOUT);
	
# for (my $m=1; $m < 100; $m++) {
	# $NumCLphrase = &NumCL("kʰwɤ", "H1", $m);
	# print XOUT "$NumCLphrase\n";
# }

# To use the Prohib function: 
# my $prohibphrase = &Prohib("hwæ",3);
# open XOUT, ">xmlout.xml";
##Writing output (test phase).
# print XOUT "$prohibphrase";

# my @S = &UtoS('ɲi.tsi°ɖɯ.kʰwɤ#ɲi$tsɯ.mv', 'MH#°');
# my @S = &UtoS('ɲi.tsi°ɖɯ.kʰwɤ', 'H#°/L');
# my @S = &UtoS('ɲi.tsi°ɖɯ.kʰwɤ', 'L°MH#');
# my @S = &UtoS('ɖɯ.ɭɯ°lɑ#ze$tsɯ.mv', '#H°');
#my @S = &UtoS('ɖɯ.ɭɯ°lɑ#ze$tsɯ.mv', 'L#°#H/L#°');
# print XOUT "Final result returned to main program by function: @S\n";

