function  universe=HOG(img,~,location)
    [height, width]=size(img);
    img=sqrt(img);      %٤��У��
    %���������ͼ����ݶȺ�ÿ�����ص��Ӧ���ݶȷ���
    angle_range=45;
    tidu=zeros(height,width);
    [row,col] = size(img);            %��x���������죬��y����������.size��������Ӧ��(row,col)�ֱ���x�У�y��
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
    %�ƶ�����
    for i = 1:row
        for j = 1:col
            %ģ���ƶ�����
            W = [calculate_image(i,j),calculate_image(i,j+1),calculate_image(i,j+2);calculate_image(i+1,j),calculate_image(i+1,j+1),calculate_image(i+1,j+2);calculate_image(i+2,j),calculate_image(i+2,j+1),calculate_image(i+2,j+2)];
            Sx = Hx .* W;
            Sy = Hy .* W;
            gradx_image(i+1,j+1) = sum(sum(Sx));
            grady_image(i+1,j+1) = sum(sum(Sy));
            a=gradx_image(i+1,j+1);
            b=grady_image(i+1,j+1);
            %�����ÿ�����ص���ݶȷ��򶼼�¼������
            ang=atan2(a, b);   %���ص���[-pi,pi]֮��Ļ���ֵ
            ang=mod(ang*180/pi,360);   %�ѽǶ�Ϊ��
            ang=ang+0.0000001; %��ֹangΪ0
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
            %�����ݶ�ֱ��ͼ ��ͼƬ�ֳ����ɸ�cell������ÿ��cell�����ݶ�ֱ��ͼ ��2*2��cell��
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
        %�����ɸ�cell�ϳ�һ��block������������ݶ�ֱ��ͼת���������� ����4��cell�ϲ���һ��block��������������
        for u=1:36
           universe(i,u)= temp(u);
        end
    end
end