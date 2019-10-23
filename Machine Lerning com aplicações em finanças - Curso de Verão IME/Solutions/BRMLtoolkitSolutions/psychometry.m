function psychometry
import brml.*
p = perms([1 2 3 4 5]); % all the permutations of 1:5
c = count( (1+sum(repmat(1:5,size(p,1),1)==p,2))',6) % counts
f = c./sum(c); % frequency
sum(f.*[0 1 2 3 4 5])  % expected number