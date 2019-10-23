function demoRejSamp

x=-pi:0.01:pi;

ps=exp(sin(x));
ss=10;

subplot(1,2,1);
plot(x,ps,'r');
hold on
q=exp(-0.5*x.^2/ss)/sqrt(2*pi*ss);
M=exp(1+pi^2/(2*ss))*sqrt(2*pi*ss);
plot(x,q*M,'b'); legend('p*','Mq');

samp=[];
for l=1:10000
    while 1
        x=sqrt(ss)*randn; 
        a=(abs(x)<pi)*exp(sin(x))/(M*exp(-0.5*x.^2/ss)/sqrt(2*pi*ss));
        if rand<a
            break
        end
    end
    samp=[samp x];
end
subplot(1,2,2); hist(samp,20);
