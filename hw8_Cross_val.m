clear; clc;

iter = 100;
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

Sel = zeros(iter, 5);
E_cv = zeros(iter, 5);

for i=1:iter
    index = randperm(size(y_train,1))';
    y_train = y_train(index);
    X_train = X_train(index,:);
    
    accuracy1 = svmtrain(y_train, X_train, '-t 1 -d 2 -g 1 -r 1 -c 0.0001 -v 10 -q');
    accuracy2 = svmtrain(y_train, X_train, '-t 1 -d 2 -g 1 -r 1 -c 0.001 -v 10 -q');
    accuracy3 = svmtrain(y_train, X_train, '-t 1 -d 2 -g 1 -r 1 -c 0.01 -v 10 -q');
    accuracy4 = svmtrain(y_train, X_train, '-t 1 -d 2 -g 1 -r 1 -c 0.1 -v 10 -q');
    accuracy5 = svmtrain(y_train, X_train, '-t 1 -d 2 -g 1 -r 1 -c 1 -v 10 -q');
    
    E_cv(i,1) = (100 - accuracy1(1))/100;
    E_cv(i,2) = (100 - accuracy2(1))/100;
    E_cv(i,3) = (100 - accuracy3(1))/100;
    E_cv(i,4) = (100 - accuracy4(1))/100;
    E_cv(i,5) = (100 - accuracy5(1))/100;
    
    E_ref = inf;
    
    for j=5:-1:1
        if E_cv(i,j)<=E_ref
            Sel(i,:)=0;
            Sel(i,j)=1;
            E_ref=E_cv(i,j);
        end
    end
end

a = sum(Sel(:,1))
b = sum(Sel(:,2))
c = sum(Sel(:,3))
d = sum(Sel(:,4))
e = sum(Sel(:,5))
