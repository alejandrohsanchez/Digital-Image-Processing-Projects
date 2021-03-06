%{
References:

The linspace() function
https://www.mathworks.com/help/matlab/ref/linspace.html

Nearest-neighbor interpolation
https://en.wikipedia.org/wiki/Nearest-neighbor_interpolation

Structure arrays in MATLAB
https://www.mathworks.com/help/matlab/ref/struct.html

Bilinear interpolation
https://en.wikipedia.org/wiki/Bilinear_interpolation

%}

clear all;
close all;
A = imread("Lab_02_image1.tif");
A = im2uint8(A);

figure()
imshow(A);
title('Original');

% Sample downsampled and upsampled test
downSample1 = myimresize(A, [40 75], 'nearest');
downSample2 = myimresize(A,[40 75],'bilinear');
upSample1 = myimresize(A, [425 600], 'nearest');
upSample2 = myimresize(A,[425 600],'bilinear');

% Show original images
figure()
imshow(downSample1);
title('Downsize to 40x75 using nearest-neighbor interpolation')
figure()
imshow(downSample2);
title('Downsize to 40x75 using bilinear interpolation')
figure()
imshow(upSample1);
title('Upsize to 425x600 using nearest-neighbor interpolation')
figure()
imshow(upSample2);
title('Upsize to 425x600 using bilinear interpolation')

% Reconstructing images
reconDownSample1 = myimresize(downSample1, [300 300], 'nearest');
reconDownSample2 = myimresize(downSample2, [300 300], 'bilinear');
reconUpSample1 = myimresize(upSample1, [300 300], 'nearest');
reconUpSample2 = myimresize(upSample2, [300 300], 'bilinear');

% Comparing downsample tests
rmseValue1 = myRMSE(A,reconDownSample1);
rmseValue2 = myRMSE(A,reconDownSample2);
fprintf("RMSE of downsampled reconstructed nearest interpolation: %f\n",rmseValue1);
fprintf("RMSE of downsampled reconstructed bilinear interpolation: %f\n",rmseValue2);
% Comparing upsample tests
rmseValue3 = myRMSE(A, reconUpSample1);
rmseValue4 = myRMSE(A, reconUpSample2);
fprintf("RMSE of upsampled reconstructed nearest interpolation: %f\n",rmseValue3);
fprintf("RMSE of upsampled reconstructed bilinear interpolation: %f\n",rmseValue4);

%{
This is the bilinear routine. This function is called from
the "myimresize" routine and performs up- and down-sampling
procedures. The routine takes an input image (type uint8),
and integer values M and N. M represents the number of rows
in the new image and N represents the number of columns in
the new image. The result of the transformation is stored
in "output" and is returned to "myimresize".
%}
function output = bilinear(input, M, N)
    % This function will perform nearest neighbor interpolation.
    Im1.rows = size(input,1); Im1.cols = size(input,2);
    Im2.rows = M; Im2.cols = N;
    % Create the first instance of the output array
    output = zeros(Im2.rows, Im2.cols);
    % We will want to floor these values (rowCoords and colCoords)
    rowCoords=round(linspace(1,Im2.rows,Im1.rows)); colCoords=round(linspace(1,Im2.cols,Im1.cols));
    
    for x=1:Im2.rows
        for i=2:length(rowCoords)
            lowerX=rowCoords(1,i-1);
            upperX=rowCoords(1,i);
            if (x>=lowerX && x<upperX)
                X1=rowCoords(1,i-1);X2=rowCoords(1,i-1);
                X3=rowCoords(1,i);X4=rowCoords(1,i);
                break;
            end
        end
        for y=1:Im2.cols
            for j=2:length(colCoords)
                lowerY=colCoords(1,j-1);
                upperY=colCoords(1,j);
                if (y>=lowerY && y<upperY)
                    Y1=colCoords(1,j-1);Y2=colCoords(1,j);
                    Y3=colCoords(1,j-1);Y4=colCoords(1,j);
                    break;
                end
            end
            % Interpolation 
            p1=input(i-1,j-1);
            p2=input(i-1,j);
            p3=input(i,j-1);
            p4=input(i,j);
            X5=x;Y5=y;
            A = [X1 Y1 X1*Y1 1;
                 X2 Y2 X2*Y2 1;
                 X3 Y3 X3*Y3 1;
                 X4 Y4 X4*Y4 1];
            B=[p1; p2; p3; p4];
            coeff=linsolve(A,double(B));
            p5=round(coeff(1,1)*X5 + coeff(2,1)*Y5 + coeff(3,1)*(X5*Y5) + coeff(4,1));
            output(x,y)=p5;
        end
    end
    output=uint8(output);
