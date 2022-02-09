clear all;

A = 5;
M = 10000000;

f = zeros(M,1);

tic

for x=1:M
    f(x) = A * sin((x-1)/(2*pi));
end

toc