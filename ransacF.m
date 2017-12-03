function [ F ] = ransacF( pts1, pts2, M )
% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q5.1:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using eightpoint
%          - using ransac

%     In your writeup, describe your algorithm, how you determined which
%     points are inliers, and any other optimizations you made
    w = 0.75;
    p = 0.999;
    n = 7;
    iternum = ceil(log(1-p)/log(1-w^n))*2;
    totalPoint = size(pts1, 1);
    threshold = 0.001;
    p1 = [pts1,ones(totalPoint,1)];
    p2 = [pts2,ones(totalPoint,1)];
    max_inlier_num = 0;
    inliers = [];
    for iter = 1:iternum
        % randomly pick up 7 points
        randind = randperm(totalPoint, n);
        pts1_seven = pts1(randind,:);
        pts2_seven = pts2(randind,:);
        F_seven = sevenpoint(pts1_seven,pts2_seven,M);
        for i = 1 : numel(F_seven)
            F = F_seven{i};
            distance = p2*F*p1';
            distance = diag(abs(distance));
            inl = distance<threshold;
            inlier_nums = nnz(inl);
            if inlier_nums>max_inlier_num
                max_inlier_num = inlier_nums;
                inliers = inl;
            end
        end
    end
    F = eightpoint(pts1(inliers,:), pts2(inliers,:), M);
end

