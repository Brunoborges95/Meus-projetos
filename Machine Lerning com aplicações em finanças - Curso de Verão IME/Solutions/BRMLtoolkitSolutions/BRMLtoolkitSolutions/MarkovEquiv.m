function [equiv imA imB] = MarkovEquiv(A,B)
%MARKOVEQUIV check if two DAGS are Markov Equivalent
% equiv = MarkovEquiv(A,B)
skA = (A+A')>0;
skB = (B+B')>0;
imA =immoralities(A); 
imB =immoralities(B); 
equiv = all(skA(:)==skB(:)) & all(imA(:)==imB(:));
