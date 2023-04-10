
%dvenugopalarao%

clc
clear 
close all

[data,txt,raw]=xlsread('N2-Data.xlsx',1);
        
x=[data(:,1:4) data(:,5)];
y=data(:,7);

Ns=floor(0.8*length(data));
[xtrain,xtest,ytrain,ytest]=train_test_data(x,y,'HS',Ns,0);

ns=floor(length(xtrain)/5);
leafsizes=[1:1:20];

for wn=1:length(leafsizes)
    
    a=1;b=ns;
    n=leafsizes(wn);
    mse=zeros(5,1);
    
    for k=1:5
        
        b=k*ns;
        testx=xtrain(a:b,:);testy=ytrain(a:b);
        
        if k==1
            trainx=[xtrain(ns+1:end,:)];trainy=[ytrain(ns+1:end)];
        else
            trainx=[xtrain(1:(k-1)*ns,:);xtrain(k*ns+1:end,:)];trainy=[ytrain(1:(k-1)*ns);ytrain(k*ns+1:end)];
        end
            
        [trainx,mux,sigmax] = zscore(trainx);
        [trainy,muy,sigmay] = zscore(trainy);
        
        xnew=(testx-mux)./sigmax; % test dataset
        
        tree = fitrtree(trainx,trainy,'MinLeafSize',n);
        ypred=predict(tree,xnew);
        
        ypred=ypred*sigmay+muy;
        
        mse(k)=mean((testy-ypred).^2);
        a=b+1;
        
%         close
    end
    
    MSE(wn,1)=mean(mse);
    clear mse
    
end

[~,idx]=min(MSE);

plot(leafsizes,MSE,'LineWidth',1.5)
xlabel('Size of leaf nodes')
ylabel('Average MSE')
