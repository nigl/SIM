function [] = plotAll(Cells)
  %function plotCarsAll plottet die Autos über die Zeit
    CellsNumber = (size(Cells,1)-1)/2;
    position = (-CellsNumber:CellsNumber);
    
    for t=1:size(Cells,2)
        
        Cars = Cells(:, t, 2);
        %X2 = Cells(CellsNumber+1:CellsNumber*2+1, t, 2);
    
        Carsp = position(Cars ~= 0);
        
        if(t == 1)
            X = Carsp;
            Y = ones(size(Carsp));
            Z = Cells(Cells(:, t, 2) ~= 0, t, 2)';
        else
            X = [X, Carsp];
            Y = [Y, t*ones(size(Carsp))];
            Z = [Z, Cells(Cells(:, t, 2) ~= 0, t, 2)'];
        end
    
    end
    %Plot
    figure();
    scatter(X, Y,[], Z, 'filled');
 
end



