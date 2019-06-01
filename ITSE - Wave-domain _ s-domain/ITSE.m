function [itse] = ITSE(H, n);
%% itse = ITSE(H, n)
%
% Takes input of a transfer function and returns the IT^nSE of the system.
% The ITSE stands for the Integral of Time by the Square of the Error and
% the function scales to any power of time from 0 - infinity. If order, n,
% is not specified, it is taken as 1, i.e. the ITSE
%
% Example:
%
%   H = tf([1], [1 1.19 1]);
%   itse = ITSE(H, 1); 
%   
%   itse =
%       
%       0.7071
%
%   This is the IT^(1)SE of the second order normalised system: 
%               1
%   -----------------------------
%      s^2   +   1.19s  +   1
%
%

% Creator:  Padraig Basquel, SEEE, UCD
% Revision: 1.5 - Stability check included
%               - Edited output
% Date:     10/4/2017

%% Input Check
switch nargin
    case 1
        n = 1;
end
%% Confirm stability
[NUM, DEN] = tfdata(H, 'v');
stable = 1; % flag for instability
[R, P, K] = residue(NUM, DEN); % P(j) are roots to denominator
Y = sign(real(P)); % Find sign of real part of roots
for j = 1:length(P) % Loop through roots
    if (Y(j) == 1), stable = -1; % if roots negative, flag
    end
end

%% Find IT^(order)SE
if (stable == 1) % If roots are stable
[A, B, C, D] = tf2ss(NUM, DEN); % find state space model
P0 = (B*B');
N = 0; % begin at N = 0
while n >= N
    P = lyap(A, P0); % Solves the equation: A*P0 + P0*A' + P = 0
    N = N + 1; % Increase counter
    P0 = P; % Substitute for next iteration
end
Chat = -C*(inv(A));
itse = factorial(n)*Chat*P*(Chat'); % calculate ISE
else % If system is unstable
itse = inf; % Output infinity, unstable system is useless
error('System input is not stable')
end   
end