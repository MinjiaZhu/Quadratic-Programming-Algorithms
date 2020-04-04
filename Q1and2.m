function [X,FVAL,t] = quad()

[train, tune, test, dataDim] = getFederalistData;

labels = train(:,1);
M = train(find(labels==2),1:end);
H = train(find(labels==1),1:end);
matrix = [H;M];
mu = 0.10;

N = size(matrix,1);
M = size(matrix,2) - 1;

H = zeros(N+M+1);
D = zeros(N+M+1,1);
D(1:M,1) = 0.5*mu;
D = diag(D);
H = H + D;

f = zeros(size(H,1),1);
f(M+2:end) = 1/N;

b = ones(N,1);

matrix(matrix(:,1)==2,1)=-1;

A1 = matrix(:,1).*matrix(:,2:end);

A2 = matrix(:,1);

A3 = eye(N);

A = [A1 A2 A3];

LB(1:71,1) = -9999999;
LB(72:157,1) = 0;
% load('QP_1.mat');
% H = Q;
% 
% H = [1 0;0 1];
% f = [-3,-1]';
% A = [-1 2;1 2];
% b = [0;1];
% LB = [-inf,0];
% load('QP_4.mat');
% H = Q;
% A = [-eye(length(LB)); eye(length(UB))];
% b = [LB;UB];
tic
[X, FVAL] = quadprog(H,f,-A,-b,[],[],LB,[]);
t = toc;

end

function [train,tune,test,dataDim] = getFederalistData
% syntax: [train,tune,test,dataDim] = getdata
% extract data from the database file federalData.mat

load federalData
dataDim = size(data,2) - 1;
labels = data(:,1);
test = data(find(labels==3),2:end);
train = data(find(labels~=3),:);
tune = train(1:20,:);
train = train(21:end,:);
return;
end
