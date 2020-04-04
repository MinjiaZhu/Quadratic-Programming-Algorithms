function [z,w,b] = Solver(M,H,mu)

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

tic
[X, FVAL] = quadprog(H,f,-A,-b,[],[],LB,[]);
w = X(1:70,:);
b = X(71,:);
z = FVAL;
t = toc;

end
