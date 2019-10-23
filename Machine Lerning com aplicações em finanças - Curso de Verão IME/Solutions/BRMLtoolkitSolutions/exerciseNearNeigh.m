function exerciseNearNeigh
import brml.*
load NNdata
n=[600 600]; % number of training points in classes

trainlabel{1}=5*ones(1,n(1));
trainlabel{2}= 9*ones(1,n(2));
trainlabels=[trainlabel{1} trainlabel{2}];

xtest=[test5 test9];
train =[train5 train9];

for K=1:6
    for leaveout=1:sum(n)
        fprintf(1,'\nK=%d, validation datapoint=%d',K,leaveout);
        newtrain=train(:,[1:leaveout-1 leaveout+1:end]); newtest=train(:,leaveout);
        newtrainlabels=trainlabels([1:leaveout-1 leaveout+1:end]);
        testlabel=trainlabels(leaveout);
        
        y = nearNeigh(newtrain, newtest, newtrainlabels,K); % 3 nearest neighbours
        nerror(leaveout,K)=y~=testlabel;     
    end
end

errors=sum(nerror,1);
disp('Training:')
for K=1:6
    disp(['Using K=' num2str(K) ' neighbours the classifer makes in total ' num2str(errors(K)),' LOO validation errors'])
end
Kopt=argmin(errors);

y = nearNeigh(train, xtest, trainlabels,Kopt); % nearest neighbours

errs =sum(y(1:252)~=5)+sum(y(253:end)~=9);
disp('Testing:')
disp(['Using Kopt=' num2str(Kopt) ' neighbours the classifer makes ' num2str(errs),' test errors ['  num2str(100*errs/size(xtest,2)) '%]'])