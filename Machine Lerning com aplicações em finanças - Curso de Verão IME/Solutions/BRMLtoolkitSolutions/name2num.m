function n=name2num(x)
c='abcdefghijklmnopqrstuvwxyz';
for i=1:length(x)
    n(i)=find(c==x(i));
end