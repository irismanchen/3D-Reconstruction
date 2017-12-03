% Q4.2:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3
    img1 = imread('../data/im1.png');
    img2 = imread('../data/im2.png');
    load('q2_1.mat');
    load('../data/intrinsics.mat');
    load('../data/templeCoords.mat');
    E = essentialMatrix(F, K1, K2);
    x2 = zeros(size(x1));
    y2 = zeros(size(y1));
    for i = 1:length(x1)
        [x2(i),y2(i)] = epipolarCorrespondence(img1, img2, F, x1(i), y1(i));
    end
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
        [Pi, err] = triangulate(C1, [x1 y1], C2s(:,:,i), [x2 y2]);
        if all(Pi(:,3)>0)
            P = Pi;
            M2 = M2s(:,:,i);
            C2 = C2s(:,:,i);
        end
    end
    save('q4_2.mat', 'F', 'M1', 'M2','C1','C2');
    figure(1);
    scatter3(P(:,1), P(:,2), P(:,3),'filled');