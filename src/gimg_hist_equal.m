function img1 = gimg_hist_equal(imgsrc, imgdst, speedtest, show, export)
    % ========================
    % This function takes grayscale image as input, performs point 
    %    processing - histogram equalization, to improve the contrast.
    % ======Variable==========
    % imgsrc:     image source path
    % imgdst:     image destination path
    % speedtest:  1 for speed test, 0 for normal conversion
    % show:       1 for showing the image, 0 for not showing
    % export:     1 for exporting the image, 0 for not exporting
    runs = 1e04;
    % ======DefaultValue======
    if nargin < 5
        imgsrc = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\lena_g_225.jpg';
        imgdst = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\img_hist_equal\lena_g_255_he_.jpg';
        speedtest = 1;
        show = 0;
        export = 0;
    end
    histdst1 = imgdst(1:end-5) + "_hist_origin.jpg";
    histdst2 = imgdst(1:end-5) + "_hist_he1.jpg";
    histdst3 = imgdst(1:end-5) + "_hist_he2.jpg";
    % ======Function==========
    function img = he1(img)
        [ih, iw] = size(img);
        L = max(img(:)) + 1;
        uni = unique(img);
        unilen = length(uni);
        T = zeros(1, L);
        % count of each gray level
        for i = 1:unilen
            T(uni(i)+1) = sum(img(:) == uni(i));
        end
        % cumulative distribution
        for i = 2:L
            T(i) = T(i) + T(i-1);
        end
        % equalize histogram
        for i = 1:L
            T(i) = T(i) / (ih * iw) * (L-1);
        end
        % equalize image
        for i = 1:ih
            for j = 1:iw
                img(i,j) = T(img(i,j)+1);
            end
        end
    end
    function img = he2(img)
        [ih, iw] = size(img);
        L = max(img(:)) + 1;
        uni = unique(img);
        unilen = length(uni);
        T = zeros(1, L);
        % count of each gray level
        for i = 1:unilen
            T(uni(i)+1) = sum(img(:) == uni(i));
        end
        % cumulative distribution
        for i = 2:L
            T(i) = T(i) + T(i-1);
        end
        % equalize histogram
        for i = 1:L
            T(i) = T(i) / (ih * iw) * (L-1);
        end
        % equalize image
        img = T(img+1);
    end
    % ======Main==============
    % load image
    img = imread(imgsrc);
    try
        % necessary if using Matlab
        img = rgb2gray(img);
    end
    img = double(img); % affect writing image

    % halftoning
    if speedtest == 1
        tic
        for i = 1:runs
            img1 = he1(img);
            img1 = mat2gray(img1, [0 255]);
        end
        elapsed_time1 = toc;
        avget1 = elapsed_time1/runs;
        fprintf('\nfinished fuunction 1 in %f seconds', elapsed_time1);
        tic
        for i = 1:runs
            img2 = he2(img);
            img2 = mat2gray(img2, [0 255]);
        end
        elapsed_time2 = toc;
        avget2 = elapsed_time2/runs;
        fprintf('\nfinished function 2 in %f seconds', elapsed_time2);
        fprintf('\nTotal runs: %d times.\n', runs);
        fprintf('Total elapsed time: %f / %f seconds.\n', elapsed_time1, elapsed_time2);
        fprintf('Averaged elapsed time: %f / %f seconds.\n', avget1, avget2);
        fprintf('Speed up on average %f seconds, %f times, %f %% of original time.\n', avget1-avget2, avget1/avget2, (avget1-avget2)/avget1*100);
    else
        tic;
        img1 = he1(img);
        img1 = mat2gray(img1, [0 255]);
        elapsed_time1 = toc;
        tic;
        img2 = he2(img);
        img2 = mat2gray(img2, [0 255]);
        elapsed_time2 = toc;
        fprintf('\nElapsed time (1/2): %f/%f\n', elapsed_time1, elapsed_time2);
        if img1 == img2
            fprintf('img1 == img2\n');
        else
            fprintf('img1 != img2\n');
        end
    end

    % show & export image
    if show == 1
        figure('visible','off');
        % original histogram
        clf
        img = imread(imgsrc);
        imhist(img);
        saveas(gcf, histdst1)
        % histogram 1
        clf
        imwrite(img1, histdst2);
        img1 = imread(histdst2);
        imhist(img1);
        saveas(gcf, histdst2)
        % histogram 2
        clf
        imwrite(img2, histdst3);
        img2 = imread(histdst3);
        imhist(img2);
        saveas(gcf, histdst3)
        % show image
        close all force
        figure('visible','on');
        h0 = imread(histdst1);
        h1 = imread(histdst2);
        h2 = imread(histdst3);
        montage({imgsrc, img1, img2, h0, h1, h2}, 'size', [2 3]);
        title('Histogram Equalization: original / modified1 / modified2');
    end
    if export == 1
        imwrite(img1, imgdst);
    end
    fprintf('finished executing\n\n');
end

% ======SpeedTestResult====
% Total runs: 10000 times.
% Total elapsed time: 203.260852 / 216.717877 seconds.
% Averaged elapsed time: 0.020326 / 0.021672 seconds.
% Speed up on average -0.001346 seconds, 0.937905 times, -6.620569 % of original time.