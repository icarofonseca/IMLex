clear all
clc

nex = 100000; % number of times to run the experiment
v1 = zeros(nex,1);
v_rand = zeros(nex,1);
v_min = zeros(nex,1);

for i = 1:nex
    results=randsrc(10,1000);
    
    % counting v1, vrand, vmin on each coin
    v1(i) = sum(results(:,1)==1)/10;
    
    c_rand = randi(1000);
    v_rand(i) = sum(results(:,c_rand)==1)/10;
    
    v_min(i) = 1;
    
    for j = 1:1000
        v_j = sum(results(:,j)==1)/10;
        
        if v_j < v_min(i)
            v_min(i) = v_j;
        end
        
        if v_min(i) == 0
            break
        end
    end
    
end

v1_avg = mean(v1)
v_rand_avg = mean(v_rand)
v_min_avg = mean(v_min)
