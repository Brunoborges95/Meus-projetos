function pot = computerExampletable(tabvars)
import brml.*
pot=array(tabvars,zeros([2 2 2 2]));
st = ind2subv([2 2 2],1:16); yes=2; no=1;
for i=1:8
    stlog = st(i,:)-1; 
    tmptable(yes,st(i,1),st(i,2),st(i,3))= stlog(1) | (stlog(2) & stlog(3));
    tmptable(no,st(i,1),st(i,2),st(i,3))= 1 - tmptable(yes,st(i,1),st(i,2),st(i,3));
end
pot.table=tmptable; 