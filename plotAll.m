function [] = plotCars2( Cells, CellsNumber )
  T = size(Cells,2);
  position13 = (-CellsNumber: -1);
  position24 = (0: CellsNumber);
for t=1:size(Cells,2)

    X1 = Cells(1:CellsNumber, t, 2);
    X2 = Cells(CellsNumber+1:CellsNumber*2+1, t, 2);
    
    CarsLeft = position13(X1 ~= 0);
    CarsRight = position24(X2 ~= 0);
    if(t == 1)
        X = [CarsLeft, CarsRight];
        Y = [ones(size(CarsLeft)),  ones(size(CarsRight))];
        Z = Cells(Cells(:, t, 2) ~= 0, t, 2)';
    else
        X = [X, [CarsLeft, CarsRight]];
        Y = [Y, t*[ones(size(CarsLeft)),  ones(size(CarsRight))]];
        Z = [Z, Cells(Cells(:, t, 2) ~= 0, t, 2)'];
    end
    
   
    
end
figure
scatter(X, Y, [], Z)
end



