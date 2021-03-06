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

Working with subplots
https://www.mathworks.com/help/images/display-multiple-images.html


%}
% May want to consider linear interpolation
% floor (average/range of pixels) * 10

inputMatrixA = im2uint8(imread("Fig0225(a)(face).tif"));
inputMatrixB = im2uint8(imread("Fig0225(b)(cameraman).tif"));
inputMatrixC = im2uint8(imread("Fig0225(c)(crowd).tif"));
inputMatrixX = im2uint8(imread("test3.png")); % TEST IMAGE

%{
Write a test script that generates a test pattern image consisting of
a grey scale "wedge" of size 256x256, whose first row is all 0, the next
row is all 1, and so on, with the last row being 255.
%}

temp = zeros(256,256);
inputWedge = im2uint8(temp);
val = 256;
for rows = 1:val
    for cols = 1:val
        inputWedge(rows,cols) = rows-1;
    end
end

outputMatrixA = halftone(inputMatrixA);
figure()
subplot(1,2,1), imshow(imread("Fig0225(a)(face).tif"));
title("Original");
subplot(1,2,2), imshow(outputMatrixA);
title("Halftone");

outputMatrixB = halftone(inputMatrixB);
figure()
subplot(1,2,1), imshow(imread("Fig0225(b)(cameraman).tif"));
title("Original");
subplot(1,2,2), imshow(outputMatrixB);
title("Halftone");

outputMatrixC = halftone(inputMatrixC);
figure()
subplot(1,2,1), imshow(imread("Fig0225(c)(crowd).tif"));
title("Original");
subplot(1,2,2), imshow(outputMatrixC);
title("Halftone");

outputWedge = halftone(inputWedge);
figure()
subplot(1,2,1), imshow(inputWedge);
title("Original");
subplot(1,2,2), imshow(outputWedge);
title("Halftone");

