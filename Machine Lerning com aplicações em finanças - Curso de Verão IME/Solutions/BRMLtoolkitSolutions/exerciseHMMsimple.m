function exerciseHMMsimple 
import brml.*

h=1:3; v=4:6;
p_initial=array(h(1),[0.9 0.1 0]);

t=1;
empot=array([v(t) h(t)],[0.7 0.4 0.8; 0.3 0.6 0.2]);

jointpot=multpots([p_initial empot]);
for t=2:3
    tranpot=array([h(t) h(t-1)],[ 0.5 0 0; 0.3 0.6 0; 0.2 0.4 1]);
    empot=array([v(t) h(t)],[0.7 0.4 0.8; 0.3 0.6 0.2]);
    jointpot=multpots([jointpot tranpot empot]);    
end

disp('p(v(1:3):')
table(sumpot(setpot(jointpot,v,[1 2 1]),[],0))

disp('p(h(1)|v(1:3):')
table(condpot(setpot(jointpot,v,[1 2 1]),h(1),0))

disp('argmax p(h(1:3)|v(1:3):')
[val state]=maxpot(setpot(jointpot,v,[1 2 1]),[],0);
state


