function testPart2()
    img1 = imread('../data/im1.png');
    img2 = imread('../data/im2.png');
    M = max([size(img1),size(img2)]);
    
%     % Q2.1----eight points
%     load('../data/some_corresp.mat');
%     F = eightpoint(pts1, pts2, M);
%     disp(F);
%     save('q2_1.mat', 'F', 'M', 'pts1', 'pts2');
%     displayEpipolarF(img1, img2, F);

%     % Q2.2----seven points
%     %cpselect(img1, img2);
%     load('../data/some_corresp.mat');
%     pointNum = size(pts1,1);
%     index = randperm(pointNum, 7);
%     p1 = pts1(index, :);
%     p2 = pts2(index, :);
%     F = sevenpoint(p1, p2, M);
%     for i = 1 : numel(F)
%          disp(F{i});
%     end
%     save('q2_2.mat', 'F', 'M', 'pts1', 'pts2');
%     displayEpipolarF(img1, img2, F{1});
%     displayEpipolarF(img1, img2, F{2});
%     displayEpipolarF(img1, img2, F{3});
    
    % Q5.1----RANSAC
    load('../data/some_corresp_noisy.mat');
    %F1 = eightpoint(pts1, pts2, M);
    %disp(F1);
    %displayEpipolarF(img1, img2, F1);
    F = ransacF(pts1, pts2, M);
    disp(F);
    save('ransacF.mat','F');
    displayEpipolarF(img1, img2, F);
end