function [newImage] = linear_blend(warped_image, unwarped_image, x, y)
%线性融合

%确定融合区域的左边界和右边界
warped_image(isnan(warped_image))=0;
%给图片1确定一个权重矩阵: - 从图片1的最左边到融合区域的最左边，weight为1 - 从融合区域的最左边到图片1的最右边，weight从1到0进行分布 
maskA = (warped_image(:,:,1)>0 |warped_image(:,:,2)>0 | warped_image(:,:,3)>0);
newImage = zeros(size(warped_image));
newImage(y:y+size(unwarped_image,1)-1, x: x+size(unwarped_image,2)-1,:) = unwarped_image;
mask = (newImage(:,:,1)>0 | newImage(:,:,2)>0 | newImage(:,:,3)>0);
mask = and(maskA, mask);

% 分别对左右两张图片应用权重矩阵
[~,col] = find(mask);
left = min(col);
right = max(col);
mask = ones(size(mask));
if( x<2)
    mask(:,left:right) = repmat(linspace(0,1,right-left+1),size(mask,1),1);
else
    mask(:,left:right) = repmat(linspace(1,0,right-left+1),size(mask,1),1);
end

% 每个通道混合
warped_image(:,:,1) = warped_image(:,:,1).*mask;
warped_image(:,:,2) = warped_image(:,:,2).*mask;
warped_image(:,:,3) = warped_image(:,:,3).*mask;

% 反转alpha值
if( x<2)
    mask(:,left:right) = repmat(linspace(1,0,right-left+1),size(mask,1),1);
else
    mask(:,left:right) = repmat(linspace(0,1,right-left+1),size(mask,1),1);
end
newImage(:,:,1) = newImage(:,:,1).*mask;
newImage(:,:,2) = newImage(:,:,2).*mask;
newImage(:,:,3) = newImage(:,:,3).*mask;

%将两张图相加
newImage(:,:,1) = warped_image(:,:,1) + newImage(:,:,1);
newImage(:,:,2) = warped_image(:,:,2) + newImage(:,:,2);
newImage(:,:,3) = warped_image(:,:,3) + newImage(:,:,3);

end