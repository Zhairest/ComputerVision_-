
function [num, inliers] = ransac(matcher2, matcher1, length, errorhold)

ninlier = 0;
fpoints = 8; 
for i=1:2000
    %随机选取若干组match点
    rd = randi([1 length],1,fpoints);
    pR = matcher2(:,rd);
    pD = matcher1(:,rd);
    h = getHomographyMatrix(pR,pD,fpoints);
    %计算affine的变换矩阵 
    rref_P = h*matcher2;
    rref_P(1,:) = rref_P(1,:)./rref_P(3,:);
    rref_P(2,:) = rref_P(2,:)./rref_P(3,:);
    error = (rref_P(1,:) - matcher1(1,:)).^2 + (rref_P(2,:) - matcher1(2,:)).^2;
    n = nnz(error<errorhold);
    if(n >= length*.95)%计算有效数据点(inliers)的数目
        num=h;
        inliers = find(error<errorhold);
        break;
    elseif(n>ninlier)%记录有效点数目最大的那组参数
        ninlier = n;
        num=h;
        inliers = find(error<errorhold);
    end
end
