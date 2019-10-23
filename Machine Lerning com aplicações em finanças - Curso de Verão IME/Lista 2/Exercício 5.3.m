function demoShortestPathMult
%DEMOSHORTESTPATH demo of finding the shortest weigthed path

%1. Write a list of rooms which cannot be reached from room 2 after 10 time steps.
import brml.*
load('virtualworlds.mat')
A=M;
B=[0];
for k=1:numel(B)
 A(ismember(A,B(k)))=inf;
end
disp('A lista de salas que n�o podem ser alcan�adas da sala dois ap�s 10 etapas:');
[optpathmult pathweightmult]=mostprobablepathmult(-A');
N=size(A,1);
startstate=2;
    for endstate=[1:startstate-1:startstate+1:N]
        [optpath logprob]=mostprobablepath(-A',startstate,endstate);
        if isfinite(logprob)
            if length(optpath)>10
            fprintf('[%d->%d]:\n',startstate,endstate)
            fprintf('multiple source method: path weight= %g, path: ',pathweightmult(startstate,endstate))
            s1= noselfpath(squeeze(optpathmult(startstate,endstate,:))');
            fprintf('%s\n',num2str(s1))
            end
        end
    end
%2. The manager complains that takes at least 13 time steps to get from room 1 to room 100. Is this true?
p=M./repmat(sum(M),size(M,1),1);
a=1; % start state
b=100; % end state
disp('O menor caminho cont�m 13 passos como observado abaixo. Portanto � verdade:');
[optpath logprob]=mostprobablepath(log(p),a,b)

%3. Find the most likely path (sequence of rooms) to get from room 1 to room 100.
p=M./repmat(sum(M),size(M,1),1);
a=1; % start state
b=100; % end state
disp('O caminho mais prov�vel da sala 1 a 100 �:');
[optpath logprob]=mostprobablepath(log(p),a,b)

%4. If a single player were to jump randomly from one room to another (or stay in the same room), with no
%preference between rooms, what is the probability at time t  1 the player will be in room 1? Assume
%that efectively an infinite amount of time has passed and the player began in room 1 at t = 1.

p=M./repmat(sum(M),size(M,1),1);
a=1; % start state
b=1; % end state
[optpath logprob]=mostprobablepath(log(p),a,b)
disp('A probabilidade do player est� na sala 1 �:');
10^(logprob)

%5. If two players are jumping randomly between rooms (or staying in the same room), explain how to
%compute the probability that, after an infinite amount of time, at least one of them will be in room 1?
%Assume that both players begin in room 1.

disp('A probabilidade de ao menos um player  est� na sala 1 � p(A uni�o A), senda p(A)  probabilidade de um player est� na sala 1.:');
ans+ans-ans*ans

