#!/usr/bin/env python
# -*- coding: utf-8 -*-

class simpleConverter():

    # fonction statique de conversion - IN word : la chaine a convertir / correspondances : le dictionnaire de correspondance
    @classmethod
    def conversion(cls, word, correspondances):
        transformation_number = 1
        # creation d'une variable dictionnaire 
        substitutions = {}
        # on boucle sur les correspondances triees par taille
        for correspondance in sorted(correspondances, key=len, reverse=True):
            # si on trouve un motif on le remplace par "%(transformation_number)s" et on ajoute la subtitution dans la variable du meme nom
            new_word = word.replace(correspondance, "%(" + str(transformation_number) + ")s")
            if (new_word != word):
                substitutions[str(transformation_number)] = correspondances[correspondance]
                transformation_number += 1
                word = new_word
        #print('conversion result : ', word)
        #print(substitutions)
        # ajout 31/10/2017
        word = word.replace("˧", "").replace("˥", "").replace("˩", "")
        # on fait les substitutions en envoyant le resultat
        return word % substitutions

    # Fonction statique de chargement des correspondance api -> orthographe a partir d'un csv
    @classmethod
    def read_correspondances(cls, correspondances_file_name):
        # creation d'une variable dictionnaire
        correspondances = {}
        with open(correspondances_file_name, encoding="utf8") as fp:
            for line in fp:
                correspondance = line.split(";",1)
                correspondances[correspondance[0]] = correspondance[1][:-1]
        #for correspondance in sorted(correspondances, key=len, reverse=True):
        #    print (correspondance, ' -> ', correspondances[correspondance])
        return correspondances
