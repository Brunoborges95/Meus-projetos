function partyanimal
import brml.*
[H A P U D]=assign(1:5); [yes no]=assign(1:2);
var(H).name='headache'; var(H).domain={'yes','no'};
var(A).name='boss angry'; var(A).domain={'yes','no'};
var(P).name='been to party'; var(P).domain={'yes','no'};
var(U).name='underperform'; var(U).domain={'yes','no'};
var(D).name='demotivated'; var(D).domain={'yes','no'};


tmp(yes,yes,yes)=0.999;
tmp(yes,yes,no)=0.9;
tmp(yes,no,yes)=0.9;
tmp(yes,no,no)=0.01;
tmp(no,:,:)=1-tmp(yes,:,:);
pot{U}=array([U P D],tmp);

clear tmp
tmp(yes,yes)=0.9;
tmp(yes,no)=0.2;
tmp(no,:)=1-tmp(yes,:);
pot{H}=array([H P],tmp);

clear tmp
tmp(yes,yes)=0.95;
tmp(yes,no)=0.5;
tmp(no,:)=1-tmp(yes,:);
pot{A}=array([A U],tmp);

pot{P}=array(P); 
pot{P}.table(yes)=0.2;pot{P}.table(no)=0.8;

pot{D}=array(D); 
pot{D}.table(yes)=0.4; pot{D}.table(no)=0.6;

jointpot=multpots(pot);
disptable(condpot(setpot(jointpot,[H A],[yes yes]),P),var);

