function result = processRollingCell(cell)
% Returns index of most common string, or 0 if the count < 4
    % Source: http://stackoverflow.com/questions/17450233/most-frequent-element-in-a-string-array-matlab

    % ia is the indices of the original matrix, sorted by the number of
    % occurrences of the string at that index
    % C is a cell array of the unique strings in cell
    [C, ia]=unique(cell);

    result = {};
    for i=1:length(C)
       freq = sum(strcmp(C(i),cell));
       if freq > 3
          result{i} = ia(i);
       end
    end
end