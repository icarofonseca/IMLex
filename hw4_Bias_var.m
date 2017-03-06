clear all
clc

datasets = 1000;
g = zeros(1,datasets);

x_d = -1+(1+1)*rand(2,datasets);
y = sin(pi*x_d);

%plot(x,y), axis([-1 1 -1 1]), grid on

for i=1:datasets
    Xcross = pinv(x_d(:,i));
    g(i) = Xcross*y(:,i);
end

%best lin. approx. is 0.9549

g_bar = mean(g); %answer 4

test_id = 10000;
test_s = -1+(1+1)*rand(1,test_id);
Ex_b = zeros(1,datasets);

for i=1:test_id
    Ex_b(i) = (g_bar*test_s(i) - sin(pi*test_s(i)))^2;
end

bias = mean(Ex_b); %answer 5

Ex_v = zeros(datasets,test_id);
Edx_v = zeros(1,datasets);

for i=1:datasets
    for j=1:test_id
        Ex_v(i,j) = (g(i)*test_s(j) - g_bar*test_s(j))^2;
    end
    Edx_v(i) = mean(Ex_v(i,:));
end

var = mean(Edx_v); %answer 6
