import unicodedata
import pandas as pd
from lxml import etree
import xml.etree.ElementTree as ET
import sys
import argparse
import os
import re

def parse_line(line):
    # Expression régulière pour capter les 3 timestamps à la fin
    match = re.search(r'(.*?)\s+(\d{2}:\d{2}:\d{2},\d{3})\s+(\d{2}:\d{2}:\d{2},\d{3})\s+(\d{2}:\d{2}:\d{2},\d{3})$', line)
    if match:
        text = match.group(1).strip()
        start = match.group(2)
        end = match.group(3)
        duration = match.group(4)

        # Détection de parenthèse fermante en fin de ligne
        forme_non_canonique = False
        if re.search(r"\)\s*$", text):
            text = re.sub(r"\)\s*$", "", text)
            forme_non_canonique = True

        return {
            "Name": text,
            "start": start,
            "end": end,
            "length": duration,
            "forme_non_canonique": forme_non_canonique
        }
    else:
        return None



def creation_tsv(fichier_entree, fichier_sortie):
    data = []
    for idx, line in enumerate(open(fichier_entree)):
        if idx <= 3:
            continue
        data.append(parse_line(line))

    df = pd.DataFrame(data)

    premiere_colonne = df.iloc[:, 0]

    # Séparation sur le caractère • avec 5 colonnes max
    colonnes_separees = premiere_colonne.str.split('•', n=4, expand=True)

    # S'assurer d’avoir 5 colonnes (remplir avec valeurs vides si moins)
    for i in range(5 - colonnes_separees.shape[1]):
        colonnes_separees[colonnes_separees.shape[1] + i] = ""

    colonnes_separees.columns = ['form', 'ex', 'zh', 'en', 'fr']

    autres_colonnes = df.iloc[:, 1:]
    df_final = pd.concat([colonnes_separees, autres_colonnes], axis=1)
    df_final['forme_non_canonique'] = df['forme_non_canonique']

    df_final.to_csv(fichier_sortie, sep='\t', index=False)
    print(f" Fichier transformé enregistré dans : {fichier_sortie}")



def conversion_duree_en_secondes(duree):
    # On remplace la virgule par un point pour les millisecondes
    duree = duree.replace(',', '.')

    # On sépare heures, minutes, secondes
    h, m, s = duree.split(':')
    secondes = float(h) * 3600 + float(m) * 60 + float(s)

    # Retourne une chaîne avec 3 décimales exactement
    return "{:.3f}".format(secondes)


def normaliser_en_nfd(s):
    """Renvoie la chaîne normalisée selon la forme Unicode NFD (décomposée)."""
    return unicodedata.normalize("NFD", s)


# def detecter_forme_non_canonique_et_nettoyer(row):
#     """Détecte une parenthèse fermante en fin de chaîne (indiquant une réalisation non canonique),
#     la retire, et retourne la ligne corrigée avec un champ booléen.
#     """
#     for champ in ['form', 'fr', 'en', 'zh', 'ex']:
#         if isinstance(row[champ], str) and row[champ].endswith(')'):
#             row[champ] = row[champ].rstrip(')')
#             row['forme_non_canonique'] = True
#     return row


def create_xml_pangloss(tsv_text, dictionary, out, identifiant):

    compte_rendu = open('compte_rendu.xml', mode = 'w', encoding='utf-8')
    compte_rendu.write('forme non trouvée dans le dictionnaire : \n\n')

    resultat = open(out, mode = 'w', encoding='utf-8')



    resultat.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
    resultat.write("<!DOCTYPE WORDLIST SYSTEM \"https://cocoon.huma-num.fr/schemas/Archive.dtd\">\n")
#    resultat.write("<WORDLIST id=\'xxx\' xml:lang='nru'>\n")
    resultat.write("<WORDLIST id=\'"+identifiant+"\' xml:lang='nru'>\n")
    resultat.write("<HEADER></HEADER>\n")

    dataframe = pd.read_csv(tsv_text, sep="\t")

    # dictionary = open(dictionary, "r", encoding="utf-8")
    # Parsing du fichier xml d'annotations
    tree = ET.parse(dictionary)
    root = tree.getroot()
    message_parenthese_en = ''
    message_parenthese_fr = ''
    num = 1

    # print(df)
    # print(df.columns.tolist())

    for index, row in dataframe.iterrows():
        # print(row['form'], row['start'])

        parenthese = 0

        resultat.write("<W id=\'w"+str(num)+"\'>\n")
        num+=1

        # Traitement des format de synchronisation
        # 00:01:54,189

        start = conversion_duree_en_secondes (row['start'])
        end = conversion_duree_en_secondes (row['end'])

        # print (start, ' ', end)

        resultat.write("<AUDIO start=\'"+start+"\' end=\'"+end+"\'/>\n")

        import re
        ## Version originale du programme : on enlève toutes les espaces.
        ## form = row['form']. replace(" ", "")
        # Commentaire Alexis : ça c'est à appliquer attentivement car il y a des entrées qui contiennent des espaces. Solution: ne retirer les espaces qu'en fin d'expression.
        form = row['form'].rstrip()

        # Normalisation Unicode (ajout du 9 juillet, pour que la forme NFC /hĩ˧mo˩/, avec i tilde U+0129, puisse être retrouvée dans le dictionnaire XML, où la forme est en NDF: /hĩ˧mo˩/)
        form = normaliser_en_nfd(form)

        transl_fr = row['fr']

        # on détecte les parenthèses (=indication d'une réalisation pas très canonique) et on effectue le traitement = supprimer la parenthese et ajouter une note supplémentaire pour cette entrée.
        # Ajout Alexis : veiller à réinitialiser à chaque itération, afin d'éviter un effet de persistance d’état, qui a lieu en Python quand des variables sont définies à l’intérieur d’un `if` et utilisées ensuite hors de tout contrôle explicite.
        # message_parenthese_en = ""
        # message_parenthese_fr = ""

