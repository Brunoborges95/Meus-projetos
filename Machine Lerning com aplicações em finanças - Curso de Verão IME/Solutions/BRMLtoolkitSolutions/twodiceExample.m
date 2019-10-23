function twoDiceExample
import brml.*
% two dice
sumOfDice = 9;

% variable ordering
dice1=1; dice2=2; score=3;

% name random variables states
variable(dice1).domain={'1', '2', '3', '4', '5', '6'};
variable(dice2).domain={'1', '2', '3', '4', '5', '6'};

% name random variables
variable(dice1).name='dice1';
variable(dice2).name='dice2';
variable(score).name='score';

% set dice potentials
pot{dice1}=array(dice1, repmat((1/6),[1 6]));
pot{dice2}=array(dice2, repmat((1/6),[1 6]));

% set score potential
% score refers to the indicator prob p(score|dice1,dice2)
pot{score}=array([dice1,dice2]);
tmptable=zeros(6);
    for m=1:6
        for n=1:6
            if m+n==sumOfDice
                tmptable(m,n)=1;
            end
        end
    end
pot{score}.table=tmptable;

joint = multpots(pot([score dice1 dice2]));

posterior = divpots(joint,sumpot(joint,score,0));
disp('p(dice1,dice2|score = ):')
disptable(posterior,variable);