clear all;

A = 5;
M = 5000000;

tic

for x=1:M
    f(x) = A * sin((x-1)/(2*pi));
end

toc