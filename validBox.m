function valid = validBox(box)
% Sanity checks to only return a box that is likely to be a real license
% plate
    valid = (box(3) > 80) & (box(4) > 20);
end