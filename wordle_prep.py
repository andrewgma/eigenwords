# for each word, what varietal is it most correlated with?

cca = open("Wy.txt",'r')
word_ref = open("indexWords.txt",'r')
word_dict = open("../../winemag/winemag_1.hist",'r')

out = open("wordle.txt",'w')


word_lookups = word_ref.readline().split()
word_lookup_dict = {}

i = 1
line_count = 1
while i < int(word_lookups[-1])+1:
	lookup = word_dict.readline()
	while str(i) not in word_lookups:
		i += 1
		lookup = word_dict.readline()
	word_lookup_dict[line_count] = lookup.split()[1]
	i += 1
	line_count += 1

line_count = 1
for line in cca:
	if len(line)>1:
		maxVar = 0
		maxVal = -999
		for i in range(0,24):
			if float(line.split()[i]) > maxVal:
				maxVal = float(line.split()[i])
				maxVar = i+1
		out.write(str(maxVar) + " " + word_lookup_dict[line_count] + " " 
			+ str(maxVal*120) + "\n")
		line_count += 1