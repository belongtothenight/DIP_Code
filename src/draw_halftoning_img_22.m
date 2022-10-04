function draw_halftoning_img_22(imgp, fn, imgsp, md, showimg)
    % ========================
    % This function takes grayscale image as input, plot and export
    %    the halftoning image with 2x2 dither matrix.
    % ======Variable==========
    % imgp: image path
    % fn: file name
    % imgsp: image save path
    % md: mode
    % showimg: show image or not
    d22 = [0 128; 192 64]; %: 2x2 dither matrix
    [dh, dw] = size(d22); %: dither matrix size
    % ======DefaultValue======
    if nargin < 5
        imgp = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\luna_grayscale.jpg';
        fn = 'luna_grayscale_hg22_.jpg';
        imgsp = strcat('D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\', fn);
        md = 4;
        showimg = 0;
    end
    % ======Function==========
    function img = md1(imgp, d22, dh, dw, ih, iw);
        % This function process one pixel at a time. With the pixel coordinate
        %    calculation in multiple lines, it takes forever to process.
        % t: too long to test
        hl = round(ih / dh);
        wl = round(iw / dw);
        for i = 1:hl
            for j = 1:wl
                try
                    if img(i*2-1,j*2-1) > d22(1,1)
                        img(i*2-1,j*2-1) = 255;
                    else
                        img(i*2-1,j*2-1) = 0;
                    end
                end
                try
                    if img(i*2-1,j*2) > d22(1,2)
                        img(i*2-1,j*2) = 255;
                    else
                        img(i*2-1,j*2) = 0;
                    end
                end
                try
                    if img(i*2,j*2-1) > d22(2,1)
                        img(i*2,j*2-1) = 255;
                    else
                        img(i*2,j*2-1) = 0;
                    end
                end
                try
                    if img(i*2,j*2) > d22(2,2)
                        img(i*2,j*2) = 255;
                    else
                        img(i*2,j*2) = 0;
                    end
                end
            end
        end
    end
    function img = md2(img, d22, dh, dw, ih, iw);
        % This function process one pixel at a time. With the pixel coordinate
        %    calculation done at first, it takes less time than md1 to process.
        % t: 24.017s
        % pic: 1
        hl = round(ih / dh);
        wl = round(iw / dw);
        for i = 1:hl
            for j = 1:wl
                x1 = i*2-1;
                x2 = i*2;
                y1 = j*2-1;
                y2 = j*2;
                try
                    if img(x1, y1) < d22(1, 1)
                        img(x1, y1) = 0;
                    else
                        img(x1, y1) = 255;
                    end
                end
                try
                    if img(x1, y2) < d22(1, 2)
                        img(x1, y2) = 0;
                    else
                        img(x1, y2) = 255;
                    end
                end
                try
                    if img(x2, y1) < d22(2, 1)
                        img(x2, y1) = 0;
                    else
                        img(x2, y1) = 255;
                    end
                end
                try
                    if img(x2, y2) < d22(2, 2)
                        img(x2, y2) = 0;
                    else
                        img(x2, y2) = 255;
                    end
                end
            end
        end
    end
    function img = md3(img, d22, dh, dw, ih, iw);
        % This function process the square of 2x2 pixels at a time.
        % t: 11.799s (border unprocessed)
        % pic: 2 (border unprocessed)
        % t: 38.436s (border processed)
        % pic: 3 (border processed)
        hl = round(ih / dh);
        wl = round(iw / dw);
        for i = 1:hl
            for j = 1:wl
                x1 = i*2-1;
                x2 = i*2;
                y1 = j*2-1;
                y2 = j*2;
                try
                   img(x1:x2, y1:y2) = img(x1:x2, y1:y2) > d22;
                catch
                    try
                        if img(i*2-1,j*2-1) > d22(1,1)
                            img(i*2-1,j*2-1) = 255;
                        else
                            img(i*2-1,j*2-1) = 0;
                        end
                    end
                    try
                        if img(i*2-1,j*2) > d22(1,2)
                            img(i*2-1,j*2) = 255;
                        else
                            img(i*2-1,j*2) = 0;
                        end
                    end
                    try
                        if img(i*2,j*2-1) > d22(2,1)
                            img(i*2,j*2-1) = 255;
                        else
                            img(i*2,j*2-1) = 0;
                        end
                    end
                    try
                        if img(i*2,j*2) > d22(2,2)
                            img(i*2,j*2) = 255;
                        else
                            img(i*2,j*2) = 0;
                        end
                    end
                end
            end
        end
        img = img * 255;
    end
    function img = md4(img, d22, dh, dw, ih, iw)
        % This function expand the dither matrix to the size of the image.
        % t: 0.0018997s (border unprocessed)
        % pic: 4 (border unprocessed)
        % t: 0.00099945s (border processed)
        % pic: 5 (border processed)
        hl = ceil(ih / dh)-1;
        wl = ceil(iw / dw)-1;
        hr = ih - hl * dh;
        wr = iw - wl * dw;
        dbuf = repmat(d22, hl, wl);
        % dbuf = [dbuf, d22(:, 1:wr)]; %horizontal
        dbuf = [dbuf, repmat(d22(:,wr), hl, wr)]; %horizontal
        % dbuf = [dbuf; zeros(1, 225)]; %vertical
        dbuf = [dbuf; [repmat(d22(hr,:), hr, wl), d22(1:hr,wr)]]; %vertical
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

    % halftoning
    [ih, iw] = size(img);
    if md == 1
        img = md1(img, d22, dh, dw, ih, iw);
    elseif md == 2
        img = md2(img, d22, dh, dw, ih, iw);
    elseif md == 3
        img = md3(img, d22, dh, dw, ih, iw);
    elseif md == 4
        img = md4(img, d22, dh, dw, ih, iw);
    else
        disp('Error: md incorrect');
    end

    % show image
    elapsed_time = etime (clock (), t0)
    img = mat2gray(img, [0 255]);
    if showimg == 1
        imshow(img);
    end
    imwrite(img, imgsp);
end
