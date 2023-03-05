function response = harrisBy(image)

 %����ͼ���Harris�ǵ�ֵ������㹫ʽ���£�
        %R=Det(M)-k(Trace(M)^2).
 %����:
       % img: ��״Ϊ (H, W)�ĻҶ�ͼ
 %����ֵ:
        %response: ͼ��Ľǵ���Ӧֵ (H, W)
    [H,W]=size(image);
    window=ones(3,3);
    response=zeros(H,W);

    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����sobel���Ӽ���ͼƬ�� �� �����ϵĵ�ƫ����(�Լ� )��
    uSobel = imag;
    for i = 2:high - 1   %sobel��Ե���
        for j = 2:width - 1
            Gx = (U(i+1,j-1) + 2*U(i+1,j) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i-1,j) + F2(i-1,j+1));
            Gy = (U(i-1,j+1) + 2*U(i,j+1) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i,j-1) + F2(i+1,j-1));
            uSobel(i,j) = sqrt(Gx^2 + Gy^2); 
        end
    end
  

end

def harris_corners(img, window_size=3, k=0.04):
   
    #img = img[:,:,0]   #���29�б������28�е�img = [:,:,0]��ע��ȡ��
   
    dx = filters.sobel_v(img)
    dy = filters.sobel_h(img)
    
    
    ### YOUR CODE HERE
    #M = np.ones((H, W,2, 2))
    #padded_dx = np.pad(dx, int((window_size-1)/2), mode='edge')
    #padded_dy = np.pad(dy, int((window_size-1)/2), mode='edge')
    #for i in range(H):
        #for j in range(W):
            #M[i, j, :, :] = np.array([[sum(sum(b) for b in (padded_dx[i:i+2, j:j+2]*padded_dx[i:i+2, j:j+2])),sum(sum(b) for b in (padded_dx[i:i+2, j:j+2]*padded_dy[i:i+2, j:j+2]))],[sum(sum(b) for b in (padded_dx[i:i+2, j:j+2]*padded_dy[i:i+2, j:j+2])),sum(sum(b) for b in (padded_dy[i:i+2, j:j+2]*padded_dy[i:i+2, j:j+2]))]])
    #for a in range(H):
        #for b in range(W):
            #response[a][b]=np.linalg.det(M[a][b])-k*(np.trace(M[a][b])**2)

    dxx = dx * dx
    dyy = dy * dy
    dxy = dx * dy
    mxx = convolve(dxx, window)
    mxy = convolve(dxy, window)
    myy = convolve(dyy, window)    
    for i in range(H):
        for j in range(W):
            M = np.array([[mxx[i, j], mxy[i, j]], [mxy[i, j], myy[i, j]]])
            response[i, j] = np.linalg.det(M) - k * np.trace(M) ** 2
    ### END YOUR CODE
    return response

���ߣ�κ��
���ӣ�https://juejin.cn/post/6844904088094638094
��Դ��ϡ�����
����Ȩ���������С���ҵת������ϵ���߻����Ȩ������ҵת����ע��������