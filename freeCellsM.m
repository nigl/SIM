function [FreeCells] = freeCellsM(Cars, Obstacles, SpeedMax)
%Funktion gibt die freien Zellen vor einem Fahrzeug an
% Cars ist Vektor der für jede Zelle angibt welches Auto darauf steht
%Obstacles gibt die Hindernisse (Kreuzungen) an
global P

FreeCells=zeros(size(Cars));

Hindernis = zeros(size(Cars));

V = Cars == 0 & Obstacles == 0;

for Distance=1:SpeedMax
    %Phillis Magic Algorithm
    doCount = (P^Distance*V) & ~Hindernis;
    FreeCells=doCount.*(FreeCells+1);
    
    Hindernis = Hindernis | (P^Distance*Cars ~= 0);
    
end
end
