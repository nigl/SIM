function [Regulation] = rechtsVorLinks(Hor, Vert)
    %Funktion ist nur f�r Horizontale Ringstra�e da Vertikale immer Vorfahrt hat 

    Regulation = (Vert == 0) & (Hor ~= 0);

end

