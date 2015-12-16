clc;
close all;
clear all;

% Anzahl Zellen bis zur Kreuzung
cellNum=100;
% Tr�delwkt
pLinger=0.30;
% Maximale geschwindigkeit
vmax=5;
% Maximale geschwindigkeit nach Stop bei Hindernis
speedStart=1;
densityH=0.30;
densityV=0.01:0.001:0.99;
timesteps=100;

sims = cell(numel(densityV, 1));
for i  = 1:numel(densityV)
    %% basic data
    sim.timesteps = timesteps;
    sim.vmax = vmax;
    sim.pLinger = pLinger;
    sim.densityV = densityV(i);
    sim.densityH = densityH;
    
    %% horizontale straße
    [CellsH, ObstaclesH, crossingH] = init_street(cellNum, 1, densityH, vmax, timesteps);
    sim.CellsH = CellsH;
    sim.ObstaclesH = ObstaclesH;
    sim.crossingH = crossingH;
    
    %% vertikale straße
    [CellsV, ObstaclesV, crossingV] = init_street(cellNum, 1, densityV(i), vmax, timesteps);
    % Doppelbelegung der Kreuzung(en) verhindern
    if( CellsV(crossingV,1,1) ~= 0)
        CellsV(crossingV,1,1) = 0;
        CellsV(crossingV,1,2) = 0;
    end
    sim.CellsV = CellsV;
    sim.ObstaclesV = ObstaclesV;
    sim.crossingV = crossingV;
    
    % Anzahl der tatsaechlichen Autos
    sim.numCarsV = sum(sim.CellsV(:, 1, 2) ~= 0);
    sim.numCarsH = sum(sim.CellsH(:, 1, 2) ~= 0);
    
    %% Nagelschreckenbergs Zauberalgorithmus
    sim = nagelschreckenberg(sim);
    sims{i} = sim;
end
% plotCars2(sims{1}.CellsH, sims{1}.CellsV, cellNum);
% plotAll(sims{1}.CellsV, cellNum);
% plotAll(sims{1}.CellsH, cellNum);
% plotAllAnimate(sims, cellNum);
plotDensity(sims.CellsH, cellNum+1);
