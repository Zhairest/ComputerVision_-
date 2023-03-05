clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%111111111111111111
img = imread('sudoku.png');
img = rgb2gray(double(img)/255);
response = harris_corners(img,0.04,0.01);

%绘制提取到的角点
addPoint(img,img,response);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%222222222222222222222
img1 = imread('uttower1.jpg');
%img1=imread('1.jpg');

img12 = rgb2gray(double(img1)/255);

img2 = imread('uttower2.jpg');
%img2=imread('2.jpg');


img22 = rgb2gray(double(img2)/255);
response1 = harris_corners(img12,0.06,0.03);
response2 = harris_corners(img22,0.06,0.03);
%绘制提取到的角点
addPoint(img1,img12,response1);
addPoint(img2,img22,response2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2.2 2.2 2.2


%用describe_keypoints函数实现特征点描述算法
sigma = 7;
[out1,point1,pointloc1] = describe_keypoints(img12, response1);
[out2,point2,pointloc2]= describe_keypoints(img22, response2);


[matchedPoints1,matchedPoints2,matcher1,matcher2,indexPairss]=match_descriptors(img12,img22,out1,out2,point1,point2);


fit_affine_matrix(img12,img22,matchedPoints1,matchedPoints2);       %不加HOG和ransac，我认为比单HOG效果更好,可能我在每一步对点的处理比较好，也有可能取到的样本点并不大那么多?


universe1=HOG(img12,response1,pointloc1);           %先把整幅图像的梯度算好，然后构建cell,people（block）,转换成特征向量
universe2=HOG(img22,response2,pointloc2);

HOGmatchimg(img1,img2,img12,img22,universe1,universe2,point1,point2);          %final step,   ransac在里面了