end

%{
This is the nearest routine. This function is called from the
"myimresize" routine and performs up- and down-sampling
procedures. The routine takes an input image (type uint8),
and integer values M and N. M represents the number of rows
in the new image and N represents the number of columns in
the new image. The result of the transformation is stored
in "output" and is returned to "myimresize".
%}
function output = nearest(input, M, N)
    % This function will perform nearest neighbor interpolation.
    Im1.rows = size(input,1); Im1.cols = size(input,2);
    Im2.rows = M; Im2.cols = N;
    % Create the first instance of the output array
    output = zeros(Im2.rows, Im2.cols);
    % We will want to floor these values (rowCoords and colCoords)
    rowCoords=round(linspace(1,Im2.rows,Im1.rows)); colCoords=round(linspace(1,Im2.cols,Im1.cols));
    
    for x=1:Im2.rows
        for y=1:Im2.cols
            for i=2:length(rowCoords)
                last_i_Val=rowCoords(1,i-1);
                current_i_Val=rowCoords(1,i);
                i_midpoint = round((current_i_Val + last_i_Val) / 2);
                if (x>=last_i_Val && x<=i_midpoint)
                    x_idx=i-1;
                    break;
                elseif (x>i_midpoint && x<=current_i_Val)
                    x_idx=i;
                    break;
                end
            end
            for j=2:length(colCoords)
                last_j_Val=colCoords(1,j-1);
                current_j_Val=colCoords(1,j);
                j_midpoint = round((current_j_Val + last_j_Val) / 2);
                if (y>=last_j_Val && y<=j_midpoint)
                    y_idx=j-1;
                    break;
                elseif (y>j_midpoint && y<=current_j_Val)
                    y_idx=j;
                    break;
                end
            end
            output(x,y)=input(x_idx,y_idx);
        end
    end
    output = uint8(output);
end

%{
This is the myRMSE routine. This function computes the
root mean squared error between two images. This
function takes input two grayscale images of the same size
and outputs a single floating point value, the RMSE.
RMSE is a numeric method for computing the difference between
two images. It is used in this program to evaluate the
effectiveness of the two image reconstruction algorithm by
computing the pixelwise difference between the original and
the reconstructed images.
%}
function value = myRMSE(Img1, Img2)
    SUM = 0;
    M=size(Img1,1);
    N=size(Img1,2);
    for i=1:M
        for j=1:N
            q1 = double(Img1(i,j));
            q2 = double(Img2(i,j));
            SUM = SUM + (q1-q2).^2;
        end
    end
    value = sqrt((1/(M*N)) * SUM);
end


%{
This is the myimresize routine. This is a function that calls to other
functions "nearest" and "bilinear" to perform up- and down-sampling
operations. The output of each of these function calls is stored into the
"outputImage" matrix and is returned at the end of the routine to main.
%}
function outputImage = myimresize(inputImage, inputSize, method)
    % Resize inputImage to get outputImage
    % inputImage = Input image, matrix
    % inputSize = Target imgage size
    % method = Nearest neighbor or bilinear interpolation
    
    M = inputSize(1);
    N = inputSize(2);

    if (strcmp(method, 'nearest'))
        outputImage = nearest(inputImage, M, N);
    elseif (strcmp(method, "bilinear"))
        outputImage = bilinear(inputImage, M, N);
    end
end