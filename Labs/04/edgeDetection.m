clc;
close all;
clear all;

% Define the input image
inputMatrix = imread("watertower.tif");
figure()
imshow(inputMatrix);
scalar = 1;
while (scalar ~= -1)
    scalar = input("Enter a scalar value (-1 to quit): ");
    finalImage = find_edges(inputMatrix,scalar);
    figure()
    imshow(finalImage);
end
fprintf("Exiting program...\n\n")

% Debugging test matrix
% testMatrix = randi(10,10,10);
% resultMatrix = spatial_filter(testMatrix, filterToApply);

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
The gradient_magnitude function returns the magnitude of the inputImage
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
The spatial_filter function returns a double
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