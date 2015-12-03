function [] = plotCars( Cells , CellsNumber )

figure

for j=1:size(Cells,2)
%j=2
 
    X1 = Cells(1:CellsNumber,j,2);
    X2 = Cells(CellsNumber+2:CellsNumber*2+1, j, 2);
    Y1 = Cells(CellsNumber*2+2:CellsNumber*3+1, j, 2);
    Y2 = Cells(CellsNumber*3+3:CellsNumber*4+2, j, 2);
    kreuz = Cells(CellsNumber+1, j, 2);
    
    position13 = (-CellsNumber:-1);
    position24 = (1:CellsNumber);
    positionKreuz = 0;
    
    CarsLeft = position13(X1 ~= 0);
    CarsRight = position24(X2 ~= 0);
    CarsDown = position13(Y1 ~= 0);
    CarsUp = position24(Y2 ~= 0);
    CarsKreuz = positionKreuz(kreuz ~= 0);

    
    X = [CarsLeft, CarsRight, zeros(size(CarsDown)), zeros(size(CarsUp)), CarsKreuz];
    Y = [zeros(size(CarsLeft)), zeros(size(CarsRight)), CarsDown, CarsUp, CarsKreuz];
     
    scatter(X,Y)
    plot([-CellsNumber-1, CellsNumber+1], [-1, -1], '-b',...
                    [-CellsNumber-1, CellsNumber+1], [1, 1], '-b', [1, 1],...
                    [-CellsNumber-1, CellsNumber+1], '-b', [-1, -1],...
                    [-CellsNumber-1, CellsNumber+1], '-b');
    axis([-CellsNumber-1 CellsNumber+1 -CellsNumber-1 CellsNumber+1])
    pause(0.5)
end;

