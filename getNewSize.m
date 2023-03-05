function [newH, newW, x1, y1, x2, y2] = getNewSize(transform, h2, w2, h1, w1)
% 计算新图片的大小
% 输入
% transform - h矩阵
% h1 - 未扭曲图像的高度
% w1 - 未扭曲图像的宽度
% h2 - 扭曲图像的高度
% w2 - 扭曲图像的宽度
% 输出
% newH - 新图像高度
% newW - 新图像宽度
% x1 - 新图像左上角的x坐标
% y1 - 新图像左上角的y坐标
% x2 - 未弯曲图像左上角的x坐标
% y2 - 未弯曲图像左上角的y坐标

% 为扭曲的图像创建网格-网格
[X,Y] = meshgrid(1:w2,1:h2);
AA = ones(3,h2*w2);
AA(1,:) = reshape(X,1,h2*w2);
AA(2,:) = reshape(Y,1,h2*w2);

% 确定新图像的四个角
newAA = transform\AA;
new_left = fix(min([1,min(newAA(1,:)./newAA(3,:))]));
new_right = fix(max([w1,max(newAA(1,:)./newAA(3,:))]));
new_top = fix(min([1,min(newAA(2,:)./newAA(3,:))]));
new_bottom = fix(max([h1,max(newAA(2,:)./newAA(3,:))]));

newH = new_bottom - new_top + 1;
newW = new_right - new_left + 1;
x1 = new_left;
y1 = new_top;
x2 = 2 - new_left;
y2 = 2 - new_top;