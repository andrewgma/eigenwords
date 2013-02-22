for var in range(1,25):

	f = open("wordle.txt",'r')

	output = open("wordles/wordle" + str(var) + ".txt",'w')

	for line in f:
		if line.split()[0] == str(var):
			output.write(line.split()[1] + ":" + line.split()[2] + "\n")
	
	f.close()
	output.close()

