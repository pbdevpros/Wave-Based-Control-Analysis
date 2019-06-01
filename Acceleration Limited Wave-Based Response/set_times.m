function op = set_times(y, n, t, options)
%% op = set_times(y,n,t,options)
%           
%           Objective of this code is to read in step response data. Finds the point 
%           at which the 2% Settling Time. Draws horizontal lines above and 
%           below the step response to indicate to user where this line is located.
%           NB: This function finds the n% settling time of a wave based control
%           scheme, to an accuracy of 3 decimal places.
%           It is assumed that the control scheme has perfect tracking, i.e. it
%           eventually settles at a final value of 1 to a step input (or oscillates
%           extremely close to this value).
%
%       Example:
%
%              settlingtime = set_time(data, 0.01, tau, 'plot');
%              
%           will give the 1% Settling time of the response, "data" vector,
%           where tau is the time vector. The option 'plot' produces a plot
%           of the response with the 1% band and 1% settling time
%           highlighted.
%
%

% Revision: 3.2 -   Finds final value, breaks if system oscillates past
%                   time limit
%               -   Reading in data, find for case: G(G) = 0.5 + 0.5*G
% Creator: Padraig Basquel, SEEE UCD
% Date: 4/4/2017

%% Input check
switch nargin
    case (3)
        options = '';
end
%% Read in Data and Process
fprintf('-----------------------------------------------------------\n')
step_data = y;                                                              % create step data vector
final = 1;                                                                  % final value
% Find 1st Peak & Trough less than 2% of Final Value
[maxpks, maxlocs] = findpeaks(step_data, 'MinPeakDistance', 40);            % find the locations of the peaks
step_data_inv = 1.01*max(step_data) - step_data;                            % reverse data for finding troughs
[minpks, minlocs] = findpeaks(step_data_inv, 'MinPeakDistance', 40);                               % find the locations of the troughs
% Compare Final Value calculations
no_pks = [length(maxlocs) length(minlocs)];                                 % length vector of number of peaks
no_pks = min(no_pks);                                                       % find smallest number - of troughs of peaks
final_vals = zeros(1, no_pks);                                              % initialise vector
for k = 1:no_pks                                                            % find the average distance between peaks
    final_vals(k) = step_data(minlocs(k)) + (step_data(maxlocs(k)) - step_data(minlocs(k)))/2; % find final values
end
final_new = round(mean(final_vals)*10000)/10000; % find the average of the final values
fprintf('\nFinal_new is %2.5f', final_new);
if final_new ~= final                                                       % if the average final value is not = 1, print error
    %fprintf('Changing final value to %2.2f', final_new)
    final_new = final; % force the final value = 1                          % error check
end
% Calculate Position of 2% Band
[nup_rows, nup_cols] = find(step_data(1,:) >= (final_new+n), 1, 'last');    % find last point outside 2% band (> 1+n)
[ndwn_rows, ndwn_cols] = find(step_data(1,:) <= (final_new-n), 1, 'last');  % find last point outside 2% band (< 1-n)
if ((ndwn_cols) == length(step_data)) && (nup_cols == length(step_data))    % error check for step input which  
    error('\nThe system is not stable or the specified time is too short.')
end
if nup_cols > ndwn_cols
    m_vals = round(step_data(1,nup_cols)*1000)/1000;                        % round to 3rd decimal place
    if (m_vals ~= final_new+n)
    fprintf('\tClosest value to the %2.4f band is %2.4f', final_new+n, m_vals)
%     m_vals = final_new + n;
    end
else 
    m_vals = round(step_data(1,ndwn_cols)*10000)/10000;                     % round to 3rd decimal place
    if (m_vals ~= final_new-n)
    fprintf('\tClosest value to the %2.4f band is %2.4f', final_new-n, m_vals) % print final value
%     m_vals = final_new - n;
    end
end
% Find settling times
    % Plot 2% Settling Time Point on axis
    % inputs needed - x,y coordinates & timespan (t) of plot
    % take in coordinates of location of final peak
    if m_vals > final_new
        min_point = (final_new-n)*(m_vals/(final_new+n));                                       % (1+n)% of final value - mirrored n% band
        min_band = min_point*(ones(1, length(t)));                              % horizontal line
        max_band = m_vals*ones(1,length(t));                                    % horizontal line
%         plot(t(nup_cols), step_data(nup_cols), 'kx')                            % plot 2% band marker
%         plot(t(nup_cols), [0:0.01:step_data(nup_cols)], 'r-')                   % plot 2% band marker
        fprintf('\nThe %.0f%% Settling Time is %.2f normalised time units\n', (n*100), t(nup_cols))
        op = t(nup_cols);
    else
        min_point = m_vals;                                                     % (1-n)% of final value - point entering n% band
        min_band = min_point*ones(1,length(t));                                 % horizontal line 
        max_point = (final_new+n)*(min_point/(final_new-n));                                    % (1+n)% of final value - mirrored n% band
        max_band = max_point*(ones(1, length(t)));                              % horizontal line
%         plot(t(ndwn_cols), step_data(ndwn_cols), 'kx')                          % plot 2% band marker
%         plot(t(ndwn_cols), [0:0.01:step_data(ndwn_cols)], 'r-')                 % plot 2% band marker
        fprintf('\nThe %.0f%% Settling Time is %.2f nomalised time units\n', (n*100), t(ndwn_cols))
        op = t(ndwn_cols);
    end
% Plot options    
if strcmp(options,'plot')
    % Initialise Plotting Colours
    RGB_lightblue = [0,0.537254901960784,0.811764705882353];
    RGB_darkblue = [0 66 122]/256;
    % Plot values - with peaks if needed
    figure
    plot(t, step_data,'Color',RGB_lightblue);                                   % plot step response
    hold on;
    % Plot 2% Settling Time Band
    plot(t, min_band, 'k--', t, max_band, 'k--')                                % plot the 2% bands
    % set(gca, 'xticklabel', t(1:2000:20001));
end
end