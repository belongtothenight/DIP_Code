function draw_halftoning_gimg(imgp, fn, dm, imgsp, showimg)
    % ========================
    % This function takes grayscale image as input, plot and export
    %    the halftoning image with 2x2 dither matrix.
    % ======Variable==========
    % imgp: image path
    % fn: file name
    % dm: dimension of dither matrix
    % imgsp: image save path
    % showimg: show image or not
    d22 = [0 128; 192 64]; %: 2x2 dither matrix
    % ======DefaultValue======
    if nargin < 5
        imgp = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\luna_grayscale.jpg';
        fn = 'luna_grayscale_hg_.jpg';
        dm = 2; % can cause error if the number is too big
        imgsp = strcat('D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\', fn);
        showimg = 1;
    end
    % ======Function==========
    function img = thg(img, dnn, dh, dw, ih, iw)
        hl = ceil(ih / dh);
        if mod(ih, dh) ~= 0
            hl = hl - 1;
        end
        wl = ceil(iw / dw);
        if mod(iw, dw) ~= 0
            wl = wl - 1;
        end
        hr = ih - hl * dh;
        wr = iw - wl * dw;
        dbuf = repmat(dnn, hl, wl);
        if wr ~= 0
            dbuf = [dbuf, repmat(dnn(:,wr), hl, wr)]; %horizontal
        end
        if hr ~= 0
            dbuf = [dbuf; [repmat(dnn(hr,:), hr, wl), dnn(1:hr,wr)]]; %vertical
        end
        img = (img > dbuf) * 255;
    end
    % ======Main==============
    % load image
    img = imread(imgp);
    try
        % necessary if using Matlab
        img = rgb2gray(img);
    end
    img = double(img); % affect writing image
    t0 = clock();
    [ih, iw] = size(img);
    if ih > (dm * 2) && iw > (dm * 2)
        dnn = d22;
        for i = 1:dm-1
            dnn = [dnn dnn+32; dnn+48 dnn+16];
        end
    else
        disp('Select a smaller dither matrix');
        return
    end
    [dh, dw] = size(dnn); %: dither matrix size

    % halftoning
    img = thg(img, dnn, dh, dw, ih, iw);

    % show image
    elapsed_time = etime (clock (), t0)
    img = mat2gray(img, [0 255]);
    if showimg == 1
        imshow(img);
    end
    imwrite(img, imgsp);
end
