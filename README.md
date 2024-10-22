# Projet KALLM : Kit avancé LLM



Ce projet fait partie de la [troisième saison du Programme 10%](https://10pct.datascience.etalab.studio/les-actualites/saison-3-programme-10/), co-porté par la DINUM en association étroite avec l'Insee.
Vous pouvez consulter le guide [ici](https://etalab.github.io/programme10pourcent-kallm/).


## Préambule

Mistral, GPT4, Claude, ALBERT, CroissantLLM... Vous ne vous y retrouvez plus parmi tous ces modèles larges de language (LLM)? Ce guide permet de se poser les bonnes questions et de pouvoir répondre à un besoin d'analyse textuelle avec une solution adaptée. Ce guide est là pour vous aider du début jusqu'à la fin, de la conception du modèle après problématisation à la mise en production.

**Objectif : Comprendre son besoin et y répondre avec une solution LLM adaptée**

## Etats des lieux des LLM

Les LLM sont des modèles de langage de grande taille, apparus vers 2018, ayant révolutionné le domaine du traitement automatique du langage naturel.
Les LLM se caractérisent généralement par une architecture de type "transformers" permettant un traitement parallèle et contextuel du langage, un entraînement sur de très vastes corpus de données textuelles, allant de millions à des milliards de paramètres, et des capacités impressionnantes pour accomplir une grande variété de tâches linguistiques comme la génération de texte, la traduction, l'analyse de sentiment.

Plus de 3000 LLM ont été entraînés et publiés sur des plateformes de partage de modèle comme [HuggingFace](https://huggingface.co/spaces/lmsys/chatbot-arena-leaderboard), dont plus d'une cinquantaine s'affronte régulièrement entre eux pour se démarquer sur différentes tâches dans une [arène dédiée](https://huggingface.co/spaces/lmsys/chatbot-arena-leaderboard). Ces modèles peuvent aussi être évalués dans une [arène française](https://comparia.beta.gouv.fr/).

Il est aujourd'hui difficile de savoir quel LLM est adapté pour son besoin spécifique et quelle infrastructure est nécessaire pour utiliser les différents LLM. Ce guide tente donc d'expliciter les raisonnements, les questions à se poser et des pistes de réponse quant aux choix et à la mise en oeuvre des LLM.


## Ce que couvre ce guide

* l'infrastructure minimale pour faire tourner un LLM
* benchmarking des "principaux" LLM
* exemple d'utilisation dans un cas simple (cas d'utilisation dit "fil rouge") sous forme de tutoriel
* finetuner un modèle LLM
* quantizer un modèle LLM
* Evaluer un LLM
* mettre en production un modèle LLM
* une bibliographie consise et non exhaustive
* d'autres exemples plus complexes de cas d'utilisation dans l'administration
* une approximation du coût environnemental et financier des différents LLM

## Ce que ne couvre pas (encore) ce guide

* les fondements théoriques de l'optimisation
* cas spécifique d'une administration
* comment débiaiser un LLM

## Membres

| Membre                  | Administration                                                                  |
| ----------------------- | ------------------------------------------------------------------------------- |
| Conrad THIOUNN          | Dares - Ministère du Travail                                                    |
| Johnny PLATON           | Santé publique France                                                           |
| Thibault DUROUCHOUX     | DGDDI - Ministère de l'Economie et des Finances                                 |
| Katia JODOGNE-DEL LITTO | IGF - Ministère de l'Economie et des Finances                                   |
| Faheem BEG              |                                                                                 |
| Camille ANDRÉ           |                                                                                 |
| Camille BRIER           | DTNum - DGFiP                                                                   |
| Daphné PERTSEKOS        | ANFSI - Ministère de l'intérieur                                                |
| Zhanna SANTYBAYEVA      | DGOS - Ministère du travail, de la santé et des solidarités                     |
| Bruno LENZI             | Ecolab - Ministère de la Transiton Écologique et de la Cohésion des Territoires |
| Hélène CHARASSON-JASSON | Banque de France                                                                |

 ## Épilogue

 Une remarque ? Une question ? Vous pouvez nous contacter sur le salon [Tchap du Programme 10%](!hMSAqEDoNuxyPzFiLH:agent.dinum.tchap.gouv.fr) ou ...
