function img1 = hist_equal(imgsrc, imgdst, speedtest, show, export)
    % ========================
    % This function takes image as input, performs point 
    %    processing - histogram equalization, to improve the contrast.
    % ======Variable==========
    % imgsrc:     image source path
    % imgdst:     image destination path
    % speedtest:  1 for speed test, 0 for normal conversion
    % show:       1 for showing the image, 0 for not showing
    % export:     1 for exporting the image, 0 for not exporting
    runs = 1e03;
    % ======DefaultValue======
    if nargin < 5
        imgsrc = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\lena_c_225.jpeg';
        imgdst = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\img_hist_equal\lena_c_255_he_.jpg';
        speedtest = 0;
        show = 1;
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
    img = double(img); % affect writing image
    x = size(img, 1);
    y = size(img, 2);
    try
        % matlab
        l = size(img, 3);
    catch
        % octave
        l = 1;
        img = reshape(img, [x, y, l]);
    end

    % halftoning
    if speedtest == 1
        % functionn 1
        tic
        for i = 1:runs
            img1 = img;
            for j = 1:l % put in loop for color image
                img1(:,:,j) = he1(reshape(img1(:,:,j), [x, y]));
            end
            img1 = mat2gray(img1, [0 255]);
        end
        elapsed_time1 = toc;
        avget1 = elapsed_time1/runs;
        fprintf('\nfinished fuunction 1 in %f seconds', elapsed_time1);
        % function 2
        tic
        for i = 1:runs
            img2 = img;
            for j = 1:l
                img2(:,:,j) = he2(reshape(img2(:,:,j), [x, y]));
            end
            img2 = mat2gray(img2, [0 255]);
        end
        elapsed_time2 = toc;
        avget2 = elapsed_time2/runs;
        fprintf('\nfinished function 2 in %f seconds\n', elapsed_time2);
        fprintf('\nTotal runs: %d times.\n', runs);
        fprintf('Total elapsed time: %f / %f seconds.\n', elapsed_time1, elapsed_time2);
        fprintf('Averaged elapsed time: %f / %f seconds.\n', avget1, avget2);
        fprintf('Speed up on average %f seconds, %f times, %f %% of original time.\n\n', avget1-avget2, avget1/avget2, (avget1-avget2)/avget1*100);
    else
        if l == 1
            pass
        elseif l == 3
            % function 1
            tic;
            rimg = he1(reshape(img(:,:,1), [x, y]));
            gimg = he1(reshape(img(:,:,2), [x, y]));
            bimg = he1(reshape(img(:,:,3), [x, y]));
            img1 = cat(3, rimg, gimg, bimg);
            img1 = mat2gray(img1, [0 255]);
            elapsed_time1 = toc;
            fprintf('\nfinished fuunction 1 in %f seconds', elapsed_time1);
            % function 2
            tic;
            rimg = he2(reshape(img(:,:,1), [x, y]));
            gimg = he2(reshape(img(:,:,2), [x, y]));
            bimg = he2(reshape(img(:,:,3), [x, y]));
            img2 = cat(3, rimg, gimg, bimg);
            img2 = mat2gray(img2, [0 255]);
            elapsed_time2 = toc;
        end
        fprintf('\nElapsed time (1/2): %f/%f\n', elapsed_time1, elapsed_time2);
        % check if the result is the same
        if img1 == img2
            fprintf('img1 == img2\n');
        else
            fprintf('img1 != img2\n');
        end
    end

    % show & export image
    if show == 1
        if l == 1
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
        elseif l == 3
            figure('visible','off');
            % original histogram
            clf
            img = imread(imgsrc);
            rimg = img(:,:,1);
            gimg = img(:,:,2);
            bimg = img(:,:,3);
            hold on
            bar(rimg, 'r');
            bar(gimg, 'g');
            bar(bimg, 'b');
            hold off
            saveas(gcf, histdst1);
            % histogram 1
            clf
            imwrite(img1, histdst2);
            img1 = imread(histdst2);
            rimg = img1(:,:,1);
            gimg = img1(:,:,2);
            bimg = img1(:,:,3);
            hold on
            bar(rimg, 'r');
            bar(gimg, 'g');
            bar(bimg, 'b');
            hold off
            saveas(gcf, histdst2);
            % histogram 2
            clf
            imwrite(img2, histdst3);
            img2 = imread(histdst3);
            rimg = img2(:,:,1);
            gimg = img2(:,:,2);
            bimg = img2(:,:,3);
            hold on
            bar(rimg, 'r');
            bar(gimg, 'g');
            bar(bimg, 'b');
            hold off
            saveas(gcf, histdst3);
            % show image
            close all force
            figure('visible','on');
            h0 = imread(histdst1);
            h1 = imread(histdst2);
            h2 = imread(histdst3);
            montage({imgsrc, img1, img2, h0, h1, h2}, 'size', [2 3]);
            title('Histogram Equalization: original / modified1 / modified2');
        end
    end
    if export == 1
        imwrite(img1, imgdst);
    end
    fprintf('finished executing\n\n');
end

% ======SpeedTestResult====
% Total runs: 1000 times.
% Total elapsed time: 171.423646 / 51.248595 seconds.
% Averaged elapsed time: 0.171424 / 0.051249 seconds.
% Speed up on average 0.120175 seconds, 3.344943 times, 70.104127 % of original time.