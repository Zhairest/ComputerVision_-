function [newH, newW, x1, y1, x2, y2] = getNewSize(transform, h2, w2, h1, w1)
% ������ͼƬ�Ĵ�С
% ����
% transform - h����
% h1 - δŤ��ͼ��ĸ߶�
% w1 - δŤ��ͼ��Ŀ��
% h2 - Ť��ͼ��ĸ߶�
% w2 - Ť��ͼ��Ŀ��
% ���
% newH - ��ͼ��߶�
% newW - ��ͼ����
% x1 - ��ͼ�����Ͻǵ�x����
% y1 - ��ͼ�����Ͻǵ�y����
% x2 - δ����ͼ�����Ͻǵ�x����
% y2 - δ����ͼ�����Ͻǵ�y����

% ΪŤ����ͼ�񴴽�����-����
[X,Y] = meshgrid(1:w2,1:h2);
AA = ones(3,h2*w2);
AA(1,:) = reshape(X,1,h2*w2);
AA(2,:) = reshape(Y,1,h2*w2);

% ȷ����ͼ����ĸ���
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