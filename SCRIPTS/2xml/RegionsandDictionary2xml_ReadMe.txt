Explanations about the RegionsandDictionary2xml.py script:

(français ci-dessous)

The label provided in the input .txt file is the identifier of the word in the dictionary, when it coincides with a dictionary entry.
When it's different (as the labelled portion of speech is a phrase, or a sentence, not just one word said in isolation), the annotation still indicates the dictionary word to which it's linked, followed by transcription & translation info.

In detail: take this line, for example:

    mv̩˧-gɤ˧lɑ˥ 00:00:01,509 00:00:02,507 00:00:00,998

This form mv̩˧-gɤ˧lɑ˥ is fetched from the dictionary XML file. Together with the symbol ⓔ (an “e” in a circle), the label forms the identifier of the word in the dictionary.
ⓔmv̩˧-gɤ˧lɑ˥

A minor complication is that there are sometimes homophones, in which case they have a homophone number: 1, 2, 3... which appears at the end of the “enriched phonetic alphabet” form. To find the corresponding entry, using the “Lexika” system set up by Benjamin Galliot, you need to add an “h surrounded by a circle” symbol before the homophone number.
For example, on line 16 of the F4_VOC1.txt file:
hi˩˥2
(it's the word for 'rain')
It's pronounced hi˩˥, and it's the 2nd in the list of homophones. This translates in the Lexika system as:
hi˩˥ⓗ2
and finally, by adding the prefix ⓔ (which all entries have):
ⓔhi˩˥ⓗ2

This identifier is used to retrieve the following from the na.xml dictionary
- the French translation
- the English translation
- the Chinese translation
and add the identifier as a note:
<NOTE message="ⓔmv̩˧-gɤ˧lɑ˥"/>


En français :

L'étiquette fournie dans le fichier .txt en entrée est l'identifiant du mot dans le dictionnaire, quand ça coïncide avec une entrée du dictionnaire.
Quand c'est différent (une expression, une phrase...), l'annotation indique tout de même le mot du dico auquel ça se rattache, puis des infos de transcription & traduction.

En détail : prenons par exemple cette ligne :

    mv̩˧-gɤ˧lɑ˥                 00:00:01,509  00:00:02,507  00:00:00,998

Il s'agit d'aller chercher dans le fichier XML du dictionnaire cette forme mv̩˧-gɤ˧lɑ˥, qui jointe au symbole ⓔ (un 'e' dans un cercle) constitue l'identifiant du mot dans le dico.
ⓔmv̩˧-gɤ˧lɑ˥

Une petite complication, c'est qu'il y a parfois des homophones, et qu'ils ont alors un numéro d'homophone: le 1, 2, 3... qui apparaît à la fin de la forme en "alphabet phonétique enrichi". Pour retrouver l'entrée correspondante, dans le système "Lexika" mis en place par Benjamin Galliot, il faut ajouter un symbole "h entouré d'un cercle" avant le numéro d'homophone.
Par exemple à la ligne 16 du fichier F4_VOC1.txt:
hi˩˥2
(c'est le mot "pluie")
Ça se prononce hi˩˥, et c'est le 2e dans la liste des homophones. Ce qui se traduit dans le système Lexika par :
hi˩˥ⓗ2
et au final, en ajoutant le préfixe ⓔ (qu'ont toutes les entrées) :
ⓔhi˩˥ⓗ2

Au moyen de cet identifiant, il s'agit d'aller récupérer dans le dico na.xml
- la traduction française
- la traduction anglaise
- la traduction chinoise
et ajouter en note l'identifiant :
<NOTE message="ⓔmv̩˧-gɤ˧lɑ˥"/>

La ligne
mv̩˧-gɤ˧lɑ˥                 00:00:01,509  00:00:02,507  00:00:00,998

donne en sortie :
  <W id="w1">
    <AUDIO start="1.509" end="2.507"/>
    <FORM kindOf="phono-deep">mv̩˧-gɤ˧lɑ˥</FORM>
    <FORM kindOf="phono-surface">mv̩˧gɤ˧lɑ˥</FORM>
    <TRANSL xml:lang="zh">天宫菩萨</TRANSL>
    <TRANSL xml:lang="fr">Esprit du ciel, Bodhisattva céleste.</TRANSL>
    <TRANSL xml:lang="en">Sky spirit.</TRANSL>
    <NOTE xml:lang="en" message="Identifier of the corresponding dictionary entry: ⓔmv̩˧-gɤ˧lɑ˥"/>
    <NOTE xml:lang="fr" message="Identifiant de l'entrée de dictionnaire correspondante: ⓔmv̩˧-gɤ˧lɑ˥"/>
    <NOTE xml:lang="zh" message="相应词典条目的识别码：ⓔmv̩˧-gɤ˧lɑ˥"/>
  </W>
