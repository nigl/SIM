clc;
close all;
clear all;

global P;

CellSize=7.5;% m
TotalLength=2250;%m
CellsNumber=10;%Anzahl Zellen bis zur Kreuzung
CellsTotalNumber=2*CellsNumber+1;%Insgesamt 2 Teilstücke je CellsNumber +2 Kreuzungszellen
PLinger=0.05;%Trödelwkt
SpeedMax=2;
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


CellsH(CellsNumber,1,1)=1;
CellsH(CellsNumber,1,2)=1;
CellsV(CellsNumber,1,1)=1;
CellsV(CellsNumber,1,2)=3;
CellsH(CellsNumber-1,1,1)=1;
CellsH(CellsNumber-1,1,2)=2;
CellsV(CellsNumber+1,1,1)=1;
CellsV(CellsNumber+1,1,2)=4;

freeCellsM(CellsH(:,1,2), ObstaclesH, SpeedMax)
freeCells(CellsH(:,1,2), ObstaclesH, SpeedMax)