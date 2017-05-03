clear; clc;

iter = 1;
w_pla = zeros(3,iter);
w_svm = zeros(3,iter);
wtarg = zeros(3,iter);
sv_no = zeros(1,iter);

for i=1:iter
    % creating datasets
    N = 100;
    
    side1 = 0;
    side2 = 0;
    
    while side1==0||side2==0
        
        x_0 = ones(N,1);
        x_1 = -1+(1+1)*rand(N,1);
        x_2 = -1+(1+1)*rand(N,1);
        
        dataset = [x_1 x_2];
        X = [x_0 x_1 x_2];
        
        % creating points to define target line
        targxs = -1+(1+1)*rand(2,1);
        targys = -1+(1+1)*rand(2,1);
        
        % creating target function
        targcoef = polyfit(targxs,targys,1);
        x1_targ = linspace(-1,1);
        x2_targ = polyval(targcoef,x1_targ);
        wtarg(:,i) = [-targcoef(2); -targcoef(1); 1];
        
        % mapping point according to target function
        y=zeros(N,1);
%         datapos = [];
%         dataneg = [];
        
        for j=1:N
            tresy = polyval(targcoef,x_1(j,1));
            if x_2(j,1)>tresy
                y(j,1) = 1;
%                   datapos = [datapos; dataset(j,:)];
                 side1 = 1;
            else
                y(j,1) = -1;
%                  dataneg = [dataneg; dataset(j,:)];
                 side2 = 1;
            end
        end
        
        % verify if there is at least one point in each side of the line
        if side1==0||side2==0
            side1 = 0;
            side2 = 0;
        end
    end
    
%     plot(datapos(:,1),datapos(:,2),'*','Color','b')
%     xlim([-1 1])
%     ylim([-1 1])
%     hold on
%     plot(dataneg(:,1),dataneg(:,2),'*','Color','r')
%     plot(x1_targ,x2_targ)
    
    wi = zeros(3,1);
    miscset = (1:N);
    
    while size(miscset,2)>=1
        % randomly choose a missclassified point and try to correct it
        misclabel = datasample(miscset,1);
        xcor = X(misclabel,:)';
        wi = wi + y(misclabel,1)*xcor;
        
        % re-verify missclassified set
        miscset = [];
        
        for j=1:N
            xver = X(j,:)';
            
            if sign(dot(wi,xver)) ~= y(j,1)
                miscset = [miscset j];
            end
        end
    end
    
    w_pla(:,i) = wi;
    
    Xsvm = [x_1 x_2];
    %matlab command
    svmStruct = svmtrain(Xsvm,y,'boxconstraint',Inf,'method','QP',...
        'ShowPlot',false,'autoscale','off');
    
    sv_no(i) = size(svmStruct.SupportVectors,1);
    
    svm(i) = svmStruct;
    
    for j=1:sv_no(i)
        w_svm(2:3,i) = w_svm(2:3,i) - svmStruct.Alpha(j)*...
            svmStruct.SupportVectors(j,:)';
    end
    
    w_svm(1,i) = - svmStruct.Bias;
    
%     1/y(svmStruct.SupportVectorIndices(1)) ...
%         - dot(w_svm(2:3,i)',svmStruct.SupportVectors(1,:))
end

Eout_pla = zeros(iter,1);
Eout_svm = zeros(iter,1);
svm_wins = zeros(iter,1);

for i = 1:iter
    N2 = 1000;
    x_02 = ones(N2,1);
    x_12 = -1+(1+1)*rand(N2,1);
    x_22 = -1+(1+1)*rand(N2,1);
    
    X2 = [x_02 x_12 x_22];
    
    for j=1:N2
        if sign(dot(w_pla(:,i)',X2(j,:))) ~= sign(dot(wtarg(:,i)',X2(j,:)))
            Eout_pla(i) = Eout_pla(i)+1;
        end
        if sign(dot(w_svm(:,i)',X2(j,:))) ~= sign(dot(wtarg(:,i)',X2(j,:)))
            Eout_svm(i) = Eout_svm(i)+1;
        end
    end
    
    if Eout_pla(i)>Eout_svm(i)
        svm_wins(i) = 1;
    end
end

answer1 = mean(svm_wins)*100
%answer2 = mean(sv_no)
