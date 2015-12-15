function [ Cells, Obstacles, crossing ] = init_street(cellnum, crossingnum, density, vmax, timesteps)
%UNTITLED Baut einen sra�en abschitt (vertikal oder horizotal)
%   Cells speichert die autos, Obstacles die Kreuzungen, und crossing die
%   kreuzungs indizes

totalcellnum = cellnum*(crossingnum+1) + crossingnum;
crossing = cellnum+1:cellnum+1:totalcellnum;
Cells=zeros(totalcellnum, timesteps, 2);
Obstacles=zeros(totalcellnum, 1);

% in der mitte ist die kreuzung
Obstacles(crossing, 1) = 1:crossingnum;

%Random Startbelegung
RandStart = rand(totalcellnum, 1);
numberCars = sum(RandStart < density);

%Cells 3 dimensionaler Vektor, erste D sind die Zellen, zweite D die
%Zeitschritte, dritte D; 1 ist Geschwindigkeit und 2 ist Autonummer bzw
Cells(RandStart < density, 1, 2) = 1:numberCars;
Cells(RandStart < density, 1, 1) = floor((vmax+1)*rand(numberCars, 1));

end