#! /usr/bin/env python
# -*- coding: utf-8 -*-

# Go under dev/scripts/ and launch this script using the following command:
# python na/py/generate_lc.py

# Import system Python module
import sys
# Import utilities
sys.path.append(".")
from common import *

# Default values of command line arguments
DEFAULT_INPUT = "./obj/Dictionary_na.xml"
DEFAULT_OUTPUT = None

class GenerateLc(InOut, XmlFormat):
    def __init__(self):
        XmlFormat.__init__(self)

    def parse_options(self):
        """Get command line arguments.
        """
        # Options management
        from optparse import OptionParser
        parser = OptionParser()
        parser.add_option("-v", "--verbose", dest="verbose", action="store_true", default=False, help="print more details to stdout [default=False]")
        parser.add_option("-i", "--input", dest="input", action="store", default=DEFAULT_INPUT, help="input XML file [default=" + str(DEFAULT_INPUT) + "]")
        parser.add_option("-o", "--output", dest="output", action="store", default=DEFAULT_OUTPUT, help="output MDF file [default=" + str(DEFAULT_OUTPUT) + "]")
        self.options = parser.parse_args()[0]
        # Compute output filename
        if self.options.output is None:
            self.options.output = "na/py/" + self.options.input[self.options.input.rfind('/') + 1:self.options.input.rfind('.')] + ".txt"

    def mono_noun(self, tones):
        """Get rules to apply.
        """
        rules = None,
        if tones == ["LM"]:
            rules = 6,
        elif tones == ["L"]:
            rules = 0,
        elif tones == ["H"]:
            rules = 3,
        return rules

    def di_noun(self, tones):
        """Get rules to apply.
        """
        rules = None,
        if tones == ["M", "M"]:
            rules = 2,
        elif tones == ["M", "#H"]:
            rules = 10, 2
        elif tones == ["M", "MH"]:
            rules = 2,
        elif tones == ["M", "H$"]:
            rules = 10, 2
        elif tones == ["M", "H"]:
            rules = 2,
        elif tones == ["L", "L"]:
            rules = 1, 7
        elif tones == ["M", "L"]:
            rules = 2,
        elif tones == ["L", "#H"]:
            rules = 10,
        elif tones == ["L", "M"]:
            rules = 6,
        return rules

    def mono_verb(self, tones):
        """Get rules to apply.
        """
        rules = None,
        if tones == ["H"]:
            rules = 3,
        elif tones == ["L"]:
            rules = 7,
        return rules

    def adj(self, tones):
        """Get rules to apply.
        """
        return self.mono_verb(tones)

    def apply_rules(self, rules, syllables_nb, tones):
        """Call each rule in order.
        """
        new_tones = list(tones)
        for rule in rules:
            if rule is not None:
                new_tones = getattr(self, "apply_rule_" + str(rule))(syllables_nb, new_tones)
        return new_tones

    def apply_rule_0(self, syllables_nb, tones):
        """Exception.
        """
        new_tones = list(tones)
        if tones == ["L"]:
            new_tones[0] = "M"
        return new_tones

    def apply_rule_1(self, syllables_nb, tones):
        """Rule 1: L tone spreads progressively (‘left-to-right’) onto syllables that are unspecified for tone.
        """
        if syllables_nb > len(tones) and tones[0] == "L":
            new_tones = []
            for i in range (0, syllables_nb - len(tones) + 1):
                new_tones.append("L")
            for i in range (syllables_nb - len(tones) + 1, syllables_nb):
                new_tones.append(tones[i - syllables_nb + len(tones)])
            return new_tones
        return list(tones)

    def apply_rule_2(self, syllables_nb, tones):
        """Rule 2: Syllables that remain unspecified for tone after the application of Rule 1 receive M tone.
        """
        # No need to apply this rule because all syllables are marked with a tone.
        return list(tones)

    def apply_rule_3(self, syllables_nb, tones):
        """Rule 3: In tone-group-initial position, H and M are neutralized to M.
        """
        new_tones = list(tones)
        if tones[0] == "H":
            new_tones[0] = "M"
        return new_tones

    def apply_rule_4(self, syllables_nb, tones):
        """Rule 4: A syllable following a H-tone syllable receives L tone.
        """
        new_tones = list(tones)
        for i in range (0, len(tones) - 1):
            if tones[i] == "H":
                new_tones[i+1] = "L"
        return new_tones

    def apply_rule_5(self, syllables_nb, tones):
        """Rule 5: All syllables following a HL or ML sequence receive L tone.
        """
        new_tones = list(tones)
        for i in range (0, len(tones) - 1):
            if tones[i] == "HL" or tones[i] == "ML":
                for j in range (i + 1, len(tones)):
                    new_tones[j] = "L"
                break
        return new_tones

    def apply_rule_6(self, syllables_nb, tones):
        """Rule 6: In tone-group-final position, H and M are neutralized to H if they follow a L tone.
        """
        new_tones = list(tones)
        if tones[-1] == "LM":
            new_tones[-1] = "LH"
        if len(tones) > 1:
            if tones[-2] == "L" and tones[-1] == "M":
                new_tones[-1] = "H"
        return new_tones

    def apply_rule_7(self, syllables_nb, tones):
        """Rule 7: If a tone group only contains L tones, a post-lexical H tone is added to its last syllable.
        """
        new_tones = list(tones)
        L = True
        for i in range (0, len(tones)):
            if tones[i] != "L":
                L = False
        if L:
            new_tones[-1] += "H"
        return new_tones
    
    def apply_rule_10(self, syllables_nb, tones):
        """Final #H => M, H$ => H.
        """
        new_tones = list(tones)
        if tones[-1] == "#H":
            new_tones[-1] = "M"
        elif tones[-1] == "H$":
            new_tones[-1] = "H"
        return new_tones

    def trans_tones(self, ps, syllables_nb, tones):
        """Depending on 'ps' and number of syllables, get 'lc' tones.
        """
        new_tones = list(tones)
        if ps == "n":
            if syllables_nb == 1:
                new_tones = self.apply_rules(self.mono_noun(tones), syllables_nb, tones)
            elif syllables_nb == 2:
                new_tones = self.apply_rules(self.di_noun(tones), syllables_nb, tones)
        elif ps == "v" and syllables_nb == 1:
            new_tones = self.apply_rules(self.mono_verb(tones), syllables_nb, tones)
        elif ps == "adj":
            new_tones = self.apply_rules(self.adj(tones), syllables_nb, tones)
        # Handle words composed of 3 syllables or more (4 or 5)
        if syllables_nb > 2:
            # Apply all rules
            rule = 1, 2, 3, 4, 5, 6, 7
            new_tones = self.apply_rules(rule, syllables_nb, tones)
        return new_tones

    def tones_to_analysis(self, ps, syllables_nb, tones):
        """Depending on 'ps' and number of syllables, map tones in list (one per syllable) into an analysis string.
        """
        analysis = None
        # Handle words composed of 3 syllables or more (4 or 5)
        if syllables_nb > 2:
            # Compute analysis from 2 significant syllables (generally the first 2 ones or the last 2 ones)
            tmp_syllables_nb = 2
            tmp_tones = []
            for tone in tones:
                if tmp_tones == [] or tone != tmp_tones[-1]:
                    tmp_tones.append(tone)
            if len(tmp_tones) < tmp_syllables_nb:
                tmp_tones.append(tmp_tones[0])
        else:
            tmp_syllables_nb = syllables_nb
            tmp_tones = tones
        if ps == "n":
            # Monosyllabic nouns
            if tmp_syllables_nb == 1:
                if tmp_tones == ["H"]:
                    analysis = "#H"
                elif tmp_tones == ["MH"]:
                    analysis = "MH#"
                else:
                    analysis = tmp_tones[0]
            # Disyllabic nouns
            elif tmp_syllables_nb == 2:
                if tmp_tones == ["M", "M"]:
                    analysis = "M"
                elif tmp_tones == ["M", "#H"]:
                    analysis = "#H"
                elif tmp_tones == ["M", "MH"]:
                    analysis = "MH#"
                elif tmp_tones == ["M", "H$"]:
                    analysis = "H$"
                elif tmp_tones == ["M", "H"]:
                    analysis = "H#"
                elif tmp_tones == ["L", "L"]:
                    analysis = "L"
                elif tmp_tones == ["M", "L"]:
                    analysis = "L#"
                elif tmp_tones == ["L", "MH"]:
                    analysis = "LM+MH#"
                elif tmp_tones == ["L", "#H"]:
                    analysis = "LM+#H"
                elif tmp_tones == ["L", "M"]:
                    analysis = "LM"
                elif tmp_tones == ["L", "H"]:
                    analysis = "LH"
        elif ps == "v" and tmp_syllables_nb == 1:
            # TOLERATE M?
            if tmp_tones == ["M"]:
                analysis = "Ma"
            # TOLERATE L?
            elif tmp_tones == ["L"]:
                analysis = "La"
            else:
                analysis = tmp_tones[0]
        elif ps == "adj" and tmp_syllables_nb == 1:
            # TOLERATE M?
            if tmp_tones == ["M"]:
                analysis = "Ma"
            # TOLERATE L?
            elif tmp_tones == ["L"]:
                analysis = "La"
            # TOLERATE #H?
            elif tmp_tones == ["#H"]:
                analysis = "H"
            else:
                analysis = tmp_tones[0]
        return analysis

    def lx_to_lc(self, lx, ps, np=None, codec=True):
        """Depending on 'ps' and number of syllables, compute 'lc' form 'lx'.
        """
        lc = ''
        if lx is None or ps is None:
            return None
        if codec:
            lx = lx.decode(encoding=CODEC)
        # Handle '-' separator
        full_analysis = ''
        for lx_segment in lx.split('-'):
            lc_segment = ''
            syllables, tones = self.dissect(lx_segment)
            syllables_nb = len(syllables)
            analysis = self.tones_to_analysis(ps, syllables_nb, tones)
            if analysis is None:
                return None
            if len(lx.split('-')) == 1:
                full_analysis += analysis
            else:
                # Reconstitute analysis from segments
                if analysis == "M":
                    # Use short way of writing tones: M°X => °X ; X°M => X°
                    if full_analysis == '' or full_analysis[-1] != u"°":
                        full_analysis += u"°"
                else:
                    if full_analysis != '' and full_analysis[-1] != u"°":
                        full_analysis += u"°"
                    full_analysis += analysis
            # To remove indexes from tones before processing
            def remove_indexes(tone): return tone.rstrip('abc')
            # Handle words containing '-' separator
            if len(lx.split('-')) > 1:
                # Apply only rule 10
                rule = 10,
                lc_tones = self.apply_rules(rule, syllables_nb, map(remove_indexes, tones))
            else:
                lc_tones = self.trans_tones(ps, syllables_nb, map(remove_indexes, tones))
            if lc_tones is None:
                return None
            for i in range (0, syllables_nb):
                lc_segment += syllables[i]
                lc_segment += self.tone_str_to_ipa(lc_tones[i])
            # Reconstitute 'lc' from segments
            if lc != '':
                lc += '-'
            lc += lc_segment
        # Check that 'np' corresponds to tones composing 'lx'
        if np is not None:
            # In case of different variants separated with '/' character, compare with each of them
            equal = False
            # TOLERATE '+' instead of '°' character?
            full_analysis_bis = full_analysis.replace(u"°", '+')
            for variant in np.split('/'):
                if variant.strip() == full_analysis or variant.strip() == full_analysis_bis:
                    equal = True
            # Consider all assumptions separated by '?' character
            for hypothesis in np.split('?'):
                if hypothesis.strip() == full_analysis or hypothesis.strip() == full_analysis_bis:
                    equal = True
            if not equal:
                return None
        if codec:
            lc = lc.encode(encoding=CODEC)
        return lc

    def dissect(self, lx):
        """Return syllables and tones composing 'lx'.
        """
        import re
        syllables = []
        tones = []
        if lx is None:
            return syllables, tones
        tones_ipa = "˩˧˥".decode(encoding=CODEC)
        # Monosyllabic
        current_pattern = "([^" + tones_ipa + "#$]+)(#?[" + tones_ipa + "]{1,2}[$#]?)([abcd123]?)"
        pattern = "^" + current_pattern + "$"
        if re.search(pattern, lx):
            result = re.match(pattern, lx)
            syllables.append(result.group(1))
            tones.append(self.tone_ipa_to_str(result.group(2) + result.group(3)))
        # Disyllabic: add a constraint on other syllables which must have at least 2 characters (maximum 5)
        syllable = "([^" + tones_ipa + "#$]{2,5})(#?[" + tones_ipa + "]{1,2}[$#]?)([abcd123]?)"
        # Handle words composed of 2, 3, 4, 5 syllables
        for syllable_nb in range (2, 6):
            current_pattern += syllable
            pattern = "^" + current_pattern + "$"
            if re.search(pattern, lx):
                result = re.match(pattern, lx)
                for i in range (0, syllable_nb):
                    syllables.append(result.group(i*3+1))
                    tones.append(self.tone_ipa_to_str(result.group(i*3+2) + result.group(i*3+3)))
        return syllables, tones

    def tone_str_to_ipa(self, tone):
        """Convert a tone string composed of 'LMH' characters into a tone string composed of '˩˧˥' IPA characters.
        """
        new_tone = tone
        tones_str = "LMH"
        tones_ipa = "˩˧˥".decode(encoding=CODEC)
        for i in range (0,3):
            new_tone = new_tone.replace(tones_str[i], tones_ipa[i])
        return new_tone

    def tone_ipa_to_str(self, tone):
        """Convert a tone string composed of '˩˧˥' characters into a tone string composed of 'LMH' IPA characters.
        """
        new_tone = tone
        tones_ipa = "˩˧˥".decode(encoding=CODEC)
        tones_str = "LMH"
        for i in range (0,3):
            new_tone = new_tone.replace(tones_ipa[i], tones_str[i])
        return new_tone

    def add_lc(self):
        """Compute 'lc' field.
        """
        out_file = self.open_write(self.options.output)
        err_file = self.open_write("na/py/tone_errors.txt")
        for lxGroup in self.tree.iterfind("lxGroup"):
            lc = None
            lx = None
            ps = None
            np = None
            for subelement in lxGroup:
                if subelement.tag == "lx":
                    lx = subelement.text
                elif subelement.tag == "ps":
                    ps = subelement.text
                elif subelement.tag == "np":
                    try:
                        if subelement.attrib["type"] == "tone":
                            np = subelement.text
                    except KeyError:
                        pass
            # Generate 'lc' from 'lx' and 'ps'
            lc = self.lx_to_lc(lx, ps, np=np, codec=False)
            # Write result in output or error file
            if lc is not None:
                file = out_file
            else:
                file = err_file
            if lc is None:
                lc = str(lc)
            if np is None:
                np = str(np)
            if lx is not None:
                file.write("\lx " + lx + "\n")
                file.write("\lc " + lc + "\n")
                file.write("\ps " + str(ps) + "\n")
                file.write("\\np " + np + "\n\n")
        err_file.close()
        out_file.close()

    def main(self):
        self.parse_options()
        # Parse input XML file
        self.tree = parse(self.options.input)
        # Add 'lc' marker
        self.add_lc()

if __name__ == '__main__':
    converter = GenerateLc()
    converter.main()
    # Exit program properly
    sys.exit(0)
