close all;
clear all;
%{
Creating greyscale image
https://www.mathworks.com/matlabcentral/answers/108006-how-to-create-a-gray-scale-image

Converting image to type uint8
https://www.mathworks.com/help/images/ref/im2uint8.html

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

Binarize an image from grayscale
https://www.mathworks.com/help/images/ref/imbinarize.html

Using progress bar (waitbar)
https://www.mathworks.com/help/matlab/ref/waitbar.html

Special characters in waitbar
https://www.mathworks.com/matlabcentral/answers/376325-how-to-write-percentage-sign-into-a-txt-file
%}

inputMatrixA = im2uint8(imread("Fig0225(a)(face).tif"));
outputMatrixA = halftone(inputMatrixA);
figure()
imshow(outputMatrixA);

inputMatrixB = im2uint8(imread("Fig0225(b)(cameraman).tif"));
outputMatrixB = halftone(inputMatrixB);
figure()
imshow(outputMatrixB);

inputMatrixC = im2uint8(imread("Fig0225(c)(crowd).tif"));
outputMatrixC = halftone(inputMatrixC);
figure()
imshow(outputMatrixC);
%{
%% Input any image you want to test the halftone function
inputMatrixX = imread("test.jpg");
outputMatrixX = halftone(rgb2gray(inputMatrixX));
figure()
imshow(outputMatrixX);
%%
%}

%{
Write a test script that generates a test pattern image consisting of
a grey scale "wedge" of size 256x256, whose first row is all 0, the next
row is all 1, and so on, with the last row being 255.
%}

inputWedge = zeros(256,256);
inputWedge = im2uint8(inputWedge);
val = 256;
for rows = 1:val
    for cols = 1:val
        inputWedge(rows,cols) = rows-1;
    end
end
outputWedge = halftone(inputWedge);
figure()
imshow(outputWedge);

