
clc
clear 
% close all

global Leafnodes parent_feat_split nodes predictedy minLeafsize VIM

[data,txt,raw]=xlsread('N2-Data.xlsx',1);
        
x=[data(:,1:4) data(:,5)];
y=data(:,7);

Ns=floor(0.8*length(data));
[xtrain,xtest,ytrain,ytest]=train_test_data(x,y,'HS',Ns,0);

[xtrain,mux,sigmax] = zscore(xtrain);
[ytrain,muy,sigmay] = zscore(ytrain);

xnew=(xtest-mux)./sigmax;

names_predictors = {'x1','x2','x3','x4','x5'}; %,'\rhoN','\rhof'

Y = ytrain;
X = xtrain;

test_setx=xnew;
test_sety=ytest;

VIM=zeros(1,size(X,2));
minLeafsize=4;%opt_leafsize;
Leafnodes=[];
parent_feat_split=[];
nodes=[];

[Tree]=RTree(X,Y,names_predictors);
Tree.nodes=nodes;
Tree.leafnodes=Leafnodes;
Tree.parent_feat_split=parent_feat_split;
Tree.predy=predy(Tree,Y);

figure(2)
treeplot(Tree.p')
 
[xs,ys,h,s]=treelayout(Tree.p');
for i=1:length(Tree.p)
   text(xs(i),ys(i),num2str((i)),'VerticalAlignment','bottom','HorizontalAlignment','right')
end
predictedy=[];
for i=2:numel(Tree.p)
    
    child_x=xs(i);
    child_y=ys(i);
    
    parent_x=xs(Tree.p(i));
    parent_y=ys(Tree.p(i));
    
    mid_x=(child_x+parent_x)/2;
    mid_y=(child_y+parent_y)/2;
    
    text(mid_x,mid_y,Tree.labels{i-1})
  % terminal node
    if ~isempty(Tree.indices{i})
        val=Y(Tree.indices{i});
        predictedy=[predictedy;[i mean(val)]];
        text(child_x,child_y,sprintf('y=%2.2f\nn=%d', mean(val), Tree.p(i)))
    end
end

% testing using optimally built tree
pred_resp=zeros(size(test_setx,1),1);
for i=1:size(test_setx,1)
    dataval=test_setx(i,:);
    [pred_resp(i)]=ppredict(dataval,Tree);
end

pred_resp=pred_resp*sigmay+muy;
ypred=pred_resp;

% test_sety=test_sety*sigmay+muy;
ytest=test_sety;

corrcoeff=corr(pred_resp,test_sety,'Type','Pearson');

samples=[1:length(pred_resp)];

figure(3)
plot(test_sety)
hold on
plot(pred_resp,'-o')
hold off
legend('Observed Response','Predicted Response')
% 
figure(4)
plot(test_sety,test_sety,test_sety,pred_resp,'o')

% VIM

VIM=(VIM/(length(Tree.nodes)));

% [VIM,idx]=sort(VIM);

figure(5)
bar(VIM)
% xticklabels(names_predictors)
ylabel('Estimates')
title('Predictor importance estimates')
h = gca;
h.XTickLabel = names_predictors;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';

R2=(corr(ytest,ypred)^2);
fprintf('R^2= %4.4f \n',R2)

% sse=sum((ypred-ytest).^2);
% sst=sum((ytest-mean(ytest)).^2);
% R2=1-(sse/sst);
% disp(R2)

AARD=100*mean(abs((ypred-ytest)./ytest));
fprintf('AARD= %4.4f \n',AARD)

RMSE=sqrt(mean((ypred-ytest).^2));
fprintf('RMSE= %4.4f \n',RMSE)

% average percent relative error
E=((ytest-ypred)./ytest)*100;
Er=mean(E);
fprintf('Er= %4.4f \n',Er)

Ea=mean(abs(E));
fprintf('Ea= %4.4f \n',Ea)

figure
plot(ytest)
hold on
plot(ypred)
legend('data','prediction')
