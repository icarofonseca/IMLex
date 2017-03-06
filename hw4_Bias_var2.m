clear all
clc

datasets = 1000;
g_a = zeros(1,datasets); %b
g_b = zeros(1,datasets); %ax
g_c = zeros(2,datasets); %ax+b
g_d = zeros(1,datasets); %ax^2
g_e = zeros(2,datasets); %ax^2+b

x_dat = -1+(1+1)*rand(2,datasets);
y = sin(pi*x_dat);

x_a = ones(2,datasets);
x_b = x_dat;
for i=1:datasets
    x_c{i} = [ones(2,1) x_dat(:,i)];
end
x_d = x_dat.^2;
for i=1:datasets
    x_e{i} = [ones(2,1) x_dat(:,i).^2];
end

for i=1:datasets
    Xcross_a = pinv(x_a(:,i));
    g_a(i) = Xcross_a*y(:,i);
    Xcross_b = pinv(x_b(:,i));
    g_b(i) = Xcross_b*y(:,i);
    Xcross_c = pinv(x_c{i});
    g_c(:,i) = Xcross_c*y(:,i);
    Xcross_d = pinv(x_d(:,i));
    g_d(i) = Xcross_d*y(:,i);
    Xcross_e = pinv(x_e{i});
    g_e(:,i) = Xcross_e*y(:,i);
end

g_bar_a = mean(g_a);
g_bar_b = mean(g_b);
g_bar_c(1,1) = mean(g_c(1,:));
g_bar_c(2,1) = mean(g_c(2,:));
g_bar_d = mean(g_d);
g_bar_e(1,1) = mean(g_e(1,:));
g_bar_e(2,1) = mean(g_e(2,:));

test_id = 10000;
test_s = -1+(1+1)*rand(1,test_id);

test_s_a = ones(1,test_id);
test_s_b = test_s;
for i=1:test_id
    test_s_c(i,:) = [1 test_s(i)];
end
test_s_d = test_s.^2;
for i=1:test_id
    test_s_e(i,:) = [1 test_s(i)^2];
end

Ex_b_a = zeros(1,datasets);
Ex_b_b = zeros(1,datasets);
Ex_b_c = zeros(1,datasets);
Ex_b_d = zeros(1,datasets);
Ex_b_e = zeros(1,datasets);

for i=1:test_id
    Ex_b_a(i) = (g_bar_a*test_s_a(i) - sin(pi*test_s(i)))^2;
    Ex_b_b(i) = (g_bar_b*test_s_b(i) - sin(pi*test_s(i)))^2;
    Ex_b_c(i) = (test_s_c(i,:)*g_bar_c - sin(pi*test_s(i)))^2;
    Ex_b_d(i) = (g_bar_d*test_s_d(i) - sin(pi*test_s(i)))^2;
    Ex_b_e(i) = (test_s_e(i,:)*g_bar_e - sin(pi*test_s(i)))^2;
end

bias_a = mean(Ex_b_a);
bias_b = mean(Ex_b_b);
bias_c = mean(Ex_b_c);
bias_d = mean(Ex_b_d);
bias_e = mean(Ex_b_e);

Ex_v_a = zeros(datasets,test_id);
Edx_v_a = zeros(1,datasets);
Ex_v_b = zeros(datasets,test_id);
Edx_v_b = zeros(1,datasets);
Ex_v_c = zeros(datasets,test_id);
Edx_v_c = zeros(1,datasets);
Ex_v_d = zeros(datasets,test_id);
Edx_v_d = zeros(1,datasets);
Ex_v_e = zeros(datasets,test_id);
Edx_v_e = zeros(1,datasets);

for i=1:datasets
    for j=1:test_id
        Ex_v_a(i,j) = (g_a(i)*test_s_a(j) - g_bar_a*test_s_a(j))^2;
        Ex_v_b(i,j) = (g_b(i)*test_s_b(j) - g_bar_b*test_s_b(j))^2;
        Ex_v_c(i,j) = (test_s_c(j,:)*g_c(:,i) - test_s_c(j,:)*g_bar_c)^2;
        Ex_v_d(i,j) = (g_d(i)*test_s_d(j) - g_bar_d*test_s_d(j))^2;
        Ex_v_e(i,j) = (test_s_e(j,:)*g_e(:,i) - test_s_e(j,:)*g_bar_e)^2;
    end
    Edx_v_a(i) = mean(Ex_v_a(i,:));
    Edx_v_b(i) = mean(Ex_v_b(i,:));
    Edx_v_c(i) = mean(Ex_v_c(i,:));
    Edx_v_d(i) = mean(Ex_v_d(i,:));
    Edx_v_e(i) = mean(Ex_v_e(i,:));
end

var_a = mean(Edx_v_a);
var_b = mean(Edx_v_b);
var_c = mean(Edx_v_c);
var_d = mean(Edx_v_d);
var_e = mean(Edx_v_e);

ans_a = bias_a + var_a
ans_b = bias_b + var_b
ans_c = bias_c + var_c
ans_d = bias_d + var_d
ans_e = bias_e + var_e
