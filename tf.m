function X = tf(X)
% SUBFUNCTION computes word frequencies
 
% for every word
for i=1:size(X, 1)
    
    % get word i counts for all documents
    x = X(i, :);
    
    % sum all word i occurences in the whole collection
    sumX = sum( x );
    
    % compute frequency of the word i in the whole collection
    if sumX ~= 0
        X(i, :) = x / sum(x);
    else
        % avoiding NaNs : set zero to never appearing words
        X(i, :) = 0;
    end
    
end