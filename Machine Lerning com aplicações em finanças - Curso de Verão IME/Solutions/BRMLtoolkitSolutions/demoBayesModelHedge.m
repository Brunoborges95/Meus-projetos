function demoBayesModelHedge
import brml.*
% make some data
w0 = [1 -1 2 -2 0 0]'; %
load dodder

for t=2:T
    y(t) = w0'*x(:,t-1)+sigma(t)*randn;
end
plot(y); title('time-series y(t)');

model = ind2subv(repmat(2,1,6),1:2^6-1)-1; % all the models
for m=1:size(model,1)
    mask=model(m,:);
    M=sum(mask); % number of parameters in this model
    A = zeros(M,M); b=zeros(M,1);c=0;
    for t=2:T
        xtm = x(mask==1,t-1);
        A = A + xtm*xtm'/sigma(t)^2;
        b = b + xtm*y(t)/sigma(t)^2;
        c=c+y(t).^2/sigma(t)^2;
    end
    A=eye(M) + A;
    logl(m) = 0.5*(-c+b'*inv(A)*b-log(det(A))+M*log(2*pi)+sum(log(2*pi*sigma(2:T).^2)));
end
post=condexp(logl'); % posterior, assuming that the prior p(m)=const
figure; bar(post); title('posterior over the models')
disp(['Correct model has weights at:     ',num2str((w0~=0)')]);
disp(['most likely model has weights at: ',num2str(ind2subv(repmat(2,1,6),argmax(post))-1)]);