# uses output of order_review_words.py

# rememeber that we use only the top 5516 words (used in >=20 reviews)
# so there are "holes" where words are not represented, so we want two versions:
# 1) ignore "holes": make trigrams as if the missing words were never there
# 2) no trigram where holes exist

# we only need to represent bigrams; trigrams can be inferred

f = open("reviewsbywords_ordered", 'r')

trigrams = open("trigrams", 'w')

# need to ensure only doing this for each wine

# pseudo:

# while file not over
# 	while wine = current_wine
# 		make bigrams

line1 = f.readline()
current_wine = line1.split()[0]

line2 = f.readline()

while line2:
	if line2.split()[0] == current_wine:
		trigrams.write(line1.split()[1] + " " + line2.split()[1] + "\n")
		line1 = line2
		line2 = f.readline()
	else:
		current_wine = line2.split()[0]
		line1 = line2
		line2 = f.readline()
