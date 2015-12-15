function [FreeCells] = freeCellsM(Cars, Obstacles, vmax)
% Die Funktion gibt die freien Zellen vor einem Fahrzeug zurück
% Cars ist Vektor der f�r jede Zelle angibt welches Auto darauf steht
% Obstacles gibt die Hindernisse (Kreuzungen) an

totalCellNum = numel(Cars);
P=diag(ones(1,totalCellNum-1), 1) + diag(1,-totalCellNum+1);

FreeCells=zeros(size(Cars));
Hindernis = zeros(size(Cars));
V = Cars == 0 & Obstacles == 0;

for Distance=1:vmax
    doCount = (P^Distance*V) & ~Hindernis;
    FreeCells(doCount) = FreeCells(doCount)+1; 
    Hindernis = Hindernis | (P^Distance*V == 0);
end

end
