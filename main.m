clc;
close all;
clear all;

CellSize=7.5;% m
TotalLength=2250;%m
CellsNumber=20;%Anzahl Zellen bis zur Kreuzung
CellsTotalNumber=4*CellsNumber+2;%Insgesamt 4 Teilstücke je CellsNumber +2 Kreuzungszellen(je in jede 1 Richtung eine)
P=0.2;%Trödelwkt
SpeedMax=5;
Density=0.20;
CarsNumber=floor(CellsTotalNumber*Density);
TimeSteps=30;

%Cells 3 dimensionaler Vektor, erste D sind die Zellen, zweite D die
%Zeitschritte, dritte D; 1 ist Geschwindigkeit und 2 ist Autonummer bzw
%Hindernis(-1)
Cells=zeros(CellsTotalNumber,TimeSteps,2);
Obstacles=zeros(CellsTotalNumber,1);

%Initialisierung der Kreuzung
Obstacles(CellsNumber+1,1)=1;%+1 ist von links nach rechts
Obstacles(CellsTotalNumber-CellsNumber+1,1)=-1;%-1 ist von unten nach oben
%Anfangsinitialisierung von Cells
Cells(1, 1, 1) = 1;%Speed
Cells(1, 1, 2) = 1;%Autonummer
Cells(2, 1, 1) = 1;%Speed
Cells(2, 1, 2) = 5;%Autonummer
Cells(30, 1, 1) = 2;%Speed
Cells(30, 1, 2) = 2;%Autonummer
Cells(10, 1, 1) = 1;%Speed
Cells(10, 1, 2) = 3;%Autonummer
Cells(50, 1, 1) = 4;%Speed
Cells(50, 1, 2) = 4;%Autonummer
%TODO Random Startbelegung

P=diag(ones(1,CellsTotalNumber-1), 1)+ diag(1,-CellsTotalNumber+1);
%Nagelschreckenberg Zauberalgorithmus
for t=2:TimeSteps
    
    Car_now = Cells(:, t-1, 2);
    Speed_now = Cells(:, t-1, 1);
    
    %Beschleunigen für Autos die nicht vor Hindernissen stehen
    Speed=min(SpeedMax, Speed_now+1);
    FreeAhead=freeCells(Car_now, Obstacles, SpeedMax);
    % bechleunige die zu beschleunigenden und die anderen gleich lassen
    %TempCells= ((FreeAhead < Speed_now).*Speed_now + (FreeAhead >= Speed_now).*Speed).*(Car_now ~= 0);
    TempCells= ((FreeAhead < Speed).*Speed_now + (FreeAhead >= Speed).*Speed).*(Car_now ~= 0);
    
    %Bremse die zu bremsenden und lasse die anderen gleich
    SpeedAfterBrake=(FreeAhead<Speed_now).*FreeAhead.*(Car_now ~= 0);
    TempCells(FreeAhead<Speed_now)=SpeedAfterBrake(FreeAhead<Speed_now);
    
    %Beschleunigen für Autos vor Hindernissen
    CarsBeforeObs = (Car_now ~= 0 & P*Obstacles ~= 0).*Car_now;
    FreeAhead = freeCells(CarsBeforeObs,zeros(size(Obstacles)),SpeedMax);
    TempCells = TempCells + (FreeAhead >= Speed_now).*Speed.*(CarsBeforeObs ~= 0);
    %Falls Auto vor Hindernis steht Entscheidungsregel anwenden
    
    
    %Trödeln
    
    %Autos neusetzen
    for j=1:CellsTotalNumber
        % shift only the cars not the empty ones
        if(Car_now(j) ~= 0);
            % update
            %TODO VLLT errordetection
            new_pos = mod(j+TempCells(j), CellsTotalNumber);
            if new_pos == 0
                new_pos = CellsTotalNumber;
            end
            Cells(new_pos, t, 1) = TempCells(j);
            Cells(new_pos, t, 2) = Car_now(j);
        end
    end
end

plotCars(Cells,CellsNumber)