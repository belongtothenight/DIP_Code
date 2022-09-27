function draw3pic
  % ====================================================================================
  % Since the picture is regulated by pixel size, it is unwise to just plot in XY plane.
  % ============Function=======
  function image = create_function(ol, il, ov, iv)
    % ol:  outer length
    % il:  inner length
    % ov: outer value
    % iv: inner value
    %l = round(ol/2)+round(il/2)
    %s = round(ol/2)-round(il/2)
    s = round(ol/2-il/2)+1;
    l = round(ol/2+il/2);
    array = ones(ol, ol)*ov;
    array(s:l,s:l) = array(s:l,s:l)/ov*iv;
    image = mat2gray(array, [0 255]);
  end
  % ============Array==========
  img{1} = create_function(128, 40, 50, 150);
  img{2} = create_function(128, 40, 100, 150);
  img{3} = create_function(128, 40, 200, 150);
  
  % ============Main===========
  space = mat2gray((ones(128, 5)*255), [0 255]);
  montage([img{1} space img{2} space img{3}], 'ThumbnailSize', [])
end
