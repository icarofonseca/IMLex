clear; clc;

iter = 500;
iter_succ = 0;
K = 9;
gamma = 1.5;
not_sep = zeros(iter,1);
w = zeros(K,iter);

E_in_svm = zeros(iter,1);
E_out_svm = zeros(iter,1);
E_in_rbf = zeros(iter,1);
E_out_rbf = zeros(iter,1);
svm_wins = zeros(iter,1);

for i=1:iter
    % creating datasets
    N = 100;
    x_1 = -1+(1+1)*rand(N,1);
    x_2 = -1+(1+1)*rand(N,1);
    
    % data set and corresponding labels
    X = [x_1 x_2];
    y = sign(x_2-x_1+0.25*sin(pi*x_1));
    
    % libsvm command
    svm_model = svmtrain(y, X, '-t 2 -g 1.5 -c 1e+10 -q');
    [~, accuracy, ~] = svmpredict(y, X, svm_model);
    E_in_svm(i) = (100 - accuracy(1))/100;
    
    % if the data set is not separable, abort iteration
    if E_in_svm > 0
        not_sep(i)=1;
        E_out_svm(i) = NaN;
        E_in_rbf(i) = NaN;
        E_out_rbf(i) = NaN;
        w(:,i) = NaN;
        svm_wins(i) = NaN;
		continue
    end
    
    mi_k = [-1+(1+1)*rand(K,1) -1+(1+1)*rand(K,1)];
    S_k_prev = [];
    S_k = cell(K,1);
    S_k{1} = 1:N;
    
    while isequal(S_k_prev, S_k)==0
        S_k_prev = S_k;
        S_k = cell(K,1);
        
        % assigning points to clusters
        for j=1:N
            dist_min = Inf;
            for k=1:K
                dist_clus = norm(X(j,:)-mi_k(k,:));
                if dist_clus < dist_min
                    clus_push = k;
                    dist_min = dist_clus;
                end
            end
            S_k{clus_push} = [S_k{clus_push} j];
        end
        
        % verifying for empty clusters
        empty_clus = 0;
        
        for j=1:K
            if size(S_k{j},1)==0
                empty_clus=1;
                continue
            end
        end

        % if there is an empty cluster, abort iteration
        if empty_clus
            continue
        end
        
        % updating cluster centers
        for j=1:K
            mi_k(j,:)=0;
            for k=1:size(S_k{j},2)
                xlabel=S_k{j}(k);
                mi_k(j,:)=mi_k(j,:)+X(xlabel,:);
            end
            mi_k(j,:)=mi_k(j,:)/size(S_k{j},2);
        end
    end
    
    % if there is an empty cluster, abort iteration
    if empty_clus
        E_out_svm(i) = NaN;
        E_in_rbf(i) = NaN;
        E_out_rbf(i) = NaN;
        w(:,i) = NaN;
        svm_wins(i) = NaN;
        continue
    end
    
    phi = zeros(N,K);
    for j=1:N
        for k=1:K
            phi(j,k)=exp(-gamma*(norm(X(j,:)-mi_k(k,:))^2));
        end
    end
    
    phi_cross = pinv(phi);
    w(:,i) = phi_cross*y;
    
    % evaluating E_in
    E_in_rbf(i) = class_err(phi,w(:,i),y);
    
    % evaluating E_out
    N2 = 1000;
    x_12 = -1+(1+1)*rand(N2,1);
    x_22 = -1+(1+1)*rand(N2,1);
    
    X2 = [x_12 x_22];
    y2 = sign(x_22-x_12+0.25*sin(pi*x_12));
    
    [~, accuracy2, ~] = svmpredict(y2, X2, svm_model);
    E_out_svm(i) = (100 - accuracy2(1))/100;
    
    phi2 = zeros(N,K);
    for j=1:N2
        for k=1:K
            phi2(j,k)=exp(-gamma*(norm(X2(j,:)-mi_k(k,:))^2));
        end
    end
    
    E_out_rbf(i) = class_err(phi2,w(:,i),y2);
    
    if E_out_rbf(i)>E_out_svm(i)
        svm_wins(i) = 1;
    end
    
    iter_succ=iter_succ+1;
end

% answer13 = 100*sum(not_sep)/iter
% answer14 = 100*sum(svm_wins(~isnan(svm_wins)))/iter_succ
% 
% mean(E_in_rbf(~isnan(E_in_rbf)))
% mean(E_out_rbf(~isnan(E_out_rbf)))

ein_null = size(E_in_rbf(E_in_rbf==0),1);
100*(ein_null/size(E_in_rbf,1))
