function valid = validatePlate(plateIn)
%VALIDATEPLATE Takes a string containing the license plate digits/letters
%without dashed and returns a correct plate string

% There are several layouts for a license plate, all described 
% at http://nl.wikipedia.org/wiki/Nederlands_kenteken
    
    % First check for sidecodes 7 & 8
    if (regexp(plateIn,'.+[A-Z]{3}.+'))
        valid = regexprep(plateIn,'[A-Z]{3}','-$0-');
        return
    end
    
    % Otherwise, just insert after 2 and 4
    firstDash = regexprep(plateIn,'^.{2}','$0-');
    valid     = regexprep(firstDash,'.{2}$','-$0');   