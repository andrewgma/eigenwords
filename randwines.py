# python script to randomly pick n wines to use
# then pick m wines to use for prediction

# here we are making files for varietal and review words

# note you will not get exactly n wines because some wines don't have reviews
# these will still match up to the varietals file 
# because we will omit varietals without wine reviews

import random

n = 10000 # change here
m = 1000 # change here

total_num_wines = 84158

n_adj = n*84158/(84158-882)
m_adj = m*84158/(84158-882)

rand_nums = random.sample(range(1,total_num_wines+1),n_adj+m_adj)
rand_nums_training = rand_nums[0:n_adj]
rand_nums_predict = rand_nums[n_adj:]
rand_nums_training.sort()
rand_nums_predict.sort()

review_src = open("../data/reviewsbywords", 'r')
varietal_src = open("varietals", 'r')

review_out = open("reviewsbywords_n.txt",'w')
varietal_out = open("varietals_n",'w')

rand_count = 0

looking_for = rand_nums_training[0]

for line in review_src:
	if int(line.split()[0]) == looking_for:
		review_out.write(line)
	elif int(line.split()[0]) > looking_for:
		rand_count += 1
		if rand_count < n_adj:
			looking_for = rand_nums_training[rand_count]
			if int(line.split()[0]) == looking_for:
				review_out.write(line)

review_src.close()
review_out.close()

line_count = 1

# so that we don't write missing wine varietals to the varietal file
f_missing = open("../data/missing",'r')
missing = []
for line in f_missing:
	missing.append(int(line))

for line in varietal_src:
	if (line_count in rand_nums_training) and (line_count not in missing):
		varietal_out.write(str(line_count) + " " + line)
	line_count += 1

varietal_src.close()
varietal_out.close()





# now create the prediction set

review_src = open("../data/reviewsbywords", 'r')
varietal_src = open("varietals", 'r')

review_out_pred = open("reviewsbywords_pred.txt",'w')
varietal_out_pred = open("varietals_n_pred",'w')

rand_count = 0

looking_for = rand_nums_predict[0]

for line in review_src:
	if int(line.split()[0]) == looking_for:
		review_out_pred.write(line)
	elif int(line.split()[0]) > looking_for:
		rand_count += 1
		if rand_count < m_adj:
			looking_for = rand_nums_predict[rand_count]
			if int(line.split()[0]) == looking_for:
				review_out_pred.write(line)

review_src.close()
review_out_pred.close()


line_count = 1

for line in varietal_src:
	if (line_count in rand_nums_predict) and (line_count not in missing):
		varietal_out_pred.write(str(line_count) + " " + line)
	line_count += 1

varietal_src.close()
varietal_out_pred.close()