# Test et traitement des parenthèses (ancienne version)
        # if (')' in form) or (')' in str(transl_fr)):
        #     form = form.replace(')',"")
        #     # print ("transl avant : ",transl_fr)
        #     transl_fr = str(transl_fr).replace(')',"")
        #     # print ("transl après : ",transl_fr)
        #     message_parenthese_en = "<NOTE xml:lang='en' message=\"This token is not recommended for the status of typical (canonical) realization (e.g. for use as illustration of the word in a multimedia dictionary).\"/>"
        #     message_parenthese_fr = "<NOTE xml:lang='fr' message=\"Il n'est pas recommandé d'employer cet item en tant que réalisation représentative (canonique), par exemple dans le cadre d'un dictionnaire multimédia.\"/>"

        if row['forme_non_canonique']:
            message_parenthese_en = "<NOTE xml:lang='en' message=\"This token is not recommended for the status of typical (canonical) realization (e.g. for use as illustration of the word in a multimedia dictionary).\"/>"
            message_parenthese_fr = "<NOTE xml:lang='fr' message=\"Il n'est pas recommandé d'employer cet item en tant que réalisation représentative (canonique), par exemple dans le cadre d'un dictionnaire multimédia.\"/>"
        else:
            message_parenthese_en = ""
            message_parenthese_fr = ""


        l_form = list(form)

        # on détecte tous les chiffres (=indication d'homonyme) et on ajoute ⓗ devant pour retrouver la bonne entrée dans le dictionnaire
        for x in range(len(l_form)):
            if form[x].isdigit():
                modif = re.sub(r'(\d+)', r'ⓗ\1',form[x])
                l_form[x]=modif


        entree = 'ⓔ'+"".join(l_form)

        # root.find(".//S[@id='S"+str(num_s)+"']")
        res = root.find(".//Dictionnaire/EntréesLexicales/EntréeLexicale[@identifiant='"+entree+"']")
        # print ('traduction zh : ', row['form'],' ',row['zh'])
        # traitement des infos et insertion dans le xml pangloss
        if res != None:
            # print (entree,' : ',res.attrib)
            form_dico_note = res.attrib['identifiant']
            # print (res.attrib,' : ',form_dico)

            form_dico = form_dico_note.replace('ⓔ','')

            forme_deep = root.find(".//Dictionnaire/EntréesLexicales/EntréeLexicale[@identifiant='"+entree+"']/Lemme/Forme").text

            forme_surface = root.find(".//Dictionnaire/EntréesLexicales/EntréeLexicale[@identifiant='"+entree+"']/Lemme/FormeDeSurface").text
            # print ("forme de surface : ", forme_de_surface)

            if res.findall('.//ListeDeSens/Sens/Définitions/Définition[@langue="eng"]'):
                traduction_en = res.find('.//ListeDeSens/Sens/Définitions/Définition[@langue="eng"]')
            if res.findall('.//ListeDeSens/Sens/Définitions/Définition[@langue="fra"]'):
                traduction_fr = res.find('.//ListeDeSens/Sens/Définitions/Définition[@langue="fra"]')
            if res.findall('.//ListeDeSens/Sens/Définitions/Définition[@langue="cmn"]'):
                traduction_zh = res.find('.//ListeDeSens/Sens/Définitions/Définition[@langue="cmn"]')




            # print ('test : ',row['zh'])

            # s'il y a des exemples, ce sont eux qu'on prend en compte pour la transcriptiion et la traduction
            # if not pd.isnull(row['ex']):
            if not pd.isnull(row['ex']):
                # print ('sans dictionnaire : ', form)

                resultat.write("<FORM kindOf='phono'>"+str(row['ex'])+"</FORM>\n")

                # test si la cellule est vide ou non. si oui, on va chercher les traductions dans le dictionnaire
                if not pd.isnull(row['zh']):
                    resultat.write("<TRANSL xml:lang='zh'>"+str(row['zh'])+"</TRANSL>\n")

                if not pd.isnull(row['fr']):
                    resultat.write("<TRANSL xml:lang='fr'>"+str(row['fr'])+"</TRANSL>\n")

                if not pd.isnull(row['en']):
                    resultat.write("<TRANSL xml:lang='en'>"+str(row['en'])+"</TRANSL>\n")

                if message_parenthese_en != '':
                    resultat.write(message_parenthese_en+'\n')
                    message_parenthese_en = ''

                if message_parenthese_fr != '':
                    resultat.write(message_parenthese_fr+'\n')
                    message_parenthese_fr = ''

                # probleme régler cette ligne
            else:
                # print ('accès dictionnaire : ', form)

                resultat.write("<FORM kindOf='phono-deep'>"+forme_deep+"</FORM>\n")
                resultat.write("<FORM kindOf='phono-surface'>"+forme_surface+"</FORM>\n")


                # print ("traduction zh : ", traduction_zh.text)
                resultat.write("<TRANSL xml:lang='zh'>"+traduction_zh.text+"</TRANSL>\n")

                # traduction_fr = root.find(".//ListeDeSens/Sens/Définitions/Définition")
                # print ("traduction fr : ", traduction_fr.text)
                resultat.write("<TRANSL xml:lang='fr'>"+traduction_fr.text+"</TRANSL>\n")

                # traduction_en = root.find(".//ListeDeSens/Sens/Définitions/Définition")
                # print ("traduction en : ", traduction_en.text)
                resultat.write("<TRANSL xml:lang='en'>"+traduction_en.text+"</TRANSL>\n")
            # print (root.find(".//Lemme/Form"))



                if message_parenthese_en != '':
                    resultat.write(message_parenthese_en+'\n')
                    message_parenthese_en = ''

                if message_parenthese_fr != '':
                    resultat.write(message_parenthese_fr+'\n')
                    message_parenthese_fr = ''


        else:
            compte_rendu.write(entree+'\n')

        resultat.write("<NOTE xml:lang='en' message =\"Identifier of the corresponding dictionary entry: "+form_dico_note+"\" />\n")
        resultat.write("<NOTE xml:lang='fr' message =\"Identifiant de l'entrée de dictionnaire correspondante: "+form_dico_note+"\" />\n")
        resultat.write("<NOTE xml:lang='zh' message =\"相应词典条目的识别码："+form_dico_note+"\" />\n")

        # if parenthese ==1:
        #     print ('oui')

        resultat.write("</W>\n")

    resultat.write("</WORDLIST>")
    resultat.close()  # Il faut fermer le fichier avant de le retraiter
    indent_xml_file(out)  # Reformate avec indentation


