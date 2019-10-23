 function demoHamburger
%Exercício 1.12
%Bruno Borges de Souza
import brml.*

hamburgers=1; KJ=2; % Variable order is arbitary
tr=1; fa=2; % define states, starting from 1.

% The following definitions of variable are not necessary for computation,
% but are useful for displaying table entries:
variable(hamburgers).name='hamburgers'; variable(hamburgers).domain = {'tr','fa'};
variable(KJ).name='KJ'; variable(KJ).domain ={'tr','fa'};

pot(KJ)=array;
pot(KJ).variables=[KJ];
pot(KJ).table(tr)=0.00001;
pot(KJ).table(fa)=0.99999;

pot(hamburgers)=array;
pot(hamburgers).variables=[KJ,hamburgers];
pot(hamburgers).table(tr,fa)=0.1;
pot(hamburgers).table(tr,tr)=0.9;
pot(hamburgers).table(fa,:)=0.001;

jointpot = multpots(pot); % joint distribution

drawNet(dag(pot),variable);
disp('p(KJ|hamburgers=tr):')
disptable(condpot(setpot(jointpot,hamburgers,tr),KJ),variable);