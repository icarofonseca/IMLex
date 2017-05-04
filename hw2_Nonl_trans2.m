clear
clc

iter = 1000;
wtarg = zeros(6,iter);
w = zeros(6,iter);
Ein = zeros(iter,5);

for i=1:iter
    % creating datasets
    dsize = 1000;
    x_0 = ones(dsize,1);
    x_1 = -1+(1+1)*rand(dsize,1);
    x_2 = -1+(1+1)*rand(dsize,1);
    
    dataset = [x_1 x_2];
    X = [x_0 x_1 x_2 x_1.*x_2 x_1.*x_1 x_2.*x_2];
    
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
    
    wa = [-1 -0.05 0.08 0.13 1.5 1.5];
    wb = [-1 -0.05 0.08 0.13 1.5 15];
    wc = [-1 -0.05 0.08 0.13 15 1.5];
    wd = [-1 -1.5 0.08 0.13 0.05 0.05];
    we = [-1 -0.05 0.08 1.5 0.15 0.15];
    
    
    for j=1:dsize
        if sign(dot(w(:,i)',X(j,:))) ~= sign(dot(wa,X(j,:)))
            Ein(i,1) = Ein(i,1)+1/dsize;
        end
        
        if sign(dot(w(:,i)',X(j,:))) ~= sign(dot(wb,X(j,:)))
            Ein(i,2) = Ein(i,2)+1/dsize;
        end
        
        if sign(dot(w(:,i)',X(j,:))) ~= sign(dot(wc,X(j,:)))
            Ein(i,3) = Ein(i,3)+1/dsize;
        end
        
        if sign(dot(w(:,i)',X(j,:))) ~= sign(dot(wd,X(j,:)))
            Ein(i,4) = Ein(i,4)+1/dsize;
        end
        
        if sign(dot(w(:,i)',X(j,:))) ~= sign(dot(we,X(j,:)))
            Ein(i,5) = Ein(i,5)+1/dsize;
        end
    end
end

Eina = mean(Ein(:,1))
Einb = mean(Ein(:,2))
Einc = mean(Ein(:,3))
Eind = mean(Ein(:,4))
Eine = mean(Ein(:,5))
