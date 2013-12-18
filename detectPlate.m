function [ bw ] = detectPlate( frame )
%DETECTPLATE Takes an RGB image and returns a logical image.
%   Detailed explanation goes here
% Convert to HSV and select Saturation channel
frame_hsv = rgb2hsv(frame);
frame_hue = frame_hsv(:,:,1);
frame_sat = frame_hsv(:,:,2);
frame_val = frame_hsv(:,:,3);

hueThresholdLow = 0.10;
hueThresholdHigh = 0.14;
satThresholdLow = 0.4;
satThresholdHigh = 1;
valThresholdLow = 0.5;
valThresholdHigh = 1.0;

% Threshold and segment image
hueMask = (frame_hue >= hueThresholdLow) & (frame_hue <= hueThresholdHigh);
satMask = (frame_sat >= satThresholdLow) & (frame_sat <= satThresholdHigh);
valMask = (frame_val >= valThresholdLow) & (frame_val <= valThresholdHigh);

bw = hueMask & satMask & valMask;

objects = bwconncomp(bw,8);
rp = regionprops(objects,'Area','PixelIdxList','BoundingBox');

% Get the bounding box of largest object
areas = [rp.Area];
[~,indexOfMax] = max(areas);

box = rp(indexOfMax).BoundingBox;
image(frame);
hold on;
rectangle(box);


end

