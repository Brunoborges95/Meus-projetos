function softxor
import brml.*
[a b c]=assign(1:3);
[zero_state one_state]=assign(1:2);

potCgivenAB=array([a b c],zeros(2,2,2));
potCgivenAB=setstate(potCgivenAB,[a b c],[zero_state zero_state one_state],0.1);
potCgivenAB=setstate(potCgivenAB,[a b c],[zero_state one_state one_state],0.99);
potCgivenAB=setstate(potCgivenAB,[a b c],[one_state zero_state one_state],0.8);
potCgivenAB=setstate(potCgivenAB,[a b c],[one_state one_state one_state],0.25);
potCgivenAB.table(:,:,zero_state)=1-potCgivenAB.table(:,:,one_state);

potA=array(a,zeros(2,1));
potA=setstate(potA,a,one_state,0.65); potA=setstate(potA,a,zero_state,0.35); 
potB=array(b,zeros(2,1));
potB=setstate(potB,b,one_state,0.77); potB=setstate(potB,b,zero_state,0.23); 

potABC=multpots([potCgivenAB potA potB]);
fprintf(1,'p(a=1|c=0)=%g\n',table(setpot(condpot(potABC,a,c),[a c],[one_state zero_state])));