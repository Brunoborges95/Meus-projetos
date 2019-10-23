function exerciseACGTHMM
import brml.*

[a c g t]=assign(1:4);

p=zeros(4,4); [p(c,a) p(g,c) p(t,g) p(a,t)]=assign([1 1 1 1]);
p

pnew=0.9*p+0.2*ones(4)/4;

q=zeros(4,4); [q(g,t) q(c,g) q(a,c) q(t,a)]=assign([1 1 1 1]);
q

qnew=0.9*q+0.1*ones(4)/4;

s=[a a g t a c t t a c c t a c g c];

pnewprob=1/4;
for t=2:length(s)
    pnewprob=pnewprob*pnew(s(t),s(t-1));
end
disp('prob of sequence s for pnew:'); pnewprob

qnewprob=1/4;
for t=2:length(s)
    qnewprob=qnewprob*qnew(s(t),s(t-1));
end
disp('prob of sequence s for qnew:'); qnewprob

disp('Since the sequence S is more similar to the transition structure from p, it makes sense that pnew has the higher probability')


for n=1:100
    v{n}(1)=randgen([1 1 1 1]);
    for t=2:16
        v{n}(t)=randgen(pnew(:,v{n}(t-1)));
    end
end
for n=1:100
    v{n+100}(1)=randgen([1 1 1 1]);
    for t=2:16
        v{n+100}(t)=randgen(qnew(:,v{n+100}(t-1)));
    end
end

opts.maxit=10; opts.plotprogress=1;
[ph,pv1gh,pvgvh,loglikelihood,phgv]=mixMarkov(v,4,2,opts);

for n=1:200
    h(n)=argmax(phgv{n});
end
bar(h);
disp('As we can see, the first 100 sequences are all assigned to the same h state, and the second 100 sequences to the other h state, as expected')

for i=1:4
    for j=1:4
        pvgh(i,j)=0.7*(i==j)+0.1*(i~=j);
    end
end

[viterbi_p logprob_p]=HMMviterbi(s,pnew,ones(4,1)/4,pvgh) % most likely joint state
[viterbi_q logprob_q]=HMMviterbi(s,qnew,ones(4,1)/4,pvgh) % most likely joint state

disp('The model pnew is much more likely. This makes sense since one can view the sequence s essentially a corrupted form of a sequence from p');