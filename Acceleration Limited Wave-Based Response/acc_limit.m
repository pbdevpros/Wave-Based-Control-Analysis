function maximum = acc_limit(n, T0, a, tau)
%% maximum = ACC_LIMIT(n,T0,a,tau)
% 
% Finds the maximum acceleration limit of the system input for a given
% controller specification, number of masses and value of T0. Time vector
% is input as tau, assumed to be [0:0.001:20] if no tau input.
%
%

% Revision: 2.1 - edited to general case
% Date:     28/04/2017
% Creator:  Padraig Basquel, UCD, SEEE
%% Find Acceleration Limit
delta = 0.01;
t_units = 20;                                                       % units of normalised time
omega = 1;                                                          % omega squared
switch nargin                                                       % input check
    case 3
        tau = omega*[0:delta:t_units - delta];
end
N = length(tau);                                                    % No. of samples
sum = 0;                                                            % initialise
% Calculate h0
shift = round(T0*1/delta);                                          % shift by T0
for k = 2:2:4*n                                                     % calculate sum of Bessel functions
    sum = sum + besselj(k, 2*tau);
end
h0 = 1 - (1 - a)*besselj(0, 2*tau) - sum - (1 - a)*besselj((4*n + 2), 2*tau);   % h_0(t)
h0T = [zeros(1,shift) h0(1:N - shift)];                                         % shifted h_0(t)
h02T = [zeros(1, 2*shift) h0(1:N-2*shift)];                                     % shifted h_0(t)
x0 = (h0 - 2*h0T + h02T);                                                       % acceleration limit
maximum = max(x0);                                                              % find maximum
end
