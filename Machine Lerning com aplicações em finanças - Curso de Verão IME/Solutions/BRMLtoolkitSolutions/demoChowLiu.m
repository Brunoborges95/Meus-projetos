%function demoChowLiu
clear all; close all
import brml.*
nstates=[2 2 3 3 3 3 2 3 3 2];
for n=1:10
    possibleparents=1:n-1;
    pot{n}=array;
    pot{n}.variables=[n randgen(ones(1,length(possibleparents)),1,1,possibleparents)];
    pot{n}.table=condp(myrand(nstates(pot{n}.variables)));
end
X=ancestralsample(pot,1000);
subplot(1,2,1); drawNet(dag(pot)); title('true Belief Net')
subplot(1,2,2); drawNet(ChowLiu(X)); title('Chow Liu Net from data')