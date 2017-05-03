clear; clc;

iter = 1000;
itcount = zeros(iter,1);
wtarg = zeros(3,iter);
w = zeros(3,iter);

for i=1:iter
    % creating datasets
    N = 100;
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
%     datapos = [];
%     dataneg = [];
    
    for j=1:N
        tresy = polyval(targcoef,x_1(j,1));
        if x_2(j,1)>tresy
            y(j,1) = 1;
%             datapos = [datapos; dataset(j,:)];
        else
            y(j,1) = -1;
%             dataneg = [dataneg; dataset(j,:)];
        end
    end
    
%     plot(datapos(:,1),datapos(:,2),'*','Color','b')
%     xlim([-1 1])
%     ylim([-1 1])
%     hold on
%     plot(dataneg(:,1),dataneg(:,2),'*','Color','r')
%     plot(x1_targ,x2_targ)
    
    miscset = (1:N);
    
    while size(miscset,2)>=1
        itcount(i,1) = itcount(i,1)+1;
        
        % randomly choose a missclassified point and try to correct it
        misclabel = datasample(miscset,1);
        xcor = X(misclabel,:)';
        w(:,i) = w(:,i) + y(misclabel,1)*xcor;
        
        % re-verify missclassified set
        miscset = [];
        
        for j=1:N
            xver = X(j,:)';
            
            if sign(w(:,i)'*xver) ~= y(j,1)
                miscset = [miscset j];
            end
        end
    end
    
%     % plotting chosen hypothesis
%     hypcoef = [-w(2,i)/w(3,i) -w(1,i)/w(3,i)];
%     x2 = linspace(-1,1);
%     y2 = polyval(hypcoef,x2);
%     
%     plot(x2,y2,'Color','r')
%     hold off
    
end

Eout = zeros(iter,1);

for i = 1:iter
    N2 = 1000;
    x_02 = ones(N2,1);
    x_12 = -1+(1+1)*rand(N2,1);
    x_22 = -1+(1+1)*rand(N2,1);
    
    X2 = [x_02 x_12 x_22];
    
    for j=1:N2
        if sign(w(:,i)'*X2(j,:)') ~= sign(wtarg(:,i)'*X2(j,:)')
            Eout(i) = Eout(i)+1;
        end
    end
    
    Eout(i) = Eout(i)/N2;
end

answer1 = mean(itcount)
answer2 = mean(Eout)
