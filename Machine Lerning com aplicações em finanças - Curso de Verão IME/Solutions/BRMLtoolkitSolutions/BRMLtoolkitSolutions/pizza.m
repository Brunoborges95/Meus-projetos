function pizza
inds=brml.ind2subv([4 4 4 4 4 4 4],1:4^7);
 
 for i=1:4
     s(:,i)=sum(inds==i,2);
 end
st=sum(s.*repmat([1000 100 10 1],size(s,1),1),2);
un=unique(st);

for i=1:length(un)
    n(i,1)=sum(st==un(i));
end
 p=n/sum(n);
 
 sum(p.*p)