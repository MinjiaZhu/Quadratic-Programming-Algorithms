function[] =  Q4()
[train, tune, test, dataDim] = getFederalistData;
mu = 0.1;

wordList = 1:70;
combArray = combnk(wordList,2);

p2Array = zeros(length(combArray),3);
p2s = zeros(length(combArray),1);
trainInit = train;
tuneInit = tune;

tune = tuneInit;
train = trainInit;
x = [train;tune;zeros(size(test,1),1),test];

madPapers = x(find(x(:,1)==1),:); %--> madison
hamPapers = x(find(x(:,1)==2),:); %--> hamilton
dispPapers = x(find(x(:,1)==0),:);  %--> disputedPapers

w1 = 0.0646;
w2 = 0.4818;
clf;

scatter(madPapers(:,4),madPapers(:,61),'+');
hold all;
scatter(hamPapers(:,4),hamPapers(:,61),'o');
hold all;
scatter(dispPapers(:,4),dispPapers(:,61),'*');

grid;
legend([{'Madison Papers'} {'Hamilton Papers'} {'Disputed Papers'}]);
title('');
ylabel('60th Element of Weighting Vector (w) --> upon');
xlabel('3rd Element of Weighting Vector (w) --> also');
          
end
