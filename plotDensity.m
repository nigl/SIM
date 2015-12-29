function plotDensity( sims, flow_point , fig)
%PLOTDENSITY Plot des Fundamentaldiagramms

% das was wir als v density eingestellt haben
densityV = cellfun(@(s) s.densityV, sims);

%Achsenbeschriftung bestimmen
timesteps = numel(sims{1}.CellsV(1,:,1));
secInHour = 3600 / timesteps;
% die tatsaechliche dichte (anzahl der autos / anzahl der zellen)
%carsV = cellfun(@(s) s.numCarsV, sims);
%act_densityV = carsV ./ numel(sims{1}.CellsV(:, 1, 2));


% den fluss annaehern (die anzahl der autos, die den flow_point Ueberqueren)
flowH = secInHour.*cellfun(@(s) calc_flow(s.CellsH, flow_point, s.numCarsH), sims);
flowV = secInHour.*cellfun(@(s) calc_flow(s.CellsV, flow_point, s.numCarsV), sims);

plot(fig, densityV, flowH, '-o', densityV, flowV, '-x')
ylabel('Fzg/h')
legend(fig, 'Horizontaler Fluss', 'Vertikaler Fluss')
end

function [flow] = calc_flow(Cells, flow_point, numCars)
% f√ºr jeden Zeitschritt die Anzahl der autos die "vor" und "nach" dem flowpoint stehen
% berechnen (es wird nur in richtung der Strecken dimension summiert!)

% keine autos keine kekse
if numCars == 0
    flow = 0;
    return;
end

% Betrachte von einem auf den anderen Zeitpunkt die
% Autonummer die am n‰chsten zum Obstacle ist
CarsBef = [Cells(flow_point+1:end, :, 2); Cells(1:flow_point, :, 2)];

lastCar = zeros(size(CarsBef, 2), 1);
for i=1:size(CarsBef, 2)
    cars = CarsBef(:, i);
    not_empty = cars ~= 0;
    cars = cars(not_empty);
    lastCar(i) = cars(end);
end
change = -diff(lastCar);

% Korrektur der negativen Werte
change(change < 0) = change(change < 0) + numCars;
flow = sum(change);

end

