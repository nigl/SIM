function plotSpeed(sims,fig)
%PLOTSPEED Plot des Dichte-Geschwindigkeitsdiagrammes

% das was wir als v density eingestellt haben
%densityV = cellfun(@(s) s.densityV, sims);
actDensityV = cellfun(@(s) s.numCarsV/numel(s.CellsV(:,1,1)), sims);

%Anzahl der Zeitschritte
timeSteps = numel(sims{1}.CellsV(1,:,1));

% die tatsaechliche dichte (anzahl der autos / anzahl der zellen)
%carsV = cellfun(@(s) s.numCarsV, sims);
%act_densityV = carsV ./ numel(sims{1}.CellsV(:, 1, 2));

%Durschschnittgeschwindigkeit bestimmen
aveSpeedV = cellfun(@(s) aveSpeed(s.CellsV, timeSteps, s.numCarsV), sims);

aveSpeedH = cellfun(@(s) aveSpeed(s.CellsH, timeSteps, s.numCarsH), sims);

plot(fig, actDensityV, aveSpeedH, '.r', actDensityV, aveSpeedV, '.b', 'MarkerSize', 16)
xlabel(fig, 'vertikale Dichte')
ylabel(fig, 'Fzg/h')
legend(fig, 'Durschnittsgesch. horizontal', 'Durschnittsgesch. vertikal')
end

function [speed] = aveSpeed(Cells, timeSteps, numCars)
%berechnet Durchschnittsgeschwindigkeit

%falls keine Autos keine kekse
if numCars < 1
    speed = 0;
    return;
end

sumOfSpeeds = sum(sum(Cells(:, :, 1), 2));
speed = sumOfSpeeds/(numCars*timeSteps);

end


