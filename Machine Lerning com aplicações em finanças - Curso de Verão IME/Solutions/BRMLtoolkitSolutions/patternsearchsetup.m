function [spphghm,pvgh,ph1,startpattern,endpattern,generalstates]=patternsearchsetup(pattern,patternstate,generalstate,tran,pvgh_pattern,pvgh_general,prior)

if ~iscell(pvgh_pattern)
    CorruptionProb=pvgh_pattern;
    clear pvgh_pattern;
    for pt=patternstate
        for l=1:length(pattern{pt})
            pvgh_pattern{pt,l}=CorruptionProb(:,pattern{pt}(l)); % probability distribution for position l of pattern pt
        end
    end
end

startpattern(1)=1;
endpattern(1)=length(pattern{1});
for p=2:length(pattern)
    startpattern(p)=endpattern(p-1)+1; % end counter for the pattern
    endpattern(p)=startpattern(p)+length(pattern{p})-1; % start of the counter for the pattern
end
H=endpattern(end)+length(generalstate);

phghm=zeros(H);
Gstart=endpattern(end)+1;
generalstates=Gstart:(Gstart+length(generalstate)-1);

% setup the prior (distribution of initial time):
ph1=zeros(H,1);
if isempty(prior); ph1=ones(H,1)/H; end % uniform if ph1==0
if ~isfield(prior,'generalstate') & ~isfield(prior,'patternstate')
    ph1=prior;
end
if isfield(prior,'generalstate')
    for gt=1:length(generalstate);
        ph1(Gstart+gt-1,1)=prior.generalstate(gt);
    end
end
if isfield(prior,'patternstate')
    for pt=patternstate
        if prior.startatbeginningpattern
            ph1(startpattern(pt),1)=prior.patternstate(pt); % start at pattern
        else
            ph1(startpattern(pt):endpattern(pt),1)=prior.patternstate(pt)/length(pattern{pt}); % start at pattern
        end
    end
end
ph1=sparse(ph1);

% pattern<-pattern:
for ptm=patternstate
    for pt=patternstate
        phghm(startpattern(pt),endpattern(ptm))=tran(pt,ptm);
    end
end
% internal pattern incrementor:
for pt=1:length(patternstate)
    s=startpattern(pt);
    for l=1:length(pattern{pt})-1
        phghm(s+1,s)=1;
        s=s+1;
    end
end

%pattern<-general
for pt=patternstate
    for g=1:length(generalstate);
        phghm(startpattern(pt),Gstart+g-1)=tran(pt,generalstate(g));
    end
end

%general<-pattern
for pt=patternstate
    for g=1:length(generalstate);
        phghm(Gstart+g-1,endpattern(pt))=tran(generalstate(g),pt);
    end
end

%general<-general
for gt=1:length(generalstate);
    for gtm=1:length(generalstate);
        phghm(Gstart+gt-1,Gstart+gtm-1)=tran(generalstate(gt),generalstate(gtm));
    end
end

% pattern emissions:
for pt=patternstate
    for l=1:length(pattern{pt})
        pvgh(:,startpattern(pt)+l-1)= pvgh_pattern{pt,l};
    end
end

for g=1:length(generalstate)
    pvgh(:,Gstart+g-1)=pvgh_general(:,g);
end
spphghm=sparse(phghm);