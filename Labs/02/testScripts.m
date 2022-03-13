clear all;
close all;
clc;
input = [1 2 3; 4 5 6; 7 8 9];
M=15; N=13;
% This function will perform nearest neighbor interpolation.
Im1.rows = size(input,1);
Im1.cols = size(input,2);
Im2.rows = M;
Im2.cols = N;
% Create the first instance of the output array
output = zeros(Im2.rows, Im2.cols);
% We will want to floor these values (rowCoords and colCoords)
rowCoords=floor(linspace(1,Im2.rows,Im1.rows));
colCoords=floor(linspace(1,Im2.cols,Im1.cols));

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