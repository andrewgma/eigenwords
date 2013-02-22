% only the following lines need to be edited

revwords = dlmread('reviewsbywords_nc_v2.txt');
varwords_source = dlmread('varietals_n');
revwords_predict = dlmread('reviewsbywords_predc_v2.txt');
varwords_predict = dlmread('varietals_n_pred');
% matlab matrices for prediction set are made at the end

max_reviews = max(revwords(:,1));
num_revwords = max(revwords(:,2));

varwords = varwords_source;
num_varwords = max(varwords(:,2));


% first create sparse matrices, then compress the zero rows AND COLUMNS
sparseReviews = sparse(revwords(:,1), revwords(:,2), revwords(:,3), 
	max_reviews, num_revwords, 0);
sparseVarietals = sparse(varwords(:,1), varwords(:,2), 1, 
	max_reviews, num_varwords, 0);

% only keep rows with reviews
sumRev = sum(sparseReviews');
indexRev = find(sumRev>0);
sparseReviews = sparseReviews(indexRev,:);
sparseVarietals = sparseVarietals(indexRev,:);

% only keep columns with words
sumWords = sum(sparseReviews);
indexWords = find(sumWords>0);
sparseReviews = sparseReviews(:,indexWords);


X = sparseVarietals';
Y = sparseReviews';

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

varwords = varwords_predict;
num_varwords = max(varwords(:,2)); % not changed


% first create sparse matrices, then compress the zero rows
sparseReviews_predict = sparse(revwords_predict(:,1), revwords_predict(:,2), 
	revwords_predict(:,3),	max_reviews_predict, num_revwords, 0);
sparseVarietals_predict = sparse(varwords_predict(:,1), varwords_predict(:,2), 
	1, max_reviews_predict, num_varwords, 0);

% only keep rows with reviews
sumRev_predict = sum(sparseReviews_predict');
index_predict = find(sumRev_predict>0);
sparseReviews_predict = sparseReviews_predict(index_predict,:);
sparseVarietals_predict = sparseVarietals_predict(index_predict,:);

% only keep columns with words as previously determined
sparseReviews_predict = sparseReviews_predict(:,indexWords);


num_reviews_predict = size(index_predict)(1,2);
predictions_cca = zeros(num_reviews_predict,1);

for n = 1:num_reviews_predict
	words_temp = sparseReviews_predict(n,:);
	coeffs_temp = words_temp*Wy;
	% divide by d to reduce number of predictions
	prediction_temp = Wx/coeffs_temp;
	[maxVal, maxInd] = max(prediction_temp);
	predictions_cca(n,1) = maxInd;
end


% Metric (error squared)

error_metric_cca = 0;

for n = 1:num_reviews_predict
	if 1 ~= sparseVarietals_predict(n,predictions_cca(n,1))
		error_metric_cca += 1;
	end
end

'wines in training set:'
size(sparseReviews)(1,1)
'wines in prediction set:'
num_reviews_predict
'number of varietals:'
num_varwords
'number of review words:'
size(sparseReviews)(1,2)
'number correctly predicted:'
num_reviews_predict - error_metric_cca
'percent correctly preddicted:'
(num_reviews_predict - error_metric_cca)/num_reviews_predict

