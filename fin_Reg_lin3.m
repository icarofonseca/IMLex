clear; clc;

ref_dig = 1;
vs_dig = 5;
lambda = 1;

% reading training set
fileID = fopen('features.train.txt','r');
[scan_train] = fscanf(fileID,'%f %f %f',[3 Inf]);
fclose(fileID);

scan_train = scan_train';
feat_train = [];

for i=1:size(scan_train,1)
    if scan_train(i,1) == ref_dig
        feat_train = [feat_train; scan_train(i,:) 1];
    elseif scan_train(i,1) == vs_dig
        feat_train = [feat_train; scan_train(i,:) -1];
    end
end

y_train = feat_train(:,4);
x0_train = ones(size(feat_train,1),1);
Z_train = [x0_train feat_train(:,2) feat_train(:,3)...
    feat_train(:,2).*feat_train(:,3) feat_train(:,2).^2 feat_train(:,3).^2];

Z_sol = (Z_train'*Z_train+lambda*eye(6))\Z_train';
w = Z_sol*y_train;

E_in = class_err(Z_train,w,y_train);
E_in

% reading test set
fileID = fopen('features.test.txt','r');
[scan_test] = fscanf(fileID,'%f %f %f',[3 Inf]);
fclose(fileID);

scan_test = scan_test';
feat_test = [];

for i=1:size(scan_test,1)
    if scan_test(i,1) == ref_dig
        feat_test = [feat_test; scan_test(i,:) 1];
    elseif scan_test(i,1) == vs_dig
        feat_test = [feat_test; scan_test(i,:) -1];
    end
end

y_test = feat_test(:,4);
x0_test = ones(size(feat_test,1),1);
Z_test = [x0_test feat_test(:,2) feat_test(:,3)...
    feat_test(:,2).*feat_test(:,3) feat_test(:,2).^2 feat_test(:,3).^2];

E_out = class_err(Z_test,w,y_test);
E_out
