function exerciseRaschBronco
import brml.*

load bronco

Q=20; % number of questions

figure
opts.maxits=1000; opts.plotprogress=1;
[a d]=rasch(X,opts);

figure
subplot(1,2,2); bar(d); title('estimated difficulty'); xlim([0 Q+1])

disp('difficulty based on rasch model (most difficult first:')
[val idx]= sort(d);
idx'
