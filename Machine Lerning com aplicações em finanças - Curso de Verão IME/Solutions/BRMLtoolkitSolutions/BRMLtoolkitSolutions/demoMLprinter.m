function demoMLprinter
import brml.*
[fuse drum toner poorpaper roller burning poorprint wrinkled multiple jam]=assign(1:10);
load printer
[V N]=size(x);

pot{fuse}=array(fuse);
pot{drum}=array(drum);
pot{toner}=array(toner);
pot{poorpaper}=array(poorpaper);
pot{roller}=array(roller);
pot{burning}=array([burning fuse]);
pot{poorprint}=array([poorprint poorpaper toner drum]);
pot{wrinkled}=array([wrinkled poorpaper fuse]);
pot{multiple}=array([multiple roller poorpaper]);
pot{jam}=array([jam fuse roller]);

varnames={'fuse' 'drum' 'toner' 'poorpaper' 'roller' 'burning' 'poorprint' 'wrinkled' 'multiple' 'jam'};
for i=1:10
    varinf(i).domain={'0','1'}; varinf(i).name=varnames{i};
    pot{i}.table=myzeros(2*ones(1,length(pot{i}.variables)));
end

for v=1:10
    family = pot{v}.variables; % family of the node
    nstates=2*ones(1,length(family));
    if length(family)>1
        c=reshape(count(x(family,:),nstates),nstates); % counts of the family
    else
        c=count(x(family,:),nstates); % counts of the family
    end
    tmppot=array(family,c);
    pot{v}=condpot(tmppot,v,setdiff(family,v));  % normalise the counts
end

jointevpot = setpot(multpots(pot),[burning jam poorprint wrinkled multiple],[2 2 1 1 1]);
disp('probability fuse assembly malfunctioned is:')
disptable(condpot(sumpot(jointevpot,fuse,0)),varinf);

%Bayesian case is the same except one adds the hyperparameters to the counts (not done here)

fprintf(1,'\noptimal joint state of faults given evidence (and marginalising over remaining symptons):\n')
[tmppot maxstate]=maxpot(jointevpot);
fprintf(1,'optimal states in 1/2 coding is:\n')
for i=1:5; fprintf(1,'%s=%d\n',varinf(i).name,maxstate(i)); end

fprintf(1,'\nUsing max absorption as an alternative:\n')
for v=1:10
    evpot{v} = setpot(pot{v},[burning jam poorprint wrinkled multiple],[2 2 1 1 1]);
end
[jtpot jtsep infostruct]=jtree(evpot); % setup the Junction Tree
[jtpot2 jtsep2]=absorption(jtpot,jtsep,infostruct,'max'); % do full round of absorption
for cl=1:length(jtpot2)
    [dumpot JTmaxstate(jtpot2{cl}.variables)] = maxpot(jtpot2{cl}); % maximum value is given by the max over any clique
end
fprintf(1,'optimal states in 1/2 coding is:\n')
for i=1:5; fprintf(1,'%s=%d\n',varinf(i).name,JTmaxstate(i)); end