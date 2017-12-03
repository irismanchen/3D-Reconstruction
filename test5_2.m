function test5_2()
    load('../data/intrinsics.mat');
    load('../data/some_corresp_noisy.mat');
    img1 = imread('../data/im1.png');
    img2 = imread('../data/im2.png');
    M = max([size(img1),size(img2)]);
    % compute F using ransac
    load('ransacF.mat');
    pointsNum = size(pts1, 1);
    threshold = 1e-3;
    errors = diag(abs([pts2, ones(pointsNum, 1)]*F*[pts1, ones(pointsNum, 1)]'));
    inliners = errors < threshold;
    pts1 = pts1(inliners, :);
    pts2 = pts2(inliners, :);
    % compute M2_inti and P_init using F got by ransac
    E = essentialMatrix(F, K1, K2);
    M1 = [eye(3) zeros(3,1)];
    C1 = K1*M1;
    % 4 possible M2
    M2s = camera2(E);
    C2s = zeros(size(M2s));
    for i = 1:size(M2s, 3)
        C2s(:, :, i) = K2 * M2s(:,:,i);
    end
    minerror = inf;
    minerroridx = 0;
    minerrorP = zeros(pointsNum, 3);
    for i=1:size(M2s,3)
        [Pi, err] = triangulate(C1, pts1, C2s(:,:,i), pts2);
        if all(Pi(:,3)>0)
            minerror = err;
            minerroridx = i;
            minerrorP = Pi;
            break;
        end
    end
    M2_init = M2s(:,:,minerroridx);
    P_init = minerrorP;
    err_before = minerror;
    disp(err_before);
    % before bundle adjustment
    load('../data/templeCoords.mat');
    x2 = zeros(size(x1));
    y2 = zeros(size(y1));
    for i = 1: size(x1,1)
        [x2(i), y2(i)] = epipolarCorrespondence(img1, img2, F, x1(i), y1(i));
    end
    [P, error1] = triangulate(C1, [x1,y1], K2*M2_init, [x2, y2]);
    figure(1);
    scatter3(P(:,1), P(:,2), P(:,3),'filled');
    pause;
    % bundle adjustment
    [M2, P] = bundleAdjustment(K1, M1, pts1, K2, M2_init, pts2, P_init);
    disp(M2);
    [P, err_after] = triangulate(C1, pts1, K2*M2, pts2);
    disp(err_after);
    % after bundle adjustment
    [P,error2 ] = triangulate(C1, [x1,y1], K2*M2, [x2, y2]);
    scatter3(P(:,1), P(:,2), P(:,3), 'filled'); 
end