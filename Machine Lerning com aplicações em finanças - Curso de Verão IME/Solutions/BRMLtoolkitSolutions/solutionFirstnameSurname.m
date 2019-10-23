function solutionFirstnameSurname
import brml.*

% Search for *firstname*surname*
% where * represents a random sequence
% To do this we need three general states and a set of pattern states

cpattern{1}='david';
cpattern{2}='anton';
cpattern{3}='fred';
cpattern{4}='jim';
cpattern{5}='barry';

cpattern{6}='barber';
cpattern{7}='ilsung';
cpattern{8}='fox';
cpattern{9}='chain';
cpattern{10}='fitzwilliam';
cpattern{11}='quinceadams';
cpattern{12}='grafvonunterhosen';

for p=1:12
    pattern{p}=name2num(cpattern{p});
end

firstname=1:5; % 5 first names
surname=6:12; % 7 surnames

patternstate=1:12; % pattern states (1 per pattern)
generalstate=13:15; % general states

nstates=generalstate(end); % total number of pattern+general states

% make the transistion matrix:
tran=zeros(nstates,nstates);
tran(generalstate(1),generalstate(1))=0.8; % not started firstname
for p=firstname
    tran(patternstate(p),generalstate(1))=0.2/length(firstname); % into a firstname
    tran(generalstate(2),patternstate(p))=1; % out of firstname
end
tran(generalstate(2),generalstate(2))=0.8; % not start surname
for p=surname
    tran(patternstate(p),generalstate(2))=0.2/length(surname);
    tran(generalstate(3),patternstate(p))=1;
end
tran(generalstate(1),generalstate(3))=1;
%tran(generalstate(3),generalstate(3))=1;


% emission:
a=0.3; % percent prob of emitting the correct letter
CorruptionProb=ones(26,26)*(1-a)/25;
for i=1:26
    CorruptionProb(i,i)=a;
end

for g=1:length(generalstate)
    pvgh_general(:,g)=ones(26,1)/26; % uniform emission for general states
end
prior.generalstate=[1 0 0]'; % start in general state 1 with certainty

[phghm,pvgh,ph1,startpatternIDX,endpatternIDX,generalstateIDX]=patternsearchsetup(pattern,patternstate,generalstate,tran,CorruptionProb,pvgh_general,prior);

%% generate some data from the model
T=10000;
%[v,h]=HMMsample(T,phghm,pvgh,ph1);
%fprintf(1,'observed sequence: %s\n',num2name(v))
load FirstnameSurnameProblem

v=name2num(noisystring);
[alpha,beta,gamma,delta,loglik,loglikpvhstar]=patternsearch(v,phghm,pvgh,ph1);

[pnum gnum]=getpattern(delta,startpatternIDX,generalstateIDX); % just get which patterns these correspond to.

fprintf(1,'\nViterbi sequence corresponds to:\n\n')

pcount=zeros(length(cpattern),length(cpattern));
fname=false; sname=false;
fprintf(1,'observation: [patternstate generalstate]')
for i=1:length(v)
    fprintf(1,'\n          %s:         [%d        %d]',num2name(v(i)),pnum(i),gnum(i));
    if pnum(i)>0 
        if gnum(i-1)==1;
        fname=true; fnamep=pnum(i);
        end
        if gnum(i-1)==2;
        sname=true; snamep=pnum(i);
        end            
        fprintf(1,' %s',cpattern{pnum(i)})
        if fname && sname
            pcount(fnamep,snamep)=pcount(fnamep,snamep)+1;
            fname=false; sname=false;
        end
    end
end
pcount(1:5,6:end)
fprintf(1,'\n\nlikelihood log p(v_{1:T})=%f\n',loglik) % log probability of the sequence
fprintf(1,'likelihood log p(v_{1:T},h^*_{1:T})=%f\n',loglikpvhstar) % log probabilty of the joint seq and most likely explanation



