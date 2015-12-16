function [ Speed ] = linger(Speed, pLinger)
%LINGER updated den Speed geschwindigkeits vektor gemäß der übergebenen 
% trödel wahrscheinlichkeit
Rand = rand(size(Speed));
Speed(Rand < pLinger) = max(Speed(Rand < pLinger)-1, 0);   

end
