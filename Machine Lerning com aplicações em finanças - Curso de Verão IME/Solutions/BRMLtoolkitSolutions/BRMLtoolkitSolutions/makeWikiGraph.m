function n=makeWikiGraph
load WikiAdjSmall
N=size(A,1); S=sparse(zeros(N,N)); Ak=eye(N);
A=(A+A')>0; % we interpret `knowing' as reciprocal
for k=1:20
    k
    Ak=A^k; % find if there is a length k path between authors
    S(Ak>0 & S==0)=k; % If the authors are not already connected then call place the length of the path on the graph
    if all(all(S>0)); break; end
    n(k)=full(sum(S(:)==k))/2;
end
figure
bar(n)