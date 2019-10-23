function A=ChowLiu(data)
%CHOWLIU Chow Liu algorithm
%A=ChowLiu(data) 
%data is a data matrix. See demoChowLiu
import brml.*
data=squeezestates(data);
nstates=maxarray(data,2); nvars=size(data,1);
c=0; % compute all pairwise Mutual Informations
for i=1:nvars
    for j=i+1:nvars
        w(i,j)=MIemp(data(i,:),data(j,:),nstates(i),nstates(j));
        c=c+1;
        link(c,:)=[i j]; val(c)=w(i,j);
    end
end
[dum b]=sort(val,'descend'); edgelist=link(b(1:c),:); % sort the edges
A=spantree(edgelist); % find a spanning 
A=triu(A); % orient away from node 1 to produce a DAG