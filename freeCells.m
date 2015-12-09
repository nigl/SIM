function [FreeCells] = freeCells(Cars, Obstacles, SpeedMax)
%Funktion gibt die freien Zellen vor einem Fahrzeug an
% Cars ist Vektor der für jede Zelle angibt welches Auto darauf steht
%Obstacles gibt die Hindernisse (Kreuzungen) an
global P

FreeCells=zeros(size(Cars));
NumberCells=numel(Cars);

% Hindernis = zeros(size(Cars));
% 
% V = Cars == 0 & Obstacles == 0;
% 
% for Distance=1:SpeedMax
%     %Phillis Magic Algorithm
%     doCount = (P^Distance*V)  & ~Hindernis;
%     FreeCells=doCount.*(FreeCells+1);
%     
%     Hindernis = Hindernis | (P^Distance*Cars ~= 0);
%     
%     
%     
% end

totalObstacles = Cars ~= 0 | Obstacles ~= 0;
for i=1:NumberCells
    free=0;
    for count=1:SpeedMax
        propTotalObst = P^count*totalObstacles;
        if (propTotalObst(i) == 1)
            break;
        end
        free = count;
    end
    FreeCells(i)=free;
end

