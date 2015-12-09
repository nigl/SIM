function [TempCells] = adjustSpeed(Speed_now, Car_now, Obstacles, SpeedMax)

    %Beschleunigen für Autos die nicht vor Hindernissen stehen
    Speed = min(SpeedMax, Speed_now+1);
    FreeAhead = freeCells(Car_now, Obstacles, SpeedMax);
    
    %bechleunige die zu beschleunigenden und die anderen gleich lassen
    %TempCells= ((FreeAhead < Speed_now).*Speed_now + (FreeAhead >= Speed_now).*Speed).*(Car_now ~= 0);
    TempCells = ((FreeAhead < Speed).*Speed_now + (FreeAhead >= Speed).*Speed).*(Car_now ~= 0);
    
    %Bremse die zu bremsenden und lasse die anderen gleich
    SpeedAfterBrake = (FreeAhead < TempCells).*FreeAhead.*(Car_now ~= 0);
    TempCells(FreeAhead < TempCells) = SpeedAfterBrake(FreeAhead < TempCells);

end

