Scripts
================================
Some simple scripts for linguistic data on the Yongning Na language (nɑ˩-ʐwɤ˥, also known as Narua or Mosuo). 

* **generate_lc** (by Benjamin Galliot) is a Python script that generates a surface-phonological representation (labelled as 'lc' in the Toolbox software, hence the script's name) on the basis of a 'deep' (abstract) phonological representation. The surface-phonological representation is 'strict IPA' (using only symbols from the International Phonetic Alphabet) whereas the 'deep' phonological representation uses some custom symbols to represent specific classes of tones. 
* **ipa2o** (by Rémy Bonnet) is a Python script that converts IPA to Na orthography (hence the name ipa2o). 
* The **2xml** folder contains Perl scripts that add markup to plain-text files to produce XML documents. The flagship script is txt2xml (for texts: narratives, etc), but there are others for other types of materials.
* **NaTone** is a Perl script that generates the tone patterns of numeral-plus-classifier phrases on the basis of underlying tones. It was written with an ambitious goal in view: generating surface-phonological tone patterns for the entire morpho-phonological system of Yongning Na. Hence its 'generic' name, **NaTone**, and its internal organization that separates various functions. 

Further explanations are provided as comments inside each script.

Also note the script for preprocessing Na data for use with the Persephone automatic transcription toolkit, here: https://github.com/persephone-tools/persephone/blob/master/persephone/datasets/na.py
