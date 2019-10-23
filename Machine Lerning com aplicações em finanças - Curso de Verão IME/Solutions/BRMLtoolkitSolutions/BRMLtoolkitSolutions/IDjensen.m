function IDjensen
import brml.*
load IDjensen
pot=str2cell(setpotclass(pot,'array'));
util=str2cell(setpotclass(util,'array'));

% Solve Influence Diagram using Junction Tree:
[jtprob jtutil infostruct]=jtreeID(pot,util,partialorder); % get the Junction Tree
[jtprob jtutil]=absorptionID(jtprob,jtutil,infostruct,partialorder); % do absorption
drawJTree(infostruct,varinf)

[probroot, utilroot]=sumpotID(jtprob(end),jtutil(end),[],[],partialorder,0);
disp(['Junction Tree: Expected Utility at the root node =',num2str(table(utilroot))]);
[newprob newutil] = sumpotID(pot,util,[],[],partialorder,0);
disp(['check by explicit enumeration =',num2str(table(newutil))])

[probtmp, utiltmp]=sumpotID(jtprob(end-1),jtutil(end-1),[],[d1],partialorder,0);
disp('Junction Tree: Expected Utility at first decision:')
disptable(utiltmp,varinf);
[newprob newutil] = sumpotID(pot,util,[],[d1],partialorder,0);
disp('check by explicit enumeration:');
disptable(newutil,varinf);