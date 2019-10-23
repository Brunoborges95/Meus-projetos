function demoCars
%DEMOCARS husband and wife cars example
import brml.*
income=3; wife=1; husband=2; % Variable order is arbitary
[low high]=assign(1:2); % some states

% The following definitions of variable are not necessary for computation,
% but are useful for displaying table entries:
variable(income).name='income'; variable(income).domain = {'low','high'};
variable(wife).name='wife'; variable(wife).domain ={'cheap1','cheap2','expensive1','expensive2'};
variable(husband).name='husband'; variable(husband).domain ={'cheap1','cheap2','expensive1','expensive2'};

% Three potentials since p(income,husband,wife)=p(wife|income)p(husband|income)p(income).

pot{income}=array(income, [0.9 0.1]);

pot{wife}=array([wife income]);
pot{wife}.table(:,low)=[0.7 0.3 0 0];
pot{wife}.table(:,high)=[0.2 0.1 0.4 0.3];

pot{husband}=array([husband income]);
pot{husband}.table(:,low)=[0.2 0.8 0 0];
pot{husband}.table(:,high)=[0 0 0.3 0.7];

jointpot = multpots(pot([income husband wife])); % joint distribution

drawNet(dag(pot),variable);
margpot_hw=sumpot(jointpot,income);
disp('p(h,w):'); disp(margpot_hw.table)

margpot_h=sumpot(margpot_hw,wife);
margpot_w=sumpot(margpot_hw,husband);
prod_pot = multpots([margpot_h margpot_w]);
disp('p(h)p(w):'); disp(prod_pot.table)
