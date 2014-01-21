function valid = validBox(box)
% Sanity checks to only return a box that is likely to be a real license
% plate
    valid = true;
    % The box must not touch a border, the probability of an incomplete
    % plate is too high
    if (box(1) == 0.5 || box(1)+box(3) == 640.5)
        valid = false;
        return;
    end
    if (box(2) == 0.5 || box(2)+box(4) == 480.5)
        valid = false;
        return;
    end

    % Minimum height and width
    if (box(3) < 80)
        valid = false;
        return;
    end
    if (box(4) < 20)
        valid = false;
        return;
    end
end