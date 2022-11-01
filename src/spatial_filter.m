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
        imgdst = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\spatial_filter\lena_g_255_';
        show = 0;
        export = 1;
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
        % scaling transform
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
        % scaling transform
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
    function img = execute(img, fun, param1)
        if fun == 1 %blur
            rimg = fun1(reshape(img(:,:,1), [x, y]), param1);
            gimg = fun1(reshape(img(:,:,2), [x, y]), param1);
            bimg = fun1(reshape(img(:,:,3), [x, y]), param1);
        elseif fun == 2 %edge detection
            rimg = fun2(reshape(img(:,:,1), [x, y]), param1);
            gimg = fun2(reshape(img(:,:,2), [x, y]), param1);
            bimg = fun2(reshape(img(:,:,3), [x, y]), param1);
        elseif fun == 3 %edge detection
            rimg = fun3(reshape(img(:,:,1), [x, y]), param1);
            gimg = fun3(reshape(img(:,:,2), [x, y]), param1);
            bimg = fun3(reshape(img(:,:,3), [x, y]), param1);
        end
        img = cat(3, rimg, gimg, bimg);
        img = mat2gray(img, [0 255]);
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
    
    % show image
    if show == 1
        montage({imgsrc, img1, img2, img3}, 'size', [1 4]);
        title('Histogram Equalization: original / blur / edge detection / edge enhancement');
    end

    % export image
    if export == 1
        imwrite(img1, strcat(imgdst,'bl_.jpg'));
        imwrite(img2, strcat(imgdst,'ed_.jpg'));
        imwrite(img3, strcat(imgdst,'ee_.jpg'));
    end
    fprintf('finished executing\n\n');
end

% ======SpeedTestResult====
