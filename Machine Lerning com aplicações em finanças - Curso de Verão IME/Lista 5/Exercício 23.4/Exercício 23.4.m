function demoHMMbigram
%DEMOHMMBIGRAM(Exercício 23.4)  demo of HHM for the bigram typing scenario
import brml.*
load freq % http://www.data-compression.com/english.shtml
l = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',' '};
load typing % lendo a matriz A de transição e B de emissão
figure(1); imagesc(A); set(gca,'xtick',1:27); set(gca,'xticklabel',l); set(gca,'ytick',1:27); set(gca,'yticklabel',l)
colorbar; colormap hot; title('transition')
figure(2); imagesc(B); set(gca,'xtick',1:27); set(gca,'xticklabel',l); set(gca,'ytick',1:27); set(gca,'yticklabel',l)
colorbar; colormap hot; title('emission')
ph1=condp(ones(27,1)); % primeira distribuição uniforme de dados escondidos


s = 'rgenmonleunosbpnntje vrancg';

v=double(s)-96;
v=replace(v,-64,27);

[maxstate logprob]=HMMviterbi(v,A,ph1,B);
X=logprob;

% Encontrando as seqüências escondidas mais prováveis, definindo um gráfico de fatores;
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
A = FactorGraph(pot);
Nmax=1500;
[maxstate maxval mess]=maxNprodFG(pot,A,Nmax);
for n=1:Nmax
    maxstatearray(n,:)= horzcat(maxstate(n,:).state);
end
strs=char(replace(maxstatearray+96,123,32))
fid=fopen('brit-a-z.txt','r');
w=textscan(fid,'%s'); w=w{1};

for t=1:Nmax
    str = strs(t,:);
    spac = strfind(str,' ');
    spac = [spac length(str)+1];
    start=1; val=1;
    for i=1:length(spac)
        wd{i} = str(start:(spac(i)-1));
        start=spac(i)+1;
        if isempty(find(strcmp(wd{i},w)))
            val=0;
            break
        end
    end
    if val
        fprintf(1,'A sentença mais provável é: ')
        disp([num2str(t) ':' str])
    end
end
fprintf(1,'O valor de log p(h1:27jv1:27) é:')
X
