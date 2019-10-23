function IM=immoralities(A)
%IMMORALITIES find the immoralities of a DAG
% IM=immoralities(A)
% immoralities are returned in the matrix IM
% If there is a child C with unconnected parents A,B, the IM(A,B)=IM(B,A)=1
% and IM(A,C)=IM(B,C)=1;
% That is we link the unmarried parents and connect them to the child
N=size(A,1); IM=zeros(N,N);
A=A>0; % convert to logical (faster)
B=~(A|A'); % B is the matrix of non-connected nodes (either direction)
B=triu(B,1); % ignore lack of self-connections and only need to non-connectivity in one direction
for i=1:N
    pa=brml.parents(A,i); % get the parents of node i
    [ind1 ind2]=find(B(pa,pa)); % find those parents that are not connected
    for j=1:length(ind1)
        IM(pa(ind1(j)),pa(ind2(j)))=1; % connect parents
        IM(pa(ind2(j)),pa(ind1(j)))=1; % .. both directions
        IM(pa(ind1(j)),i)=1;  % connect a parent to the child
        IM(pa(ind2(j)),i)=1;  % and the other parent to child
    end
end