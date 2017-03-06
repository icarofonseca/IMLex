clear
clc

iter = 1000;
itcount=zeros(iter,1);
disprob=zeros(iter,1);
wtarg = zeros(3,iter);
w = zeros(3,iter);
Ein = zeros(iter,1);

for i=1:iter
    % creating datasets
    dsize = 100;
    x_0 = ones(dsize,1);
    x_1 = -1+(1+1)*rand(dsize,1);
    x_2 = -1+(1+1)*rand(dsize,1);
    
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
    y=zeros(dsize,1);
%     datapos = [];
%     dataneg = [];
    
    for j=1:dsize
        tresy = polyval(targcoef,x_1(j,1));
        if x_2(j,1)>tresy
            y(j,1) = 1;
%              datapos = [datapos; dataset(j,:)];
        else
            y(j,1) = -1;
%              dataneg = [dataneg; dataset(j,:)];
        end
    end
    
%     plot(datapos(:,1),datapos(:,2),'*','Color','b')
%     xlim([-1 1])
%     ylim([-1 1])
%     hold on
%     plot(dataneg(:,1),dataneg(:,2),'*','Color','r')
%     plot(x1_targ,x2_targ)
    
    Xcross = pinv(X);
    w(:,i) = Xcross*y;
    
%     hypcoef = [-w(2,i)/w(3,i) -w(1,i)/w(3,i)];
%     
%     % plotting chosen hypothesis
%     x2 = linspace(-1,1);
%     y2 = polyval(hypcoef,x2);
%     
%     plot(x2,y2,'Color','r')
%     hold off
    
    for j=1:dsize
        if sign(dot(w(:,i)',X(j,:))) ~= y(j,1)
            Ein(i,1) = Ein(i,1)+1;
        end
    end    
    
    Ein(i,1) = Ein(i,1)/100;
end

Eout = zeros(iter,1);

for i = 1:iter
    dsize2 = 1000;
    x_02 = ones(dsize2,1);
    x_12 = -1+(1+1)*rand(dsize2,1);
    x_22 = -1+(1+1)*rand(dsize2,1);
    
    X2 = [x_02 x_12 x_22];
    
    for j=1:dsize2
        if sign(dot(w(:,i)',X2(j,:))) ~= sign(dot(wtarg(:,i)',X2(j,:)))
            Eout(i,1) = Eout(i,1)+1;
        end
    end   
    
    Eout(i,1) = Eout(i,1)/1000;
end

answer1 = mean(Ein)
answer2 = mean(Eout)
