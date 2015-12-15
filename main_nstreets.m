clc;
close all;
clear all;

% Anzahl der Kreuzungen
crossingNum=2;
% Anzahl Zellen zwischen Kreuzungen
cellNum=100;
% Tr�delwkt
pLinger=0.30;
% Maximale geschwindigkeit
vmax=5;
% Maximale geschwindigkeit nach Stop bei Hindernis
speedStart=1;
densityH=0.05;
densityV=repmat(0.01, crossingNum);
timesteps=100;

sims = cell(numel(densityV, 1));
for i  = 1:size(densityV, 2)
    % basic data
    sim.timesteps = timesteps;
    sim.vmax = vmax;
    sim.pLinger = pLinger;
    sim.densityV = densityV(:,i);
    
    % horizontale straße
    [CellsH, ObstaclesH, crossingH] = init_street(cellNum, crossingNum, densityH, vmax, timesteps);
    sim.CellsH = CellsH;
    sim.ObstaclesH = ObstaclesH;
    sim.crossingH = crossingH;
    
    % vertikale straßen
    sim.vert = cell(numel(crossingNum), 1);
    for j = 1:crossingNum
        [CellsV, ObstaclesV, crossingV] = init_street(cellNum, 1, densityV(j, i), vmax, timesteps);
        
        % Doppelbelegung der Kreuzung(en) verhindern
        if( CellsV(crossingV,1,1) ~= 0)
            CellsV(crossingV,1,1) = 0;
            CellsV(crossingV,1,2) = 0;
        end
        sim.vert{j}.CellsV = CellsV;
        sim.vert{j}.ObstaclesV = j.*ObstaclesH;
        sim.vert{j}.crossingV = crossingV;
    end
    
    % Nagelschreckenbergs Zauberalgorithmus
    sim = nagelschreckenberg(sim);
    sims{i} = sim;
end
% plotCars2(CellsH, CellsV, cellsNumber);
% plotAll(CellsV, cellsNumber);
% plotAll(CellsH, cellsNumber);
