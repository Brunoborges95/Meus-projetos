function [pnum gnum]=getpattern(p,startIDX,genIDX)

pnum=zeros(1,length(p));
gnum=zeros(1,length(p));
for i=1:length(p)
    k=find(p(i)==startIDX);
    if ~isempty(k); pnum(i)=k; end
    l=find(p(i)==genIDX);
    if ~isempty(l); gnum(i)=l; end
    if isempty(k)&isempty(l)
        pnum(i)=pnum(i-1);
        gnum(i)=gnum(i-1);
    end
end