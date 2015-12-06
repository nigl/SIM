clc;
close all;
clear all;

global P;

CellSize=7.5;% m
TotalLength=2250;%m
CellsNumber=50;%Anzahl Zellen bis zur Kreuzung
CellsTotalNumber=2*CellsNumber+1;%Insgesamt 2 Teilstücke je CellsNumber +2 Kreuzungszellen
PLinger=0.05;%Trödelwkt
SpeedMax=5;
SpeedStart=1;%Maximale geschwindigkeit nach Stop bei Hindernis
Density=0.05;

TimeSteps = 30;

%Matrix P shiftet Vektor der Länge CellsTotalNumber um 1 hoch
P=diag(ones(1,CellsTotalNumber-1), 1)+ diag(1,-CellsTotalNumber+1);

%Cells 3 dimensionaler Vektor, erste D sind die Zellen, zweite D die
%Zeitschritte, dritte D; 1 ist Geschwindigkeit und 2 ist Autonummer bzw
%Hindernis(-1)
CellsH=zeros(CellsTotalNumber,TimeSteps,2);
CellsV=zeros(CellsTotalNumber,TimeSteps,2);

ObstaclesH=zeros(CellsTotalNumber,1);
ObstaclesV=zeros(CellsTotalNumber,1);

%Initialisierung der Kreuzung, die Nummer gibt an um welche Kreuzung es
%sich handelt
ObstaclesH(CellsNumber+1,1) = 1;% 1 ist von links nach rechts
ObstaclesV(CellsNumber+1,1) = 1;% 1 ist von unten nach oben

%Anfangsinitialisierung von Cells
%Random Startbelegung
RandStartH = rand(CellsTotalNumber,1);
NumberCarsH = sum(RandStartH < Density);
CellsH(RandStartH < Density, 1, 2) = 1: NumberCarsH ;
CellsH(RandStartH < Density, 1, 1) =  floor((6)*rand(NumberCarsH,1)) ;

RandStartV = rand(CellsTotalNumber,1);
NumberCarsV = sum(RandStartV < Density);
CellsV(RandStartV < Density, 1, 2) = 1: NumberCarsV ;
CellsV(RandStartV < Density, 1, 1) =  floor((6)*rand(NumberCarsV,1)) ;
%Doppelbelegung der Kreuzung verhindern
if( CellsV(CellsNumber+1,1,1) ~= 0)
    CellsV(CellsNumber+1,1,1) = 0;
    CellsV(CellsNumber+1,1,2) = 0;
end

% CellsH(CellsNumber,1,1)=1;
% CellsH(CellsNumber,1,2)=1;
% CellsV(CellsNumber,1,1)=1;
% CellsV(CellsNumber,1,2)=1;
% CellsH(CellsNumber-1,1,1)=1;
% CellsH(CellsNumber-1,1,2)=1;
% CellsV(CellsNumber+1,1,1)=1;
% CellsV(CellsNumber+1,1,2)=1;

%Nagelschreckenberg Zauberalgorithmus
for t=2:TimeSteps
    %Bremsen und Beschleunigen von Autos nicht vor Hindernissen
    TempCellsH=adjustSpeed(CellsH(:, t-1, 1),CellsH(:, t-1, 2), ObstaclesH, SpeedMax);
    TempCellsV=adjustSpeed(CellsV(:, t-1, 1),CellsV(:, t-1, 2), ObstaclesV, SpeedMax);
   
    %Beschleunigen für Autos vor Hindernissen
    %CarsBeforeObs gibt an welche Autos vor einem Hindernis stehen, Annahme
    %Hindernisse sind auf beiden Straßen an der gleichen Stelle, 
    %TODO für unterschiedliche Positionen 
    CarsBeforeObsH = (CellsH(:, t-1, 2) ~= 0 & P*ObstaclesH ~= 0 ).*CellsH(:, t-1, 2);
    FreeAheadH = freeCells(CarsBeforeObsH, zeros(size(ObstaclesH)), SpeedStart);
    
    CarsBeforeObsV = (CellsV(:, t-1, 2) ~= 0 & P*ObstaclesV ~= 0 ).*CellsV(:, t-1, 2);
    FreeAheadV = freeCells(CarsBeforeObsV, zeros(size(ObstaclesV)), SpeedStart);
    
    %CarsInObs gibt an ob ein Auto in einem Hindernis steht
    CarsInObs = (ObstaclesH ~= 0).* (CellsH(:, t-1, 2) ~= 0) | (ObstaclesV ~= 0).*(CellsV(:, t-1, 2) ~= 0);
    % Blocked gibt an ob die Kreuzung frei ist
    ObsFree = P*(~CarsInObs);
    
    %Regulation Rule ist nur für vertikalfahrende Autos, da horizontal
    %immer Vorfahrt hat
    RegulationRule=rechtsVorLinks(CarsBeforeObsH, CarsBeforeObsV);
    TempCellsH = TempCellsH + (RegulationRule).*(ObsFree).*(FreeAheadH >= SpeedStart).*(CarsBeforeObsH ~= 0);
    TempCellsV = TempCellsV + (~RegulationRule).*(ObsFree).*(FreeAheadV >= SpeedStart).*(CarsBeforeObsV ~= 0);
    
    %Trödeln
    RandH = rand(CellsTotalNumber,1);
    RandV = rand(CellsTotalNumber,1);
    TempCellsH(RandH < PLinger) = max(TempCellsH(RandH < PLinger)-1, 0);   
    TempCellsH(RandV < PLinger) = max(TempCellsV(RandV < PLinger)-1, 0); 
    
    %Autos neusetzen
    [CellsH(:,t,1), CellsH(:,t,2)] = shift(CellsH(:, t-1, 2), TempCellsH, CellsTotalNumber);
    [CellsV(:,t,1), CellsV(:,t,2)] = shift(CellsV(:, t-1, 2), TempCellsV, CellsTotalNumber);
end
plotCars2(CellsH, CellsV, CellsNumber);
