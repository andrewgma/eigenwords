f = open("names1000c2.txt",'r')

max = 0

for line in f:
	word = int(line.split()[1])
	if word > max:
		max = word

print max
