function F = r2r_times(n,T0,RHO, X)
%% F = r2r_times(n,T0,RHO,X)
%
% This function is used to calculate the rest-to-rest times of a system of
% springs and masses using time optimal control. 
%
% Creator:  Padraig Basquel
% Date:     4/20/2017
% Revision: 3.2 - R2R times accurate to 4 decimal places

%% Calculate n + 1 equations
F = zeros(n+1,1);
F(1) = T0 - (X(1)^2)/8;
for i = 1:n
    F(1) = F(1) + (-1)^(i+1)*X(i+1)^2;
end
for j = 2:n+1
    F(j) = cos(RHO(j-1)*X(1)/2) + (-1)^(n+1);
end
for j = 2:n+1
    for i = 1:n
        F(j) = F(j) + 2*(-1)^(i)*cos(RHO(j-1)*X(i+1));
    end
end
end