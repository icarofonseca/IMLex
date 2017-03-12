clear
clc

rho = (9 + 4*(6)^0.5)^0.5;

x = [-1; rho; 1];
y = [0; 1; 0];

E_cte = zeros(3,1);
E_lin = zeros(3,1);

%1st out
cte1 = mean(y(2:3));
E_cte(1) = (y(1)-cte1)^2;

targcoef1 = polyfit(x(2:3),y(2:3),1);
E_lin(1) = (y(1)-polyval(targcoef1,x(1)))^2;

%2nd out
cte2 = mean([y(1) y(3)]);
E_cte(2) = (y(2)-cte2)^2;

targcoef2 = polyfit([x(1),x(3)],[y(1),y(3)],1);
E_lin(2) = (y(2)-polyval(targcoef2,x(2)))^2;

%3rd out
cte3 = mean(y(1:2));
E_cte(3) = (y(3)-cte3)^2;

targcoef3 = polyfit(x(1:2),y(1:2),1);
E_lin(3) = (y(3)-polyval(targcoef3,x(3)))^2;

mean(E_cte)
mean(E_lin)