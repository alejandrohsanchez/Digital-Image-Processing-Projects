clc;
close all;
clear all;

% Define the input image
inputMatrix = imread("watertower.tif");
% Define the filter
filterToApply = [1 1 1; 1 1 1; 1 1 1];
% Call spatial_filter function
%resultMatrix = spatial_filter(filterToApply, filterToApply);

% Debugging test matrix
testMatrix = randi(10,10,10);
resultMatrix = spatial_filter(testMatrix, filterToApply);

function outputImage = spatial_filter(inputImage, filterMatrix)
    M = size(inputImage,1);
    N = size(inputImage,2);
    filterM = size(filterMatrix,1);
    filterN = size(filterMatrix,2);

    temp = zeros(M+filterM-1,N+filterN-1);
    offsetX = ((filterM - 1) / 2) + 1;
    offsetY = ((filterN - 1) / 2) + 1;
    
    for x = offsetX:M+1
        for y = offsetY:N+1
            temp(x,y) = inputImage(x-offsetX+1,y-offsetY+1);
        end
    end
    outputImage = temp;
end