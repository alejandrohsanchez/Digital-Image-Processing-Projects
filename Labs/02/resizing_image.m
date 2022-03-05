% Use interpolation to downsample or upsample image

A = imread('Lab_02_image1.tif');

% Use myimreasize to upsample or downsample
B = myimresize(A, [40, 75], 'nearest');
B1 = myimresize(B, [300, 300], 'nearest');

C = myimresize(A, [40, 75], 'bilinear');

imwrite(B, 'downsample_NN.tif');
imwrite(C, 'downsample_bilinear.tif');

% RMSE

Be = myRMSE(A, B1);
Ce = myRMSE(A, C1);

function e = myRMSE(A, B)
    % Implement the root mean squared equation here
    e = 'your value';
end


function v = mybilinear(x, y, p)
    % x, y is the location of 5 pixels
    % p is the pixel values of 4 pixels

    % We will calculate the 5th pixel value
    v = 'your value';
end


function B = myimresize(A, insize, method)
    % resize A to get B

    % A: input image, matrix
    % insize: target image size
    % method: Nearest neighbor or bilinear

    M = insize(1);
    N = insize(2);

    [Minput, Ninput] = size(A);

    B = uint8(zeros(M, N));

    for m=1:M
        for n=1:N
            % Your implementation here
            % Assign pixel values for each pixel of B
            
            % Find the corresponding location in A

            % Use that location to determine the pixel value
            if (strcmp(method, 'nearest'))
                the_value = 'your value';
            elseif (strcmp(method, 'bilinear'))
                % Use mybilinear function here
                the_value = mybilinear(1, 1, 1);
            end

            B(m,n) = the_value;

        end
    end
end