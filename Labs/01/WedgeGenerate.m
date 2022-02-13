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

Taking a mean of all elements in an array
https://www.mathworks.com/help/matlab/ref/mean.html

Calculating remainder
https://www.mathworks.com/help/matlab/ref/rem.html
%}

A = halftone(imread("Fig0225(a)(face).tif"));
figure()
imshow(A);

%{
Write a test script that generates a test pattern image consisting of
a grey scale "wedge" of size 256x256, whose first row is all 0, the next
row is all 1, and so on, with the last row being 255.
%}

B = zeros(256,256);

val = 256;
for rows = 1:256
    for cols = 1:256
        B(rows,cols) = rows-1;
    end
end

figure()
B = halftone(B);
imshow(B);

function A = halftone(image)
    A = uint8(image);
    % Number of pixel rows and columns in the image
    rows = size(A,1);
    cols = size(A,2);

    %Detecting if image is not divisible by 3 evenly
    r_remain = rem(rows, 3);
    c_remain = rem(cols, 3);

    % Creating halftone transform matrices
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
    
    right_edge_catch = false;

    for row_idx = 1:3:cols
        right_edge_corrected = false;
        for col_idx = 1:3:rows
            if (right_edge_catch == false)
                % Normal preparation for transform
                PXL_AVG = round(mean(A(row_idx:row_idx+2,col_idx:col_idx+2), "all"));
                transform = false;
                %% Transforms
                if (PXL_AVG>0 && PXL_AVG<=25 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot9;
                    transform = true;
                elseif (PXL_AVG>=26 && PXL_AVG<=51 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot8;
                    transform = true;
                elseif (PXL_AVG>=52 && PXL_AVG<=77 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot7;
                    transform = true;
                elseif (PXL_AVG>=78 && PXL_AVG<=103 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot6;
                    transform = true;
                elseif (PXL_AVG>=104 && PXL_AVG<=129 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot5;
                    transform = true;
                elseif (PXL_AVG>=130 && PXL_AVG<=155 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot4;
                    transform = true;
                elseif (PXL_AVG>=156 && PXL_AVG<=181 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot3;
                    transform = true;
                elseif (PXL_AVG>=182 && PXL_AVG<=207 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot2;
                    transform = true;
                elseif (PXL_AVG>=208 && PXL_AVG<=233 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot1;
                    transform = true;
                elseif (PXL_AVG>=234 && PXL_AVG<=255 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot0;
                    transform = true;
                end
            else
                right_edge_catch = false;
                right_edge_corrected = true;
                %PXL_AVG = round(mean(A(row_idx:row_idx+2,col_idx-offset:col_idx+2-offset), "all"));
                transform = false;
                if (PXL_AVG>0 && PXL_AVG<=25 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot9(:,1:2-c_remain);
                    transform = true;
                elseif (PXL_AVG>=26 && PXL_AVG<=51 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot8(:,1:2-c_remain);
                    transform = true;
                elseif (PXL_AVG>=52 && PXL_AVG<=77 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot7(:,1:2-c_remain);
                    transform = true;
                elseif (PXL_AVG>=78 && PXL_AVG<=103 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot6(:,1:2-c_remain);
                    transform = true;
                elseif (PXL_AVG>=104 && PXL_AVG<=129 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot5(:,1:2-c_remain);
                    transform = true;
                elseif (PXL_AVG>=130 && PXL_AVG<=155 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot4(:,1:2-c_remain);
                    transform = true;
                elseif (PXL_AVG>=156 && PXL_AVG<=181 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot3(:,1:2-c_remain);
                    transform = true;
                elseif (PXL_AVG>=182 && PXL_AVG<=207 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot2(:,1:2-c_remain);
                    transform = true;
                elseif (PXL_AVG>=208 && PXL_AVG<=233 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot1(:,1:2-c_remain);
                    transform = true;
                elseif (PXL_AVG>=234 && PXL_AVG<=255 && transform==false)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot0(:,1:2-c_remain);
                    transform = true;
                end
            end
            
            %%
            if (col_idx+3>=rows)
                if (c_remain > 0 && right_edge_corrected == false)
                    right_edge_catch = true;
                else
                    break;
                end
            end
        end
        if (row_idx+3>=cols)
            break;
        end
    end
    % Used to test
    % fprintf("A(%.f:%.f,%.f:%.f) => %.f   |   ", row_idx, row_idx+2, col_idx, col_idx+2, PXL_AVG);
end