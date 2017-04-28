clear; clc;

ref_dig = 8; %vs all
lambda = 1;

% reading training set
fileID = fopen('features.train.txt','r');
[feat_train] = fscanf(fileID,'%f %f %f',[3 Inf]);
fclose(fileID);

feat_train = feat_train';

for i=1:size(feat_train,1)
    if feat_train(i,1) == ref_dig
        feat_train(i,4) = 1;
    else
        feat_train(i,4) = -1;
    end
end

y_train = feat_train(:,4);
x0_train = ones(size(feat_train,1),1);
X_train = [x0_train feat_train(:,2:3)];

X_sol = (X_train'*X_train+lambda*eye(3))\X_train';
w = X_sol*y_train;

E_in = 0;

for i=1:size(X_train,1)
    if sign(w'*X_train(i,:)') ~= y_train(i)
        E_in = E_in+1/size(X_train,1);
    end
end

E_in

% reading test set
fileID = fopen('features.test.txt','r');
[feat_test] = fscanf(fileID,'%f %f %f',[3 Inf]);
fclose(fileID);

feat_test = feat_test';

for i=1:size(feat_test,1)
    if feat_test(i,1) == ref_dig
        feat_test(i,4) = 1;
    else
        feat_test(i,4) = -1;
    end
end

y_test = feat_test(:,4);
x0_test = ones(size(feat_test,1),1);
X_test = [x0_test feat_test(:,2:3)];

E_out = 0;

for i=1:size(X_test,1)
    if sign(w'*X_test(i,:)') ~= y_test(i)
        E_out = E_out+1/size(X_test,1);
    end
end

E_out
