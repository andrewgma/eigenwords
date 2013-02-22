import sys

filename = sys.argv[1]

f = open(filename,'r')

rounded = open(filename+"_rounded",'w')

predicted_word_count = 0

for line in f:
	if float(line) < 0:
		rounded.write("0"+"\n")
	else:
		rounded_val = int(round(float(line)))
		# option for round down:
		# rounded_val = int((float(line)))
		rounded.write(str(rounded_val)+"\n")
		predicted_word_count += int(rounded_val)

f.close()
rounded.close()

print 'total number of words predicted: ' + str(predicted_word_count)