clear
clc

% read data set
fileID = fopen('in.dta','r');
[in_dta,count] = fscanf(fileID,'%f %f %f',[3 Inf]);
fclose(fileID);

in_dta = in_dta';
count = count/3;

in_set = in_dta(:,1:2);

phi_0_in = ones(count,1);
phi_1_in = in_set(:,1);
phi_2_in = in_set(:,2);
phi_3_in = in_set(:,1).^2;
phi_4_in = in_set(:,2).^2;
phi_5_in = in_set(:,1).*in_set(:,2);
phi_6_in = abs(in_set(:,1)-in_set(:,2));
phi_7_in = abs(in_set(:,1)+in_set(:,2));

nltransf_in = [phi_0_in phi_1_in phi_2_in phi_3_in phi_4_in phi_5_in...
    phi_6_in phi_7_in];

phi_in = nltransf_in;
y_in = in_dta(:,3);

phi_cross = pinv(phi_in);
w = phi_cross*y_in;

E_in = 0;

for i=1:count
    if sign(dot(w,phi_in(i,:))) ~= y_in(i)
        E_in = E_in+1;
    end
end

E_in = E_in/count

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

nltransf_out = [phi_0_out phi_1_out phi_2_out phi_3_out phi_4_out...
    phi_5_out phi_6_out phi_7_out];

E_out = 0;

for i=1:count1
    if sign(dot(w,nltransf_out(i,:))) ~= y_out(i)
        E_out = E_out+1;
    end
end

E_out = E_out/count1