%% FUNCTION SCRIPT
function output = halftone(inputImage)
    A = inputImage;
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
    
    f = waitbar(0, "Processing");

    right_edge_catch = false;
    % LEFT-RIGHT TRANSFORM
    for row_idx = 1:3:rows
        waitbar(row_idx/rows,f,sprintf("Processing %.f%%", (row_idx/rows)*100));
        pause(0);
        right_edge_corrected = false;
        for col_idx = 1:3:cols
            if (right_edge_catch == false && col_idx+2<=cols && row_idx+2<=rows)
                % Normal preparation for transform
                PXL_AVG = round(mean(A(row_idx:row_idx+2,col_idx:col_idx+2), "all"));
               
                if (PXL_AVG>0 && PXL_AVG<=25)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot9;
                   
                elseif (PXL_AVG>=26 && PXL_AVG<=51)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot8;
                   
                elseif (PXL_AVG>=52 && PXL_AVG<=77)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot7;
                   
                elseif (PXL_AVG>=78 && PXL_AVG<=103)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot6;
                   
                elseif (PXL_AVG>=104 && PXL_AVG<=129)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot5;
                   
                elseif (PXL_AVG>=130 && PXL_AVG<=155)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot4;
                   
                elseif (PXL_AVG>=156 && PXL_AVG<=181)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot3;
                   
                elseif (PXL_AVG>=182 && PXL_AVG<=207)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot2;
                   
                elseif (PXL_AVG>=208 && PXL_AVG<=233)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot1;
                   
                elseif (PXL_AVG>=234 && PXL_AVG<=255)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot0;
                   
                end
            % RIGHT EDGE TRANSFORM
            elseif (row_idx+2<=rows)
                right_edge_catch = false;
                right_edge_corrected = true;
                PXL_AVG = round(mean(A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1), "all"));
               
                if (PXL_AVG>0 && PXL_AVG<=25)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot9(:,1:c_remain);
                   
                elseif (PXL_AVG>=26 && PXL_AVG<=51)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot8(:,1:c_remain);
                   
                elseif (PXL_AVG>=52 && PXL_AVG<=77)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot7(:,1:c_remain);
                   
                elseif (PXL_AVG>=78 && PXL_AVG<=103)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot6(:,1:c_remain);
                   
                elseif (PXL_AVG>=104 && PXL_AVG<=129)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot5(:,1:c_remain);
                   
                elseif (PXL_AVG>=130 && PXL_AVG<=155)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot4(:,1:c_remain);
                   
                elseif (PXL_AVG>=156 && PXL_AVG<=181)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot3(:,1:c_remain);
                   
                elseif (PXL_AVG>=182 && PXL_AVG<=207)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot2(:,1:c_remain);
                   
                elseif (PXL_AVG>=208 && PXL_AVG<=233)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot1(:,1:c_remain);
                   
                elseif (PXL_AVG>=234 && PXL_AVG<=255)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot0(:,1:c_remain);
                   
                end
            end
            
            %%
            if (col_idx+3>=cols)
                if (c_remain > 0 && right_edge_corrected == false)
                    right_edge_catch = true;
                else
                    break;
                end
            end
        end
        if (row_idx+3>=rows)
            break;
        end
    end

    % BOTTOM EDGE TRANSFORM
    if (r_remain > 0)
        row_idx = rows-2;
        for col_idx = 1:3:cols
            if (col_idx+2<=cols)
                PXL_AVG = round(mean(A(row_idx:row_idx+2,col_idx:col_idx+2), "all"));
               
                if (PXL_AVG>0 && PXL_AVG<=25)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot9;
                   
                elseif (PXL_AVG>=26 && PXL_AVG<=51)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot8;
                   
                elseif (PXL_AVG>=52 && PXL_AVG<=77)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot7;
                   
                elseif (PXL_AVG>=78 && PXL_AVG<=103)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot6;
                   
                elseif (PXL_AVG>=104 && PXL_AVG<=129)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot5;
                   
                elseif (PXL_AVG>=130 && PXL_AVG<=155)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot4;
                   
                elseif (PXL_AVG>=156 && PXL_AVG<=181)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot3;
                   
                elseif (PXL_AVG>=182 && PXL_AVG<=207)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot2;
                   
                elseif (PXL_AVG>=208 && PXL_AVG<=233)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot1;
                   
                elseif (PXL_AVG>=234 && PXL_AVG<=255)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot0;
                   
                end
            % BOTTOM-RIGHT CORNER TRANSFORM
            else
                PXL_AVG = round(mean(A(rows-2:rows,cols-2:cols), "all"));
               
                if (PXL_AVG>0 && PXL_AVG<=25)
                    A(rows-2:rows,cols-2:cols) = dot9;
                   
                elseif (PXL_AVG>=26 && PXL_AVG<=51)
                    A(rows-2:rows,cols-2:cols) = dot8;
                   
                elseif (PXL_AVG>=52 && PXL_AVG<=77)
                    A(rows-2:rows,cols-2:cols) = dot7;
                   
                elseif (PXL_AVG>=78 && PXL_AVG<=103)
                    A(rows-2:rows,cols-2:cols) = dot6;
                   
                elseif (PXL_AVG>=104 && PXL_AVG<=129)
                    A(rows-2:rows,cols-2:cols) = dot5;
                   
                elseif (PXL_AVG>=130 && PXL_AVG<=155)
                    A(rows-2:rows,cols-2:cols) = dot4;
                   
                elseif (PXL_AVG>=156 && PXL_AVG<=181)
                    A(rows-2:rows,cols-2:cols) = dot3;
                   
                elseif (PXL_AVG>=182 && PXL_AVG<=207)
                    A(rows-2:rows,cols-2:cols) = dot2;
                   
                elseif (PXL_AVG>=208 && PXL_AVG<=233)
                    A(rows-2:rows,cols-2:cols) = dot1;
                   
                elseif (PXL_AVG>=234 && PXL_AVG<=255)
                    A(rows-2:rows,cols-2:cols) = dot0;
                   
                end
            end
        end
    end
    delete(f)
    output = imbinarize(A);
end