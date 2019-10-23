function demoNaiveBayes
% Exercício com códigos derivado do exemplo DEMONAIVEBAYES Naive Bayes
import brml.*
xP=[1 0 1 1 1 0 1 1; % Politicos
0 0 0 1 0 0 1 1;
1 0 0 1 1 0 1 0;
0 1 0 0 1 1 0 1;
0 0 0 1 1 0 1 1;
0 0 0 1 1 0 0 1]
xS=[1 1 0 0 0 0 0 0; % Sport
0 0 1 0 0 0 0 0;
1 1 0 1 0 0 0 0;
1 1 0 1 0 0 0 1;
1 1 0 1 1 0 0 0;
0 0 0 1 0 1 0 0;
1 1 1 1 1 0 1 0]

pP = size(xP,1)/(size(xP,1) + size(xS,1)); pS =1-pP; % ML class priors pP = p(c=P), pS=p(c=S)

mP = mean(xP); % ML estimates of p(x=1|c=P)
mS = mean(xS); % ML estimates of p(x=1|c=S)

xtest=[1 0 0 1 1 1 1 0]; % test point

npP = pP*prod(mP.^xtest.*(1-mP).^(1-xtest)); % p(x,c=P)
npS = pS*prod(mS.^xtest.*(1-mS).^(1-xtest)); % p(x,c=S)

pxP = npP/(npP+npS); % probability that x is Politic
disp(['probabilidade de x ser político é = ',num2str(pxP)]);
