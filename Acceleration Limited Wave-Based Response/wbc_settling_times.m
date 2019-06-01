%% Calculate Respose of a System Using WBC w/ Preamplifier
% Finds the 1% and 2% settling times for a system with a controller
% specified and over a varying number of masses and springs. Uses the value
% of eta from Time Optimal Control calculations to find corresponding
% wave-based settling times

% Creator:  Padraig Basquel, UCD, SEEE
% Date:     27/04/2017
% Revision: 2.1 - edited time samples to obtain more accurate results
delta = 0.01;                                                                % delta
a = 0.5;                                                                     % a
t_units = 20;                                                                % units of normalised time
omega = 1;                                                                   % omega squared
L = 1;                                                                       % L
tau = omega*[0:delta:t_units - delta];                                       % time vector
eta = 2;                                                                     % value for eta
a_max = (omega^2)*L/(2*eta);                                                 % maximum acceleration physical limit
T0 = omega*sqrt(L/(2*a_max));                                                % Calculate T0
max_acc = acc_limit(1,T0,a, tau);                                            % find maximum acceleration limit


% Using U\bar_0 = 0.5U\bar
% Find response of system
f = fopen('wbc_settling_times.txt.', 'w');
for n = 1:8                                                                 % iterate for varying of n
    f = fopen('wbc_settling_times.txt.', 'a+');                             % open file to append
    fprintf(f, '\n------------------------------------------------------------------\n\tn = %1.0f:', n);
    if n == 3                                                               % extend timespan
        tau = omega*[0:delta:30 - delta];                                           
    elseif n == 7                                                           % create longer vector
        tau = omega*[0:delta:50 - delta];
    end
    x_n = response(n, T0, a, tau);                                          % find response
    st1 = set_times(x_n, 0.01, tau);                                        % find 1% settling time
    st2 = set_times(x_n, 0.02, tau);                                        % find 2% settling time
    fprintf(f, ' 2%% Settling Time is = %2.2f,\n\t\t   1%% Settling Time is = %2.2f.\n', st2, st1);
    fprintf(f, '\n-----------------------00000000000-------------------------------\n');
    fclose(f);                                                              % close file
end