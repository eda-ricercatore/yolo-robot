function valid = validPlate(plateIn)
    % There are several layouts for a license plate, all described 
    % at http://nl.wikipedia.org/wiki/Nederlands_kenteken
    
    % Sidecode 4 XX-00-XX
    pattern4 = '^[A-Z]{2}-\d{2}-[A-Z]{2}$';
    
    % Sidecode 5 XX-XX-00
    pattern5 = '^[A-Z]{2}-[A-Z]{2}-\d{2}$';
    
    % Sidecode 6 00-XX-XX
    pattern6 = '^\d{2}-[A-Z]{2}-[A-Z]{2}$';
    
    % Sidecode 7 00-XXX-0
    pattern7 = '^\d{2}-[A-Z]{3}-\d$';
    
    % Sidecode 8 00-XXX-0
    pattern8 = '^\d-[A-Z]{3}-\d{2}$';
    
    pattern = [pattern4 '|' pattern5 '|' pattern6 '|' pattern7 '|' pattern8];
    ex = regexp(plateIn, pattern);
    valid = (ex == 1);