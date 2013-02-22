% build 2n * n matrix (n = 5516)
% each column is a word in the vocabulary (size n)
% each of the n words has two corresponding rows, indicating an appearance 
% before or after the word in the column

n = 5516;

num_rows = n*2;
num_columns = n;

trigrams = dlmread('trigrams');

% each word has two corresponding adjacent rows
% rows in top half mean an appearance of the row# BEFORE the column#
% rows in bottom half mean an appearance of the row# AFTER the column#

occurrence_counts = sparse([trigrams(:,1); trigrams(:,2)+5516], 
	[trigrams(:,2); trigrams(:,1)], 1, num_rows, num_columns, 0);

% note that the bottom half of the matrix is exactly the inverse of the top half





[U,D,V] = fast_svd(occurrence_counts,20)


% following method in EMNLP_simple.pdf

% k = 40;
% l = 10;
% c = num_rows;

% omega = rand(k+l, c);

% [U_1, D_1, V_1] = svd(omega*occurrence_counts);

% V_1_k = V_1(:,1:k);

% [U_2, D_2, V_2] = svd(occurrence_counts*V_1_k);




% haven't done this when skip word
% would need a new trigrams file
