function demoCoin
import brml.*
theta=        [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9]; % values of theta
pfair = normp([1     2   3   4   20  4  3  2   1]);% fair coin
pbiased = normp([10 9 8 7 3 7 8 9 10]);
figure
bar(theta,pfair); title('fair coin');
figure
bar(theta,pbiased); title('biased coin');

H=5; T=2;

pDataFair  = sum(prod(pfair.*theta.^H.*(1-theta).^T))
pDatabiased  = sum(prod(pbiased.*theta.^H.*(1-theta).^T))

logpDataFair=logsumexp(log(theta.^H.*(1-theta).^T),pfair)
exp(logpDataFair)