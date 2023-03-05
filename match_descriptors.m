function [matchedPoints1,matchedPoints2,matcher1,matcher2,indexPairss]=match_descriptors(img1,img2,out1,out2,point1,point2)
   
    indexPairss=[];
   [matcher1,matcher2,xp1,yp1,xp2,yp2]= Euclidean(out1,out2,point1(:,1),point1(:,2),point2(:,1),point2(:,2),0.5);
    for o=1:size(matcher1,2)
       indexPairss(o,1)=o;
       indexPairss(o,2)=o;
    end
    indexPairss=size(indexPairss,1);
    k=matcher1';
    matchedPoints1(:,2)=k(:,2);
    matchedPoints1(:,1)=k(:,1);
    k=matcher2';
    matchedPoints2(:,2)=k(:,2);
    matchedPoints2(:,1)=k(:,1);
    [a,b]=size(img1);
    im1=zeros(a,2*b);
    for i=1:a
        for j=1:b
            im1(i,j)=img1(i,j);
        end
    end
    for i=1:a
        for j=b+1:2*b
            im1(i,j)=img2(i,j-b);
        end
    end
    figure;
    imshow(im1);
    hold on;
    for i=1:size(matcher1,2)
        plot(yp1(i),xp1(i),'ro');
        plot(yp2(i)+b,xp2(i),'ro');
        plot([matcher1(1,i),matcher2(1,i)+b],[matcher1(2,i),matcher2(2,i)],'Color',[rand(),rand(),rand()]);
    end

    hold off;
end


function [matcher_A,matcher_B,x_A,y_A,x_B,y_B] = Euclidean(des_A,des_B,x_A,y_A,x_B,y_B,threshold) %欧式距离
    dist = distance(des_A,des_B);
    [ord_dist, index] = sort(dist, 2);    %对dist中各行元素进行升序排序
    ratio = ord_dist(:,1)./ord_dist(:,2);
    index0 = ratio<threshold;

    x_A = x_A(index0);
    y_A = y_A(index0);
    x_B = x_B(index(index0,1));
    y_B = y_B(index(index0,1));
    npoints = length(x_A);
    matcher_A = [y_A, x_A, ones(npoints,1)]';
    matcher_B = [y_B, x_B, ones(npoints,1)]';

end



function dist = distance(x, c)%用于求距离
    [ndata, ~] = size(x);
    [ncentres, ~] = size(c);
    dist = (ones(ncentres, 1) * sum((x.^2)', 1))' + ones(ndata, 1) * sum((c.^2)',1) - 2.*(x*(c'));
end