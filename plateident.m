%% function that takes a black white license plate image as input and returns the string of the license plate

function outputString = plateident(licenseplateimg)

% filter and make blackwhite
% lgplate = lapgauss(licenseplateimg);
% bwplate = im2bw(licenseplateimg,0.25);

% it is apparently computationally efficient to convert the image to the
% grayscale before converting it to a black and white image. 
grplate = rgb2gray(licenseplateimg);
bwplate = abs(im2bw(grplate,0.25)-1);

%% perform some minor binary morphology operations on the image, 
%  not necessary, we do this after we crop the image further

% chop op the plate into recognizable individual characters (taking care to
% not ignore the dashes), then feed these chunks to the charident function,
% invariant of Dutch plates is that the letters are a certain width and
% there are always 2 dashes and 6 characters and it always starts with a 
% character this will help with identification (this can be augmented if we 
% wish the system to handle foreign plates)

se = ones(6,6);
bw = imopen(bwplate,se);
bw2 = imclose(bw,se);
objects = bwconncomp(bw2,8);
rp = regionprops(objects,'Area');
l = labelmatrix(objects);

subplot(2,2,1)
imshow(bwplate)
subplot(2,2,2)
imshow(bw)
subplot(2,2,3)
imshow(bw2)
subplot(2,2,4)
imshow(label2rgb(l))

%% sort objects in the image by size, take largest object as max and min 
%% y-value of all other objects, make the x-axis also between the largest 
%% 6 objects, this should avoid all border issues and artifacts.

