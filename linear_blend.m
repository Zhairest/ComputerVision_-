function [newImage] = linear_blend(warped_image, unwarped_image, x, y)
%�����ں�

%ȷ���ں��������߽���ұ߽�
warped_image(isnan(warped_image))=0;
%��ͼƬ1ȷ��һ��Ȩ�ؾ���: - ��ͼƬ1������ߵ��ں����������ߣ�weightΪ1 - ���ں����������ߵ�ͼƬ1�����ұߣ�weight��1��0���зֲ� 
maskA = (warped_image(:,:,1)>0 |warped_image(:,:,2)>0 | warped_image(:,:,3)>0);
newImage = zeros(size(warped_image));
newImage(y:y+size(unwarped_image,1)-1, x: x+size(unwarped_image,2)-1,:) = unwarped_image;
mask = (newImage(:,:,1)>0 | newImage(:,:,2)>0 | newImage(:,:,3)>0);
mask = and(maskA, mask);

% �ֱ����������ͼƬӦ��Ȩ�ؾ���
[~,col] = find(mask);
left = min(col);
right = max(col);
mask = ones(size(mask));
if( x<2)
    mask(:,left:right) = repmat(linspace(0,1,right-left+1),size(mask,1),1);
else
    mask(:,left:right) = repmat(linspace(1,0,right-left+1),size(mask,1),1);
end

% ÿ��ͨ�����
warped_image(:,:,1) = warped_image(:,:,1).*mask;
warped_image(:,:,2) = warped_image(:,:,2).*mask;
warped_image(:,:,3) = warped_image(:,:,3).*mask;

% ��תalphaֵ
if( x<2)
    mask(:,left:right) = repmat(linspace(1,0,right-left+1),size(mask,1),1);
else
    mask(:,left:right) = repmat(linspace(0,1,right-left+1),size(mask,1),1);
end
newImage(:,:,1) = newImage(:,:,1).*mask;
newImage(:,:,2) = newImage(:,:,2).*mask;
newImage(:,:,3) = newImage(:,:,3).*mask;

%������ͼ���
newImage(:,:,1) = warped_image(:,:,1) + newImage(:,:,1);
newImage(:,:,2) = warped_image(:,:,2) + newImage(:,:,2);
newImage(:,:,3) = warped_image(:,:,3) + newImage(:,:,3);

end