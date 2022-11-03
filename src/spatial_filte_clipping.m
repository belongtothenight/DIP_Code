function img1 = spatial_filter(imgsrc, imgdst, show, export)
    % ========================
    % This function takes image as input, performs point 
    %    processing - histogram equalization, to improve the contrast.
    % ======Variable==========
    % imgsrc:     image source path
    % imgdst:     image destination path
    % export:     1 for exporting the image, 0 for not exporting
    clip_max = 6; % exponential value for clipping
    clip_min = 0; % exponential value for clipping
    clip_int = 0.5 % interval exponential value for clipping
    % ======DefaultValue======
    if nargin < 4
        imgsrc = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\lena_c_225.jpg';
        imgdst = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\spatial_filter_clipping\lena_c_225_';
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
        mask = [0 -1 0; -1 5 -1; 0 -1 0];
        [h, w] = size(img);
        img_temp = img;
        % masking - edge detection
        for i = 2:h-1
            for j = 2:w-1
                img_temp(i, j) = sum(sum(img(i-1:i+1, j-1:j+1) .* mask));
            end
        end
        % scaling transform (positive)
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
    
    % load runtimes
    times = ((clip_max-clip_min) / clip_int);
    run = [0];
    for i=2:times+1
        run = [run, exp(clip_min + clip_int*(i-1))];
    end
    run = run([2:end])

    % edge detection + edge enhancement variable adjustment
    for i=1:times
        num = [0 run(i)]
        img2 = execute(img, 6, num);
        img3 = execute(img, 7, num);
        if export == 1
            imwrite(img2, strcat(imgdst,'ed_', num2str(num(2)), '.jpg'));
            imwrite(img3, strcat(imgdst,'ee_', num2str(num(2)), '.jpg'));
        end
    end

    fprintf('finished executing\n\n');
end

% ======SpeedTestResult====
