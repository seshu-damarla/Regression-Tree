
clc
clear

load carsmall

X=[Weight Cylinders];
Y=MPG;

index=[];
for i=1:1:length(Y)
    if isnan(Y(i))
        index=[index;i];
    end
end

Y(index)=[];
X(index,:)=[];

samples=[1:1:length(Y)]';

% root node
RSS=sum((Y-mean(Y)).^2);
cutpoint=[sort(X(:,1)) sort(X(:,2))]; % candidate values of cut point for predictors
% first split
for j=1:1:size(cutpoint,2)
    
    predictor=X(:,j);
    
    for i=1:1:length(cutpoint(:,j))
        
%         s=(cutpoint(i,j)+cutpoint(i+1,j))/2;
        s=cutpoint(i,j);
        idx1=predictor<s;   % indices of training obsv. belonging to left child node
        idx2=predictor>=s;  % indices of training obsv. belonging to right child node
        
        leftnode=predictor(idx1);
        rightnode=predictor(idx2);
        
        Rss1(i,j)=sum((Y(idx1)-mean(Y(idx1))).^2);
        Rss2(i,j)=sum((Y(idx2)-mean(Y(idx2))).^2);
        
        DelRss(i,j)=RSS-Rss1(i,j)-Rss2(i,j);
        
    end
    
end
clear idx1 idx2 leftnode rightnode RSS 

[max1,idx1]=max(DelRss(:,1));
[max2,idx2]=max(DelRss(:,2));

if max1>max2
    splitting=cutpoint(idx1,1);
    root_node=X(:,1);
    leftnode=(root_node<splitting);
    rightnode=(root_node>=splitting);
    RssL=sum((Y(leftnode)-mean(Y(leftnode))).^2);
    RssR=sum((Y(rightnode)-mean(Y(rightnode))).^2);
    bestpredictor='Weight';
else
    splitting=cutpoint(idx2,2);
    root_node=X(:,2);
    leftnode=(root_node<splitting);
    rightnode=(root_node>=splitting);
    RssL=sum((Y(leftnode)-mean(Y(leftnode))).^2);
    RssR=sum((Y(rightnode)-mean(Y(rightnode))).^2);
    bestpredictor='Cylinders';
end

clear Rss1 Rss2 DelRss cutpoint

RSS=sum((Y(leftnode)-mean(Y(leftnode))).^2);
cutpoint=[sort(X(leftnode,1)) sort(X(leftnode,2))]; % candidate values of cut point for predictors
Inputs=X(leftnode,:);


for j=1:1:size(cutpoint,2)
    
    predictor=Inputs(:,j);
    
    for i=1:1:length(cutpoint(:,j))
        
%         s=(cutpoint(i,j)+cutpoint(i+1,j))/2;
        s=cutpoint(i,j);
        idx1=predictor<s;   % indices of training obsv. belonging to left child node
        idx2=predictor>=s;  % indices of training obsv. belonging to right child node
        
        leftnode=predictor(idx1);
        rightnode=predictor(idx2);
        
        Rss1(i,j)=sum((Y(idx1)-mean(Y(idx1))).^2);
        Rss2(i,j)=sum((Y(idx2)-mean(Y(idx2))).^2);
        
        DelRss(i,j)=RSS-Rss1(i,j)-Rss2(i,j);
        
    end
    
end 

[max1,idx1]=max(DelRss(:,1));
[max2,idx2]=max(DelRss(:,2));  

if max1>max2
    splitting=cutpoint(idx1,1);
    parent_node=Inputs(:,1);
    leftnode=samples(parent_node<splitting);
    rightnode=samples(parent_node>=splitting);
    RssL=sum((Y(leftnode)-mean(Y(leftnode))).^2);
    RssR=sum((Y(rightnode)-mean(Y(rightnode))).^2);
    bestpredictor='Weight';
else
    splitting=cutpoint(idx2,2);
    parent_node=Inputs(:,2);
    leftnode=samples(parent_node<splitting);
    rightnode=samples(parent_node>=splitting);
    RssL=sum((Y(leftnode)-mean(Y(leftnode))).^2);
    RssR=sum((Y(rightnode)-mean(Y(rightnode))).^2);
    bestpredictor='Cylinders';
