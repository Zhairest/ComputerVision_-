function response= harris_corners(img,k,Q)

    % ����ͼ���Harris�ǵ�ֵ������㹫ʽ���£�
    %  R=Det(M)-k(Trace(M)^2).
  
    %   ����:
    %    img: ��״Ϊ (H, W)�ĻҶ�ͼ
    %      window_size: kernel�ĳߴ�
    %   k: ���жȵ������� 
    %kһ��ȡֵ0.04-0.06 
    %��Q*RMax��Ϊ��ֵ���ж�һ�����ǲ��ǽǵ�
    %Q=0.01;

    % ����ֵ:
     %   response: ͼ��Ľǵ���Ӧֵ (H, W)

     img = im2double(img);
    [height,width]= size(img);
    
    %1.����X�����Y������ݶȼ���ƽ�� ����sobel���Ӽ���ͼƬ�� �� �����ϵĵ�ƫ����(�Լ� )��
    X=imfilter(img,[-1 0 1]);
    X2=X.^2;
    Y=imfilter(img,[-1 0 1]');
    Y2=Y.^2;
    XY=X.*Y;
    
    %���ɸ�˹����ˣ���X2��Y2��XY����ƽ�� ����ÿ�����ص㣬����ƫ�����ĳ˻������ø�˹���ӽ���ƽ��
    h=fspecial('gaussian',[9 9],2);
    w=h*h';
    A=imfilter(X2,w);
    B=imfilter(Y2,w);
    C=imfilter(XY,w);
    
    %����ÿ�����ص㣬�������M������
    RMax=0;
    
    
    R=zeros(height,width);
    for h=1:height
        for w=1:width
            %����M����
            M=[A(h,w) C(h,w);C(h,w) B(h,w)];
             % ����ÿ�����ص㣬����ǵ���ӦֵR�����ж��Ƿ��Ǳ�Ե
            R(h,w)=det(M) - k*(trace(M)^2);
            %���R�����ֵ��֮������ȷ���жϽǵ����ֵ
            if(R(h,w)>RMax)
                RMax=R(h,w);
            end
        end
    end

    %�������ѵ�д��
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

    %������ֵ���˵�һ���ֵĽǵ㣬Ȼ�����÷Ǽ���ֵ���ƽ���ϸ��
   
 %   R_corner=(R>=(Q*RMax)).*R;

    %Ѱ��3x3�����ڵ����ֵ��ֻ��һ��������8�������Ǹ����������ʱ������Ϊ�õ��ǽǵ�
  %  fun = @(x) max(x(:)); 
  %  R_localMax = nlfilter(R,[3 3],fun); 

    %Ѱ�Ҽ�����ǵ���ֵ��������8�����������ֵ��ĵ���Ϊ�ǵ�
    %ע�⣺��Ҫ�޳���Ե��
   % [row,col]=find(R_localMax(2:height-1,2:width-1)==R_corner(2:height-1,2:width-1));
 
