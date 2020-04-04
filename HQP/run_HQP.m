function [z,b,w,p1,p2] = run_HQP(M, H, mu)

matrix = [H;M];

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
% load('QP_5.mat')
% 
% H = Q;
% 
% A = [-eye(length(LB)); eye(length(UB))];
% b = [LB;UB];

tic
%% DUAL PROBLEM INITIALIZATION 
H_inverse = H\eye(size(H,1));
P = A*H_inverse*A';
D = A*H_inverse*f + b;

%Initialize lambda vectors 
lambda = zeros(size(D,1),1);
lambdaOld= zeros(size(D,1),1);
lambdaNew = ones(size(D,1),1);

n = size(D,1);
count = 0;
check = 1;

%  tol = 1e-9;
%% CHECK FOR CONVERGENCE
while count<100000
    lambda = lambdaNew;
    for ii = 1:n
        
        sum1 = 0;
        sum2 = 0;
        
        %LHS
        for a = 1:ii-1
            sum1 = sum1 + P(ii,a)*lambdaNew(a);
        end
        
        %RHS
        for b = ii+1:n
            sum2 = sum2 + P(ii,b)*lambda(b);
        end
        
        sum = sum1 + sum2 + D(ii,1);
        %Update lambda 
        lambdaNew(ii) = max(0,((-1)/P(ii,ii))*(D(ii) + sum1 + sum2));
        
    end
%      delta = abs(lambda - lambdaNew);
%     
%     if delta < tol
%         break;
%     end
%     lambdaNew = lambda;
     count = count + 1;
    
    %Check for convergence comparing lambda in iteration k and k+1
%    check = norm(lambdaNew-lambdaOld);
%    if lambdaNext ~= lambdaPrev
%          check = 1;
%      else
%          check = 0;
%      end

end


%%CALCULATE OBJECT VAL
x = -H_inverse*f - H_inverse*A'*lambdaNew
z = 0.5*x'*H*x + f'*x

t1 = toc;

tic
[xquad, fval] = quadprog(Q,f,[],[],[],[],LB,UB);
w = xquad(1:70,:);
b = xquad(71,:);
z = fval;
t2 = toc
