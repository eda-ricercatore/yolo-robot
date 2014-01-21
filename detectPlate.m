function [boxes, crop, hits] = detectPlate( frame )

%DETECTPLATE Takes an RGB image and returns a logical image.
%   Detailed explanation goes here
% Convert to HSV and select Saturation channel
frame_hsv = rgb2hsv(frame);
frame_hue = frame_hsv(:,:,1);
frame_sat = frame_hsv(:,:,2);
frame_val = frame_hsv(:,:,3);

hueThresholdLow  = 0.08;
hueThresholdHigh = 0.16;
satThresholdLow  = 0.4;
satThresholdHigh = 1;
valThresholdLow  = 0.5;
valThresholdHigh = 1.0;

% Threshold and segment image
hueMask = (frame_hue >= hueThresholdLow) & (frame_hue <= hueThresholdHigh);
satMask = (frame_sat >= satThresholdLow) & (frame_sat <= satThresholdHigh);
valMask = (frame_val >= valThresholdLow) & (frame_val <= valThresholdHigh);

bw = hueMask & satMask & valMask;

clear hueMask satMask valMask frame_hsv frame_hue frame_sat frame_val

objects = bwconncomp(bw,8);
rp = regionprops(objects,'Area','BoundingBox','Orientation');

% Get the areas in the binary image
areas = [rp.Area];

% Sort objects by area
[~, sortedIndices] = sort(areas, 'descend');
totalAreas = length(areas);

% Loop over objects to reveal plates
hits = 0;
boxes = zeros(totalAreas,4);
crop = cell(1, totalAreas);
for i= 1:totalAreas
    index = sortedIndices(i);
    currentBox = rp(index).BoundingBox;
    if (validBox(currentBox))
        hits = i;
        boxes(i,:) = currentBox;

        % Crop the entire frame to the (possibly rotated) plate
        [cropped, croppedSize] = imcrop(frame, currentBox);
        croppedWidth = croppedSize(3);

        % Get rotation and undo in-plane rotation of the plate
        orientation = rp(index).Orientation;
        rotated = imrotate(cropped, -orientation, 'bicubic', 'loose');

        % The rotation created an image that is too large, we need to do a
        % second cropping
        rotatedWidth  = length(rotated(1,:,1));
        rotatedHeight = length(rotated(:,1,:));

        cutoffHeight = tand(orientation)*rotatedWidth;
        newHeight = rotatedHeight - 2*cutoffHeight;

        twiceCropped = imcrop(rotated, [0,cutoffHeight,rotatedWidth, newHeight]);
        crop{i} = twiceCropped;
    else
        % Since we are using sorted elements, the first invalid box will
        % terminate the loop

        break
    end
end
end

