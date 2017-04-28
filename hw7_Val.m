clear
clc

tra_st = 26;
tra_en = 35;
val_st = 1;
val_en = 25;

% read data set
fileID = fopen('in.dta','r');
[in_dta,count] = fscanf(fileID,'%f %f %f',[3 Inf]);
fclose(fileID);

in_dta = in_dta';
count = count/3;

in_set = in_dta(:,1:2);
in_y = in_dta(:,3);

phi_0 = ones(count,1);
phi_1 = in_set(:,1);
phi_2 = in_set(:,2);
phi_3 = in_set(:,1).^2;
phi_4 = in_set(:,2).^2;
phi_5 = in_set(:,1).*in_set(:,2);
phi_6 = abs(in_set(:,1)-in_set(:,2));
phi_7 = abs(in_set(:,1)+in_set(:,2));

model_k3 = [phi_0 phi_1 phi_2 phi_3];
model_k4 = [phi_0 phi_1 phi_2 phi_3 phi_4];
model_k5 = [phi_0 phi_1 phi_2 phi_3 phi_4 phi_5];
model_k6 = [phi_0 phi_1 phi_2 phi_3 phi_4 phi_5 phi_6];
model_k7 = [phi_0 phi_1 phi_2 phi_3 phi_4 phi_5 phi_6 phi_7];

%create training and validation sets
k3_tra = model_k3(tra_st:tra_en,:);
k4_tra = model_k4(tra_st:tra_en,:);
k5_tra = model_k5(tra_st:tra_en,:);
k6_tra = model_k6(tra_st:tra_en,:);
k7_tra = model_k7(tra_st:tra_en,:);
y_tra = in_y(tra_st:tra_en);

k3_val = model_k3(val_st:val_en,:);
k4_val = model_k4(val_st:val_en,:);
k5_val = model_k5(val_st:val_en,:);
k6_val = model_k6(val_st:val_en,:);
k7_val = model_k7(val_st:val_en,:);
y_val = in_y(val_st:val_en);

k3_tra_cross = pinv(k3_tra);
w3 = k3_tra_cross*y_tra;

k4_tra_cross = pinv(k4_tra);
w4 = k4_tra_cross*y_tra;

k5_tra_cross = pinv(k5_tra);
w5 = k5_tra_cross*y_tra;

k6_tra_cross = pinv(k6_tra);
w6 = k6_tra_cross*y_tra;

k7_tra_cross = pinv(k7_tra);
w7 = k7_tra_cross*y_tra;

E3_val = 0;
E4_val = 0;
E5_val = 0;
E6_val = 0;
E7_val = 0;

for i=1:(val_en-val_st+1)
    if sign(dot(w3,k3_val(i,:))) ~= y_val(i)
        E3_val = E3_val+1;
    end
    if sign(dot(w4,k4_val(i,:))) ~= y_val(i)
        E4_val = E4_val+1;
    end
    if sign(dot(w5,k5_val(i,:))) ~= y_val(i)
        E5_val = E5_val+1;
    end
    if sign(dot(w6,k6_val(i,:))) ~= y_val(i)
        E6_val = E6_val+1;
    end
    if sign(dot(w7,k7_val(i,:))) ~= y_val(i)
        E7_val = E7_val+1;
    end
end

E3_val = E3_val/(val_en-val_st+1);
E4_val = E4_val/(val_en-val_st+1);
E5_val = E5_val/(val_en-val_st+1);
E6_val = E6_val/(val_en-val_st+1);
E7_val = E7_val/(val_en-val_st+1);

% read out of sample
fileID = fopen('out.dta','r');
[out_dta,count1] = fscanf(fileID,'%f %f %f',[3 Inf]);
fclose(fileID);

out_dta = out_dta';
count1 = count1/3;

out_set = out_dta(:,1:2);
y_out = out_dta(:,3);

phi_0_out = ones(count1,1);
phi_1_out = out_set(:,1);
phi_2_out = out_set(:,2);
phi_3_out = out_set(:,1).^2;
phi_4_out = out_set(:,2).^2;
phi_5_out = out_set(:,1).*out_set(:,2);
phi_6_out = abs(out_set(:,1)-out_set(:,2));
phi_7_out = abs(out_set(:,1)+out_set(:,2));

k3_out = [phi_0_out phi_1_out phi_2_out phi_3_out];
k4_out = [phi_0_out phi_1_out phi_2_out phi_3_out phi_4_out];
k5_out = [phi_0_out phi_1_out phi_2_out phi_3_out phi_4_out phi_5_out];
k6_out = [phi_0_out phi_1_out phi_2_out phi_3_out phi_4_out phi_5_out phi_6_out];
k7_out = [phi_0_out phi_1_out phi_2_out phi_3_out phi_4_out phi_5_out phi_6_out phi_7_out];

E3_out = 0;
E4_out = 0;
E5_out = 0;
E6_out = 0;
E7_out = 0;

for i=1:count1
    if sign(dot(w3,k3_out(i,:))) ~= y_out(i)
        E3_out = E3_out+1;
    end
    if sign(dot(w4,k4_out(i,:))) ~= y_out(i)
        E4_out = E4_out+1;
    end
    if sign(dot(w5,k5_out(i,:))) ~= y_out(i)
        E5_out = E5_out+1;
    end
    if sign(dot(w6,k6_out(i,:))) ~= y_out(i)
        E6_out = E6_out+1;
    end
    if sign(dot(w7,k7_out(i,:))) ~= y_out(i)
        E7_out = E7_out+1;
    end
end

E3_out = E3_out/count1
E4_out = E4_out/count1
E5_out = E5_out/count1
E6_out = E6_out/count1
E7_out = E7_out/count1
