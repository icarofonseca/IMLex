clear; clc; close all;

x_pos = [-1 0; 0 2; 0 -2; -2 0];
x_neg = [1 0; 0 1; 0 -1];

plot(x_pos(:,1),x_pos(:,2),'*','Color','b')
xlim([-2.5 2.5])
ylim([-2.5 2.5])
hold on
plot(x_neg(:,1),x_neg(:,2),'*','Color','r')

z_pos = [x_pos(:,2).^2-2*x_pos(:,1)-1 x_pos(:,1).^2-2*x_pos(:,2)+1];
z_neg = [x_neg(:,2).^2-2*x_neg(:,1)-1 x_neg(:,1).^2-2*x_neg(:,2)+1];

figure
plot(z_pos(:,1),z_pos(:,2),'*','Color','b')
xlim([-5.5 5.5])
ylim([-5.5 5.5])
hold on
plot(z_neg(:,1),z_neg(:,2),'*','Color','r')
