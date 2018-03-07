#!/usr/bin/env python
# -*- coding: utf-8 -*-
import lxml.etree
import copy

import sys
import re
# appel du fichier simpleConverter (qui doit se trouver dans le meme repertoire) ou se trouve les fonctions read_correspondances et conversion
from simpleConverter import simpleConverter as sc

# ajoute les versions orthographiques dans un fichier TEXT ou WORDLIST

# on charge les correspondances de "ipa2spelling.csv" (pour l'instant choix du fichier en dur (modifier si necessaire)
correspondances = sc.read_correspondances("ipa2spelling.csv")
# si on decide de passer le fichier de correspondance en argument mettre >> correspondances = sc.read_correspondances(sys.argv[1])
# et du coup pour la boucle il faudra mettre >> for name in sys.argv[2:]:

def addOrtho(phonologic_element, correspondances):
    ortho = lxml.etree.Element("FORM")
    ortho.text = sc.conversion(phonologic_element.text, correspondances)
    ortho.set("kindOf", "ortho")
    phonologic_element.addnext(ortho)

# on boucle sur les fichiers a traiter
for name in sys.argv[1:]:
       tree = lxml.etree.parse(name)
       root = tree.getroot()
       if(root.tag == "WORDLIST"):
           wordlist = True
       else:
           wordlist = False

       if wordlist:
           parent_markup = "W"
       else:
           parent_markup = "S"


       for to_rename in tree.findall("./" + parent_markup):
           if wordlist:
               if (to_rename.find("FORM[@kindOf='phonemic']") is not None):
                   addOrtho(to_rename.find("FORM[@kindOf='phonemic']"), correspondances)
               elif (to_rename.find("FORM[@kindOf='phono']") is not None):
                   addOrtho(to_rename.find("FORM[@kindOf='phono']"), correspondances)
               elif (to_rename.find("FORM") is not None):
                   addOrtho(to_rename.find("FORM"), correspondances)
               else: 
                   print("rien trouve a convertir ")
           else:
               for form in to_rename.findall("FORM"):
                   form.set("kindOf", "phono") 
                   addOrtho(form, correspondances)

       open(name+'_ortho.xml','w', encoding='utf-8').write(lxml.etree.tostring(root, encoding='UTF-8').decode('utf-8'))

