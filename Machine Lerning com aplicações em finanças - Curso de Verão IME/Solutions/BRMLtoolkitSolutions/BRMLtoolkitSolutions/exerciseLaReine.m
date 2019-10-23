function exerciseLaReine
import brml.*

load BTL
S=100;

imagesc(X); xlabel('competitor'); ylabel('competitor'); colormap hot; colorbar

% Maximum Likelood training using simple Gradient ascent:
figure
eta_a=20; % learning rate
a=rand(S,1);
a(1)=0; % remove translation invariance by forcing a(1)=0;
for loop=1:2000
    D = a*ones(1,S) - ones(S,1)*a';
    sig=sigma(D);
    loglik(loop) = sum(sum(X.*log(sig)));
    grada = sum(X.*(1-sig),2)-sum(X.*(1-sig),1)';  grada(1)=0;
    a = a + eta_a*grada/S;
    plot(loglik); title('log likelihood'); drawnow;
end
[val idx]=sort(a,'descend');
disp('top ten cows:')
idx(1:10)