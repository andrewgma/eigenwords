source = open('../data/winemag_reviews','r')

f = open("varietals.txt",'w')

linecount = 0

varietal_dict = {}
varietal_count = 1

for line in source:
	words = line.split()
	if words[0] == "Varietal:":
		varietal = ""
		for i in range(1,len(words)):
			varietal = varietal + words[i] + " "
		if varietal not in varietal_dict:
			varietal_dict[varietal] = varietal_count
			varietal_count += 1
		f.write(str(varietal_dict[varietal]) + "\n")
		linecount = 0
	elif linecount > 5:
		f.write("\n")
		linecount = 1
	else:
		linecount += 1

f.close()

dic_output = open("varietal_dict.txt",'w')

for varietal in varietal_dict:
	dic_output.write(str(varietal_dict[varietal]) + " " + varietal + "\n")