function [BW,maskedRGBImage] = createMaskRed(RGB, view)
    I = rgb2hsv(RGB);
    % view : 1 = Top, 2 = Side
    channel1Min = [0.021 0.017];
    channel1Max = [0.075 0.049];
    channel2Min = [0.355 0.138];
    channel2Max = [1.000 1.000];
    channel3Min = [0.923 0.772];
    channel3Max = [1.000 1.000];
    sliderBW = (I(:,:,1) >= channel1Min(view) ) & (I(:,:,1) <= channel1Max(view)) & ...
        (I(:,:,2) >= channel2Min(view) ) & (I(:,:,2) <= channel2Max(view)) & ...
        (I(:,:,3) >= channel3Min(view) ) & (I(:,:,3) <= channel3Max(view));
    BW = sliderBW;
    maskedRGBImage = RGB;
    maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
end