function gimg_arith_op_1(imgsrc, imgdst, speedtest, show, export)
    % ========================
    % This function takes grayscale image as input, plot and export
    %    the solarized image.
    % ======Variable==========
    % imgsrc: image source path
    % imgdst: image destination path
    % speedtest: 1 for speed test, 0 for normal conversion
    % show: show image or not
    % export: export image or not
    runs = 1e05;
    % ======DefaultValue======
    if nargin < 5
        imgsrc = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\lena_g_225.jpg';
        imgdst = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\img_arith_op_1\luna_ao1_.jpg';
        speedtest = 1;
        show = 0;
        export = 0;
    end
    % ======Function==========
    function img = ao1(img)
        [ih, iw] = size(img); % really time costly
        for i = 1:ih
            for j = 1:iw
                if img(i, j) > 127
                    continue
                else
                    img(i, j) = 255 - img(i, j);
                end
            end
        end
    end
    function img = ao2(img)
        img = (img > 127) .* img + (img <= 127) .* (255 - img);
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
            img1 = ao1(img);
        end
        elapsed_time1 = toc;
        avget1 = elapsed_time1/runs;
        tic
        for i = 1:runs
            img2 = ao2(img);
        end
        elapsed_time2 = toc;
        avget2 = elapsed_time2/runs;
        fprintf('\nTotal runs: %d times.\n', runs);
        fprintf('Total elapsed time: %f / %f seconds.\n', elapsed_time1, elapsed_time2);
        fprintf('Averaged elapsed time: %f / %f seconds.\n', avget1, avget2);
        fprintf('Speed up on average %f seconds, %f times, %f %% of original time.\n', avget1-avget2, avget1/avget2, (avget1-avget2)/avget1*100);
    else
        tic;
        img1 = ao1(img);
        elapsed_time1 = toc;
        tic;
        img2 = ao2(img);
        elapsed_time2 = toc;
        fprintf('\nElapsed time (1/2): %f/%f\n', elapsed_time1, elapsed_time2);
        if img1 == img2
            fprintf('img1 == img2\n\n');
        else
            fprintf('img1 != img2\n\n');
        end
    end

    % show & export image
    img1 = mat2gray(img1, [0 255]);
    img2 = mat2gray(img2, [0 255]);
    if show == 1
        figure('visible','on');
        montage({imgsrc, img1, img2}, 'ThumbnailSize', [], 'size', [1 3]);
        title('Arithmetic Operation 1: original / modified1 / modified2');
    end
    if export == 1
        imwrite(img, imgdst);
    end
    fprintf('\n');
end

% ======SpeedTestResult====
% Total runs: 100000 times.
% Total elapsed time: 20.923535 / 2.138721 seconds.
% Averaged elapsed time: 0.000209 / 0.000021 seconds.
% Speed up on average 0.000188 seconds, 9.783201 times, 89.778397 % of original time.