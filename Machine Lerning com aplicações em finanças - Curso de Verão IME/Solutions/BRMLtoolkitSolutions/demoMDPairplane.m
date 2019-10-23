function demoMDPairplane
import brml.*
Gx = 18; Gy = 15;  % two dimensional grid size
S = Gx*Gy; % number of states on grid
st = reshape(1:S,Gx,Gy); % assign each grid point a state

A = 5;  % number of action (decision) states
[stay up down left right] = assign(1:A); % actions (decisions)
p = zeros(S,S,A); % initialise the transition p(xt|xtm,dtm) ie p(x(t)|x(t-1),d(t-1))

plane_faulty=1; % faulty airplane ... set to zero otherwise

% make a deterministic transition matrix on a 2D grid:
for x = 1:Gx
    for y = 1:Gy
        p(st(x,y),st(x,y),stay)=1; % can stay in same state
        if ~plane_faulty
            if validgridposition(x+1,y,Gx,Gy)
                p(st(x+1,y),st(x,y),right)=1;
            else
                p(st(x,y),st(x,y),right)=1;
            end
        end
        if validgridposition(x-1,y,Gx,Gy)
            p(st(x-1,y),st(x,y),left)=1;
        else
            p(st(x,y),st(x,y),left)=1;
        end
        if validgridposition(x,y+1,Gx,Gy)
            p(st(x,y+1),st(x,y),up)=1;
        else
            p(st(x,y),st(x,y),up)=1;
        end
        if validgridposition(x,y-1,Gx,Gy)
            p(st(x,y-1),st(x,y),down)=1;
        else
            p(st(x,y),st(x,y),down)=1;
        end
        if plane_faulty
            
            if ~validgridposition(x+1,y,Gx,Gy)
                p(st(x,y),st(x,y),right)=1; % stay in same place
            end
            
            if  validgridposition(x+1,y,Gx,Gy) & validgridposition(x,y+1,Gx,Gy)
                p(st(x+1,y),st(x,y),right)=0.9; %
                p(st(x,y+1),st(x,y),right)=0.1;
            end
            
            if validgridposition(x+1,y,Gx,Gy) & ~validgridposition(x,y+1,Gx,Gy)
                p(st(x+1,y),st(x,y),right)=1; %
            end
            
        end
    end
end

% define utilities
load airplane
u=U(:);
gam = 0.99; % discount factor

[xt xtm dtm]=assign(1:3); % assign the variables x(t), x(t-1), d(t-1) to some numbers
% define the domains of the variables

% define the transition potential: p(x(t)|x(t-1),d(t-1))
tranpot=array([xt xtm dtm],p);

% setup the value potential: v(x(t))
valpot=array(xt,ones(S,1)); % initial values
maxiterations=50; tol=0.001; % termination critria

% Policy Iteration:
valpot.table=ones(S,1); % initial values
oldvalue=valpot.table;
figure;
for policyloop=1:maxiterations
    policyloop
    % Policy evaluation: get the optimal decisions as a function of the state:
    [tmppot dstar] = maxpot(sumpot(multpots([tranpot valpot]),xt),dtm);
    for x1=1:S
        for x2=1:S
            pdstar(x1,x2) = p(x2,x1,dstar(x1));
        end
    end
    valpot.table = (eye(S)-gam*pdstar)\u;
    if mean(abs(valpot.table-oldvalue))<tol; break; end % stop if converged
    oldvalue=valpot.table;
    imagesc(reshape(valpot.table,Gx,Gy)'); colorbar; drawnow
end
figure; bar3zcolor(reshape(valpot.table,Gx,Gy)');

figure
imagesc(reshape(valpot.table,Gx,Gy)'); xlabel('x'); ylabel('y');
% plane starts in 1,13 : get optimal sequence: up down left right
xt(1)=1; yt(1)=13;
for t=1:50
    dec=dstar(st(xt(t),yt(t)));
    xold=xt(t); yold=yt(t);
    xnew=xt(t); ynew=yt(t);
    text(xt(t),yt(t),num2str(t));
    switch dec
        case 1
            ynew=yold; xnew=xold;
        case 2
            ynew=yold+1;
        case 3
            ynew=yold-1;
        case 4
            xnew=xold-1;
        case 5
            xnew=xold+1;
    end
    xt(t+1)=xnew; yt(t+1)=ynew;
end

