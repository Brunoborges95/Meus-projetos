function demoClouseau2
import brml.*
% modified inspector clouseau example

murderer=2; knife=1;
neither=1; maidNotButler=2; butlerNotMaid = 3; both = 4; 
used=1; notused=2;

variable(murderer).domain ={'neither','maid & not butler', 'butler & not maid', 'maid and butler'};
variable(knife).domain={'used','not used'};

variable(murderer).name='murderer';
variable(knife).name='knife';

% Two potentials since p(butler,maid,knife)=p(knife|murderer)p(murderer).
% potential numbering is arbitary
pot{murderer}=array(murderer);
pot{murderer}.table(neither)=0.32;
pot{murderer}.table(maidNotButler)=0.04;
pot{murderer}.table(butlerNotMaid)=0.64;
pot{murderer}.table(both)=0;

pot{knife}=array([knife,murderer]); % define array below using this variable order
tmptable(used, neither)=0.3;  
tmptable(used, maidNotButler)=0.2;
tmptable(used, butlerNotMaid)=0.6;
tmptable(used, both)=0.1;
tmptable(notused,:)=1-tmptable(used,:); % due to normalisation
pot{knife}.table=tmptable;

jointpot = multpots(pot([murderer knife])); % joint distribution

draw_layout(dag(pot),field2cell(variable,'name'));
disp('p(murderer|knife=used):')
disptable(condpot(setpot(jointpot,knife,used),murderer),variable);