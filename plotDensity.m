function plotDensity( sims, flow_point )
%PLOTDENSITY Plot des Fundamentaldiagramms

% das was wir als v density eingestellt haben
densityV = cellfun(@(s) s.densityV, sims);

% die tatsächliche dichte (anzahl der autos / anzahl der zellen)
act_densityV = cellfun(@(s) sum(s.CellsV(:, 1, 2) ~= 0) / numel(s.CellsV(:, 1, 2)), sims);

% den fluss annähern (die anzahl der autos, die den flow_point überqueren)
flowH = cellfun(@(s) calc_flow(s.CellsH, flow_point), sims);
flowV = cellfun(@(s) calc_flow(s.CellsV, flow_point), sims);

figure;
plot(1:numel(sims), densityV, 1:numel(sims), act_densityV)
%figure;
%plot(act_densityV, flowH)
figure;
plot(densityV, flowH, '-o', densityV, flowV, '-x')
grid on;

end

function [flow] = calc_flow(Cells, flow_point)
% für jeden Zeitschritt die Anzahl der autos die "vor" und "nach" dem flowpoint stehen
% berechnen (es wird nur in richtung der Strecken dimension summiert!)
B = sum(Cells(1:flow_point, :, 2) ~= 0, 1);
%A = sum(Cells(flow_point+1:end, :, 2) ~= 0, 1);

% ist nun von einem zeitschritt auf dem anderen (diff) die anzahl "vor"
% dem flow_piont  kleiner geworden so haben autos diesen Punkt passiert
% TODO dass stimmt nicht ganz, denn wenn im selben zeitschritt eines von
% "nach" der kreuzung auf "vor" die kreuzung wechselt und eines über die 
% kreuzung fährt, dann sehen wir keine änderung...
change = diff(B);
change = change(change < 0);

flow = -sum(change);

end

