function I = idf(X)
% SUBFUNCTION computes inverse document frequencies
 
% m - number of terms or words
% n - number of documents
[m, n]=size(X);
 
% allocate space for document idf's
I = zeros(n, 1);
 
% for every document
for j=1:n
    
    % count non-zero frequency words
    nz = nnz( X(:, j) );
    
    % if not zero, assign a weight:
    if nz
        I(j) = log( m / nz );
    end
    
end