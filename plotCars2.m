function plotCars2( CellsH , CellsV, CellsNumber , fig)

for j=1:size(CellsH,2)

    X1 = CellsH(1:CellsNumber,j,2);
    X2 = CellsH(CellsNumber+1:CellsNumber*2+1, j, 2);
    Y1 = CellsV(1:CellsNumber, j, 2);
    Y2 = CellsV(CellsNumber+1:CellsNumber*2+1, j, 2);
    
    position13 = (-CellsNumber:-1);
    position24 = (0:CellsNumber);

    CarsLeft = position13(X1 ~= 0);
    CarsRight = position24(X2 ~= 0);
    CarsDown = position13(Y1 ~= 0);
    CarsUp = position24(Y2 ~= 0);
  
    
    XV = [zeros(size(CarsDown)), zeros(size(CarsUp))];
    YV = [CarsDown, CarsUp];
    
    XH = [CarsLeft, CarsRight];
    YH = [zeros(size(CarsLeft)),  zeros(size(CarsRight))];
    plot(fig, XV, YV, 'o', XH, YH, 'or',  ...
                    [-CellsNumber-1, CellsNumber+1], [-1, -1], '-b',...
                    [-CellsNumber-1, CellsNumber+1], [1, 1], '-b', [1, 1],...
                    [-CellsNumber-1, CellsNumber+1], '-b', [-1, -1],...
                    [-CellsNumber-1, CellsNumber+1], '-b');
    axis(fig, [-CellsNumber-1 CellsNumber+1 -CellsNumber-1 CellsNumber+1])
    pause(0.1)
end;

