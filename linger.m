function [ Speed ] = linger(Speed, pLinger)
%LINGER updated den Speed geschwindigkeits vektor gemäß der übergebenen 
% troedel wahrscheinlichkeit

% Rand = rand(size(Speed));
% Speed(Rand < pLinger) = max(Speed(Rand < pLinger)-1, 0); 


nonZeroIndices = find(Speed);
Rand = rand(size(nonZeroIndices));
choosenIndices = nonZeroIndices(Rand<pLinger);
Speed(choosenIndices) = max(Speed(choosenIndices)-1,0);

end

