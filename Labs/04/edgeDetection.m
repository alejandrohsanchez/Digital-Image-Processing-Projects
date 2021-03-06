clc;
close all;
clear all;

%{
Linear Spatial Filtering
https://www.math.uci.edu/icamp/courses/math77c/demos/linear_spatial_filtering.pdf

Image Gradient Wikipedia
https://en.wikipedia.org/wiki/Image_gradient

Sobel Operator Wikipedia
https://en.wikipedia.org/wiki/Sobel_operator

What is zero padding
https://www.icsid.org/uncategorized/what-is-zero-padding-in-image-processing/
%}

% Define the input image
inputMatrix = imread("watertower.tif");
figure()
imshow(inputMatrix);
scalar = 1;
while (scalar ~= -1)
    scalar = input("Enter a scalar value (-1 to quit): ");
    if (scalar ~= -1)
        finalImage = find_edges(inputMatrix,scalar);
        figure()
        imshow(finalImage);
    end
end
fprintf("Exiting program...\n\n")

% Debugging test matrix
% testMatrix = randi(10,10,10);
% resultMatrix = spatial_filter(testMatrix, filterToApply);

%{
This is the find_edges function. It takes an input matrix of
type uint8 and a scalar value between 0 and 255, then returns a
gradient image. The return value is type uint8.
%}
function resultingImage = find_edges(inputImage, scalar)
    % Call gradient magnitude function
    magnitude = gradient_magnitude(inputImage);
    M = size(magnitude,1);
    N = size(magnitude,2);
    % Create result matrix
    resultingImage = zeros(M,N);
    for x=1:M
        for y=1:N
            if magnitude(x,y) >= scalar
                resultingImage(x,y) = 255;
            else
                resultingImage(x,y) = 0;
            end
        end
    end
    resultingImage = uint8(resultingImage);
end

%{
This is the gradient_magnitude function. It takes a matrix of
type uint8 as an argument and returns a matrix of type double.
It returns the magnitude of the gradient of an image.
%}
function magnitude = gradient_magnitude(inputImage)
    % Define the sobel masks
    sobelX = [-1 -2 -1;
               0 0 0;
               1 2 1];
    sobelY = [-1 0 1;
              -2 0 2;
              -1 0 1];
    % Call spatial_filter function
    gX = spatial_filter(inputImage, sobelX);
    gY = spatial_filter(inputImage, sobelY);
    M = size(gX,1);
    N = size(gX,2);
    magnitude = zeros(M,N);
    for x = 1:M
        for y = 1:N
            magnitude(x,y) = sqrt(gX(x,y).^2 + gY(x,y).^2);
        end
    end
end

%{
This is the spatial_filter function. It takes a matrix of type
uint8 and a filter mask as arguments and returns a matrix of type
double. It returns an image copy of the input image after a
filter is applied to its values.
%}
function outputImage = spatial_filter(inputImage, filterMatrix)
    M = size(inputImage,1);
    N = size(inputImage,2);
    filterM = size(filterMatrix,1);
    filterN = size(filterMatrix,2);
    % Create temp matrix to apply filter matrix
    temp = zeros(M+filterM-1,N+filterN-1);
    offsetX = ((filterM - 1) / 2) + 1;
    offsetY = ((filterN - 1) / 2) + 1;
    
    % Initialize the output image
    outputImage = zeros(M,N);

    % Reassign the values in the temp matrix
    for x = offsetX:M+1
        for y = offsetY:N+1
            temp(x,y) = inputImage(x-offsetX+1,y-offsetY+1);
        end
    end
    
    % Go through each value in the image (the values where the image and the
    % temp matrix overlap)
    for x = offsetX:M+1
        for y = offsetY:N+1
            % Go through each pixel in the image and apply the filter
            val = 0;
            for m=1:filterM
                for n=1:filterN
                    val = val + (temp(x-offsetX+m,y-offsetY+n) * filterMatrix(m,n));
                    
                end
            end
            outputImage(x-offsetX+1, y-offsetY+1) = val;
        end
    end

end