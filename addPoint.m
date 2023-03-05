function addPoint(orinimg,img,response)
 
    [m,n]=size(img);
    figure;
    imshow(orinimg);
    hold on;
        for i=2:m-1
            for j=2:n-1
                if response(i,j)==1
                    plot(j,i, 'r*')
                end
            end
        end
    hold off; 
end