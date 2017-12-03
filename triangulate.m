function [ P, err ] = triangulate( C1, p1, C2, p2 )
% triangulate:
%       C1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       C2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

%       P - Nx3 matrix of 3D coordinates
%       err - scalar of the reprojection error

% Q3.2:
%       Implement a triangulation algorithm to compute the 3d locations
%

    numOfPoints = size(p1,1);
    P = zeros(numOfPoints,3);
    for i =1:numOfPoints
        A = [p1(i,1)*C1(3,:)-C1(1,:)
             p1(i,2)*C1(3,:)-C1(2,:)
             p2(i,1)*C2(3,:)-C2(1,:)
             p2(i,2)*C2(3,:)-C2(2,:)];
        [U, S, V] = svd(A);
        P(i,:) = V(1:3,end)'/V(4,end);
    end
    P_homo = [P,ones(numOfPoints,1)]';
    p1_proj = C1*P_homo;
    p1_proj = p1_proj(1:2,:)./repmat(p1_proj(3,:),2,1);
    p1_proj = p1_proj';
    p2_proj = C2*P_homo;
    p2_proj = p2_proj(1:2,:)./repmat(p2_proj(3,:),2,1);
    p2_proj = p2_proj';
    err = sum((p1(:)-p1_proj(:)).^2+(p2(:)-p2_proj(:)).^2);
end
