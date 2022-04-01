close all;
clear all;
%{
This script will perform histogram equalization on a grayscale
image. Assumes all images are grayscale and have values from
0 to 255.

Sum of all elements in MATLAB
https://www.mathworks.com/help/matlab/ref/sum.html

Bar graph in MATLAB
https://www.mathworks.com/help/matlab/ref/bar.html


%}
inputMatrix1 = imread("Lab_03_image1_dark.tif");
inputMatrix2 = imread("Lab_03_image2_light.tif");

output1 = equalize(inputMatrix1);
figure()
imshow(output1);

%{
This is the plot_histogram function. It takes a histogram as
input (as returned from compute_histogram) and plots it. The
x-axis ranges from 0 to 255 and is labeled "intensity value".
The y-axis ranges from 0 to the maximum values of the
histogram and should be labeled "PMF" (for probability mass
function).
%}
function plot_histogram(h)
    x = linspace(0,255,256);
    figure()
    bar(x,h);
    xlabel('intensity value');
    ylabel('PMF');
end

%{
This is the compute_histogram function. It takes a grayscale
image as input and returns a length 256 row vector h which is
the hisogram of the values in the image. h contains values
from 0 to 1 and its components sum up to 1.
%}
function h = compute_histogram(I)
    % Determine probability of pixels appearing in image.
    h = zeros(1,256);
    M=size(I,1); N=size(I,2);
    for i=0:255
        total=0;
        for x=1:M
            for y=1:N
                if (i==I(x,y))
                    total=total+1;
                end
            end
        end
        probability = total / (M*N);
        h(i+1) = probability;
    end
end

function T = histogram_transform(h)
    T = zeros(1,256);
    % All the intensity values that can occur in the image.
    for j=0:255
        S = 0;
        for k=0:j
            S = S + (255*h(j+1));
        end
        T(j+1) = round(S);
    end
end

function output = equalize(I)
    figure()
    imshow(I);
    I = double(I);
    M=size(I,1); N=size(I,2); output=zeros(M,N);
    h = compute_histogram(I);
    plot_histogram(h);
    T = histogram_transform(h)
    for i=1:size(T,2)
        for x=1:M
            for y=1:N
                if (I(x,y)==(i-1))
                    output(x,y) = T(i);
                end
            end
        end
    end
    output = uint8(output);
    h_eq = compute_histogram(output);
    plot_histogram(h_eq);
end