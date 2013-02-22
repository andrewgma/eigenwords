import re

source = open('winemag_reviews','r')

f = open("prices",'w')

linecount = 0

for line in source:
	words = line.split()
	if words[0] == "Price:":
		p = words[1]
		p = re.sub('\$','',p)
		f.write(p + "\n")
		linecount = 0
	elif linecount > 5:
		f.write("\n")
		linecount = 1
	else:
		linecount += 1

f.close()