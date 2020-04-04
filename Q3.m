%Load the data
[train, tune, test, dataDim] = getFederalistData;


%mu = 0.1;
% N = 86;
N = 20;
mu = 0.1;
% H = 0.5*(mu)*diag([ones(1,2),zeros(1,87)]);
H = 0.5*(mu)*diag([ones(1,2),zeros(1,21)]);
% f = 1/86*[zeros(1,3), ones(1,86)];
f = 1/20*[zeros(1,3), ones(1,20)];

%Translate to yi
y = zeros(N,1);
for i = 1:N
    if tune(i,1) == 2
        y(i,1) = -1;
    else
        y(i,1) = 1;
    end
end

A = [];
B = [];
b = -ones(N,1);
%make the A coefficient, each row is [70 text coefficients, b coefficient]
count = 1;
for ac = 2:71
    for ca = 2:71
        if ac == ca
            continue;
        else
        A = [];
        B = [];
        train2 = [tune(:,ac) tune(:,ca)];
        for i = 1:N
            coef = train2(i,1:2);
            coef = y(i,1)*[coef,1];
            A = [A;-coef(1:2)];
            B = [B;y(i,1)*-1];
        end
        A = [A B -eye(20)];
        lb = zeros(23,1);
        for i = 1:3
            lb(i) = -inf;
        end
        [x,fval] = quadprog(H,f,A,b,[],[],lb,[]);
        xx(:,count) = x;
        w = xx(1:2,:);
        c = xx(3,:);
%         for iiii = 1:86
        for iiii = 1:20
            ffff(count,iiii) = train2(iiii,:)*w(:,count) + c(:,count);
        end
        ffff(count,iiii+1) = ac;
        ffff(count,iiii+2) = ca;
        count = count + 1;
        end
    end
end

ffff = ffff';

test2 = [test(:,ac-1) test(:,ca-1)];
for i = 1:12
testresults(i,1) = test2(i,:)*w + c;
end
testresulttable = array2table(testresults);
writetable(testresulttable,'testresults.csv');



figure
plot(xaxis,yaxis);

% for i = 1:N
%  coef = train(i,2:71);
%  coef = y(i,1)*[coef,1];
%  %coef = [coef,1];
%  A = [A;-coef(1:70)];
%  B = [B;y(i,1)*-1];
% end
% A = [A B -eye(86)];
% % A = [A B -eye(20)];
% %run Quadprog
% lb = zeros(157,1);
% for i = 1:71
%     lb(i) = -inf;
% end
% [x,fval] = quadprog(H,f,A,b,[],[],lb,[]);

% % fprintf('w values')
% w = x(1:70,1)
% % fprintf('b value')
% b = x(71,1)
% % fprintf('s values')
% s = x(72:157,1)
% % s = x(72:91,1)

% for iiii = 1:86
% % for iiii = 1:20
% ffff(iiii) = train(iiii,2:71)*w + b;
% end
% ffff = ffff';

% for i = 1:12
% testresults(i,1) = test(i,:)*w + b;
% end
% testresulttable = array2table(testresults);
% writetable(testresulttable,'testresults.csv');

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