close all;
clear all;
%{
Creating greyscale image
https://www.mathworks.com/matlabcentral/answers/108006-how-to-create-a-gray-scale-image

Remainder
https://www.mathworks.com/help/matlab/ref/rem.html

Ones matrix generation
https://www.mathworks.com/help/matlab/ref/ones.html

%}

%{
Write a test script that generates a test pattern image consisting of
a grey scale "wedge" of size 256x256, whose first row is all 0, the next
row is all 1, and so on, with the last row being 255.
%}

A = halftone(imread("Fig0225(a)(face).tif"));
figure()
imshow(A);

C = zeros(256,256);

% i is row, j is column
val = 256;
for i = 1:256
    for j = 1:256
        C(i,j) = val;
    end
    if (rem(i,32) == 0)
        val = val - 32;
    end
end

figure()
D = uint8(C);
imshow(D);

function A = halftone(image)
    A = uint8(image);
    dot9 = [0 0 0; 0 0 0; 0 0 0];
    dot8 = [0 0 0; 0 1 0; 0 0 0];
    dot7 = [0 0 0; 1 1 0; 0 0 0];
    dot6 = [0 0 0; 1 1 0; 0 1 0];
    dot5 = [0 0 0; 1 1 1; 0 1 0];
    dot4 = [0 0 1; 1 1 1; 0 1 0];
    dot3 = [0 0 1; 1 1 1; 1 1 0];
    dot2 = [1 0 1; 1 1 1; 1 1 0];
    dot1 = [1 0 1; 1 1 1; 1 1 1];
    dot0 = [1 1 1; 1 1 1; 1 1 1];
end