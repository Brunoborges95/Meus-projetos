function wetgrass
import brml.*
% variable ordering
r=1; s=2; j=3;t=4;
% number states
true=1; false=2;
% name random vars
variable(r).name='r';variable(s).name='s';
variable(j).name='j';variable(t).name='t';
% name random vare states
variable(r).domain={'true','false'}; variable(s).domain={'true','false'};
variable(j).domain={'true','false'}; variable(t).domain={'true','false'};
% define p(r)
pot{r}=array(r);
pot{r}.table(true)=0.2; pot{r}.table(false)=1-pot{r}.table(true);
% define p(s)
pot{s}=array(s);
pot{s}.table(true)=0.1; pot{s}.table(false)=1-pot{s}.table(true);
% define p(j|r)
pot{j}=array([j,r]);
pot{j}.table(true,true)=1; pot{j}.table(true,false)=0.2;
pot{j}.table(false,:)=1-pot{j}.table(true,:);
% define p(t|r,s)
pot{t}=array([t,r,s]);
pot{t}.table(true,true,true)=1;
pot{t}.table(true,false,true)=0.9;
pot{t}.table(true,true,false)=1;
pot{t}.table(true,false,false)=0;
pot{t}.table(false,:,:)=1-pot{t}.table(true,:,:);
% calculate p(r,s,j,t)
jointPot=multpots(pot([r s j t]));
disp('p(s|t=true)');
%conditionalise s on t p(s|t) and then set t=true
disptable(setpot(condpot(jointPot,s,t),t,true),variable);