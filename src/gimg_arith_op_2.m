function gimg_arith_op_1(imgsrc, imgdst, showimg)
    % ========================
    % This function takes grayscale image as input, plot and export
    %    the solarized image.
    % ======Issue=============
    % ======Variable==========
    % imgsrc: image source path
    % imgdst: image destination path
    % showimg: show image or not
    % ======DefaultValue======
    if nargin < 3
        imgsrc = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\lena.tif';
        imgdst = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\img_arith_op_2\luna_ao2.jpg';
        showimg = 1;
    end
    % ======Function==========
    function img = ao1(img)
        [ih, iw] = size(img);
        for i = 1:ih
            for j = 1:iw
                if img(i, j) > 127
                    img(i, j) = 255 - img(i, j);
                else
                    continue
                end
            end
        end
    end
    % ======Main==============
    % load image
    img = imread(imgsrc);
    try
        % necessary if using Matlab
        img = rgb2gray(img);
    end
    img = double(img); % affect writing image
    t0 = clock();

    % halftoning
    img = ao1(img);

    % show image
    elapsed_time = etime (clock (), t0)
    img = mat2gray(img, [0 255]);
    if showimg == 1
        montage({img, imgsrc}, 'ThumbnailSize', []);
        title('Arithmetic Operation 1: original / modified');
    end
    imwrite(img, imgdst);
end
