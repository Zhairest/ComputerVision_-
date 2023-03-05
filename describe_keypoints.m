function [out,point,location] = describe_keypoints(input_image,response)
    [H,W]=size(input_image); 
    out=[];
    point=[];
    location=[];
    img=input_image;
    img=padarray(img, [8,8]);
    response=padarray(response, [8,8]);
     num=1;
    %�򵥵�����������Χ��һ���̶���С��window����������������
    for i=9:H-8 %��Ϊ���ÿ�Ϊ16*16 ���Դ�9��ʼѭ������֤���ܿ�ȫ��������
      for j=9:W-8
            if(response(i,j)==1)    
                middle=img(i-8:i+7,j-8:j+7);
                out(num,:)=middle(:)';%����������
                point(num,1)=i-8;%���λ��
                point(num,2)=j-8;
                o=1;
                for k=i-8: i+7
                   for l=j-8:j+7
                        location(num,o,1)=k;
                        location(num,o,2)=l;
                       o=o+1;
                   end
                end
                num=num+1;
            end
      end
    end
    disp(num);
end