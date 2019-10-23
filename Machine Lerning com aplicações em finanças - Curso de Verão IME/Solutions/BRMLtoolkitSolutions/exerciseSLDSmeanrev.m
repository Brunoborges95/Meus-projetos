function exerciseSLDSmeanrev
import brml.*
S=2;

H=1; V=1;
B=zeros(V,H,S);
A=zeros(H,H,S);
alpha=0.9; m=10;

A(:,:,1) = alpha;
A(:,:,2) =1;
meanH(:,1) = m-alpha*m;
meanH(:,2) = 0;
covH(:,:,1)=0.0001;
covH(:,:,2)=0.01;
B(:,:,1) = 1;
B(:,:,2) =1;
covV(:,:,1)=0.001;
covV(:,:,2)=0.001;
prior=[0.5 0.5]';
covP(:,:,1)=0.1*eye(H);covP(:,:,2)=0.1*eye(H);
meanP(:,1)=m; % vague prior
meanP(:,2)=m;

stran=condp([0.95 0.05; 0.05 0.95]);

load meanrev
I=2;
% Perform approximate Filtered inference:
[f F alpha w loglik]=SLDSforward(v,A,B,covH,covV,meanH,zeros(V,H,S),covP,meanP,stran,prior,I);

% Perform approximate Smoothed inference:
J=I; doEC=1;

inference={'GPB','EC '};
[g G gamma u]=SLDSbackward(v,f,F,alpha,w,A,covH,meanH,stran,I,J,doEC);

fprintf(1,'\np(s(280)=2|v(1:280)=%g',alpha(2,280))

fprintf(1,'\np(s(280)=2|v(1:4000)=%g',gamma(2,280))



