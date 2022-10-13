function gimg_ao2_value(imgdst, showimg)
    % ========================
    % This function export the conversion image of
    %    old to new value of function "img_arith_op_1.m".
    % ======Variable==========
    % imgdst: image destination path
    % showimg: show image or not
    % ======DefaultValue======
    if nargin < 2
        imgdst = 'D:\Note_Database\Subject\DIP Digital Image Processing\DIP_Code\pic\img_arith_op_2\ao2_value.jpg';
        showimg = 0;
    end
    % ======Main==============
    line = zeros(256, 1);
    for i = 0:127
        line(i+1, 1) = i;
    end
    for i = 128:255
        line(i+1, 1) = 255-i;
    end
    % figure
    if showimg ~= 1
        f = figure('visible','off');
    else
        f = figure;
    end
    plot(line, 'LineWidth', 2)
    axis([1 256 1 256])
    xticks([1 256])
    xticklabels({'0','255'})
    yticks([1 256])
    yticklabels({'0','255'})
    xlabel('Old Value')
    ylabel('New Value')
    saveas(f,imgdst)  % here you save the figure
end