clear
clc

ref_dig = 1; %vs all

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
X_train = feat_train(:,2:3);

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
X_test = feat_test(:,2:3);

model = svmtrain(y_train, X_train, '-t 1 -d 2 -g 1 -r 1 -c 0.01');

[predicted_labels, accuracy, ~] = svmpredict(y_train, X_train, model);

E_in = 100 - accuracy(1)
