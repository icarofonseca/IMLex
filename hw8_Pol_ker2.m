clear; clc;

ref_dig = 1;
vs_dig = 5;

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
X_train = feat_train(:,2:3);

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
X_test = feat_test(:,2:3);

model = svmtrain(y_train, X_train, '-t 1 -d 5 -g 1 -r 1 -c 0.0001');

[predicted_labels, accuracy2, ~] = svmpredict(y_test, X_test, model);

E_out = 100 - accuracy2(1)

[predicted_labels, accuracy1, ~] = svmpredict(y_train, X_train, model);

E_in = 100 - accuracy1(1)
