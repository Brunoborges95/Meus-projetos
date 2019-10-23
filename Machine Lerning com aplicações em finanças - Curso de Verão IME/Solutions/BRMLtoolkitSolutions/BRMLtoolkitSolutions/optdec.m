function [d1 val]=optdec(epsilonA1,epsilonB1,desired,T,w1,pars)
import brml.*
epsilonAtran=pars.epsilonAtran;
epsilonBtran=pars.epsilonBtran;
epsilonAval=pars.epsilonAval;
epsilonBval=pars.epsilonBval;
DecisionValue=pars.DecisionValue;
WealthValue=pars.WealthValue;

w(1)=w1;

% dynamic programming:
[vdAt,vdAtm,vdBt,vdBtm,vwtm,vdtm]=assign(1:6);
Atran=array([vdAt,vdAtm],epsilonAtran);
Btran=array([vdBt,vdBtm],epsilonBtran);
pot=array([vdAt vdBt vwtm vdtm]);
for t=T:-1:3
    for wtm=1:length(WealthValue)
        for dtm=1:length(DecisionValue)
            for dAt=1:length(epsilonAval)
                for dBt=1:length(epsilonBval)
                    DecisionValuetm=DecisionValue(dtm);
                    wtval=WealthValue(wtm)*(DecisionValuetm*(1+epsilonAval(dAt))+(1-DecisionValuetm)*(1+epsilonBval(dBt)));
                    wt=val2state(wtval,WealthValue); % get the nearest state corresponding to this value
                    if t==T
                        tmp=ufun(WealthValue(wt),desired);
                    else
                        tmp=gamma(t).table(dAt,dBt,wt);
                    end
                    pot.table(dAt,dBt,wtm,dtm)=tmp;
                end
            end
        end
    end
    gamma(t-1)=maxpot(sumpot(multpots([Atran Btran pot]),[vdAt vdBt]),vdtm);
end

clear pot
pot=array([vdAt vdBt vdtm]);
wtm=val2state(w(1),WealthValue);
for dtm=1:length(DecisionValue)
    for dAt=1:length(epsilonAval)
        for dBt=1:length(epsilonBval)
            DecisionValuetm=DecisionValue(dtm);
            wtval=WealthValue(wtm)*(DecisionValuetm*(1+epsilonAval(dAt))+(1-DecisionValuetm)*(1+epsilonBval(dBt)));
            wt=val2state(wtval,WealthValue); % get the nearest state corresponding to this value
            pot.table(dAt,dBt,dtm)=gamma(2).table(dAt,dBt,wt);
        end
    end
end
U=sumpot(multpots([Atran Btran pot]),[vdAt vdBt]);
Ud1=setpot(U,[vdAtm vdBtm],[epsilonA1 epsilonB1]);
d1=argmax(Ud1.table); val=max(Ud1.table);

function u=ufun(w,desired)
u=real(w>desired);

function s=val2state(x,prices)
s=brml.argmin(abs(prices-x));
