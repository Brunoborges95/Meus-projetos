function exerciseCanonVarDigits57 
import brml.*

p = 500; % number of examples
Dim=10;

load digit5; D{1} = x(1:p,:)'; Dtest{1}=x(p+1:end,:)'; T1=size(Dtest{1},2);
load digit7; D{2} = x(1:p,:)'; Dtest{2}=x(p+1:end,:)'; T2=size(Dtest{2},2);
W=((CanonVar(D,Dim)));
YtestCCA=W'*[Dtest{1} Dtest{2}]; %projected test data
YtrainCCA=W'*[D{1} D{2}]; %projected train data

c_cca = nearNeigh(YtrainCCA, YtestCCA, [5*ones(1,size(D{1},2)) 7*ones(1,size(D{2},2))],1); %  nearest neighbour

[Y,E,L,m,Xtilde]=pca([D{1} D{2}],Dim);
Wpca=E(:,1:Dim);
YtestPCA=Wpca'*[Dtest{1} Dtest{2}]; %projected test data
YtrainPCA=Wpca'*[D{1} D{2}]; %projected train data
c_pca = nearNeigh(YtrainPCA, YtestPCA, [5*ones(1,size(D{1},2)) 7*ones(1,size(D{2},2))],1); %  nearest neighbour


fprintf(1,'CCA+KNN number of correct = %d\n',sum(c_cca(1:size(Dtest{1},2))==5)+ sum(c_cca(size(Dtest{1},2)+1:end)==7))
fprintf(1,'PCA+KNN number of correct = %d\n',sum(c_pca(1:size(Dtest{1},2))==5)+ sum(c_pca(size(Dtest{1},2)+1:end)==7))

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
