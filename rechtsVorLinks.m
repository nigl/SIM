function [Regulation] = rechtsVorLinks(Hor, Vert)
    %Funktion ist nur für Horizontale Ringstraße da Vertikale immer Vorfahrt hat 

    Regulation = (Vert == 0) & (Hor ~= 0);

end

