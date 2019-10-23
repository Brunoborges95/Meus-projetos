function exercise141
import brml.*
data=load('./data/NNdata.mat');
n=[600 600]; % numero de pontos em treinamento nas classes

train5=data.train5;  % class 5 treinando os dados para o dígito 5
train9=data.train9;  % class 9 treinando os dados para o dígito 9


test5=data.test5; % Testando os dados para o dígito 5
test9=data.test9; % testando dados para o dígito 9 

traindata=[train5  train9];
trainlabel=[5*ones(1,600), 9*ones(1,600)];

xtest=[test5 test9];
train =[train5 train9];

for ks=1:20
    error=0;
    for t5=1:1200
        train5=train(:,[1:t5-1 t5+1:end]);
        test5=train(:,t5);
        trainlabel5=trainlabel([1:t5-1 t5+1:end]);
        testlabel=trainlabel(t5);
        %NEARNEIGH Nearest Neighbour classification
% y=nearNeigh(xtrain, xtest, trainlabels,K)
% calculate the nearest  neighbour classification (use squared distance to measure dissimilarity)
% If there is a tie, the single nearest neighbour class is returned
% xtrain : matrix with each column a training vector
% xtest : matrix with each column a test vector
% trainlabels : vector of length size(xtrain,2) of training labels
        y = nearNeigh(train5, test5, trainlabel5,ks); % Encontrando proximidades
        errorfinal(t5,ks)=y~=testlabel;     
    end
end

errors=sum(errorfinal,1);
for K=1:20
     disp(['Com K=' num2str(K) ' existem Erros= ' num2str(errors(K)),'']);
end
Melhor_K=argmin(errors);
disp(['Portanto, o melhor K =' num2str(Melhor_K)]);

%% Obtendo precisão de classificação para melhor k


testout5 = nearNeigh(traindata,test5 , trainlabel,Melhor_K); % Encontrando proximidades
testout9 = nearNeigh(traindata,test9 , trainlabel,Melhor_K); % Encontrando proximidades
y = nearNeigh(train,xtest, trainlabel,Melhor_K);
erros =sum(y(1:252)~=5)+sum(y(253:end)~=9);

accuracy=((584-(erros))/584)*100;

disp(strcat('Acuracia= ', num2str(accuracy),'%'));

