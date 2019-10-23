%function demoHolmes
import brml.*
[b a w g]=assign(1:4); % Variable order is arbitary
t=1; f=2; % define states, starting from 1.

var(b).name='b'; var(b).domain={'t','f'};
var(a).name='a';var(a).domain={'t','f'};
var(w).name='w';var(w).domain={'t','f'};
var(g).name='g';var(g).domain={'t','f'};

pot{b}=array(b);
pot{b}.table(t)=0.01;pot{b}.table(f)=1-0.01;

tmp(t,t)=0.99; tmp(t,f)=0.05; tmp(f,:)=1-tmp(t,:);
pot{a}=array([a b],tmp);

tmp(t,t)=0.9; tmp(t,f)=0.5; tmp(f,:)=1-tmp(t,:);
pot{w}=array([w a],tmp);

tmp(t,t)=0.7; tmp(t,f)=0.2; tmp(f,:)=1-tmp(t,:);
pot{g}=array([g a],tmp);

jointpot=multpots(pot);

disp('question 1a:')
disptable(condpot(setpot(jointpot,w,t),b));

disp('question 1b:')
disptable(condpot(setpot(jointpot,[w g],[t f]),b));

[b a w g tw tg]=assign(1:6); 
pot{tw}=array(w);
pot{tw}.table(f)=0.7; pot{tw}.table(t)=1-0.7;

pot{tg}=array(g);
pot{tg}.table(f)=0.9; pot{tg}.table(t)=1-0.9;

disp('question 2a:')
disptable(condpot(multpots([condpot(jointpot,b,w) pot{tw}]),b));

disp('question 2b:')
disptable(condpot(multpots([condpot(jointpot,b,[w g]) pot{tw} pot{tg}]),b));


