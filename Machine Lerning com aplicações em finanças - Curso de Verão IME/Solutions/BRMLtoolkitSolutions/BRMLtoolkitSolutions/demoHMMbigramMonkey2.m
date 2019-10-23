function demoHMMbigramMonkey
import brml.*
load freq
l = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',' '};
load typing % get the A transition and B emission matrices
figure(1); imagesc(A); set(gca,'xtick',1:27); set(gca,'xticklabel',l); set(gca,'ytick',1:27); set(gca,'yticklabel',l)
colorbar; colormap hot; title('transition')
figure(2); imagesc(B); set(gca,'xtick',1:27); set(gca,'xticklabel',l); set(gca,'ytick',1:27); set(gca,'yticklabel',l)
colorbar; colormap hot; title('emission')
ph1=condp(ones(27,1)); % uniform first hidden state distribution

%s = 'tgenmonleu os pn the vrancg';
%s = 'tgenmonleu osbpnntje vrancg';
s = 'rgenmonleunosbpnntje vrancg';

v=double(s)-96;
v=replace(v,-64,27);

[maxstate logprob]=HMMviterbi(v,A,ph1,B);

fprintf(1,'Sentence to correct is:\n %s\n',s);
fprintf(1,'Most likely decoded character sequence is:\n %s\n',strrep(char(maxstate+96),'{',' '))

fprintf(1,'Looking for a sensible sentence...')
T = length(s);

hh=1:T; vv=T+1:2*T;
empot=array([vv(1) hh(1)],B);
prior=array(hh(1),ph1);

pot{1} = multpots([setpot(empot,vv(1),v(1)) prior]);

for t=2:T
    tranpot=array([hh(t) hh(t-1)],A);
    empot=array([vv(t) hh(t)],B);
    pot{t} = multpots([setpot(empot,vv(t),v(t)) tranpot]);
end
A = FactorGraph(pot); % variable nodes are first in A
Nmax=1000;
[maxstate maxval mess]=maxNprodFG(pot,A,Nmax);
for n=1:Nmax
    maxstatearray(n,:)= horzcat(maxstate(n,:).state);
end
strs=char(replace(maxstatearray+96,123,32)) % make strings from the decodings
fid=fopen('brit-a-z.txt','r');
w=textscan(fid,'%s'); w=w{1};

for t=1:Nmax
    str = strs(t,:);
    spac = strfind(str,' ');
    spac = [spac length(str)+1];
    start=1; val=1;
    for i0=1:length(spac)
        wd{i0} = str(start:(spac(i0)-1));
        start=spac(i0)+1;
        if isempty(find(strcmp(wd{i0},w)))
            val=0;
            break
        end
    end
    if val
        disp([num2str(t) ':' str])
    end
end