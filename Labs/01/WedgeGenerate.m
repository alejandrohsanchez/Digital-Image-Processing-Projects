close all;
clear all;
%{
Creating greyscale image
https://www.mathworks.com/matlabcentral/answers/108006-how-to-create-a-gray-scale-image

Remainder
https://www.mathworks.com/help/matlab/ref/rem.html

Ones matrix generation
https://www.mathworks.com/help/matlab/ref/ones.html

Accessing specific column range in an array
https://www.mathworks.com/matlabcentral/answers/333727-specific-column-range-from-an-array

Determining sum of elements in a matrix
https://www.mathworks.com/help/matlab/ref/sum.html

Using fprintf
https://www.mathworks.com/help/matlab/ref/fprintf.html

Rounding values in MATLAB
https://www.mathworks.com/help/matlab/ref/round.html

Accessing the size of an array in MATLAB
https://www.mathworks.com/help/matlab/ref/size.html

%}

%{
Write a test script that generates a test pattern image consisting of
a grey scale "wedge" of size 256x256, whose first row is all 0, the next
row is all 1, and so on, with the last row being 255.
%}

A = halftone(imread("Fig0225(a)(face).tif"));
%figure()
%imshow(A);

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

%figure()
%D = uint8(C);
%imshow(D);

function A = halftone(image)
    A = uint8(image);
    % Number of pixel rows and columns in the image
    rows = size(A,1);
    cols = size(A,2);
    
    for row_idx = 1:3:cols
        for col_idx = 1:3:rows
            PXL_SUM = sum(sum(A(row_idx:row_idx+2,col_idx:col_idx+2)));
%            fprintf("A(%.f:%.f,%.f:%.f) => %.f   |   ", row_idx, row_idx+2, col_idx, col_idx+2, PXL_SUM);
            if (col_idx+3>=rows)
                break;
            end
        end
        if (row_idx+3>=cols)
            break;
        end
    end
    dot9 = [0 0 0; 0 0 0; 0 0 0];
    dot8 = [0 0 0; 0 255 0; 0 0 0];
    dot7 = [0 0 0; 255 255 0; 0 0 0];
    dot6 = [0 0 0; 255 255 0; 0 255 0];
    dot5 = [0 0 0; 255 255 255; 0 255 0];
    dot4 = [0 0 255; 255 255 255; 0 255 0];
    dot3 = [0 0 255; 255 255 255; 255 255 0];
    dot2 = [255 0 255; 255 255 255; 255 255 0];
    dot1 = [255 0 255; 255 255 255; 255 255 255];
    dot0 = [255 255 255; 255 255 255; 255 255 255];
end