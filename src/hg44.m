function hg44(imgp, fn, imgsp, showimg)
    % ========================
    % This function takes grayscale image as input, plot and export
    %    the halftoning image with 2x2 dither matrix.
    % ======Variable==========
    % imgp: image path
    % fn: file name
    % imgsp: image save path
    % showimg: show image or not
    d22 = [0 128; 192 64]; %: 2x2 dither matrix
    d44 = [d22 d22+32; d22+48 d22+16]; %: 4x4 dither matrix
    [dh, dw] = size(d44); %: dither matrix size
    % ======DefaultValue======
    if nargin < 4
        imgp = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\luna_grayscale.jpg';
        fn = 'luna_grayscale_hg44_.jpg';
        imgsp = strcat('D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\', fn);
        showimg = 1;
    end
    % ======Function==========
    function img = hg(img, d44, dh, dw, ih, iw)
        hl = ceil(ih / dh)-1;
        wl = ceil(iw / dw)-1;
        hr = ih - hl * dh;
        wr = iw - wl * dw;
        dbuf = repmat(d44, hl, wl);
        dbuf = [dbuf, repmat(d44(:,wr), hl, wr)]; %horizontal
        dbuf = [dbuf; [repmat(d44(hr,:), hr, wl), d44(1:hr,wr)]]; %vertical
        img = (img > dbuf) * 255;
    end
    % ======Main==============
    % load image
    img = imread(imgp);
    img = double(img); % affect writing image
    t0 = clock();

    % halftoning
    [ih, iw] = size(img);
    img = hg(img, d44, dh, dw, ih, iw);

    % show image
    elapsed_time = etime (clock (), t0)
    img = mat2gray(img, [0 255]);
    if showimg == 1
        imshow(img);
    end
    imwrite(img, imgsp);
end
