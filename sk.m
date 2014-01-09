%% process image data of the license plate templates 
% (ie this is what we compare our video to).

function out = sk(in)

i = double(in);
temp1 = rgb2gray(i);
temp2 = im2bw(temp1);
out = bwmorph(abs(1-temp2),'thin',inf);