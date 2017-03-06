clear
clc

iter = 1;
itcount=zeros(iter,1);
disprob=zeros(iter,1);

for i=1:iter
    % creating datasets
    dsize = 10;
    y = -1+(1+1)*rand(dsize,1);
    x = -1+(1+1)*rand(dsize,1);
    dataset = [x y];
    
    % creating points to define target line
    targxs = -1+(1+1)*rand(2,1);
    targys = -1+(1+1)*rand(2,1);
    
    % creating target function
    targcoef = polyfit(targxs,targys,1);
    x1 = linspace(-1,1);
    y1 = polyval(targcoef,x1);
    
    % mapping point according to target function
    ftarg=zeros(dsize,1);
%     datapos = [];
%     dataneg = [];
    
    for j=1:dsize
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
    
    wi = zeros(3,1);
    miscset = (1:dsize);
    
    while size(miscset,2)>=1
        itcount(i,1) = itcount(i,1)+1;
        
        % randomly choose a missclassified point and try to correct it
        misclabel = datasample(miscset,1);
        xcor = [1; dataset(misclabel,1); dataset(misclabel,2)];
        wi = wi + ftarg(misclabel,1)*xcor;
        
        % re-verify missclassified set
        miscset = [];
        
        for j=1:dsize
            xver = [1; dataset(j,1); dataset(j,2)];
            
            if sign(dot(wi,xver)) ~= ftarg(j,1)
                miscset = [miscset j];
            end
        end
    end
    
%     % missing: evaluate area difference with integral for rectangular 
%     % booundaries and in case the lines cross inside the domain
%     
%     % calculating area difference between target function and chosen
%     % hypothesis
%     polarea1 = polyint(targcoef);
%     area1 = polyval(polarea1,1) - polyval(polarea1,-1);
%     
%     hypcoef = [-wi(2)/wi(3) -wi(1)/wi(3)];
%     polarea2 = polyint(hypcoef);
%     area2 = polyval(polarea2,1) - polyval(polarea2,-1);
%     
%     targcoef
%     hypcoef
%     
% %     area1
% %     area2
%     
%     areadiff = abs(area1-area2)
%     disprob = areadiff/4;
%     
%     % plotting chosen hypothesis
%     x2 = linspace(-1,1);
%     y2 = polyval(hypcoef,x2);
%     
%     plot(x2,y2,'Color','r')
%     hold off
    
end

answer1 = mean(itcount);
answer2 = mean(disprob);
