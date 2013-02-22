# reduces the number of words for a reviewsbywords file 
# simplifies wine numbering (e.g. 2,4,5,8 becomes 1,2,3,4)

# expects 3 columns
# 1) wine number
# 2) word number
# 3) number of occurrences

# difference from clean.py:
# will not assign new integer references for words
# good because we can match up words to winemag_1.hist

# will keep words that appear in greater than or equal to n wines:

n = 300

# run this file twice, once with block A for reviews, and once for block B for names

# block A: reviews
input_file = "reviewsbywords_n.txt"
input_prediction_file = "reviewsbywords_pred.txt"
new_output = open("reviewsbywords_nc.txt",'w')
new_output_pred = open("reviewsbywords_predc.txt",'w')

# block B: words
# input_file = "names_n.txt"
# input_prediction_file = "names_n_pred.txt"
# new_output = open("names_nc.txt",'w')
# new_output_pred = open("names_nc_pred.txt",'w')

f = open(input_file,'r')

ref_dict = {}
count_dict = {}
count = 0

for line in f:
	old_ref = int(line.split()[1])
	if old_ref not in ref_dict:
		count += 1
		ref_dict[old_ref] = count
		count_dict[old_ref] = 1
	else:
		count_dict[old_ref] += 1

f.close()

f = open(input_file,'r')

# for now I'm testing without new wine nums

for line in f:
	old_wine_num = int(line.split()[0])
	old_ref = int(line.split()[1])
	if count_dict[old_ref] >= n:
		new_output.write(str(old_wine_num) + " " 
			+ str(old_ref) + " " + line.split()[2] + "\n")

f.close()
new_output.close()

ans = 0
for i in count_dict.keys():
	if count_dict[i] >= n:
		ans += 1

print "num in ref_dict: " + str(count)
print "num meeting restriction: " + str(ans)




# do the same thing for the prediction set
# but only keep words that were in the training set

f_pred = open(input_prediction_file,'r')

for line in f_pred:
	old_wine_num = int(line.split()[0])
	old_ref = int(line.split()[1])
	if old_ref in ref_dict:
		new_output_pred.write(str(old_wine_num) + " " 
			+ str(old_ref) + " " + line.split()[2] + "\n")

f_pred.close()
new_output_pred.close()