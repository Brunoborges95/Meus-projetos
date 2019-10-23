function hamburger
import brml.*
[ham KJ]=assign([1 2]); % assign variables
[tr fa]=assign([1 2]); % assign states

varinf(ham).name='Hamburger Eater';
varinf(ham).domain={'true','false'};

varinf(KJ).name='Kreuzfeld Jacob sufferer';
varinf(KJ).domain={'true','false'};

pot{ham}=array([ham KJ]);
pot{ham}.table(tr,tr)=0.9;
pot{ham}.table(fa,tr)=0.1;
beta=1/100000;
pot{KJ}=array(KJ);
pot{KJ}.table(tr)=beta;
pot{KJ}.table(fa)=1 - pot{KJ}.table(tr);

alpha=0.5;
gamma=(alpha-0.9*beta)/(1-beta); % using the constraint alpha=0.9*beta+gamma*(1-beta)
pot{ham}.table(tr,fa)=gamma;
pot{ham}.table(fa,fa)=1-gamma;

fprintf('if probability of eating hamburger=%g, then a posteriori:\n',alpha)
disptable(condpot(setpot(multpots(pot([ham KJ])),ham,tr)),varinf);

alpha=0.001;
gamma=(alpha-0.9*beta)/(1-beta); % using the constraint alpha=0.9*beta+gamma*(1-beta)
pot{ham}.table(tr,fa)=gamma;
pot{ham}.table(fa,fa)=1-gamma;

fprintf('if probability of eating hamburger=%g, then a posteriori:\n',alpha)
disptable(condpot(setpot(multpots(pot([ham KJ])),ham,tr)),varinf);