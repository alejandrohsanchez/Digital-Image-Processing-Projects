clear all;

M = [0 : 0.1 : 2*pi];

fprintf(1,'M has length %d\n', size(M,2) );

f = sin(M);

plot(f);            

figure;             % New figure

plot(M,f);