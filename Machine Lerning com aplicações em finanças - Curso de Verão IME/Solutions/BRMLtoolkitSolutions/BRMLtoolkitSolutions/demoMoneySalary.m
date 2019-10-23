function demoMoneySalary
close all
import brml.*


disp('Using the linear utility:')
utility_bet = 0.5*(1000000000)+0.5*1000
utility_nobet = 1000000

p=normp([1 2 3 4 15 10 4 3 2 1]);
bar(p); title('wealth distribution')
u=cumsum(p);
figure; plot(u); title('cumulative wealth distribution')

% states that represent the three positions:
poor=1; millionaire=8; billionaire=10; 

disp('Using the non-linear utility:')
utility_bet = 0.5*u(billionaire)+0.5*u(poor)
utility_nobet = u(millionaire)
