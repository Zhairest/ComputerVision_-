clear all;
close all;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%111111111111111111
img = imread('sudoku.png');
img = rgb2gray(double(img)/255);
response = harris_corners(img,0.04,0.01);




%绘制提取到的角点

addPoint(img,response);
%figure;
%imshow(img),
%hold on
%    plot(col,row, 'r*'),
%hold off;


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%222222222222222222222
img1 = imread('uttower1.jpg');
img12 = rgb2gray(double(img1)/255);
img2 = imread('uttower2.jpg');
img22 = rgb2gray(double(img2)/255);
[col1,row1] = harris_corners(img12,0.06,0.03);
[col2,row2] = harris_corners(img22,0.06,0.03);
figure;
imshow(img1),
hold on
    plot(col1,row1, 'b*'),
hold off;

figure;
imshow(img2),
hold on
    plot(col2,row2, 'b*'),
hold off;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%333333333333333333333


%用describe_keypoints函数实现特征点描述算法
sigma = 7;
[des1] = describe_keypoints(img12,  row1, col1,sigma);
[des2] = describe_keypoints(img22, row2, col2, sigma);




%%




