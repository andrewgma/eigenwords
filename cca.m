% only the following lines need to be edited

revwords = dlmread('reviewsbywords_nc.txt');
namwords_source = dlmread('names_nc.txt');
revwords_predict = dlmread('reviewsbywords_predc.txt');
namwords_predict = dlmread('names_nc_pred.txt');
% matlab matrices for prediction set are made at the end

max_reviews = max(max(revwords(:,1)),max(namwords_source(:,1)));
num_revwords = max(revwords(:,2));

namwords = namwords_source;
num_namwords = max(namwords(:,2));


% first create sparse matrices, then compress the zero rows AND COLUMNS
sparseReviews = sparse(revwords(:,1), revwords(:,2), revwords(:,3), 
	max_reviews, num_revwords, 0);
sparseNames = sparse(namwords(:,1), namwords(:,2), 1, 
	max_reviews, num_namwords, 0);

% only keep rows with reviews
sumRev = sum(sparseReviews');
indexRev = find(sumRev>0);
sparseReviews = sparseReviews(indexRev,:);
sparseNames = sparseNames(indexRev,:);

% only keep columns with words
sumWords = sum(sparseReviews);
indexWords = find(sumWords>0);
sparseReviews = sparseReviews(:,indexWords);

sumNameWords = sum(sparseNames);
indexNameWords = find(sumNameWords>0);
sparseNames = sparseNames(:,indexNameWords);


% use TF*IDF to normalize the matrices
% see tfidf.m, tf.m, idf.m

X = tfidf(sparseNames');
Y = tfidf(sparseReviews');

% CCA calculate canonical correlations
%
% [Wx Wy r] = cca(X,Y) where Wx and Wy contains the canonical correlation
% vectors as columns and r is a vector with corresponding canonical
% correlations. The correlations are sorted in descending order. X and Y
% are matrices where each column is a sample. Hence, X and Y must have
% the same number of columns.
%
% Example: If X is M*K and Y is N*K there are L=MIN(M,N) solutions. Wx is
% then M*L, Wy is N*L and r is L*1.
%
%
% © 2000 Magnus Borga, Linköpings universitet

% --- Calculate covariance matrices ---

z = [X;Y];
C = cov(z.');
sx = size(X,1);
sy = size(Y,1);
Cxx = C(1:sx, 1:sx) + 10^(-8)*eye(sx);
Cxy = C(1:sx, sx+1:sx+sy);
Cyx = Cxy';
Cyy = C(sx+1:sx+sy, sx+1:sx+sy) + 10^(-8)*eye(sy);
invCyy = inv(Cyy);

% --- Calcualte Wx and r ---

[Wx,r] = eig(inv(Cxx)*Cxy*invCyy*Cyx); % Basis in X
r = sqrt(real(r));      % Canonical correlations

% --- Sort correlations ---

V = fliplr(Wx);		% reverse order of eigenvectors
r = flipud(diag(r));	% extract eigenvalues anr reverse their orrer
[r,I]= sort((real(r)));	% sort reversed eigenvalues in ascending order
r = flipud(r);		% restore sorted eigenvalues into descending order
for j = 1:length(I)
  Wx(:,j) = V(:,I(j));  % sort reversed eigenvectors in ascending order
end
Wx = fliplr(Wx);	% restore sorted eigenvectors into descending order

% --- Calcualte Wy  ---

Wy = invCyy*Cyx*Wx;     % Basis in Y
Wy = Wy./repmat(sqrt(sum(abs(Wy).^2)),sy,1); % Normalize Wy



% begin predictions


max_reviews_predict = max(revwords_predict(:,1));
num_revwords = max(revwords_predict(:,2)); % not changed

namwords = namwords_predict;
num_namwords = max(namwords(:,2)); % not changed


% first create sparse matrices, then compress the zero rows
sparseReviews_predict = sparse(revwords_predict(:,1), revwords_predict(:,2), 
	revwords_predict(:,3),	max_reviews_predict, num_revwords, 0);
sparseNames_predict = sparse(namwords_predict(:,1), namwords_predict(:,2), 
	1, max_reviews_predict, num_namwords, 0);

% only keep rows with reviews
sumRev_predict = sum(sparseReviews_predict');
index_predict = find(sumRev_predict>0);
sparseReviews_predict = sparseReviews_predict(index_predict,:);
sparseNames_predict = sparseNames_predict(index_predict,:);

% only keep columns with words as previously determined
sparseReviews_predict = sparseReviews_predict(:,indexWords);
sparseNames_predict = sparseNames_predict(:,indexNameWords);


num_reviews_predict = size(index_predict)(1,2);
num_names_predict = size(indexNameWords)(1,2);
num_revwords = size(indexWords)(1,2);
predictions_cca = sparse(num_reviews_predict,num_names_predict);

for n = 1:num_reviews_predict
words_temp = sparseReviews_predict(n,:);
coeffs_temp = words_temp*Wy;
% multiply by d to increase number of predictions
d=50;
prediction_temp = round((Wx/coeffs_temp)*d);
for m = 1:num_names_predict
if prediction_temp(m,1) < 0
prediction_temp(m,1) = 0;
end
end
predictions_cca(n,:) = prediction_temp';
end


% Error (sum of squared error squared for each wine)

error_metric = 0;

for n = 1:num_reviews_predict
error_temp = (predictions_cca(n,:) - sparseNames_predict(n,:));
error_metric += sum(error_temp.^2);
end

% Error v2 (weighted percent of correct/total predictions for each wine)

error_metric_2 = 0;

% for n = 1:num_reviews_predict
% 	if sum(predictions_cca(n,:)) > 0
% 		error_temp = 0;
% 		for m = 1:num_names_predict
% 			curr_value = sparseNames_predict(n,m);
% 			if curr_value > 0
% 				if curr_value == predictions_cca(n,m);
% 					error_temp += curr_value;
% 				else
% 					error_temp += min(curr_value,predictions_cca(n,m));
% 				end
% 			end
% 		end
% 		error_metric_2 += error_temp/sum(predictions_cca(n,:));
% 	end
% end



error_metric_2 = 0;
for n = 1:num_reviews_predict
if sum(predictions_cca(n,:)) > 0
error_temp = 0;
for m = 1:num_names_predict
curr_value = sparseNames_predict(n,m);
if curr_value > 0
if curr_value == predictions_cca(n,m);
error_temp += curr_value;
else
error_temp += min(curr_value,predictions_cca(n,m));
end
end
end
error_metric_2 += error_temp/sum(predictions_cca(n,:));
end
end


'wines in training set:'
size(sparseReviews)(1,1)
'wines in prediction set:'
num_reviews_predict
'number of review words:'
num_revwords
'number of name words:'
num_names_predict
'error1:'
error_metric
'error2:'
error_metric_2/num_reviews_predict

