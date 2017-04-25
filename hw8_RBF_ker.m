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

E_in = zeros(1, 5);
E_out = zeros(1, 5);

model_1 = svmtrain(y_train, X_train, '-t 2 -g 1 -c 0.01 -q');
model_2 = svmtrain(y_train, X_train, '-t 2 -g 1 -c 1 -q');
model_3 = svmtrain(y_train, X_train, '-t 2 -g 1 -c 100 -q');
model_4 = svmtrain(y_train, X_train, '-t 2 -g 1 -c 10000 -q');
model_5 = svmtrain(y_train, X_train, '-t 2 -g 1 -c 1000000 -q');

[predicted_labels1, accuracy1, ~] = svmpredict(y_train, X_train, model_1);
[predicted_labels2, accuracy2, ~] = svmpredict(y_train, X_train, model_2);
[predicted_labels3, accuracy3, ~] = svmpredict(y_train, X_train, model_3);
[predicted_labels4, accuracy4, ~] = svmpredict(y_train, X_train, model_4);
[predicted_labels5, accuracy5, ~] = svmpredict(y_train, X_train, model_5);

E_in(1) = 100 - accuracy1(1);
E_in(2) = 100 - accuracy2(1);
E_in(3) = 100 - accuracy3(1);
E_in(4) = 100 - accuracy4(1);
E_in(5) = 100 - accuracy5(1);

E_in

[predicted_labels6, accuracy6, ~] = svmpredict(y_test, X_test, model_1);
[predicted_labels7, accuracy7, ~] = svmpredict(y_test, X_test, model_2);
[predicted_labels8, accuracy8, ~] = svmpredict(y_test, X_test, model_3);
[predicted_labels9, accuracy9, ~] = svmpredict(y_test, X_test, model_4);
[predicted_labels10, accuracy10, ~] = svmpredict(y_test, X_test, model_5);

E_out(1) = 100 - accuracy6(1);
E_out(2) = 100 - accuracy7(1);
E_out(3) = 100 - accuracy8(1);
E_out(4) = 100 - accuracy9(1);
E_out(5) = 100 - accuracy10(1);

E_out
