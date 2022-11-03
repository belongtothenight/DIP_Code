function img1 = spatial_filter(imgsrc, imgdst, show, export)
    % ========================
    % This function takes image as input, performs point 
    %    processing - histogram equalization, to improve the contrast.
    % ======Variable==========
    % imgsrc:     image source path
    % imgdst:     image destination path
    % show:       1 for showing the image, 0 for not showing
    % export:     1 for exporting the image, 0 for not exporting
    % ======DefaultValue======
    if nargin < 4
        imgsrc = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\lena_g_225.jpg';
        imgdst = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\spatial_filter\lena_g_225_';
        show = 1;
        export = 0;
    end
    % ======Function==========
    function img = fun1(img, mask_size)
        mask = ones(mask_size, mask_size) * 1 / (mask_size * mask_size);
        t = fix(mask_size / 2);
        [h, w] = size(img);
        img_temp = img;
        for i = 1+t:h-t
            for j = 1+t:w-t
                img_temp(i, j) = sum(sum(img(i-t:i+t, j-t:j+t) .* mask));
            end
        end
        img = img_temp;
    end
    function img = fun2(img, scaling_size)
        mask = [0 -1 0; -1 4 -1; 0 -1 0];
        [h, w] = size(img);
        img_temp = zeros(h, w); % can't use the same matrix to compute, the value just going to explode
        % masking - edge detection
        for i = 2:h-1
            for j = 2:w-1
                img_temp(i, j) = sum(sum(img(i-1:i+1, j-1:j+1) .* mask));
            end
        end
        % scaling transform (pos and neg)
        if scaling_size ~= 0
            gh = max(max(img_temp)) * scaling_size;
            gl = min(min(img_temp)) * scaling_size;
            img = (img_temp - gl) / (gh - gl) * 255;
        elseif scaling_size == -1
            img = abs(img_temp);
        else
            img = img_temp;
        end
    end
    function img = fun3(img, scaling_size)
        mask = [0 -1 0; -1 5 -1; 0 -1 0];
        [h, w] = size(img);
        img_temp = img;
        % masking - edge detection
        for i = 2:h-1
            for j = 2:w-1
                img_temp(i, j) = sum(sum(img(i-1:i+1, j-1:j+1) .* mask));
            end
        end
        % scaling transform (pos and neg)
        if scaling_size ~= 0
            gh = max(max(img_temp)) * scaling_size;
            gl = min(min(img_temp)) * scaling_size;
            img = (img_temp - gl) / (gh - gl) * 255;
        elseif scaling_size == -1
            img = abs(img_temp);
        else
            img = img_temp;
        end
    end
    function img = fun4(img, scaling_size)
        mask = [0 -1 0; -1 4 -1; 0 -1 0];
        [h, w] = size(img);
        img_temp = zeros(h, w);
        % masking - edge detection
        for i = 2:h-1
            for j = 2:w-1
                img_temp(i, j) = sum(sum(img(i-1:i+1, j-1:j+1) .* mask));
            end
        end
        % scaling transform (postive)
        if scaling_size ~= 0
            gh = max(max(img_temp)) * scaling_size;
            gl = 0;
            img = (img_temp - gl) / (gh - gl) * 255;
        elseif scaling_size == -1
            img = abs(img_temp);
        else
            img = img_temp;
        end
    end
    function img = fun5(img, scaling_size)
        mask1 = [0 -1 0; -1 4 -1; 0 -1 0];
        % mask2 = [0 0 0; 0 1 0; 0 0 0]
        % mask = [0 -1 0; -1 5 -1; 0 -1 0];
        [h, w] = size(img);
        img_temp = img;
        % masking - edge detection
        for i = 2:h-1
            for j = 2:w-1
                img_temp(i, j) = sum(sum(img(i-1:i+1, j-1:j+1) .* mask1));
            end
        end
        % scaling transform (positive)
        if scaling_size ~= 0
            gh = max(max(img_temp)) * scaling_size;
            gl = 0;
            img_temp = (img_temp - gl) / (gh - gl) * 255;
            img = img + img_temp;
        elseif scaling_size == -1
            img_temp = abs(img_temp);
            img = img + img_temp;
        else
            img = img_temp;
        end
    end
    function img = fun6(img, limit)
        % limit(1): lower limit
        % limit(2): upper limit
        mask = [0 -1 0; -1 4 -1; 0 -1 0];
        [h, w] = size(img);
        img_temp = zeros(h, w);
        % masking - edge detection
        for i = 2:h-1
            for j = 2:w-1
                img_temp(i, j) = sum(sum(img(i-1:i+1, j-1:j+1) .* mask));
            end
        end
        % clip value
        imgu = (img_temp > limit(2))*limit(2);
        imgl = (img_temp < limit(1)).*limit(1);
        imgm = ((img_temp >= limit(1)) + (img_temp <= limit(2))) .* img_temp;
        img = imgu + imgl + imgm;
    end
    function img = fun7(img, limit)
        mask1 = [0 -1 0; -1 4 -1; 0 -1 0];
        mask2 = [0 0 0; 0 1 0; 0 0 0];
        % mask = [0 -1 0; -1 5 -1; 0 -1 0];
        [h, w] = size(img);
        img_temp = img;
        % masking - edge detection
        for i = 2:h-1
            for j = 2:w-1
                img_temp(i, j) = sum(sum(img(i-1:i+1, j-1:j+1) .* mask1));
            end
        end
        % clip value
        imgu = (img_temp > limit(2))*limit(2);
        imgl = (img_temp < limit(1)).*limit(1);
        imgm = ((img_temp >= limit(1)) + (img_temp <= limit(2))) .* img_temp;
        img_temp = imgu + imgl + imgm;
        % add back the original image
        img = img_temp + img; % mask 2
    end
    function img = execute(img, fun, param1)
        limit = [0 255];
        if fun == 1 %blur
            rimg = fun1(reshape(img(:,:,1), [x, y]), param1);
            gimg = fun1(reshape(img(:,:,2), [x, y]), param1);
            bimg = fun1(reshape(img(:,:,3), [x, y]), param1);
        elseif fun == 2 %edge detection + scaling transform
            rimg = fun2(reshape(img(:,:,1), [x, y]), param1);
            gimg = fun2(reshape(img(:,:,2), [x, y]), param1);
            bimg = fun2(reshape(img(:,:,3), [x, y]), param1);
        elseif fun == 3 %edge enhancement + scaling transform
            rimg = fun3(reshape(img(:,:,1), [x, y]), param1);
            gimg = fun3(reshape(img(:,:,2), [x, y]), param1);
            bimg = fun3(reshape(img(:,:,3), [x, y]), param1);
        elseif fun == 4 %edge detection + scaling transform (positive)
            rimg = fun4(reshape(img(:,:,1), [x, y]), param1);
            gimg = fun4(reshape(img(:,:,2), [x, y]), param1);
            bimg = fun4(reshape(img(:,:,3), [x, y]), param1);
        elseif fun == 5 %edge enhancement + scaling transform (positive)
            rimg = fun5(reshape(img(:,:,1), [x, y]), param1);
            gimg = fun5(reshape(img(:,:,2), [x, y]), param1);
            bimg = fun5(reshape(img(:,:,3), [x, y]), param1);
        elseif fun == 6 %edge detection + clip
            rimg = fun6(reshape(img(:,:,1), [x, y]), param1);
            gimg = fun6(reshape(img(:,:,2), [x, y]), param1);
            bimg = fun6(reshape(img(:,:,3), [x, y]), param1);
        elseif fun == 7 %edge enhancement + clip
            rimg = fun7(reshape(img(:,:,1), [x, y]), param1);
            gimg = fun7(reshape(img(:,:,2), [x, y]), param1);
            bimg = fun7(reshape(img(:,:,3), [x, y]), param1);
        end
        img = cat(3, rimg, gimg, bimg);
        img = mat2gray(img, limit);
    end
    % ======Main==============
    % load image
    img = imread(imgsrc);
    img = double(img); % affect writing image
    [x, y, z] = size(img);
    
    % simple execution
    img1 = execute(img, 1, 3);
    img2 = execute(img, 2, 0);
    img3 = execute(img, 3, 0);
    img4 = execute(img, 4, 0);
    img5 = execute(img, 5, 0);
    img6 = execute(img, 6, [0 1000]);
    img7 = execute(img, 7, [0 1000]);
    
    % show image
    if show == 1
        montage({imgsrc, img1, img2, img3, img4, img5, img6, img7}, 'size', [2 4]);
        title('Histogram Equalization: original / blur / edge detection | edge enhancement / edge detection / edge enhancement');
    end

    % export image
    if export == 1
        imwrite(img1, strcat(imgdst,'bl_.jpg'));
        imwrite(img2, strcat(imgdst,'ed_.jpg'));
        imwrite(img3, strcat(imgdst,'ee_.jpg'));
        imwrite(img4, strcat(imgdst,'ed1_.jpg'));
        imwrite(img5, strcat(imgdst,'ee1_.jpg'));
        imwrite(img6, strcat(imgdst,'ed2_.jpg'));
        imwrite(img7, strcat(imgdst,'ee2_.jpg'));
    end
    fprintf('finished executing\n\n');
end

% ======SpeedTestResult====
