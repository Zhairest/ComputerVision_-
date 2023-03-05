function [out,point,location] = describe_keypoints(input_image,response)
    [H,W]=size(input_image); 
    out=[];
    point=[];
    location=[];
    img=input_image;
    img=padarray(img, [8,8]);
    response=padarray(response, [8,8]);
     num=1;
    %简单地在特征点周围框定一个固定大小的window来进行特征点描述
    for i=9:H-8 %因为设置框为16*16 所以从9开始循环，保证框能框全而不超限
      for j=9:W-8
            if(response(i,j)==1)    
                middle=img(i-8:i+7,j-8:j+7);
                out(num,:)=middle(:)';%换成行向量
                point(num,1)=i-8;%标记位置
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