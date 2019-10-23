function exerciseSLDSprice
import brml.*
load SLDSpricemodel

V=1; H=2; S=2; I=2; T=200;

% Perform approximate Filtered inference:
[f F alpha w loglik]=SLDSforward(v,A,B,covH,covV,meanH,zeros(V,H,S),covP,meanP,stran,prior,I);
[mf, dum]=SLDSmargGauss(w,alpha,f,F);
vpred(2:T+1)=sum(mf);

mean_abs_pred_error=mean(abs(vpred(2:end-1)-v(2:end)))
mean_abs_pred_error_naive=mean(abs(v(1:end-1)-v(2:end)))