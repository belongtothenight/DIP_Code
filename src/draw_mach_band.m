function draw_mach_band(bc, x, y)
    % =====================================================================
    % This function takes the number of bands as input and plot Mach bands.
    % bc: band count
    % x:  the width of each band
    % y:  the hight of bands
    % ========================DefaultValue=================================
    if nargin < 3
        bc = 5;
        x = 50;
        y = 200;
    end
    % ===========================Main======================================
    max = 255;
    min = 0;
    diff = round((max - min) / bc);
    for i = 1:bc
        arr{i} = mat2gray(ones(y, x) * (min + diff * (i - 1)), [min max]);
    end
    montage(arr, 'ThumbnailSize', [], 'size', [1 length(arr)]);
end

