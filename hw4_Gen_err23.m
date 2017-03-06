clear all
clc

Nmax = 1000;
dvc = 50;
sigma = 0.05;
N = 1:Nmax;
mh = (2*N).^dvc;
mhdev = (N.*N).^dvc;

orig = (8./N.*log(4.*mh/sigma)).^0.5;
rade = (2./N.*log(2.*N.*mh)).^0.5+(2./N*log(1/sigma)).^0.5+1./N;

parr=zeros(1,Nmax);
devr=zeros(1,Nmax);

for i=1:Nmax
    fun1=@(epsilon)(1/N(i)*(2*epsilon+log(6*mh(i)/sigma)))^0.5-epsilon;
    solution1=fzero(fun1,1);
    parr(i)=solution1;
    fun2=@(epsilon)((1/(2*N(i)))*(4*epsilon*(1+epsilon)+log(4*mhdev(i)/sigma)))^0.5-epsilon;
    solution2=fzero(fun2,1);
    devr(i)=solution2;
end

devr(1)=0;
devr(2)=0;

plot(N,orig,N,rade,N,parr,N,devr)
legend('show')