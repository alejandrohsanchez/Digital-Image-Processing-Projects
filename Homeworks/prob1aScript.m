x1 = 4; x2 = 4; x3 = 5; x4 = 5;
y1 = 10; y2 = 11; y3 = 10; y4 = 11;
p1 = 100; p2 = 107; p3 = 120; p4 = 130;

A = [x1 y1 x1*y1 1;
     x2 y2 x2*y2 1;
     x3 y3 x3*y3 1;
     x4 y4 x4*y4 1];
B = [p1; p2; p3; p4];

% Want to find: v(x5,y5)
x5 = 4.3; y5 = 10.4;

X = linsolve(A,B);
fprintf("a = %.4f\nb = %.4f\nc = %.4f\nd = %.4f\n", X(1,1), X(2,1), X(3,1), X(4,1))
p5 = X(1,1)*x5 + X(2,1)*y5 + X(3,1)*(x5*y5) + X(4,1);

% Value of p5
fprintf("Value of p5 is %f\n", p5);