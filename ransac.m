
function [num, inliers] = ransac(matcher2, matcher1, length, errorhold)

ninlier = 0;
fpoints = 8; 
for i=1:2000
    %���ѡȡ������match��
    rd = randi([1 length],1,fpoints);
    pR = matcher2(:,rd);
    pD = matcher1(:,rd);
    h = getHomographyMatrix(pR,pD,fpoints);
    %����affine�ı任���� 
    rref_P = h*matcher2;
    rref_P(1,:) = rref_P(1,:)./rref_P(3,:);
    rref_P(2,:) = rref_P(2,:)./rref_P(3,:);
    error = (rref_P(1,:) - matcher1(1,:)).^2 + (rref_P(2,:) - matcher1(2,:)).^2;
    n = nnz(error<errorhold);
    if(n >= length*.95)%������Ч���ݵ�(inliers)����Ŀ
        num=h;
        inliers = find(error<errorhold);
        break;
    elseif(n>ninlier)%��¼��Ч����Ŀ�����������
        ninlier = n;
        num=h;
        inliers = find(error<errorhold);
    end
end
