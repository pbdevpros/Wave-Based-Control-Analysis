function x_n = response(n, T0, a, tau)
%% x_n = response(n,T0,a,tau)
%
% Finds the response of a system using wave-based control, with a
% pre-preamplifier, P, through the use of Bessel and Hypergeometric
% functions. n corresponds to the number of masses, T0 is defined by the
% user,a is the controller spec, from 0.5 -> 1.
% Time vector tau is assumed to be [0:0.01:19.99] if not specified.
%

% Creator:  Padraig Basquel
% Date:     28/04/2017
% Revision: 2.1 - Added tau vector for changing timespan
%% Find response
delta = 0.01;                                                   % sampling distance
omega = 1;                                                      % omega variable
switch nargin                                                   % input check
    case 3
        t_units = 20; % units of normalised time
        tau = omega*[0:delta:t_units - delta];
end
N = length(tau);                                                % No. of samples
sum = 0;                                                        % initialise
shift = round(T0/delta);                                        % delay
%Calculate value of the Time Optimal Equation: the generalised
%hypergeometric function and the variable "h1" are functions of normalised
%time.
f = hypergeom([1/2],[3/2 2],-(tau).^2);                         % hypergeometric function
for k = 2:2:2*n                                                 % calculate iteration of bessel functions
    sum = sum - ((n+1-k/2)^2 - (2*n+1-k)*a)*(besselj(k,2*tau));
end
h1 = 1/(T0^2)*(1/2*(tau.^2) - (n+1-a)*(tau.^2).*f - ((n+1)^2-(2*n+1)*a)/2*(besselj(0,2*tau)-1) + sum);
h1T = [zeros(1,shift) h1(1:N-shift)];                           % Repeat for h1 function shifted by T0
h12T = [zeros(1,2*shift) h1(1:N-2*shift)];                      % Repeat for h1 function shifted by 2*T0
%Calculate response of end mass according to Eq. 100
x_n = h1 - 2*h1T + h12T;                                        % x(double dot) 1 - acc. limit response for n = 1
end