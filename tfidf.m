function Y = tfidf( X )
% FUNCTION computes TF-IDF weighted word histograms.
%
%   Y = tfidf( X );
%
% INPUT :
%   X        - document-term matrix (documents in columns)
%
% OUTPUT :
%   Y        - TF-IDF weighted document-term matrix
%
 
% get term frequencies
X = tf(X);
 
% get inverse document frequencies
I = idf(X);
 
% apply weights for each document
for j=1:size(X, 2)
    X(:, j) = X(:, j)*I(j);
end
 
Y = X;