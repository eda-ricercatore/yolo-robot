frameImage = imread('images/frame1.jpg');
frameImage_hsv = rgb2hsv(frameImage);
frameImage_sat = frameImage_hsv(:,:,2);

threshold = graythresh(frameImage_sat);
bw = im2bw(frameImage_sat,threshold);
objects = bwconncomp(bw,8);
rp = regionprops(objects,'Area','PixelIdxList')
areas = [rp.Area];
[~,indexOfMax] = max(areas);

plate = false(size(bw));
plate(objects.PixelIdxList{indexOfMax}) = true;
imshow(plate);