% outputMatrixX = halftone(rgb2gray(inputMatrixX)); % TEST IMAGE
% figure()
% subplot(1,2,1), imshow(imread("test3.png"));
% title("Original");
% subplot(1,2,2), imshow(outputMatrixX);
% title("Halftone");

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
    
    f = waitbar(100, "Media Read!", "Name", "Halftone Transformation Progress", "CreateCancelBtn",...
        "setappdata(gcbf,'canceling',1)");
    pause(0.3)
    kill = false;
    progress = 0;
    setappdata(f,"canceling",0);
    % UPPER-LEFT LEFT-TO-RIGHT TRANSFORM
    localTicks = (rows-r_remain) * (cols-c_remain);
    currentTick = 0;
    for row_idx = 1:3:rows-r_remain
        if (c_remain > 0 && r_remain > 0)
            progress = (row_idx/(rows-r_remain))*0.25;
        elseif ((c_remain > 0 && r_remain==0) || (c_remain==0 && r_remain>0))
            progress = (row_idx/(rows-r_remain))*0.33;
        else
            progress = (row_idx/(rows-r_remain));
        end
        waitbar(progress,f,sprintf("Processing Halftone Transformation %.f%%", (currentTick/localTicks)*100));
        if getappdata(f,"canceling")
            kill = true;
            break
        end
        for col_idx = 1:3:cols-c_remain
            if (col_idx+2<=cols)
                currentTick = currentTick + 9;
                % Normal preparation for transform
                % Linear Interpolation Method
                PXL_AVG = floor((mean(A(row_idx:row_idx+2,col_idx:col_idx+2), "all")/255)*10);
                if (PXL_AVG==0)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot9;
                elseif (PXL_AVG==1)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot8;
                elseif (PXL_AVG==2)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot7;
                elseif (PXL_AVG==3)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot6;
                elseif (PXL_AVG==4)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot5;
                elseif (PXL_AVG==5)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot4;
                elseif (PXL_AVG==6)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot3;
                elseif (PXL_AVG==7)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot2;
                elseif (PXL_AVG==8)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot1;
                elseif (PXL_AVG==9)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot0;
                end
            else
                break
            end
        end
        if (row_idx+3>=rows)
            break;
        end
    end
    waitbar(progress,f,sprintf("Processing Halftone Transformation %.f%%", (currentTick/localTicks)*100));
    
    % PROCESSING EDGES %
    % RIGHT EDGE TRANSFORM
    if ((r_remain>0 || c_remain>0) && getappdata(f,"canceling")==false)
        localTicks = ((rows-r_remain) * c_remain) + ((cols-c_remain) * r_remain) + (r_remain * c_remain);
        currentTick = 0;
    end
    if (c_remain > 0 && kill==false)
        col_idx = cols-c_remain+1;
        for row_idx = 1:3:rows
            if getappdata(f,"canceling")
                kill = true;
                break
            end
            if (row_idx+2<=rows)
                if (c_remain > 0 && r_remain > 0)
                    progress = ((row_idx/(rows-r_remain))*0.25)+0.25;
                elseif (c_remain > 0 && r_remain==0)
                    progress = ((row_idx/(rows-r_remain))*0.33)+0.33;
                end
                waitbar(progress,f,sprintf("Cleaning Right Edge %.f%%", (currentTick/localTicks)*100));
                currentTick = currentTick + (3 * c_remain);
                PXL_AVG = floor((mean(A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1), "all")/255)*10);
                if (PXL_AVG==0)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot9(:,1:c_remain);
                elseif (PXL_AVG==1)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot8(:,1:c_remain);
                elseif (PXL_AVG==2)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot7(:,1:c_remain);
                elseif (PXL_AVG==3)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot6(:,1:c_remain);
                elseif (PXL_AVG==4)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot5(:,1:c_remain);
                elseif (PXL_AVG==5)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot4(:,1:c_remain);
                elseif (PXL_AVG==6)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot3(:,1:c_remain);
                elseif (PXL_AVG==7)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot2(:,1:c_remain);
                elseif (PXL_AVG==8)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot1(:,1:c_remain);
                elseif (PXL_AVG==9)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot0(:,1:c_remain);
                end
            end
        end
        waitbar(progress,f,sprintf("Cleaning Right Edge %.f%%", (currentTick/localTicks)*100));
    end

    % BOTTOM EDGE TRANSFORM
    if (r_remain > 0 && kill==false)
        row_idx = rows-r_remain+1;
        for col_idx = 1:3:cols
            if getappdata(f,"canceling")
                kill = true;
                break
            end
            if (col_idx+2<=cols)
                if (c_remain > 0 && r_remain > 0)
                    progress = ((col_idx/(cols-c_remain))*0.25)+0.50;
                elseif (c_remain==0 && r_remain>0)
                    progress = ((col_idx/(cols-c_remain))*0.33)+0.33;
                end
                waitbar(progress,f,sprintf("Cleaning Bottom Edge %.f%%", (currentTick/localTicks)*100));
                currentTick = currentTick + (3 * r_remain);
                PXL_AVG = floor((mean(A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2), "all")/255)*10);
                if (PXL_AVG==0)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot9(1:r_remain,:);
                elseif (PXL_AVG==1)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot8(1:r_remain,:);
                elseif (PXL_AVG==2)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot7(1:r_remain,:);
                elseif (PXL_AVG==3)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot6(1:r_remain,:);
                elseif (PXL_AVG==4)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot5(1:r_remain,:);
                elseif (PXL_AVG==5)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot4(1:r_remain,:);
                elseif (PXL_AVG==6)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot3(1:r_remain,:);
                elseif (PXL_AVG==7)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot2(1:r_remain,:);
                elseif (PXL_AVG==8)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot1(1:r_remain,:);
                elseif (PXL_AVG==9)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot0(1:r_remain,:);
                end
            end
        end
        waitbar(progress,f,sprintf("Cleaning Bottom Edge %.f%%", (currentTick/localTicks)*100));
    end
    
    % BOTTOM-RIGHT CORNER TRANSFORM
    if ((r_remain > 0 && kill==false) || (c_remain > 0 && kill==false))
        row_idx = rows-r_remain+1;
        col_idx = cols-c_remain+1;
        if (c_remain > 0 && r_remain > 0)
            progress = 0.75;
        elseif ((c_remain > 0 && r_remain==0) || (c_remain==0 && r_remain>0))
            progress = 0.67;
        end
        waitbar(progress,f,sprintf("Touching Up Corners %.f%%", (currentTick/localTicks)*100));
        currentTick = currentTick + (r_remain * c_remain);
        progress = 1;
        waitbar(progress,f,sprintf("Touching Up Corners %.f%%", (currentTick/localTicks)*100));
        PXL_AVG = floor((mean(A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1), "all")/255)*10);
        if (PXL_AVG==0)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot9(1:r_remain,1:c_remain);
        elseif (PXL_AVG==1)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot8(1:r_remain,1:c_remain);
        elseif (PXL_AVG==2)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot7(1:r_remain,1:c_remain);
        elseif (PXL_AVG==3)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot6(1:r_remain,1:c_remain);
        elseif (PXL_AVG==4)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot5(1:r_remain,1:c_remain);
        elseif (PXL_AVG==5)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot4(1:r_remain,1:c_remain);
        elseif (PXL_AVG==6)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot3(1:r_remain,1:c_remain);
        elseif (PXL_AVG==7)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot2(1:r_remain,1:c_remain);
        elseif (PXL_AVG==8)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot1(1:r_remain,1:c_remain);
        elseif (PXL_AVG==9)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot0(1:r_remain,1:c_remain);
        end
    end
    if (kill==false)
        pause(0.3);
        output = imbinarize(A);
        delete(f)
    else
        waitbar(progress,f,sprintf("Processing Interrupted! %.f%%", (currentTick/localTicks)*100));
        pause(0.3);
        delete(f);
        output = A;
    end
end