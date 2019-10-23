function solutionBearBull
close all
import brml.*

[bear bull]=assign(1:2); % bear goes up, bull goes down

Tran(bear,bear)=0.8;
Tran(bull,bear)=0.2;
Tran(bull,bull)=0.7;
Tran(bear,bull)=0.3;

P=100; % number of price values
price=1:P; % price values
load BearBullproblem
T=length(p); % length of timeseries
subplot(2,1,1); plot(1:T,p,'-o'); title('price')

% dynamic programming for filtering:
[htm ht vtm vt]=assign(1:4);
tranpot=array([ht htm],Tran);
for h=1:2
    for ptm=price
        for pt=price
            if h==bull
                tmp(pt,ptm,h)=pbull(pt,ptm);
            else
                tmp(pt,ptm,h)=pbear(pt,ptm);
            end
        end
    end
end
empot=array([vt vtm ht],tmp);

f(:,1)=[0.5 0.5]';
filt=array(1,[0.5 0.5]);
for t=2:T
    filt=condpot(setpot(empot,[vtm vt],[p(t-1) p(t)])*tranpot*filt,ht); % filtered update
    f(:,t)=filt.table;
    filt.variables=1; % need to reset the filtered distribution variable number for the next timestep
end
subplot(2,1,2); plot(f(2,:),'-o'); title('p bull')

% prediction:
predh=condpot(filt*tranpot,ht); % latent state prediction
predv=condpot(setpot(empot,vtm,p(T))*predh,vt); % output state prediction

U=0; V=0;
for i=price
    U=U+predv.table(i)*(i-p(T)); % expected gain
    V=V+predv.table(i)*(i-p(T)).^2; % expected squared gain
end
fprintf(1,'Expected price gain = %f\n', U); % total expected gain
fprintf(1,'Expected price gain standard deviation = %f\n', sqrt(V-U^2));