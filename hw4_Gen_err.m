clear all
clc

eps = 0.05;
dvc = 10;
sigma = 1;
N = 1;

while sigma>0.05
    sigma=4*(2*N)^dvc*exp(-1/8*eps^2*N);
    N=N+1;
end

N
sigma