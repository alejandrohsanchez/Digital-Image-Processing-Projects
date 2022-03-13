clear all;
close all;

A = imread("Lab_02_image1.tif");
o1 = myimresize(A, [20, 30], 'nearest');
figure()
imshow(o1);

test = imread("imageTest.png");
test = uint8(test);
o1 = myimresize(test, [40, 45], 'nearest');
figure()
imshow(o1);

%Test nearest neighbor interpolation method with RMSE equation
rmseImage = nearest(A,size(A,1),size(A,2));
value = myRMSE(A, rmseImage);
fprintf("The Root-Mean Square Error of this nearest neighbor interpolation is: %f\n",value);
% o2 = myimresize(A, [55, 75], 'bilinear');



function output = nearest(input, M, N)
    % This function will perform nearest neighbor interpolation.
    Im1.rows = size(input,1); Im1.cols = size(input,2);
    Im2.rows = M; Im2.cols = N;
    % Create the first instance of the output array
    output = zeros(Im2.rows, Im2.cols);
    % We will want to floor these values (rowCoords and colCoords)
    rowCoords=floor(linspace(1,Im2.rows,Im1.rows)); colCoords=floor(linspace(1,Im2.cols,Im1.cols));
    
    for x=1:Im2.rows
        for y=1:Im2.cols
            for i=2:length(rowCoords)
                last_i_Val=rowCoords(1,i-1);
                current_i_Val=rowCoords(1,i);
                i_midpoint = round((current_i_Val + last_i_Val) / 2);
                if (x>=last_i_Val && x<=i_midpoint)
                    x_idx=i-1;
                    break;
                elseif (x>i_midpoint && x<current_i_Val)
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
                elseif (y>j_midpoint && y<current_j_Val)
                    y_idx=j;
                    break;
                end
            end
            
            output(x,y)=input(x_idx,y_idx);
        end
    end
    output = uint8(output);
end

function value = myRMSE(Img1, Img2)
    SUM = 0;M=size(Img1,1);N=size(Img1,2);
    for i=1:M
        for j=1:N
            SUM = SUM +((Img1(i,j)-Img2(i,j)).^2);
        end
    end
    SUM = double(SUM);
    value = sqrt((1/(M*N)) * SUM);
end

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
        fprintf("Chose bilinear\n")
        outputImage = [1,1];
    end
    

end