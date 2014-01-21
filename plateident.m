%% function that takes a license plate image as input and returns the string of the license plate

function outputString = plateident(licenseplateimg)
load letterarray
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
rp = regionprops(objects,'all');
l = labelmatrix(objects);

% subplot(2,2,1)
% imshow(bwplate)
% subplot(2,2,2)
% imshow(bw)
% subplot(2,2,3)
% imshow(bw2)
% subplot(2,2,4)
% imshow(label2rgb(l))    


%% sort objects in the image by size, take largest object as max and min 
% y-value of all other objects, make the x-axis also between the largest 
% 6 objects, this should avoid most border issues and artifacts.

areas = [rp.Area];
[~, sortedIndices] = sort(areas,'descend');
minx = 10000;
maxx = 0;
miny = 10000;
maxy = 0;
if length(rp) < 6
    outputString = '';
    return
end
if (rp(sortedIndices(6)).Area < 400)
    outputString = '';
    return
end
for i = 1:6
    minx = min(minx,min(rp(sortedIndices(i)).Extrema(:,1)));
    miny = min(miny,min(rp(sortedIndices(i)).Extrema(:,2)));
    maxx = max(maxx,max(rp(sortedIndices(i)).Extrema(:,1)));
    maxy = max(maxy,max(rp(sortedIndices(i)).Extrema(:,2)));
end
letterheight = maxy-miny;
newimage = imcrop(bw2,[minx miny maxx-minx maxy-miny]);

clear minx miny maxx maxy i;

%% discretize the objects into distinct objects
objects = bwconncomp(newimage,8);
rp2 = regionprops(objects,'all');
% subplot(3,3,1)
% imshow(newimage)

oString = '';

for j = 1:length(rp2)
    if rp2(j).Area > 400
        
        % find box of letters
        minx = min(rp2(j).Extrema(:,1));
        maxx = max(rp2(j).Extrema(:,1));
        miny = min(rp2(j).Extrema(:,2));
        maxy = max(rp2(j).Extrema(:,2));
        letter = imcrop(newimage,[minx miny maxx-minx letterheight]);
        %     imshow(letter)
        %     pause(0.75)
        %     letterskel = bwmorph(abs(letter),'thin',inf); %skeleton doesn't yield
        %     similar enough results
        %     subplot(3,3,j+1)
        %     imshow(letter)
        %     tempstr = imcompare(letter,letterheight, maxx-minx); %replaced by
        %     scaling and iteration over array.
        compar = zeros(length(letterArray),1);
        for i = 1:length(letterArray)
            % find letterarray(i,1) height and width
            testletter = letterArray{i,1};
            height = length(testletter(:,1));
            width = length(testletter(1,:));
            % templ = scaled letter by height and width
            templ = imresize(letter, [height width]);
            compar(i) = sum(sum(abs(testletter-templ)));
            clear testletter height width
        end
        
        testthresh = 150;
        [letterMin letterIndex] = min(compar);
        if letterMin < testthresh
            oString = strcat(oString,letterArray{letterIndex,2});
        else
            oString = strcat(oString,' ');
        end
        clear minx maxx miny maxy letter compar
    end
end
outputString = oString;
clear minx miny maxx maxy letterheight letter tempstr;