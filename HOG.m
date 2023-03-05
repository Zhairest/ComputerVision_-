function  universe=HOG(img,~,location)
    [height, width]=size(img);
    img=sqrt(img);      %伽马校正
    %以下先求出图像的梯度和每个像素点对应的梯度方向
    angle_range=45;
    tidu=zeros(height,width);
    [row,col] = size(img);            %正x轴向下延伸，正y轴向右延伸.size函数所对应的(row,col)分别是x行，y列
    double_image = double(img);
    calculate_image = zeros(row+2,col+2);
    for i = 2:row+1
        for j = 2:col+1
            calculate_image(i,j) = double_image(i-1,j-1);
        end
    end
    Hx = [-1,-2,-1;0,0,0;1,2,1];
    Hy = Hx';
    gradx_image = zeros(row+2,col+2);
    grady_image = zeros(row+2,col+2);
    %移动窗口
    for i = 1:row
        for j = 1:col
            %模板移动窗口
            W = [calculate_image(i,j),calculate_image(i,j+1),calculate_image(i,j+2);calculate_image(i+1,j),calculate_image(i+1,j+1),calculate_image(i+1,j+2);calculate_image(i+2,j),calculate_image(i+2,j+1),calculate_image(i+2,j+2)];
            Sx = Hx .* W;
            Sy = Hy .* W;
            gradx_image(i+1,j+1) = sum(sum(Sx));
            grady_image(i+1,j+1) = sum(sum(Sy));
            a=gradx_image(i+1,j+1);
            b=grady_image(i+1,j+1);
            %这里把每个像素点的梯度方向都记录下来了
            ang=atan2(a, b);   %返回的是[-pi,pi]之间的弧度值
            ang=mod(ang*180/pi,360);   %把角度为正
            ang=ang+0.0000001; %防止ang为0
            tidu(i,j) = floor(ang/angle_range);

        end
    end
    gradx_image = abs(gradx_image);
    grady_image = abs(grady_image);
    gradx = zeros(row,col);
    grady = zeros(row,col);
    for i = 1:row
        for j = 1:col
            gradx(i,j) = gradx_image(i+1,j+1);
            grady(i,j) = grady_image(i+1,j+1);
        end
    end
    global people;
    people=zeros(4,9);
    universe=zeros(size(location,1),36);
    for i = 1:size(location,1)
        k=1;
        temp=zeros(4,9);
        for j=1:size(location,2)
            a=location(i,j,1);
            b=location(i,j,2);
            %计算梯度直方图 将图片分成若干个cell，并对每个cell计算梯度直方图 （2*2个cell）
            if b<=width&&a<=height
                if(ceil(k/16)<=8 && (k-ceil(k/16)*16)<=8)
                temp(1,tidu(a,b)+1)=temp(1,tidu(a,b)+1)+sqrt(gradx(a,b)*gradx(a,b)+grady(a,b)*grady(a,b));
                end
                if(ceil(k/16)<=8 && (k-ceil(k/16)*16)>8)
                    temp(2,tidu(a,b)+1)=temp(2,tidu(a,b)+1)+sqrt(gradx(a,b)*gradx(a,b)+grady(a,b)*grady(a,b));
                end
                if(ceil(k/16)>8 && (k-ceil(k/16)*16)<=8)
                    disp(temp(3,tidu(a,b)+1));
                    temp(3,tidu(a,b)+1)=temp(3,tidu(a,b)+1)+sqrt(gradx(a,b)*gradx(a,b)+grady(a,b)*grady(a,b));
                end
                if(ceil(k/16)>8 && (k-ceil(k/16)*16)>8)
                    temp(4,tidu(a,b)+1)=temp(4,tidu(a,b)+1)+sqrt(gradx(a,b)*gradx(a,b)+grady(a,b)*grady(a,b));
                end
            end
            k=k+1;
        end
        temp=temp(:)';
        %将若干个cell合成一个block，并将里面的梯度直方图转成特征向量 （将4个cell合并成一个block生成特征向量）
        for u=1:36
           universe(i,u)= temp(u);
        end
    end
end