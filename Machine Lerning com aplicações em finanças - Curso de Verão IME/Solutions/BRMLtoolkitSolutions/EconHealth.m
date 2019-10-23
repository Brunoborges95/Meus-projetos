function EconHealth
import brml.*
[oil inf eh bp rt]=assign(1:5);
[high low normal]=assign(1:3);

varinf(oil).name='oil'; varinf(oil).domain={'high','low'};
varinf(inf).name='inf'; varinf(inf).domain={'high','low'};
varinf(eh).name='EH'; varinf(eh).domain={'high','low'};
varinf(bp).name='BP'; varinf(bp).domain={'normal','high','low'};
varinf(rt).name='RT'; varinf(rt).domain={'normal','high','low'};

pot{eh}=array(eh);
pot{eh}.table(low)=0.2;
pot{eh}.table(high)=0.8;

pot{bp}=array([bp oil]);
pot{bp}.table(low,low)=0.9;
pot{bp}.table(normal,low)=0.1;
pot{bp}.table(high,low)=0;
pot{bp}.table(low,high)=0.1;
pot{bp}.table(normal,high)=0.4;
pot{bp}.table(high,high)=0.5;

pot{oil}=array([oil eh]);
pot{oil}.table(low, low)=0.9;
pot{oil}.table(low, high)=0.05;
pot{oil}.table(high,:)=1-pot{oil}.table(low,:);

pot{rt}=array([rt inf eh]);
pot{rt}.table(low, low,low)=0.9;
pot{rt}.table(low, low, high)=0.1;
pot{rt}.table(low, high, low)=0.1;
pot{rt}.table(low, high, high)=0.01;
pot{rt}.table(high,:,:)=1-pot{rt}.table(low,:,:);

pot{inf}=array([inf oil eh]);
pot{inf}.table(low, low,low)=0.9;
pot{inf}.table(low, low, high)=0.1;
pot{inf}.table(low, high, low)=0.1;
pot{inf}.table(low, high, high)=0.01;
pot{inf}.table(high,:,:)=1-pot{inf}.table(low,:,:);

evpot = setpot(multpots(pot),[bp rt],[normal high]);
disptable(condpot(evpot,inf),varinf);

drawNet(dag(pot),varinf);