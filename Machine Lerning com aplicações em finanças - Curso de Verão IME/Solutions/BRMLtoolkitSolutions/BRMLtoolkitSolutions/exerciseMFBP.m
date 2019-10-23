function exerciseMFBP
import brml.*
[w x y z]=assign(1:4);


load pMRF
phi=str2cell(setpotclass(phi,'array'));
p = condpot(multpots(phi)); % normalise so we can monitor the KL exactly
[vars nstates]=potvariables(p);
[W X Y Z]=assign(nstates);

% approximating q structure:
qw = array(w,normp(rand([W 1])));
qx = array(x,normp(rand([X 1])));
qy = array(y,normp(rand([Y 1])));
qz = array(z,normp(rand([Z 1])));

xcord=[0.2 0.2 0.8 0.8]; ycord=[0.2 0.8 0.2 0.8];
subplot(1,2,1); draw_layout(markov(p)-eye(4),{'w','x','y','z'},zeros(4,1),xcord,ycord); title('original graph')
subplot(1,2,2); draw_layout(markov([qw qx qy qz])-eye(4),{'w','x','y','z'},zeros(4,1),xcord,ycord); title('Factorised graph')
figure
for loop=1:50
    ord=randperm(4);
    for o=ord
        switch o
            case 1
                qw = condpot(exppot(sumpot(multpots([logpot(p) qx qy qz]),w,0)));
            case 2
                qx = condpot(exppot(sumpot(multpots([logpot(p) qw qy qz]),x,0)));
            case 3
                qy = condpot(exppot(sumpot(multpots([logpot(p) qx qw qz]),y,0)));
            case 4
                qz = condpot(exppot(sumpot(multpots([logpot(p) qx qy qw]),z,0)));
        end
    end
    kl(loop) = KLdiv(multpots([qw qx qy qz]),p);
    plot(kl,'-o'); title('KL divergence');drawnow
end
[margMF{1} margMF{2} margMF{3} margMF{4}]=assign([qw qx qy qz]);

% BP:
opt.tol=10e-10; opt.maxit=50;
figure;
[marg mess A2]=LoopyBP(phi,opt);
title('BP marginal convergence'); drawnow

jpot=multpots(phi);
fprintf('\nExact and Loopy BP marginals and MF marginals:\n\n')
for i=1:length(potvariables(phi))
    fprintf('variable(%d)\n     Exact    Loopy BP     MF    \n',i);
    disp([table(condpot(jpot,i)) table(marg{i}) table(margMF{i})])
    errBP(i)=mean(abs(table(condpot(jpot,i))-table(marg{i})));
    errMF(i)=mean(abs(table(condpot(jpot,i))-table(margMF{i})));
    
end
fprintf('mean error BP = %g\n',mean(errBP))
fprintf('mean error MF = %g\n',mean(errMF))
