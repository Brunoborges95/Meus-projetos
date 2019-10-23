function MarkovEquivExample
import brml.*
a = zeros(9); b=a;

a(1,3)=1; a(1,6)=1; a(1,4)=1;
a(2,3)=1; a(2,5)=1;
a(3,7)=1;
a(4,8)=1;
a(5,3)=1; a(5,7)=1;
a(6,8)=1; a(6,4)=1;
a(4,9)=1; a(7,9)=1;
drawNet(a); title('a');

figure; 

b(1,4)=1; 
b(1,3)=1;
b(2,3)=1;
b(3,7)=1;
b(4,8)=1;
b(5,7)=1;b(5,3)=1; b(5,2)=1;
b(6,1)=1; b(6,4)=1; b(6,8)=1;
b(4,9)=1; b(7,9)=1;
drawNet(b); title('b');

[equiv imA imB]=MarkovEquiv(a,b);
equiv
figure; drawNet(imA); title('immoralities a')
figure; drawNet(imB); title('immoralities b')