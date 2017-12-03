function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup
    pts1 = pts1/M;
    pts2 = pts2/M;
    A = [pts2(:,1).*pts1(:,1), pts2(:,1).*pts1(:,2), pts2(:,1),...
         pts2(:,2).*pts1(:,1), pts2(:,2).*pts1(:,2), pts2(:,2),...
         pts1(:,1), pts1(:,2), ones(size(pts1,1),1)];
    [U,S,V] = svd(A);
    F = reshape(V(:,9),[3,3])';
    F = refineF(F, pts1, pts2);
    [U,S,V] = svd(F);
    S(3,3) = 0;
    F = U*S*V';
    T = diag([1/M, 1/M, 1]);
    F = T'*F*T;
end

