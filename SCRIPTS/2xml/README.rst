...2xml: scripts to add markup to plain text files, producing XML documents
================================

##############
Python scripts
##############

In 2025, Séverine Guillaume produced a script to produce XML documents in `the format of the Pangloss Collection <pangloss.cnrs.fr/tools/pangloss.dtd>`_ (also available `from the Cocoon platform <http://cocoon.huma-num.fr/schemas/Archive.dtd>`_) based on (i) a reference to `the Na dictionary <https://github.com/alexis-michaud/na/tree/master/DICTIONARY>`_ and (ii) time codes in the corresponding audio file.

The script is called::

    RegionsandDictionary2xml.py

Explanations in English and French are provided in::

    RegionsandDictionary2xml_ReadMe.txt

To run the script::

    python3 regions_and_dictionary_to_xml.py input.txt na.xml

There are 2 output files: the compte_rendu.xml file, which lists the words not found in the dictionary, and the Pangloss XML file, which bears the same name as the input file but (i) with a _AUTO suffix (to be removed manually after the file has been tested to be OK), so as to avoid overwriting another file, and (ii) with the .xml extension (such as: NRU_F4_VOC1.xml).

##############
Heritage Perl scripts
##############

These Perl scripts add markup to plain-text files to produce XML documents in `the format of the Pangloss Collection <pangloss.cnrs.fr/tools/pangloss.dtd>`_ (also available `from the Cocoon platform <http://cocoon.huma-num.fr/schemas/Archive.dtd>`_). There are lavish comments inside the scripts.

These scripts were produced by a nonprofessional programmer (Alexis Michaud) and the code is very basic.

The flagship scripts are **txt2xml.pl** (for texts: narratives, etc.) and **voc2xml.pl** (for word lists: vocabulary elicitation sessions, phonological materials, etc.).

These scripts were still functional as of 2024.

