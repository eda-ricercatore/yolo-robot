function result = processRollingCell(cell)
% Returns index of most common string, or 0 if the count < 4
    % Source: http://stackoverflow.com/questions/17450233/most-frequent-element-in-a-string-array-matlab
    result = 0;
    [~, ~, string_map]=unique(cell);
    [most_common_index, frequency] = mode(string_map);
    if frequency > 3
        result = most_common_index;
    end
end