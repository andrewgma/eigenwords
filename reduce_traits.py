f = open("reviewsbywords",'r')
new = open("reviewsbywords4", 'w')

for line in f:
	if int(line.split()[1]) <= 10000:
		new.write(line)