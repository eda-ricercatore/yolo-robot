function result = processRollingCell(cell)
% Returns index of most common string, or 0 if the count < 4
    % Source: http://stackoverflow.com/questions/17450233/most-frequent-element-in-a-string-array-matlab
    result = 0;

    % ia is the indices of the original matrix, sorted by the number of
    % occurrences of the string at that index
    [~, ia, ~]=unique(cell);

    % If there are only 2 indices, there were 4 equal strings, and the
    % first index is the most common string
    if length(ia) < 3
        result = ia(1);
    else
        result = 0;
    end
end