function carstart
import brml.*
battery = 1; fuel = 2; gauge = 3; turnover = 4; start = 5;
flat = 1; charged = 2; empty = 1; full = 2; gEmpty = 1; gFull = 2;
turns = 1; noTurn = 2; starts = 1; noStart = 2;
variable(battery).domain = {'flat', 'charged'};
variable(fuel).domain = {'empty', 'full'};
variable(gauge).domain = {'gEmpty', 'gFull'};
variable(turnover).domain = {'true', 'false'};
variable(start).domain = {'true', 'false'};
variable(battery).name = 'battery'; variable(fuel).name = 'fuel';
variable(gauge).name = 'gauge'; variable(turnover).name = 'turnover';
variable(start).name = 'start';
% Battery potential p(b)
pot{battery}=array(battery);
pot{battery}.table(flat)=0.02;
pot{battery}.table(charged)=1-pot{battery}.table(flat);
% Fuel potential p(f)
pot{fuel}=array(fuel);
pot{fuel}.table(empty)=0.05; pot{fuel}.table(full)=0.95;
% Gauge potential p(g|b,f)
pot{gauge}=array([gauge, battery, fuel]);
pot{gauge}.table(gEmpty, charged, full)=0.04;
pot{gauge}.table(gEmpty, flat, full)=0.1;
pot{gauge}.table(gEmpty, charged, empty)=0.97;
pot{gauge}.table(gEmpty, flat, empty)=0.99;
pot{gauge}.table(gFull,:,:)=1-pot{gauge}.table(gEmpty,:,:);
% Turnover potential p(t|b)
pot{turnover}= array([turnover, battery]);
pot{turnover}.table(noTurn,charged)=0.03;
pot{turnover}.table(noTurn,flat)=0.98;
pot{turnover}.table(turns,:)=1-pot{turnover}.table(noTurn,:);
% Start potential p(s|t,f)
pot{start}=array([start, turnover, fuel]);
pot{start}.table(noStart,turns,full)=0.01;
pot{start}.table(noStart,noTurn,full)=1;
pot{start}.table(noStart,turns,empty)=0.92;
pot{start}.table(noStart,noTurn,empty)=0.99;
pot{start}.table(starts,:,:)=1-pot{start}.table(noStart,:,:);
jointPot = multpots(pot([start turnover gauge fuel battery]));
drawNet(dag(pot),variable);
disp('p(fuel | start = false):')
disptable(setpot(condpot(jointPot,fuel,start),start,noStart),variable);