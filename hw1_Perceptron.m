clear
clc

iter = 1000;
itcount = zeros(iter,1);
wtarg = zeros(3,iter);
w = zeros(3,iter);

for i=1:iter
    % creating datasets
    N = 100;
    y = -1+(1+1)*rand(N,1);
    x = -1+(1+1)*rand(N,1);
    dataset = [x y];
    
    % creating points to define target line
    targxs = -1+(1+1)*rand(2,1);
    targys = -1+(1+1)*rand(2,1);
    
    % creating target function
    targcoef = polyfit(targxs,targys,1);
    x1 = linspace(-1,1);
    y1 = polyval(targcoef,x1);
    wtarg(:,i) = [-targcoef(2); -targcoef(1); 1];
    
    % mapping point according to target function
    ftarg=zeros(N,1);
%     datapos = [];
%     dataneg = [];
    
    for j=1:N
        tresy = polyval(targcoef,x(j,1));
        if y(j,1)>tresy
            ftarg(j,1) = 1;
%              datapos = [datapos; dataset(j,:)];
        else
            ftarg(j,1) = -1;
%              dataneg = [dataneg; dataset(j,:)];
        end
    end
    
%     plot(datapos(:,1),datapos(:,2),'*','Color','b')
%     xlim([-1 1])
%     ylim([-1 1])
%     hold on
%     plot(dataneg(:,1),dataneg(:,2),'*','Color','r')
%     plot(x1,y1)
    
    miscset = (1:N);
    
    while size(miscset,2)>=1
        itcount(i,1) = itcount(i,1)+1;
        
        % randomly choose a missclassified point and try to correct it
        misclabel = datasample(miscset,1);
        xcor = [1; dataset(misclabel,1); dataset(misclabel,2)];
        w(:,i) = w(:,i) + ftarg(misclabel,1)*xcor;
        
        % re-verify missclassified set
        miscset = [];
        
        for j=1:N
            xver = [1; dataset(j,1); dataset(j,2)];
            
            if sign(w(:,i)'*xver) ~= ftarg(j,1)
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
    dsize2 = 1000;
    x_02 = ones(dsize2,1);
    x_12 = -1+(1+1)*rand(dsize2,1);
    x_22 = -1+(1+1)*rand(dsize2,1);
    
    X2 = [x_02 x_12 x_22];
    
    for j=1:dsize2
        if sign(w(:,i)'*X2(j,:)') ~= sign(wtarg(:,i)'*X2(j,:)')
            Eout(i) = Eout(i)+1;
        end
    end
    
    Eout(i) = Eout(i)/dsize2;
end

answer1 = mean(itcount)
answer2 = mean(Eout)
