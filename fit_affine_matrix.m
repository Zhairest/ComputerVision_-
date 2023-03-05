function fit_affine_matrix(img1,img2,m1,m2)

    [m1,normMatrix1] = images.geotrans.internal.normalizeControlPoints(m1);
    [m2,normMatrix2] = images.geotrans.internal.normalizeControlPoints(m2);

    minRequiredNonCollinearPairs = 2;
    M = size(m2,1);

    x = m2(:,1);
    y = m2(:,2);
    X = [x   y  ones(M,1)   zeros(M,1);
         y  -x  zeros(M,1)  ones(M,1)  ];

    u = m1(:,1);
    v = m1(:,2);
    U = [u; v];

    if rank(X) >= 2*minRequiredNonCollinearPairs 
        r = X \ U;    
    end

    sc = r(1);
    ss = r(2);
    tx = r(3);
    ty = r(4);

    Tinv = [sc -ss 0;
            ss  sc 0;
            tx  ty 1];

    Tinv = normMatrix2 \ (Tinv * normMatrix1);

    T = inv(Tinv);
    T(:,3) = [0 0 1]';
    %这里得到了转换矩阵
    tform = affine2d(T);
    % 进行仿射变换
    Jregistered = imwarp(img1,tform,'OutputView',imref2d(size(img2)));
    img3=img1;
    img4=img2;
    figure;
    imshow(Jregistered);    
    Rfixed = imref2d(size(img4));
    [registered2, Rregistered] = imwarp(img3, tform);
    figure();
    imshowpair(img4,Rfixed,registered2,Rregistered,'blend');
end