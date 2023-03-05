%清空变量，读取图像
clear;close all
src= imread('uttower1.jpg'); 

gray=rgb2gray(src);  
gray = im2double(gray);

%计算X方向和Y方向的梯度及其平方
X=imfilter(gray,[-1 0 1]);
X2=X.^2;
Y=imfilter(gray,[-1 0 1]');
Y2=Y.^2;
XY=X.*Y;

%生成高斯卷积核，对X2、Y2、XY进行平滑
h=fspecial('gaussian',[5 1],1.5);
w=h*h';
A=imfilter(X2,w);
B=imfilter(Y2,w);
C=imfilter(XY,w);

%k一般取值0.04-0.06
k=0.04;
RMax=0;
size=size(gray);
height=size(1);
width=size(2);
R=zeros(height,width);
for h=1:height
    for w=1:width
        %计算M矩阵
        M=[A(h,w) C(h,w);C(h,w) B(h,w)];
        %计算R用于判断是否是边缘
        R(h,w)=det(M) - k*(trace(M))^2;
        %获得R的最大值，之后用于确定判断角点的阈值
        if(R(h,w)>RMax)
            RMax=R(h,w);
        end
    end
end

%用Q*RMax作为阈值，判断一个点是不是角点
Q=0.01;
R_corner=(R>=(Q*RMax)).*R;

%寻找3x3邻域内的最大值，只有一个交点在8邻域内是该邻域的最大点时，才认为该点是角点
fun = @(x) max(x(:)); 
R_localMax = nlfilter(R,[3 3],fun); 

%寻找既满足角点阈值，又在其8邻域内是最大值点的点作为角点
%注意：需要剔除边缘点
[row,col]=find(R_localMax(2:height-1,2:width-1)==R_corner(2:height-1,2:width-1));

%绘制提取到的角点
figure('name','Result');
imshow(gray),title('my-Harris'),
hold on
plot(col,row, 'r*'),
hold off

%用matlab自带的edge函数提取Harris角点，对比效果
%C = corner(gray);
%figure;
%imshow(gray),title('matlab-conner'),
%hold on
%plot(C(:,1), C(:,2), 'r*');
%hold off