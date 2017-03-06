clear
clc

iter = 1000;
wtarg = zeros(6,iter);
w = zeros(6,iter);
Eout = zeros(iter,1);

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
    
    % creating verification dataset
    dsize2 = 1000;
    x_02 = ones(dsize2,1);
    x_12 = -1+(1+1)*rand(dsize2,1);
    x_22 = -1+(1+1)*rand(dsize2,1);
    
    X2 = [x_02 x_12 x_22 x_12.*x_22 x_12.*x_12 x_22.*x_22];
    
    % define function results
    y2=zeros(dsize2,1);
    
    noise_lab = datasample(1:dsize2,0.1*dsize2,'Replace',false);
            
    for j=1:dsize2
        y2(j) = sign(x_12(j)^2+x_22(j)^2-0.6);
        
        for k=1:size(noise_lab,2)
            y2(noise_lab(k)) = -y2(noise_lab(k));
        end
    end
    
    for j=1:dsize2
        if sign(dot(w(:,i)',X2(j,:))) ~= y2(j)
            Eout(i,1) = Eout(i,1)+1;
        end
    end
    
    Eout(i,1) = Eout(i,1)/dsize;
end

answer = mean(Eout)
