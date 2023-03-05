function [hh] = getHomographyMatrix(point_ref, point_src, npoints)
% 获得变换矩阵
% 输出
% h --- 变换矩阵

x_ref = point_ref(1,:)';
y_ref = point_ref(2,:)';
x_src = point_src(1,:)';
y_src = point_src(2,:)';

% 线性方程右边的系数
A = zeros(npoints*2,8);
A(1:2:end,1:3) = [x_ref, y_ref, ones(npoints,1)];
A(2:2:end,4:6) = [x_ref, y_ref, ones(npoints,1)];
A(1:2:end,7:8) = [-x_ref.*x_src, -y_ref.*x_src];
A(2:2:end,7:8) = [-x_ref.*y_src, -y_ref.*y_src];

% 线性方程左边的系数
B = [x_src, y_src];
B = reshape(B',npoints*2,1);

% 解线性方程组
h = A\B;

hh = [h(1),h(2),h(3);h(4),h(5),h(6);h(7),h(8),1];