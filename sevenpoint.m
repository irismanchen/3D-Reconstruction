function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - 7x2 matrix of (x,y) coordinates
%   pts2 - 7x2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup
    pts1 = pts1/M;
    pts2 = pts2/M;
    A = [pts2(:,1).*pts1(:,1), pts2(:,1).*pts1(:,2), pts2(:,1),...
         pts2(:,2).*pts1(:,1), pts2(:,2).*pts1(:,2), pts2(:,2),...
         pts1(:,1), pts1(:,2), ones(size(pts1,1),1)];
    [U,S,V] = svd(A);
    F1 = reshape(V(:,9),[3,3])';
    F2 = reshape(V(:,8),[3,3])';
    syms a;
    F = a*F1+(1-a)*F2;
    p = double(coeffs(det(F)));
    r = roots(fliplr(p));
    roots_real = isreal(r(1)) + isreal(r(2)) + isreal(r(3));
    F = cell([roots_real, 1]);
    T = diag([1/M, 1/M, 1]);
    cnt = 1;
    for i = 1:3
        if isreal(r(i))
            F{cnt} = r(i)*F1+(1-r(i))*F2;
            F{cnt} = refineF(F{cnt}, pts1, pts2);
            F{cnt} = T'*F{cnt}*T;
            cnt = cnt+1;
        end
    end
end

