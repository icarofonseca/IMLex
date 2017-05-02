clear; clc;

x = [1 0; 0 1; 0 -1; -1 0; 0 2; 0 -2; -2 0];
y = [-1; -1; -1; 1; 1; 1; 1];

%libsvm command
model = svmtrain(y, x, '-t 1 -d 2 -g 1 -r 1 -c 1e+10');
