function ABCproblem
import brml.*

[a b c]=assign([1 2 3]);
pA=array(a,[3/5 2/5]);
pBgA=array([b a],[1/4 15/40; 1/12 1/8; 2/3 1/2]);
pCgB=array([c b],[1/3 1/2 15/40; 2/3 1/2 5/8]);
pABC=pA*pBgA*pCgB;
pAC=sum(pABC,b);
pApC = sum(pAC,a)*sum(pAC,c);

disp('check if a and c are independent:')
disp('p(a,c):'); table(pAC)
disp('p(a)p(c):'); table(pApC)

M(:,1)=rand(2,1);
lambda=rand;
M(:,2)=lambda*M(:,1);
M(:,3)=rand(2,1);
N(:,1)=rand(2,1);
N(:,2)=rand(2,1);

gamma=rand;
N(:,3)=gamma*(N(:,1)+lambda*N(:,2));
[a b c]=assign([1 2 3]);

potAB=array([a b],M);
potBC=array([b c],N');
potABC=condpot(potAB*potBC); % normalise

disp('p(a):'); table(condpot(sum(potABC,[b c])))
disp('p(b|a):'); table(condpot(potABC,b,a))'
disp('p(c|b):'); table(condpot(potABC,c,b))'

disp('check if a and c are independent:')
potAC=sumpot(potABC,b);
potApotC = sum(potAC,a)*sum(potAC,c);
disp('p(a,c):'); table(potAC)
disp('p(a)p(c):');table(potApotC)