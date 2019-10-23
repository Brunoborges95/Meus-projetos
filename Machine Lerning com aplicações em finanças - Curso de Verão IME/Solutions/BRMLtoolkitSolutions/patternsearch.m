function [alpha,beta,gamma,delta,loglik,logpvhstar]=patternsearch(v,spphghm,pvgh,ph1,varargin)
% [alpha,beta,gamma,delta,loglik,logpvhstar]=patternsearch(observations,transition,emission,prior,thres,<printtime>)
% returns:
% alpha: p(h_t|v_{1:t})
% beta: p(h_t|v_{t+1:T})
% gamma: p(h_t|v_{1:T})
% delta: most likely state
% loglik: log p(v_{1:T})
% logpvhstar: log p(v_{1:T},h^*_{1:T})  -- log of most likely explanation
import brml.*
if nargin==6
    printtime=varargin{1};
else
    printtime=0;
end
t=cputime;
[alpha, loglik]=HMMforward(v,spphghm,ph1,pvgh);
beta=HMMbackward(v,spphghm,pvgh);
gamma=(alpha).*(beta);
gamma = bsxfun(@rdivide, gamma, sum(gamma));
if printtime; fprintf(1,'\nHMM marginal inference takes %f seconds',cputime-t); end
t=cputime;
[delta,logpvhstar]=HMMviterbi(v,spphghm,ph1,pvgh);
if printtime; fprintf(1,'\nHMM viterbi takes %f seconds\n',cputime-t); end