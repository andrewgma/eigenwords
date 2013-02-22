# outputs a text file with 3 columns:
# 1) wine number
# 2) word in wine name (as a unique integer)
# 3) count of appearances

# can replace "Name:" with any of the wine review descriptors
# only uses words that appear at least 10 times

import re
# import csv

f = open("names2",'w')
# c = csv.writer(open("names.csv",'wb'))

wine_num = 0
univ_ref_dict = {}
num_words = 0
univ_dict_count = 1
univ_dict = {}

source = open('winemag_reviews','r')

for line in source:
	words = line.split()
	if words[0] == "Name:":
		for i in range(1,len(words)):
			num_words += 1
			w = words[i]
			w = re.sub('\(','',w)
			w = re.sub('\)','',w)
			if w not in univ_ref_dict:
				univ_ref_dict[w] = univ_dict_count
				univ_dict_count += 1
				univ_dict[w] = 1
			else:
				univ_dict[w] += 1
source.close()

output_dict = {}
output_ref = 0

for line in open('winemag_reviews','r'):
	words = line.split()
	if words[0] == "Name:":
		word_dict = {}
		wine_num += 1
		for i in range(1,len(words)):
			w = words[i]
			w = re.sub('\(','',w)
			w = re.sub('\)','',w)
			if univ_dict[w] >= 50:
				if w not in output_dict:
					output_ref += 1
					output_dict[w] = output_ref
				if w not in word_dict:
					word_dict[w] = 1
				else:
					word_dict[w] += 1
		for word in word_dict.keys():
			f.write(str(wine_num) + " " + str(output_dict[word]) + " " + str(word_dict[word]) + "\n")
			# c.writerow([str(wine_num), str(univ_dict[word]), str(word_dict[word])])

f.close()
print "unique words in wine names: "
print str(len(univ_dict))
print "total words in wine names: "
print str(num_words)
print "check (should be 84158): "
print str(wine_num)
print "check (should be 4624): "
print str(output_ref)

ans1 = 0
ans2 = 0
ans3 = 0
for w in univ_dict.keys():
	if univ_dict[w] >= 50:
		ans1 += 1
	if univ_dict[w] >= 55:
		ans2 += 1
	if univ_dict[w] >= 60:
		ans3 += 1

print ">50: " + str(ans1)
print ">55: " + str(ans2)
print ">60: " + str(ans3)