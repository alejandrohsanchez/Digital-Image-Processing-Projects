clc;
close all;
clear all;

inputMatrix = imread("watertower.tif");

filterToApply = [1 1 1; 1 1 1; 1 1 1];

resultMatrix = spatial_filter(inputMatrix, filterToApply);


function outputImage = spatial_filter(inputImage, filterMatrix)
    
    outputImage = 2;
end