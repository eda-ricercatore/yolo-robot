function valid = validatePlate(plateIn)
%VALIDATEPLATE Takes a string containing the license plate digits/letters
%without dashed and returns a correct plate string

% There are several layouts for a license plate, all described 
% at http://nl.wikipedia.org/wiki/Nederlands_kenteken
    
    % First check for sidecodes 7 & 8
    if (regexp(plateIn,'(^\d[A-Z]{3}\d{2}$)|(^\d{2}[A-Z]{3}\d$)'))
        valid = regexprep(plateIn,'[A-Z]{3}','-$0-');
        return
    end
    
    % Otherwise, check for groups of 2
    if (isempty(regexp(plateIn, '^([A-Z]{2}|\d{2}){3}$')))
        valid = '';
        return
    end

    % Finally, just insert after 2 and 4
    firstDash = regexprep(plateIn,'^.{2}','$0-');
    valid     = regexprep(firstDash,'.{2}$','-$0');