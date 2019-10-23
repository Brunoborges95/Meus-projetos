function ConnectedComputerProblem
import brml.*
[c12 c13 c23 c32 c21 c31]=assign(1:6);
[cc12 cc13 cc23 cc32 cc21 cc31]=assign(7:12);
var(c12).name='c[12]';
var(c13).name='c[13]';
var(c23).name='c[23]';
var(c32).name='c[32]';
var(c21).name='c[21]';
var(c31).name='c[31]';
var(cc12).name='c2[12]';
var(cc13).name='c2[13]';
var(cc23).name='c2[23]';
var(cc32).name='c2[32]';
var(cc21).name='c2[21]';
var(cc31).name='c2[31]';

yes=2; no=1;
for i=1:6
    pot{i}=array(i);
    pot{i}.table(yes)=0.1;
    pot{i}.table(no)=0.9;
end

tab=cc12; tabvars=[tab c12 c13 c32]; pot{tab} = computerExampletable(tabvars);
tab=cc13; tabvars=[tab c13 c12 c23]; pot{tab} = computerExampletable(tabvars);
tab=cc23; tabvars=[tab c23 c21 c13]; pot{tab} = computerExampletable(tabvars);
tab=cc21; tabvars=[tab c21 c23 c31]; pot{tab} = computerExampletable(tabvars);
tab=cc32; tabvars=[tab c32 c31 c12]; pot{tab} = computerExampletable(tabvars);
tab=cc31; tabvars=[tab c31 c32 c21]; pot{tab} = computerExampletable(tabvars);

jointpot=multpots(pot);
evpot = setpot(jointpot,[cc12 cc23],[yes no]);
for i=1:6
    tmp=condpot(evpot,i,0);
    conn(i)=tmp.table(yes);
end
conn
drawNet(dag(pot),var);