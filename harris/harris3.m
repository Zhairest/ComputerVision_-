clc;clear;close all;

img=imread('uttower1.jpg');
img_gray=rgb2gray(img);

psf=fspecial('gaussian',[5,5],1);
Ix=filter2([-1,0,1],img_gray);
Iy=filter2([-1,0,1]',img_gray);
Ix2=filter2(psf,Ix.^2);
Iy2=filter2(psf,Iy.^2);
Ixy=filter2(psf,Ix.*Iy);

[m,n]=size(img_gray);
R=zeros(m,n);
max=0;
for i=1:m
    for j=1:n
        M=[Ix2(i,j),Ixy(i,j); Ixy(i,j),Iy2(i,j)];
        R(i,j)=det(M)-0.05*(trace(M))^2;
        if R(i,j)>max
            max=R(i,j);
        end
    end
end

thresh=0.1;%��ֵ�ɵ�
tmp=zeros(m,n);
neighbours=[-1,-1;-1,0;-1,1;0,-1;0,1;1,-1;1,0;1,1];
for i=2:m-1
    for j=2:n-1
        if R(i,j)>thresh*max
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

imshow(img),title('�ǵ���');
hold on;
for i=2:m-1
    for j=2:n-1
        if tmp(i,j)==1
            plot(j,i,'rx')
        end
    end
end
hold off;      
