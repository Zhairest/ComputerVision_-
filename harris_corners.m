function response= harris_corners(img,k,Q)

    % 计算图像的Harris角点值，其计算公式如下：
    %  R=Det(M)-k(Trace(M)^2).
  
    %   参数:
    %    img: 形状为 (H, W)的灰度图
    %      window_size: kernel的尺寸
    %   k: 敏感度调节因子 
    %k一般取值0.04-0.06 
    %用Q*RMax作为阈值，判断一个点是不是角点
    %Q=0.01;

    % 返回值:
     %   response: 图像的角点响应值 (H, W)

     img = im2double(img);
    [height,width]= size(img);
    
    %1.计算X方向和Y方向的梯度及其平方 利用sobel算子计算图片在 和 方向上的的偏导数(以及 )。
    X=imfilter(img,[-1 0 1]);
    X2=X.^2;
    Y=imfilter(img,[-1 0 1]');
    Y2=Y.^2;
    XY=X.*Y;
    
    %生成高斯卷积核，对X2、Y2、XY进行平滑 对于每个像素点，计算偏导数的乘积，并用高斯算子进行平滑
    h=fspecial('gaussian',[9 9],2);
    w=h*h';
    A=imfilter(X2,w);
    B=imfilter(Y2,w);
    C=imfilter(XY,w);
    
    %对于每个像素点，计算矩阵M，其中
    RMax=0;
    
    
    R=zeros(height,width);
    for h=1:height
        for w=1:width
            %计算M矩阵
            M=[A(h,w) C(h,w);C(h,w) B(h,w)];
             % 对于每个像素点，计算角点响应值R用于判断是否是边缘
            R(h,w)=det(M) - k*(trace(M)^2);
            %获得R的最大值，之后用于确定判断角点的阈值
            if(R(h,w)>RMax)
                RMax=R(h,w);
            end
        end
    end

    %换用室友的写法
    tmp=zeros(height,width);
    neighbours=[-1,-1;
                -1,0;
                -1,1;
                0,-1;
                0,1;
                1,-1;
                1,0;
                1,1];
            
    for i=2:height-1
        for j=2:width-1
            if R(i,j)>Q*RMax
                for k=1:8
                    if R(i,j)<R(i+neighbours(k,1),j+neighbours(k,2))
                        break;
                    end
                end
                if k==8
                    tmp(i,j)=1;
                end
            end
        end
    end

    response=tmp;
end

    %先用阈值过滤掉一部分的角点，然后再用非极大值抑制进行细化
   
 %   R_corner=(R>=(Q*RMax)).*R;

    %寻找3x3邻域内的最大值，只有一个交点在8邻域内是该邻域的最大点时，才认为该点是角点
  %  fun = @(x) max(x(:)); 
  %  R_localMax = nlfilter(R,[3 3],fun); 

    %寻找既满足角点阈值，又在其8邻域内是最大值点的点作为角点
    %注意：需要剔除边缘点
   % [row,col]=find(R_localMax(2:height-1,2:width-1)==R_corner(2:height-1,2:width-1));
 
