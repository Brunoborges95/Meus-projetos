function IsingZ
import brml.*
N=10;

% form the potentials for each pair of neighbouring variables:
for x=1:2
    for y=1:2
        isingtable(x,y)=exp(1*(x==y));
    end
end
S = reshape(1:N*N,N,N);
c=0;
for s1=1:N*N
    [i1 j1]=find(S==s1);
    for s2=s1+1:N*N
        [i2 j2]=find(S==s2);
        if (j1==j2)&(abs(i1-i2)==1) | (i1==i2)&(abs(j1-j2)==1)
            c=c+1;
            phi{c}=array([s1 s2],isingtable);
            tab(i1,i2,j1,j2)=c;
            tab(i2,i1,j2,j1)=c;
        end
    end
end

% form column potentials:
colphi{1}=const(1);
for i=1:N-1
    colphi{i}=const(1);
    for j=1:N-1
        colphi{i}=multpots([colphi{i} phi{tab(j,j,i,i+1)}]);
        colphi{i}=multpots([colphi{i} phi{tab(j,j+1,i,i)}]);
    end
    colphi{i}=multpots([colphi{i} phi{tab(N,N,i,i+1)}]);
end
for j=1:N-1
    colphi{i}=multpots([colphi{i} phi{tab(j,j+1,i+1,i+1)}]);
end

% do message passing in this new chain with the column potentials:
mmess=[];
sumover=setdiff(colphi{1}.variables,intersect(colphi{1}.variables,colphi{2}.variables));
mess=sumpot(colphi{1},sumover);
for i=2:N-2
    sumover=setdiff(colphi{i}.variables,intersect(colphi{i}.variables,colphi{i+1}.variables));
    mess=sumpot(multpots([mess colphi{i}]),sumover);
    mmess=[mmess max(mess.table(:))];
    mess.table=mess.table./mmess(end); % tables may overflow so remove constant factor
end
logZ = log(table(sumpot(multpots([mess colphi{N-1}]),[],0)));
logZ = logZ+ sum(log(mmess)) % add back any removed constant factor