function test4_1()
    img1 = imread('../data/im1.png');
    img2 = imread('../data/im2.png');
    load('q2_1.mat');
    [pts1, pts2] = epipolarMatchGUI(img1, img2, F);
    save('q4_1.mat', 'F', 'pts1', 'pts2');
end