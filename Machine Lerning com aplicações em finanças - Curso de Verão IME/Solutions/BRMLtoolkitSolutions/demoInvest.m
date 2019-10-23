function demoInvest
import brml.*

deltaAval=[0 0.01]; % possible percent changes for asset A
deltaBval=[-0.12 0 0.15]; % possible percent changes for asset B 
decval=[1:-0.25:0]; % possible fractions to invest in asset A

Wval=0:0.1:3; % possible discrete wealth values

% asset A
for st=1:length(deltaAval)
    for stp=1:length(deltaAval)
        deltaAtran(stp,st)=exp(- 0*1500*(deltaAval(stp)-deltaAval(st)).^2);
    end
end
deltaAtran=condp(deltaAtran);

% asset B
for st=1:length(deltaBval)
    for stp=1:length(deltaBval)
        deltaBtran(stp,st)=exp(- 10*(deltaBval(stp)-deltaBval(st)).^2);
    end
end
deltaBtran=condp(deltaBtran);

% simulate some price movements

deltaA(1)=1;
deltaB(1)=length(deltaBval);

w(1)=1;
priceA(1)=1;
priceB(1)=1;

T=40;

for t=2:T
    deltaA(t)=randgen(deltaAtran(:,deltaA(t-1)));
    deltaB(t)=randgen(deltaBtran(:,deltaB(t-1)));
        
    priceA(t)=priceA(t-1)*(1+deltaAval(deltaA(t)));
    priceB(t)=priceB(t-1)*(1+deltaBval(deltaB(t)));
end
figure
plot((priceA),'-ko','markerfacecolor','k','markersize',3)
hold on; 
plot((priceB),'-ko','markersize',3)
legend('A price','B price')

desired=1.5;
pars.epsilonAtran=deltaAtran;
pars.epsilonBtran=deltaBtran;
pars.epsilonAval=deltaAval;
pars.epsilonBval=deltaBval;
pars.DecisionValue=decval;
pars.WealthValue=Wval;
figure
for t=1:T-1
    [dec(t) val(t)]=optdec(deltaA(t),deltaB(t),desired,T+2-t,w(t),pars);
    dval(t)=decval(dec(t));
    fprintf('time %d: optimally place %f of wealth in asset a,giving an expected utility of %f. wealth=%f\n',...
        t,dval(t),val(t),w(t));
     w(t+1)=w(t)*(dval(t)*(1+deltaAval(deltaA(t+1)))+(1-dval(t))*(1+deltaBval(deltaB(t+1))));  
     cla; plot(w,'sk-','markersize',4,'markerfacecolor','k'); hold on;
     line([1 T],[desired desired],'color','k','linestyle','--'); title('wealth');
     drawnow
end

figure
plot(dval,'-k.'); title('Optimal decisions: % invested in bank asset A')


