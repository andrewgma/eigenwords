# return reviewsbywords ORDERED

# mark 'p' for previous word not in top 5516 (i.e. does not appear >=20 times)
# mark 'n' for next word not in top 5516 - not implemented

# realized after writing this:
# after running this file, there is still more preprocessing to be done
# see make_trigrams.py

f = open("justreviews_clean", 'r')

wordct = open("wordcounts", 'r')

ordered = open("reviewsbywords_ordered", 'w')

# first make a dict from winemag_1.hist

word_ref_dict = {}

word_ref = 0
for line in wordct:
	word_ref += 1
	word_ref_dict[line.split()[1]] = word_ref

wine_count = 0

for line in f:
	wine_count += 1
	words = line.split()
	# track whether the previous word is in the top 5516 (i.e. if it's in the file)
	# starts false for each new line
	prev = False
	for word in words:
		if word in word_ref_dict:
			if not prev:
				ordered.write(str(wine_count) + " " + str(word_ref_dict[word]) + "\n")
			else:
				ordered.write(str(wine_count) + " " + str(word_ref_dict[word]) + " p \n")
			# reset to false
			prev = False
		else:
			prev = True