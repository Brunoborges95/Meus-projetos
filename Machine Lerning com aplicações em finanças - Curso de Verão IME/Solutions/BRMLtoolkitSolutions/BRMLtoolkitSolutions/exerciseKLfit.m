function exerciseKLfit
import brml.*
load p
p=setpotclass(p,'array');

X=3; Y=3; H=3;
[x y h]=assign(1:3);

qxy = array([x y],normp(rand([X Y])));

qh = array(h,normp(rand(H,1)));

% using a general mean field update approach:
for loop=1:100
    qxy = condpot(exppot(sumpot(multpots([logpot(p) qh]),h)));
    qh = condpot(exppot(sumpot(multpots([logpot(p) qxy]),[x y])));
    qxyh = multpots([qxy qh]);
    kl(loop) = KLdiv(qxyh,p);
    plot(kl); title('KL divergence'); drawnow
end
approx = table(multpots([qxy qh]));
figure
plot(approx(:),'+'); hold on; plot(p.table(:),'ro'); legend('q','p');
fprintf(1,'Mean deviation between p and q approx = %g\n',mean(abs(approx(:)-p.table(:))));