function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q4.1:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q4_1.mat
%
%           Explain your methods and optimization in your writeup
    windowSize = 25;
    maxDistance = 20;
    sigma = 3;
    epipolarLine = F*[x1 y1 1]';
    weights = fspecial('gaussian', 2*windowSize+1, sigma);
    patch1 = double(im1((y1-windowSize):(y1+windowSize),(x1-windowSize):(x1+windowSize)));
    min_error = inf;
    for y=windowSize+1:size(im2,1)-windowSize-1
        x = round((-epipolarLine(2)*y-epipolarLine(3))/epipolarLine(1));
        if(x<(windowSize+1)||x>(size(im2,2)-windowSize-1))
            continue;
        end
        if((x-x1)^2+(y-y1)^2>maxDistance^2)
            continue;
        end
        patch2 = double(im2((y-windowSize):(y+windowSize),(x-windowSize):(x+windowSize)));
        diff = abs(patch1-patch2).*weights;
        error = sum(diff(:));
        if error<min_error
            min_error = error;
            x2 = x;
            y2 = y;
        end
    end
end

