clear
clc

iter = 1000;
wtarg = zeros(3,iter);
w = zeros(3,iter);
Ein = zeros(iter,1);

for i=1:iter
    % creating datasets
    dsize = 1000;
    x_0 = ones(dsize,1);
    x_1 = -1+(1+1)*rand(dsize,1);
    x_2 = -1+(1+1)*rand(dsize,1);
    
    dataset = [x_1 x_2];
    X = [x_0 x_1 x_2];
    
    % define target function
    y=zeros(dsize,1);
    datapos = [];
    dataneg = [];
    
    noise_lab = datasample(1:dsize,0.1*dsize,'Replace',false);
            
    for j=1:dsize
        y(j) = sign(x_1(j)^2+x_2(j)^2-0.6);
        
        for k=1:size(noise_lab,2)
            y(noise_lab(k)) = -y(noise_lab(k));
        end
        
        if y(j) == 1
             datapos = [datapos; dataset(j,:)];
        else
             dataneg = [dataneg; dataset(j,:)];
        end
    end
    
%     plot(datapos(:,1),datapos(:,2),'*','Color','b')
%     xlim([-1 1])
%     ylim([-1 1])
%     hold on
%     plot(dataneg(:,1),dataneg(:,2),'*','Color','r')
% %     plot(x1_targ,x2_targ)
    
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
        if sign(dot(w(:,i)',X(j,:))) ~= y(j)
            Ein(i,1) = Ein(i,1)+1;
        end
    end    
    
    Ein(i,1) = Ein(i,1)/dsize;
end

answer1 = mean(Ein)
