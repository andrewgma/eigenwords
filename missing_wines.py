# find wines that don't have words in "reviewsbywords"



f = open("reviewsbywords",'r')
out = open("missing",'w')

looking_for = 1
no_words = []

for line in f:
	if int(line.split()[0]) == looking_for:
		looking_for += 1
	elif int(line.split()[0]) > looking_for:
		no_words.append(looking_for)
		looking_for += 1
		while int(line.split()[0]) > looking_for:
			looking_for += 1
			no_words.append(looking_for)

for wine in no_words:
	out.write(str(wine) + "\n")