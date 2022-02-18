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
% inputMatrixX = im2uint8(imread("test4.jpg")); % TEST IMAGE
% inputMatrixX2 = im2uint8(imread("test5.jpg")); % TEST IMAGE

%{
Write a test script that generates a test pattern image consisting of
a grey scale "wedge" of size 256x256, whose first row is all 0, the next
row is all 1, and so on, with the last row being 255.
%}

temp = zeros(256,256);
inputWedge = im2uint8(temp);
for rows = 1:size(inputWedge,1)
    for cols = 1:size(inputWedge,2)
        inputWedge(rows,cols) = rows-1;
    end
end

%% MAKE A WEDGE OF ANY DIMENSIONS GREATER THAN 255 x 255 PIXELS
% stop = false;
% while(true)
%     x = input("Enter the height: ");
%     if (x > 255)
%         break;
%     elseif (x == -1)
%         stop = true;
%         break;
%     else
%         fprintf("Invalid size! Enter number greater than 255 or -1 to cancel!\n");
%     end
% end
% if (stop~=true)
%     while (true)
%         y = input("Enter the width: ");
%         if (y > 255)
%             break;
%         elseif (y == -1)
%             stop = true;
%             break;
%         else
%             fprintf("Invalid size! Enter number greater than 255 or -1 to cancel!\n");
%         end
%     end
% end
% 
% if (stop == true)
%     fprintf("Process terminated!\n\n")
% else
%     temp = ones(x,y);
%     ver = round(size(temp,2)/256);
%     matrix = im2uint8(temp);
%     for rows = 1:size(matrix,1)
%         i = 0;
%         for cols = 1:ver:size(matrix,2)
%             if cols+ver>size(matrix,2)
%                 break;
%             else
%                 matrix(rows,cols:(cols+ver)) = i;
%                 i = i + 1;
%             end
%         end
%     end
%     newWedge = halftone(matrix);
%     figure()
%     subplot(1,2,1), imshow(matrix);
%     title("Your Original");
%     subplot(1,2,2), imshow(newWedge);
%     title("Halftone");
% end
%%

outputMatrixA = halftone(inputMatrixA);
figure()
imshow(imread("Fig0225(a)(face).tif"));
title("Original");
pause(0.3)
figure()
imshow(outputMatrixA);
title("Halftone");
pause(0.3)

outputMatrixB = halftone(inputMatrixB);
figure()
imshow(imread("Fig0225(b)(cameraman).tif"));
title("Original");
pause(0.3)
figure()
imshow(outputMatrixB);
title("Halftone");
pause(0.3)

outputMatrixC = halftone(inputMatrixC);
figure()
imshow(imread("Fig0225(c)(crowd).tif"));
title("Original");
pause(0.3)
figure()
imshow(outputMatrixC);
title("Halftone");
pause(0.3)

outputWedge = halftone(inputWedge);
figure()
imshow(inputWedge);
title("Original");
pause(0.3)
figure()
imshow(outputWedge);
title("Halftone");
pause(0.3)

% INSERT A TEST IMAGE
% outputMatrixX = halftone(rgb2gray(inputMatrixX)); % TEST IMAGE
% figure()
% subplot(1,2,1), imshow(imread("test.jpg"));
% title("Original");
% subplot(1,2,2), imshow(outputMatrixX);
% title("Halftone");


