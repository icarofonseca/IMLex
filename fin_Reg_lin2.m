clear; clc;

lambda = 1;
E_in = zeros(10,1);
E_out = zeros(10,1);

% reading training set
fileID = fopen('features.train.txt','r');
[feat_train] = fscanf(fileID,'%f %f %f',[3 Inf]);
fclose(fileID);

feat_train = feat_train';

% reading test set
fileID = fopen('features.test.txt','r');
[feat_test] = fscanf(fileID,'%f %f %f',[3 Inf]);
fclose(fileID);

feat_test = feat_test';

for i=1:10
    
    ref_dig = i-1; %vs all
    
    for j=1:size(feat_train,1)
        if feat_train(j,1) == ref_dig
            feat_train(j,4) = 1;
        else
            feat_train(j,4) = -1;
        end
    end

    y_train = feat_train(:,4);
    x0_train = ones(size(feat_train,1),1);
    Z_train = [x0_train feat_train(:,2) feat_train(:,3)...
        feat_train(:,2).*feat_train(:,3) feat_train(:,2).^2 feat_train(:,3).^2];

    Z_sol = (Z_train'*Z_train+lambda*eye(6))\Z_train';
    w = Z_sol*y_train;
    
    E_in(i) = class_err(Z_train,w,y_train);
    
    for j=1:size(feat_test,1)
        if feat_test(j,1) == ref_dig
            feat_test(j,4) = 1;
        else
            feat_test(j,4) = -1;
        end
    end

    y_test = feat_test(:,4);
    x0_test = ones(size(feat_test,1),1);
    Z_test = [x0_test feat_test(:,2) feat_test(:,3)...
        feat_test(:,2).*feat_test(:,3) feat_test(:,2).^2 feat_test(:,3).^2];
    
    E_out(i) = class_err(Z_test,w,y_test);
    
end

E_in
E_out
