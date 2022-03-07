clear all;
close all;

A = imread("Lab_02_image1.tif");

o1 = myimresize(A, [20, 40], 'nearest');

o2 = myimresize(A, [55, 75], 'bilinear');



function outputImage = myimresize(inputImage, inputSize, method)
    % Resize inputImage to get outputImage
    % inputImage = Input image, matrix
    % inputSize = Target imgage size
    % method = Nearest neighbor or bilinear interpolation

    M = inputSize(1)
    N = inputSize(2)

    if (strcmp(method, 'nearest'))
        fprintf("Chose nearest\n");
    elseif (strcmp(method, "bilinear"))
        fprintf("Chose bilinear\n")
    end
    outputImage = [1,1];

end