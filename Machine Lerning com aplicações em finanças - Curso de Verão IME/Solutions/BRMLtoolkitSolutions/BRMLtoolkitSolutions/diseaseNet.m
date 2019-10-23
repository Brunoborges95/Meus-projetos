function diseaseNet
import brml.*
D=20;S=40; dv=1:D; sv=D+1:D+S;
load diseaseNet
pot=str2cell(setpotclass(pot,'array'));
drawNet(dag(pot),variable);

tstart=tic;
[jtpot jtsep infostruct]=jtree(pot); % setup the Junction Tree
jtpot=absorption(jtpot,jtsep,infostruct); % do full round of absorption
t=toc(tstart);
disp(['Junction Tree takes ',num2str(t),' seconds to form and perform absoprtion'])

for i=1:length(jtpot); label{i}=horzcat(variable(jtpot{i}.variables).name); sz(i)=length(jtpot{i}.variables); end
figure; draw_layout(infostruct.cliquetree,label);
drawnow
disp(['Maximum JT clique size is ',num2str(max(sz))])

for s=1:S
    jtpotnum = whichpot(jtpot,sv(s),1); % find a single JT potential that contains the sympton
    margpot=sumpot(jtpot{jtpotnum},sv(s),0);
    ps_jt(s)=margpot.table(1);
end

% More efficent summation based on needing only the parents of each sympton:
tstart=tic;
A = dag(pot);
for s=1:S
    margpot2 = sumpot(multpots([pot(sv(s)) pot(parents(A,sv(s)))]),sv(s),0);
    ps_eff(s)=margpot2.table(1);
end
t=toc(tstart);
disp(['Efficent inference takes ',num2str(t),' seconds'])

disp('JT marginals and Efficient Inference marginals are the same:')
for s=1:S;fprintf(1,'p(s(%d)=1): Junction tree %g : efficient inference: %g\n',s,ps_jt(s),ps_eff(s)); end

[jtpot jtsep]=jtassignpot(setpot(pot,[sv(1:5) sv(6:10)],[1 1 1 1 1 2 2 2 2 2]),infostruct);
jtpot=absorption(jtpot,jtsep,infostruct); % do full round of absorption
disp('The marginals p(disease=1|evidence):')
for d=1:D
    jtpotnum = whichpot(jtpot,d,1) % find a single JT potential that contains the disease
    margpot=condpot(sumpot(jtpot(jtpotnum),d,0));
    pd_jt(d)=margpot.table(1);
    fprintf(1,'p(d(%d)=1|s(1:10))=%g\n',d,pd_jt(d));
end

