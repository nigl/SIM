function [ sim ] = nagelschreckenberg(sim)
%nagelschreckenberg Simulates the nagelschreckenberg model with the given initial conditions

% Matrix Ph / Pv shiftet Vektor der L�nge totalCellNum um 1 hoch
%totalCellNum = size(sim.CellsH, 1);
%Ph=diag(ones(1,totalCellNum-1), 1) + diag(1,-totalCellNum+1);
%totalCellNum = size(sim.vert{1}.CellsV, 1);
%Pv=diag(ones(1,totalCellNum-1), 1) + diag(1,-totalCellNum+1);

for t=2:sim.timesteps
    %% Bremsen und Beschleunigen von Autos nicht vor Hindernissen
    TempCellsH = adjustSpeed(sim.CellsH(:, t-1, 1), ...
                             sim.CellsH(:, t-1, 2), ...
                             sim.ObstaclesH, ...
                             sim.vmax);
    TempCellsV = adjustSpeed(sim.CellsV(:, t-1, 1), ...
                             sim.CellsV(:, t-1, 2), ...
                             sim.ObstaclesV, ...
                             sim.vmax);        
   
    %% Die Kreuzung updaten
    % Vector der angibt ob die kreuzung belegt ist
    crossing_set = sim.CellsH(sim.crossingH, t-1, 2) ~= 0 | ...
                   sim.CellsV(sim.crossingV, t-1, 2) ~= 0;
    % Vector der angibt ob vertical ein auto vor der kreuzung steht
    vert_before_crossing = sim.CellsV(sim.crossingV-1, t-1, 2) ~= 0;
    
    TempCellsH(sim.crossingH-1) = TempCellsH(sim.crossingH-1) + ~crossing_set.*~vert_before_crossing;
    TempCellsV(sim.crossingV-1) = TempCellsV(sim.crossingV-1) + ~crossing_set.*vert_before_crossing;
    
    % TODO andere obstacles (nicht kreuzungen) auch updaten!
   
    %% Tr�deln
    TempCellsH = linger(TempCellsH, sim.pLinger);
    TempCellsV = linger(TempCellsV, sim.pLinger);
    
    %% Autos neusetzen
    [sim.CellsH(:,t,1), sim.CellsH(:,t,2)] = shift(sim.CellsH(:, t-1, 2), TempCellsH);
    [sim.CellsV(:,t,1), sim.CellsV(:,t,2)] = shift(sim.CellsV(:, t-1, 2), TempCellsV);
end

end

