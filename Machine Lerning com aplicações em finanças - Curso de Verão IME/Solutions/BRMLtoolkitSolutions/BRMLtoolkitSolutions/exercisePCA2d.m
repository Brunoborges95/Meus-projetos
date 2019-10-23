function exercisePCA2D
X=[ [ 1.3 1.6 2.8]' [4.3, -1.4, 5.8]' [-0.6,3.7,0.7]' [-0.4,3.2,5.8]' [3.3,-0.4,4.3]' [-0.4,3.1,0.9]']

disp('mean c=:')
c=mean(X,2)


disp('covaricance S=:')
S=X*X'/6-c*c'

disp('eigen decomposition:')
 [V D]=eig(S)
 
 e1=V(:,3); e2=V(:,2);
 
 disp('two dim representations:')
 for n=1:6; disp([e1'*(X(:,n)-c) e2'*(X(:,n)-c)]); end
 
 disp('reconstructed matrix:')
 for n=1:6; XX(:,n)=c+e1'*(X(:,n)-c)*e1+ e2'*(X(:,n)-c)*e2; end
 XX
 
 disp('original data matrix:')
 X