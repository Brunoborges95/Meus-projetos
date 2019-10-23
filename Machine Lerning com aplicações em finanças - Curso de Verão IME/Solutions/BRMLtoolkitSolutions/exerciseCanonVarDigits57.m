function exerciseCanonVarDigits57 
import brml.*

p = 500; % Computando o número de exemplos
%Algoritmo CanonVar
%Primeiros 500 exemplos
load digit5; D{1} = x(1:p,:)';
load digit7; D{2} = x(1:p,:)'; 
 D2{1}=x(p+1:end,:)'; T1=size(D2{1},2);
 D2{2}=x(p+1:end,:)'; T2=size(D2{2},2);
 %CANONVAR  Canonical Variates (no post rotation of variates)
% W=CanonVar(X,K,<shrinkage>)
%
% Inputs:
% X : cell array of data matrices in which each column contains a
% datapoint. X{c} contains the data for class c
% K : dimension of the projection
%
% Output:
% W : the projection matrix
W=((CanonVar(D,10)));
%NEARNEIGH Nearest Neighbour classification
% y=nearNeigh(xtrain, xtest, trainlabels,K)
xtest=W'*[D2{1} D2{2}];
xtrain=W'*[D{1} D{2}]; 

y1 = nearNeigh(xtrain, xtest, [5*ones(1,size(D{1},2)) 7*ones(1,size(D{2},2))],2); %  nearest neighbour
%Algoritmo PCA
%PCA Principal Components Analysis
% [Y,E,L,m,Xtilde]=pca(X,<M>,<usemean>,<return only principal solution>)
% Inputs:
% X : each column of matrix X contains a datapoint
% M : the number of principal components to retain (if missing M=size(X,1))
% usemean : set this to 1 to use a mean for the reconstruction
% return only principal solution : set to 1 to return only the M leading eigenvectors and eigenvalues
% Outputs:
% Y : coefficients
% E : eigenvectors
% L : eigenvalues
% m : mean of the data
% Xtilde : reconstructions using M components
pca([D{1} D{2}],10);
W2=E(:,1:10);
xtest2=W2'*[D2{1} D2{2}]; %projected test data
xtrain2=W2'*[D{1} D{2}]; %projected train data
y2 = nearNeigh(xtrain2, xtest2, [5*ones(1,size(D{1},2)) 7*ones(1,size(D{2},2))],1); %  nearest neighbour


fprintf(1,'CCA+KNN number of correct = %d\n',sum(y1(1:size(D2{1},2))==5)+ sum(y1(size(D2{1},2)+1:end)==7))
fprintf(1,'PCA+KNN number of correct = %d\n',sum(y2(1:size(D2{1},2))==5)+ sum(y2(size(D2{1},2)+1:end)==7))

%size(Dtest{1},2)+size(Dtest{2},2)


scatter(YtrainCCA(1,1:500),YtrainCCA(2,1:500),100,'r.'); hold on
scatter(YtrainCCA(1,501:end),YtrainCCA(2,501:end),100,'g.'); 
title('CCA train')


figure
scatter(YtestCCA(1,1:T1),YtestCCA(2,1:T1),100,'r.'); hold on
scatter(YtestCCA(1,T1+1:end),YtestCCA(2,T1+1:end),100,'g.'); 
title('CCA test')


figure
scatter(YtrainPCA(1,1:500),YtrainPCA(2,1:500),100,'r.'); hold on
scatter(YtrainPCA(1,501:end),YtrainPCA(2,501:end),100,'g.'); 
title('PCA train')


figure
scatter(YtestPCA(1,1:T1),YtestPCA(2,1:T1),100,'r.'); hold on
scatter(YtestPCA(1,T1+1:end),YtestPCA(2,T1+1:end),100,'g.'); 
title('PCA test')

for d=1:Dim
figure
imagesc(reshape(W(:,d),28,28)'); title(['cca' num2str(d)])
end

for d=1:Dim
figure
imagesc(reshape(Wpca(:,d),28,28)'); title(['pca' num2str(d)])
end
