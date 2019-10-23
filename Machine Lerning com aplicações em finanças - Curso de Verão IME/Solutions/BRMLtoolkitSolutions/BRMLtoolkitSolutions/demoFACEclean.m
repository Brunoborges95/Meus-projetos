function demoFACEclean
%DEMOFACECLEAN demo of image denoising using a binary state Markov Random Field

import brml.*
f=imread('face.jpg');
xclean=f(:,:,1)>125; % binary clean image


Gx=321; Gy=265; N=Gx*Gy;
st = reshape(1:N,Gx,Gy); % assign each grid point a state

if exist('W0.mat')
    load W0
else
    disp('building the MRF...')
    W0=sparse(N,N);
    for x = 1:Gx
        for y = 1:Gy
            if validgridposition(x+1,y,Gx,Gy); W0(st(x+1,y),st(x,y))=1; end
            if validgridposition(x-1,y,Gx,Gy); W0(st(x-1,y),st(x,y))=1; end
            if validgridposition(x,y+1,Gx,Gy); W0(st(x,y+1),st(x,y))=1; end
            if validgridposition(x,y-1,Gx,Gy); W0(st(x,y-1),st(x,y))=1; end
        end
    end
end
subplot(1,3,1); imagesc(xclean); colormap bone; title('clean');

if exist('noisyface.mat')
    load('noisyface')
else
    n = rand(size(xclean))>0.75;
    xnoisy = xclean; xnoisy(n>0)=(1-xclean(n>0)); % flip pixels
end
subplot(1,3,2); imagesc(xnoisy); title('noisy');

b = 2*xnoisy(:)-1; % bias to favour the noisy image
W=10*W0; % preference for neighbouring pixels to be in same state
opts.maxit=1; opts.minit=1; opts.xinit=xnoisy(:);

for loop=1:10
    [xrestored El] = brml.binaryMRFmap(W,b,1,opts);
    E(loop)=El;
    figure(1)
    subplot(1,3,3); imagesc(reshape(xrestored,Gx,Gy)); title(['restored ' num2str(loop)]); drawnow
    opts.xinit=xrestored;
    figure(2);
    plot(E,'-o'); title('Objective function value'); drawnow
end
