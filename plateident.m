%% function that takes a license plate image as input and returns the string of the license plate

function [outputImage, outputString] = plateident(licenseplateimg)
load letterarray
% filter and make blackwhite
% lgplate = lapgauss(licenseplateimg);
% bwplate = im2bw(licenseplateimg,0.25);

%%%%%%%%%%%%%% Make a variable intensity threshold based on the average
%%%%%%%%%%%%%% intensity of a scene, somewhere between 0.4 and 0.6?

sceneIntensity = licenseplateimg(:,:,3);
height = floor(length(licenseplateimg(:,1,1))/2);
faultImage = zeros(size(licenseplateimg));
if height == 0
    outputString = '';
    outputImage = faultImage;
    return
end

iThresh = mean(mean(sceneIntensity(height-1:height+1,:)));
if iThresh > 0.75
    sceneIntensityAvg = 0.65;
elseif iThresh > 0.55
    sceneIntensityAvg = 0.5;
elseif iThresh > 0.4
    sceneIntensityAvg = 0.4;
else
    sceneIntensityAvg = 0.3;
end
bwplate = abs(im2bw(sceneIntensity,sceneIntensityAvg)-1);
% 
% intensitythreshold = 0.4;
% 
% grplate = licenseplateimg(:,:,1);
% grplate1 = imcrop(grplate, [5 1 length(grplate(1,:,1))-10 length(grplate(:,1,1))]);
% bwplate = abs(im2bw(grplate1,intensitythreshold)-1);
% bwplate = imclearborder(bwplate);
% imshow(bwplate)
%% perform some minor binary morphology operations on the image, 
%  not necessary, we do this after we crop the image further

% chop op the plate into recognizable individual characters (taking care to
% not ignore the dashes), then feed these chunks to the charident function,
% invariant of Dutch plates is that the letters are a certain width and
% there are always 2 dashes and 6 characters and it always starts with a 
% character this will help with identification (this can be augmented if we 
% wish the system to handle foreign plates)

% se = ones(6,6);
% bw = imopen(bwplate,se);
% bw2 = imclose(bw,se);
objects = bwconncomp(bwplate,8);
rp = regionprops(objects,'Area','Extrema');
% imshow(bwplate)
% subplot(2,2,1)
% imshow(bwplate)
% subplot(2,2,2)
% imshow(bw)
% subplot(2,2,3)
% imshow(bw2)
% subplot(2,2,4)
% imshow(label2rgb(l))    

areaThres = length(bwplate(1,:))*length(bwplate(:,1))*0.008;

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
    outputImage = faultImage;
    return
end
if (rp(sortedIndices(6)).Area < areaThres)
    outputString = '';
    outputImage = faultImage;
    return
end
newimage = bwplate;
newimage(1,:) = zeros(1,length(bwplate(1,:)));
for i = 1:6
    minx = min(minx,min(rp(sortedIndices(i)).Extrema(:,1)));
    miny = min(miny,min(rp(sortedIndices(i)).Extrema(:,2)));
    maxx = max(maxx,max(rp(sortedIndices(i)).Extrema(:,1)));
    maxy = max(maxy,max(rp(sortedIndices(i)).Extrema(:,2)));
end
letterheight = maxy-miny;

newimage = imcrop(newimage,[minx-1 miny-1 maxx-minx+2 maxy-miny+2]);
width = length(newimage(1,:));
height = length(newimage(:,1));
newimage = imclearborder(newimage);
outputImage = newimage;
clear minx miny maxx maxy i width;

%% discretize the objects into distinct objects
objects = bwconncomp(newimage,8);
rp2 = regionprops(objects,'Area','Extrema');
% subplot(3,3,1)
% imshow(newimage)

oString = '';

for j = 1:length(rp2)
    if rp2(j).Area > areaThres
        
        % find box of letters
        minx = min(rp2(j).Extrema(:,1));
        maxx = max(rp2(j).Extrema(:,1));
        miny = min(rp2(j).Extrema(:,2));
        maxy = max(rp2(j).Extrema(:,2));
        letter = imcrop(newimage,[minx miny maxx-minx maxy-miny]);

        %     pause(0.75)
        %     letterskel = bwmorph(abs(letter),'thin',inf); %skeleton doesn't yield
        %     similar enough results
        %     subplot(3,3,j+1)
        %     imshow(letter)
        %     tempstr = imcompare(letter,letterheight, maxx-minx); %replaced by
        %     scaling and iteration over array.
        compar = zeros(length(letterArray),1);
        templ = imresize(letter, [60 40]);

        if (length(letter(1,:)) / length(letter(:,1)) < 0.4)
            oString = strcat(oString,'1');
            continue;
        end
        for i = 1:length(letterArray)
            % find letterarray(i,1) height and width
            testletter = letterArray{i,1};

            % Special case for no. 1: Check height/width ratio
            if (i == 22)
                compar(i) = 10000;
                continue;
            end

            compar(i) = sum(sum(abs(testletter-templ)));
            clear testletter height width
        end

        [letterMin, letterIndex] = min(compar);
        oString = strcat(oString,letterArray{letterIndex,2}{1});

        clear minx maxx miny maxy letter compar temp1
    end
end
outputString = oString;
clear minx miny maxx maxy letterheight letter tempstr letterArray;