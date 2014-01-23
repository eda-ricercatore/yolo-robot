function maker = getCarMaker(plate)
    site = urlread(['https://ovi.rdw.nl/default.aspx?kenteken=' plate]);
    expr = '<div class=\"ui-block-d border ovigrid\" id=\"Merk\">[A-Z]+</div>';
    div = regexp(site, expr, 'match');
    cell = regexprep(div, '<.*?>','');
    if length(cell) > 0
        maker = cell{1};
    else
        maker = '';
    end
end