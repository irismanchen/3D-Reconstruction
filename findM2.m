% Q3.3:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, C2, p1, p2, R and P to q3_3.mat
    img1 = imread('../data/im1.png');
    img2 = imread('../data/im2.png');
    load('../data/intrinsics.mat');
    load('../data/some_corresp.mat');
    M = max([size(img1), size(img2)]);
    F = eightpoint(pts1, pts2, M);
    E = essentialMatrix(F, K1, K2);
    disp(E);
    M1 = [eye(3), zeros(3, 1)];
    C1 = K1*M1;
    % 4 possible M2
    M2s = camera2(E);
    C2s = zeros(size(M2s));
    for i = 1:size(M2s, 3)
        C2s(:, :, i) = K2 * M2s(:,:,i);
    end
    P = [];
    C2 = [];
    M2 = [];
    for i=1:size(M2s,3)
        [Pi, err] = triangulate(C1, pts1, C2s(:,:,i), pts2);
        if all(Pi(:,3)>0)
            P = Pi;
            M2 = M2s(:,:,i);
            C2 = C2s(:,:,i);
        end
    end
    p1 = pts1;
    p2 = pts2;
    save('q3_3.mat', 'M2', 'C2', 'p1', 'p2', 'P');