annotations.csv is taken from:

	Eva Maria Vecchi and Marco Marelli and Roberto Zamparelli and Marco Baroni
	Spicy adjectives and nominal donkeys: Capturing semantic deviance using compositionality in distributional spaces
	Cognitive Science
	2016

unigram_freq.csv is taken from:

	English Word Frequency
	https://www.kaggle.com/rtatman/english-word-frequency
	Rachael Tatman
	sep 2017

scores.csv is produced by score.py. It assigns an acceptability score to each AN-pair based on annotations.csv

phrase_preparation.R produces two equally sized phrase pools, one with low and one with high semantic deviance phrases
It uses unigram_freq.csv to ensure an equal distribution of word frequencies between the two pools.
On top of that, word lengths are also equally distributed between the two pools.
Note that the produced pools are not the same each time the script is run.

experiment.osexp is the Open Sesame experiment that was used to conduct the study

Distributions for the generated data set used in the study:
![ScreenShot](dataset.png)

