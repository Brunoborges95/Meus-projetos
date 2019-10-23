function  exerciseSampleHMM
import brml.*
H=2; V=2; T=10;
% make a HMM
lambdas=[0.1 1 10 20];

for la=1:length(lambdas)
    lambda=lambdas(la);
    fprintf(1,'lambda=%f\n',lambda)
    for ex=1:20
        fprintf(1,'experiment=%d\n',ex)
        A=condp(rand(H,H).^lambda);
        B=condp(rand(V,H).^1);
        a=condp(rand(H,1));
        
        % draw some samples for v:
        h(1)=randgen(a); v(1)=randgen(B(:,h(1)));
        for t=2:T
            h(t)=randgen(A(:,h(t-1)));  v(t)=randgen(B(:,h(t)));
        end
        [logalpha,loglik]=HMMforward(v,A,a,B); logbeta=HMMbackward(v,A,B);
        gamma=HMMsmooth(logalpha,logbeta,B,A,v); % exact marginal
        
        % single site Gibbs updating
        hsamp(:,1)=randgen(1:H,1,T);
        hv=1:T; vv=T+1:2*T; % hidden and visible variable indices
        
        num_samples=100;
        for sample=2:num_samples
            h = hsamp(:,sample-1);
            emiss=array([vv(1) hv(1)],B);
            trantm=array(hv(1),a);
            trant=array([hv(2) hv(1)],A); 
            h(1) = randgen(table(setpot(multpots([trantm trant emiss]),[vv(1) hv(2)],[v(1) h(2)])));
            
            for t=2:T-1
                trantm=array([hv(t) hv(t-1)],A); 
                trant=array([hv(t+1) hv(t)],A);
                emiss=array([vv(t) hv(t)],B);
                h(t) = randgen(table(setpot(multpots([trantm trant emiss]),[vv(t) hv(t-1) hv(t+1)],[v(t) h(t-1) h(t+1)])));
            end
            
            trantm=array([hv(T) hv(T-1)],A);
            emiss=array([vv(T) hv(T)],B);
            h(T) = randgen(table(setpot(multpots([trantm emiss]),[vv(T) hv(T-1)],[v(T) h(T-1)])));
            
            hsamp(:,sample)=h; % take the sample after a forward sweep through time
        end
        for t=1:T
            gamma_samp(:,t) = count(hsamp(t,:),H)/num_samples;
        end
        er(ex,la) = mean(abs(gamma(:)-gamma_samp(:)));
    end
end
fprintf(1,'lambdas and mean absoluite error in marginals:\n')
disp([lambdas' mean(er)'])