def fichier_avec_extension_attendue(extension_attendue):
    def verif(path):
        if not os.path.isfile(path):
            raise argparse.ArgumentTypeError(f"Le fichier '{path}' n'existe pas.")
        if not path.lower().endswith(extension_attendue.lower()):
            raise argparse.ArgumentTypeError(f"Le fichier '{path}' n'a pas l'extension attendue : '{extension_attendue}'")
        return os.path.abspath(path)
    return verif

def indent_xml_file(filepath):
    """Recharge un fichier XML et le réécrit avec indentation correcte."""
    parser = etree.XMLParser(remove_blank_text=True)
    tree = etree.parse(filepath, parser)
    tree.write(filepath, pretty_print=True, encoding='utf-8', xml_declaration=True)

# def indent_xml_file(filepath):
#     """Recharge un fichier XML et le réécrit avec indentation."""
#     parser = ET.XMLParser(target=ET.TreeBuilder(insert_comments=True))
#     tree = ET.parse(filepath, parser=parser)
#     root = tree.getroot()


if __name__ == "__main__":


    parser = argparse.ArgumentParser(description="Script de traitement avec deux fichiers en entrée.")
    parser.add_argument("fichier_soundforge",  type=fichier_avec_extension_attendue(".txt"), help="Chemin du fichier soundforge")
    parser.add_argument("dictionnaire",  type=fichier_avec_extension_attendue(".xml"), help="Chemin du dictionnaire")

    args = parser.parse_args()

    # file = sys.argv[1]
    # dico = sys.argv[2]

    file = args.fichier_soundforge
    dico = args.dictionnaire
    basename = os.path.basename(file)         # Extrait le nom de fichier seul, sans chemin
    identifiant = basename[4:].split('.')[0]      # Retire les 4 premiers caractères et l’extension

    file_tmp = file.split('.')
    filename = file_tmp[0]
    print (file, '        ',filename)
    creation_tsv(file, filename+'.tsv')

    create_xml_pangloss(filename+'.tsv', dico, filename+'_AUTO.xml', identifiant)
