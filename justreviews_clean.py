# remove the ' . ' in front of each line of justreviews

f = open("../winemag/justreviews", 'r')

new_output = open("justreviews_clean", 'w')

for line in f:
	if line[0]==' ' and line[1]=='.' and line[2]==' ':
		new_output.write(line[3:])
	else:
		new_output.write(line)