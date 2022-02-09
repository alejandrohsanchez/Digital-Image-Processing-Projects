clear all;

A = 5;
M = 10000000;
f = zeros(M,1);

tic

x = 0:M-1;
f = A * sin(x/(2*pi));

toc