%% FUNCTION SCRIPT
function output = halftone(inputImage)
    %{
    halftone  Converts a grayscale image to a binary image by using binary dot patterns to 
    render grayscale values.
    Syntax: 
        out = halftone(in) 
     
    Input: 
        in = the grayscale image to be rendered. It should be of type uint8 and have values in the range 0-255.
      
    Output: 
        out = the rendered binary image. It is of type uint8 and will have two values: 0 and 255. 
     
    History: 
        See GitHub commit history:
        https://github.com/alejandrohsanchez/Digital-Image-Processing-Projects/commits/main
    %}
    A = inputImage;
    % Number of pixel rows and columns in the image
    rows = size(A,1);
    cols = size(A,2);
    %Detecting if image is not divisible by 3 evenly
    r_remain = rem(rows, 3);
    c_remain = rem(cols, 3);

    % Creating halftone transform matrices
    % 0 is black, 255 is white
    dot0 = [0 0 0; 0 0 0; 0 0 0];
    dot1 = [0 255 0; 0 0 0; 0 0 0];
    dot2 = [0 255 0; 0 0 0; 0 0 255];
    dot3 = [255 255 0; 0 0 0; 0 0 255];
    dot4 = [255 255 0; 0 0 0; 255 0 255];
    dot5 = [255 255 255; 0 0 0; 255 0 255];
    dot6 = [255 255 255; 0 0 255; 255 0 255];
    dot7 = [255 255 255; 0 0 255; 255 255 255];
    dot8 = [255 255 255; 255 0 255; 255 255 255];
    dot9 = [255 255 255; 255 255 255; 255 255 255];
    
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
                PXL_AVG = round(mean(A(row_idx:row_idx+2,col_idx:col_idx+2), "all"));
                if (PXL_AVG>=0 && PXL_AVG<=25)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot0;
                elseif (PXL_AVG>=26 && PXL_AVG<=51)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot1;
                elseif (PXL_AVG>=52 && PXL_AVG<=77)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot2;
                elseif (PXL_AVG>=78 && PXL_AVG<=103)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot3;
                elseif (PXL_AVG>=104 && PXL_AVG<=129)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot4;
                elseif (PXL_AVG>=130 && PXL_AVG<=155)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot5;
                elseif (PXL_AVG>=156 && PXL_AVG<=181)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot6;
                elseif (PXL_AVG>=182 && PXL_AVG<=207)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot7;
                elseif (PXL_AVG>=208 && PXL_AVG<=233)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot8;
                elseif (PXL_AVG>=234 && PXL_AVG<=255)
                    A(row_idx:row_idx+2,col_idx:col_idx+2) = dot9;
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
                PXL_AVG = round(mean(A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1), "all"));
                if (PXL_AVG>=0 && PXL_AVG<=25)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot0(:,1:c_remain);
                elseif (PXL_AVG>=26 && PXL_AVG<=51)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot1(:,1:c_remain);
                elseif (PXL_AVG>=52 && PXL_AVG<=77)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot2(:,1:c_remain);
                elseif (PXL_AVG>=78 && PXL_AVG<=103)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot3(:,1:c_remain);
                elseif (PXL_AVG>=104 && PXL_AVG<=129)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot4(:,1:c_remain);
                elseif (PXL_AVG>=130 && PXL_AVG<=155)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot5(:,1:c_remain);
                elseif (PXL_AVG>=156 && PXL_AVG<=181)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot6(:,1:c_remain);
                elseif (PXL_AVG>=182 && PXL_AVG<=207)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot7(:,1:c_remain);
                elseif (PXL_AVG>=208 && PXL_AVG<=233)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot8(:,1:c_remain);
                elseif (PXL_AVG>=234 && PXL_AVG<=255)
                    A(row_idx:row_idx+2,col_idx:col_idx+c_remain-1) = dot9(:,1:c_remain);
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
                PXL_AVG = round(mean(A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2), "all"));
                if (PXL_AVG>=0 && PXL_AVG<=25)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot0(1:r_remain,:);
                elseif (PXL_AVG>=26 && PXL_AVG<=51)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot1(1:r_remain,:);
                elseif (PXL_AVG>=52 && PXL_AVG<=77)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot2(1:r_remain,:);
                elseif (PXL_AVG>=78 && PXL_AVG<=103)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot3(1:r_remain,:);
                elseif (PXL_AVG>=104 && PXL_AVG<=129)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot4(1:r_remain,:);
                elseif (PXL_AVG>=130 && PXL_AVG<=155)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot5(1:r_remain,:);
                elseif (PXL_AVG>=156 && PXL_AVG<=181)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot6(1:r_remain,:);
                elseif (PXL_AVG>=182 && PXL_AVG<=207)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot7(1:r_remain,:);
                elseif (PXL_AVG>=208 && PXL_AVG<=233)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot8(1:r_remain,:);
                elseif (PXL_AVG>=234 && PXL_AVG<=255)
                    A(row_idx:row_idx+r_remain-1,col_idx:col_idx+2) = dot9(1:r_remain,:);
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
        PXL_AVG = round(mean(A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1), "all"));
        if (PXL_AVG>=0 && PXL_AVG<=25)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot0(1:r_remain,1:c_remain);
        elseif (PXL_AVG>=26 && PXL_AVG<=51)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot1(1:r_remain,1:c_remain);
        elseif (PXL_AVG>=52 && PXL_AVG<=77)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot2(1:r_remain,1:c_remain);
        elseif (PXL_AVG>=78 && PXL_AVG<=103)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot3(1:r_remain,1:c_remain);
        elseif (PXL_AVG>=104 && PXL_AVG<=129)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot4(1:r_remain,1:c_remain);
        elseif (PXL_AVG>=130 && PXL_AVG<=155)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot5(1:r_remain,1:c_remain);
        elseif (PXL_AVG>=156 && PXL_AVG<=181)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot6(1:r_remain,1:c_remain);
        elseif (PXL_AVG>=182 && PXL_AVG<=207)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot7(1:r_remain,1:c_remain);
        elseif (PXL_AVG>=208 && PXL_AVG<=233)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot8(1:r_remain,1:c_remain);
        elseif (PXL_AVG>=234 && PXL_AVG<=255)
            A(row_idx:row_idx+r_remain-1,col_idx:col_idx+c_remain-1) = dot9(1:r_remain,1:c_remain);
        end
    end
    if (kill==false)
        pause(0.3);
        output = A;
        delete(f)
    else
        waitbar(progress,f,sprintf("Processing Interrupted! %.f%%", (currentTick/localTicks)*100));
        pause(0.3);
        delete(f);
        output = A;
    end
end