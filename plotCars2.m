function plotCars2( CellsH , CellsV, CellsNumber , fig)

for j=1:size(CellsH,2)

    X1 = CellsH(1:CellsNumber,j,2);
    X2 = CellsH(CellsNumber+1:CellsNumber*2+1, j, 2);
    Y1 = CellsV(1:CellsNumber, j, 2);
    Y2 = CellsV(CellsNumber+1:CellsNumber*2+1, j, 2);
    
    position13 = (0:CellsNumber);
    position24 = (CellsNumber+1:2*CellsNumber+1);

    CarsLeft = position13(X1 ~= 0);
    CarsRight = position24(X2 ~= 0);
    CarsDown = position13(Y1 ~= 0);
    CarsUp = position24(Y2 ~= 0);
  
    
    XV = CellsNumber*[ones(size(CarsDown)), ones(size(CarsUp))];
    YV = [CarsDown, CarsUp];
    
    XH = [CarsLeft, CarsRight];
    YH = CellsNumber*[ones(size(CarsLeft)),  ones(size(CarsRight))];
    plot(fig, XV, YV, 'o', XH, YH, 'or',  ...
                    [0, 2*CellsNumber+1], [CellsNumber-1, CellsNumber-1], '-b',...
                    [0, 2*CellsNumber+1], [CellsNumber+1, CellsNumber+1], '-b', ...
                    [CellsNumber+1, CellsNumber+1], [0, 2*CellsNumber+1], '-b', ...
                    [CellsNumber-1, CellsNumber-1], [0, 2*CellsNumber+1], '-b');
    axis(fig, [0 2*CellsNumber+1 0 2*CellsNumber+1])
    pause(0.1)
end;