end

clear Rss1 Rss2 DelRss cutpoint RSS Inputs

RSS=sum((Y(leftnode)-mean(Y(leftnode))).^2);
cutpoint=[sort(X(leftnode,1)) sort(X(leftnode,2))]; % candidate values of cut point for predictors
Inputs=X(leftnode,:);

for j=1:1:size(cutpoint,2)
    
    predictor=Inputs(:,j);
    
    for i=1:1:length(cutpoint(:,j))
        
%         s=(cutpoint(i,j)+cutpoint(i+1,j))/2;
        s=cutpoint(i,j);
        idx1=predictor<s;   % indices of training obsv. belonging to left child node
        idx2=predictor>=s;  % indices of training obsv. belonging to right child node
        
        leftnode=predictor(idx1);
        rightnode=predictor(idx2);
        
        Rss1(i,j)=sum((Y(idx1)-mean(Y(idx1))).^2);
        Rss2(i,j)=sum((Y(idx2)-mean(Y(idx2))).^2);
        
        DelRss(i,j)=RSS-Rss1(i,j)-Rss2(i,j);
        
    end
    
end 

[max1,idx1]=max(DelRss(:,1));
[max2,idx2]=max(DelRss(:,2));  

if max1>max2
    splitting=cutpoint(idx1,1);
    parent_node=Inputs(:,1);
    leftnode=samples(parent_node<splitting);
    rightnode=samples(parent_node>=splitting);
    RssL=sum((Y(leftnode)-mean(Y(leftnode))).^2);
    RssR=sum((Y(rightnode)-mean(Y(rightnode))).^2);
    bestpredictor='Weight';
else
    splitting=cutpoint(idx2,2);
    parent_node=Inputs(:,2);
    leftnode=samples(parent_node<splitting);
    rightnode=samples(parent_node>=splitting);
    RssL=sum((Y(leftnode)-mean(Y(leftnode))).^2);
    RssR=sum((Y(rightnode)-mean(Y(rightnode))).^2);
    bestpredictor='Cylinders';
end

clear Rss1 Rss2 DelRss cutpoint RSS Inputs

RSS=sum((Y(rightnode)-mean(Y(rightnode))).^2);
cutpoint=[sort(X(rightnode,1)) sort(X(rightnode,2))]; % candidate values of cut point for predictors
Inputs=X(rightnode,:);

for j=1:1:size(cutpoint,2)
    
    predictor=Inputs(:,j);
    
    for i=1:1:length(cutpoint(:,j))
        
%         s=(cutpoint(i,j)+cutpoint(i+1,j))/2;
        s=cutpoint(i,j);
        idx1=predictor<s;   % indices of training obsv. belonging to left child node
        idx2=predictor>=s;  % indices of training obsv. belonging to right child node
        
        leftnode=predictor(idx1);
        rightnode=predictor(idx2);
        
        Rss1(i,j)=sum((Y(idx1)-mean(Y(idx1))).^2);
        Rss2(i,j)=sum((Y(idx2)-mean(Y(idx2))).^2);
        
        DelRss(i,j)=RSS-Rss1(i,j)-Rss2(i,j);
        
    end
    
end 

[max1,idx1]=max(DelRss(:,1));
[max2,idx2]=max(DelRss(:,2));  

if max1>max2
    splitting=cutpoint(idx1,1);
    parent_node=Inputs(:,1);
    leftnode=samples(parent_node<splitting);
    rightnode=samples(parent_node>=splitting);
    RssL=sum((Y(leftnode)-mean(Y(leftnode))).^2);
    RssR=sum((Y(rightnode)-mean(Y(rightnode))).^2);
    bestpredictor='Weight';
else
    splitting=cutpoint(idx2,2);
    parent_node=Inputs(:,2);
    leftnode=samples(parent_node<splitting);
    rightnode=samples(parent_node>=splitting);
    RssL=sum((Y(leftnode)-mean(Y(leftnode))).^2);
    RssR=sum((Y(rightnode)-mean(Y(rightnode))).^2);
    bestpredictor='Cylinders';
end

% clear Rss1 Rss2 DelRss cutpoint RSS Inputs
