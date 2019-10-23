function demoHMMbigramMonkey
import brml.*
load freq
[a b c d e f g h i j k l m n o p q r s t u v w x y z sp]=assign(1:27);
B=3*eye(27,27);
B([q w s x z],a)=1;
B([v g h n],b)=1;
B([x d f v],c)=1;
B([e s x c f r],d)=1;
B([w s d f r],e)=1;
B([d r t g v c],f)=1;
B([f t y h b v],g)=1;
B([g y u j n b],h)=1;
B([j u o k],i)=1;
B([h u i k m n],j)=1;
B([i j m l o],k)=1;
B([o p k m],l)=1;
B([n j k l],m)=1;
B([b h j m],n)=1;
B([i k l p],o)=1;
B([o l],p)=1;
B([w a],q)=1;
B([e d f t],r)=1;
B([w a z x d e],s)=1;
B([r f g y],t)=1;
B([y h j k i],u)=1;
B([c f g b],v)=1;
B([q a s d e],w)=1;
B([z s d c],x)=1;
B([t g h u],y)=1;
B([a s x],z)=1;
B([m n b v],sp)=1;

B = condp(B);

ph1=condp(ones(27,1));
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
    for i=1:length(spac)
        wd{i} = str(start:(spac(i)-1));
        start=spac(i)+1;
        if isempty(find(strcmp(wd{i},w)))
            val=0;
            break
        end
    end
    if val
        disp([num2str(t) ':' str])
    end
end








