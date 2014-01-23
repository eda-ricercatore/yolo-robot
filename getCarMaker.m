function maker = getCarMaker(plate)
    try
        site = urlread(['https://ovi.rdw.nl/default.aspx?kenteken=' plate]);
    catch err
        maker = '';
        return
    end
    expr = '<div class=\"ui-block-d border ovigrid\" id=\"Merk\">[A-Z]+</div>';
    div = regexp(site, expr, 'match');
    cell = regexprep(div, '<.*?>','');
    if ~isempty(cell)
        maker = cell{1};
    else
        maker = '';
    end
end