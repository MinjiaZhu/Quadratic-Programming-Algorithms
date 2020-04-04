function [z,w,b,p1,p2] = run_CG(M,H,mu)

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
x = (H\eye(size(H,1)))* f;
% x = randn(size(H,1),1);
% z = 0.5*x'*H*x + f'*x ;
omegaold = 900;
omega = omegaold;
k = 0;
count = 0;

while omegaold <= omega
    omegaold = omega;
    Hadj = H + 2*omega*A'*A;
    fadj = f' - 2*omega*b'*A;
    wbtb = omegaold*b'*b;
    grad = Hadj*x + fadj';
    p = -grad;
    while  k <= 1000
%         zold = 0.5*x'*Hadj*x + fadj*x;
        grad = Hadj*x + fadj';
        alpha = - (p'*grad)/(p' * Hadj * p);
        x1 = x + alpha*p;
        gradnew = Hadj*x1 + fadj';
%         beta = (norm(gradnew)^2)/(norm(grad)^2);
        beta = (gradnew' * Hadj * p)/(p' * Hadj *p);
        p = -gradnew + beta*p;
        x = x1;
        znew = 0.5*x'*Hadj*x + fadj*x ;
        k = k+1;
    end
    omega = znew;
    z = znew;
    xopt = x;
    count = count+1;
end

w = X(1:70,:);
b = X(71,:);
z = FVAL;
t = toc;