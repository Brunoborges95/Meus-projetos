function demoEMprinter
import brml.*
[fuse drum toner poorpaper roller burning poorprint wrinkled multiple jam]=assign(1:10);

x= [nan nan nan 1 0 0 nan 0 nan 0 0 nan 1 nan 1;
	nan 0 nan 0 1 0 0 1 nan nan 1 1 nan 0 0;
	1 1 0 nan nan 1 0 1 0 nan 0 1 nan 0 nan;
	1 0 1 0 1 nan 1 0 1 1 nan 1 1 nan 0;
	0 0 nan nan nan 0 1 nan 0 0 nan 0 nan 1 1;
	0 nan nan 1 0 0 0 0 0 nan 0 nan 1 0 nan;
	1 1 1 0 1 1 0 1 0 0 1 1 nan nan 0;
	0 0 1 0 0 0 nan 0 1 nan 0 0 1 1 1;
	0 nan 1 0 nan 0 1 0 1 nan 0 0 nan 0 1;
	nan 0 1 1 nan 0 1 1 1 1 0 nan 0 1 nan];
x=x+1; % toolbox needs states starting from 1
[V N]=size(x);
imagesc(x,[-1 2]); colormap hot; title('data : black is missing')

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

pars.tol=0.0001; pars.maxiterations=50; pars.plotprogress=10;
[pot loglik]=EMbeliefnet(pot,x,pars); % do EM

for i=1:10
	disp(['table ',varnames{i},':'])
	disptable(pot{i}); disp(' ');
end

variable(drum).name='drum'; variable(drum).domain={'no','yes'};
jointpot=multpots(pot); no=1; yes=2;
disp('Probability of a drum unit problem given the evidence is:')
disptable(condpot(setpot(jointpot,[wrinkled burning poorprint], [no no yes]),drum),variable);