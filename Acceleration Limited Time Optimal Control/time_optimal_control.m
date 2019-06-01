%% TIME OPTIMAL CONTROL CALCULATIONS:
% 
%   This script is used to calculate the rest-to-rest times for the time
%   optimal control of a system of springs and masses. Calculations can be
%   performed for a varying number of springs and masses and for a varying
%   acceleration limit. The script then prints to a file labelled:
%
%           'SettlingTimes.txt'
%
%      which shows the 1% & 2% settling times and the rest to rest times of
%      the time optimal control. There are 2 sections, the first calculates
%      the rest-to-rest times and the second is where the settling time
%      calculations are performed.
%
%
%   NB: A note on how the calculations are performed in Section 1.
%   1. Initial conditions are prepared.
%               - this is where user can change the variables being
%               calculated
%               
%                   eta:  
%                      change this vector to change the desired
%                   values of eta
%
%                   n:    
%                       change this to change the number of springs used.
%
%   2. Chebyshev polynomials of the 2nd kind are declared (included as the 
%   chebyshevU command is not available in MATLAB R2014a).
%   3. Roots of Chebyshev equation give the values of \rho_j - used to
%   calculate the switching times
%   4. Rest-to-Rest times are found by solving a set of equations giving
%   the vector output:
%       | tau_f |
%       | d_1   |
%   V = | d_2   |
%       | d_3   |
%       | ...   |
%       | d_n   |
%
%   5. These values tau_f, d_1,...,d_n are used to find the settling times
%   in Section 2.
%
%
% Creator:      Padraig Basquel, UCD, SEEE
% Date:         4/20/2017
% Revision:     5.6 - output to file included

%% -------------------------------------------------------------------------------------------------------------------------------------- %%
% ------------------------------------------------------- Section 1: --------------------------------------------------------------------- %
% --------------------------------------------------Find Rest-to-Rest Times--------------------------------------------------------------- %
% ---------------------------------------------------------------------------------------------------------------------------------------- %
% ---------------------------------------------------------------------------------------------------------------------------------------- %
%                          THIS SECTION CALCULATES THE REST TO REST TIMES
%                          OF THE TIME OPTIMAL CONTROL OF A SYSTEM OF n
%                          SPRINGS AND MASSES. THE OUTPUT OF THIS SECTION
%                          ARE:
%                               rest_times (Rest-2-Rest times)
%                               d_n        (used for switching times)
%
% ---------------------------------------------------------------------------------------------------------------------------------------- %
% ---------------------------------------------------------------------------------------------------------------------------------------- %

% VARIABLES WHICH THE USER CAN CHANGE
n = 1:8;                                                % number of springs and masses
eta = 0.5:0.1:2;                                        % Desired range of eta for R2R calculations
eta_range = [0.5:0.5:2];                                % Desired range of eta for 1 & 2% Calculations

% Create Initial Condition
tol = 1E-06;                                            % tolerance
check = 1;                                              % iteration counter for accuracy loop                                    
final_val = zeros(n(length(n))+1,length(eta));          % vector for storing rest times
OPTIONS = optimoptions('fsolve','Algorithm','levenberg-marquardt', 'Display', 'none'); % Options - CHANGE 'Display' TO 'iter' TO SEE ACCURACY OF REST TIMES
%% -------------------------------------------------------------------------------------------------------------------------------------- %%
% ---------------------------------------------------------------------------------------------------------------------------------------- %
% -------------------------------------------- Define Chebyshev Functions  --------------------------------------------------------------- %
% ---------------------------------------------------------------------------------------------------------------------------------------- %
% ---------------------------------------------------------------------------------------------------------------------------------------- %
syms x; % create symbol
U0 = { 0; % U-1
    1; % U0
    symfun(2*(1 + x/2), x); % U1
    symfun(4*((1 + x/2)^2) - 1, x); % U2
    symfun(8*((1 + x/2)^3) - 4*(1 + x/2), x); % U3
    symfun(16*((1 + x/2)^4) - 12*(1 + x/2)^2 + 1, x); % U4 
    symfun(32*((1 + x/2)^5) - 32*(1 + x/2)^3 + 6*(1 + x/2), x); % U5
    symfun(64*((1 + x/2)^6) - 80*(1 + x/2)^4 + 24*(1 + x/2)^2 - 1, x); % U6
    symfun(128*((1 + x/2)^7) - 192*(1 + x/2)^5 + 80*(1 + x/2)^3 - 8*(1 + x/2), x); % U7
    symfun(256*(1 + x/2)^8 - 448*(1 + x/2)^6 + 240*(1 + x/2)^4 - 40*(1 + x/2)^2 + 1, x); % U8
    symfun(512*(1 + x/2)^9 - 1024*(1 + x/2)^7 + 672*(1 + x/2)^5 - 160*(1 + x/2)^3 + 10*(1 + x/2), x); % U9
    symfun(1024*(1 + x/2)^10 - 2304*(1 + x/2)^8 + 1792*(1 + x/2)^6 - 560*(1 + x/2)^4 + 60*(1 + x/2)^2 - 1, x); % U10
    symfun(2048*(1 + x/2)^11 - 5120*(1 + x/2)^9 + 4608*(1 + x/2)^7 - 1792*(1 + x/2)^5 + 280*(1 + x/2)^3 - 12*(1 + x/2), x); % U11
    symfun(4096*(1 + x/2)^12 - 11264*(1 + x/2)^10 + 11520*(1 + x/2)^8 - 5376*(1+x/2)^6 + 1120*(1 + x/2)^4 - 84*(1+x/2)^2 + 1, x); % U12
    symfun(8192*((1 + x/2))^13 - 24576*(1 + x/2)^11 + 28160*(1 + x/2)^9 - 15360*(1 + x/2)^7 + 4032*(1 + x/2)^5 - 448*(1 + x/2)^3 + 14*(1 + x/2), x); % U13
    symfun(16384*(1 + x/2)^14 - 53248*(1 + x/2)^12 + 67584*(1 + x/2)^10 - 42240*(1 + x/2)^8 + 13440*(1 + x/2)^6 - 2016*(1 + x/2)^4 + 112*(1 + x/2)^2 - 1, x);
    symfun(32768*(1 + x/2)^15 - 114688*(1 + x/2)^13 + 159744*(1 + x/2)^11 - 112640*(1 + x/2)^9 + 42240*(1 + x/2)^7 - 8064*(1 + x/2)^5 +672*(1 + x/2)^3 - 16*(1 + x/2), x);
    };
%% Create Output Matrices
rest_times = zeros(n(length(n))+1,length(eta));                         % output vector - R2R times
d_n = cell(n(length(n)),1);                                             % create cell
for cellcount = 1:length(d_n)                                           % Loop through switching times
    d_n{cellcount} = zeros((n(length(n))-cellcount+1), length(eta));    % create cell array for switching times d_n
end
% Find rest-to-rest times
for kk = 1:length(n)
    % Define ICs
    X = zeros(n(kk)+1,1);
    X(1) = 2.5 + 2.48*n(kk);
    for i = 1:n(kk)
        X(i+1) = 1.34*(n(kk)+1-i);
    end
    % Find Roots of Chebyshev Polynomials
    if n == 0
    recursion = 0;
    else 
    recursion = U0{n(kk)} - (1 + x)*U0{n(kk)+1};                         % create Chebyshev recursion equation
    end
    S = real(double(solve(recursion, x)));                               % Solve symbolic equation
    if S(S>0)                                                            % Check roots are as expected
        warning('The roots of the Chebyshev recursion were not negative, real roots.');
    end
    RHO = sqrt(-S);                                                      % These are the eigenvalues (\rho_j) of the matrix K, which is part of the state matrix A
    for p = 1:length(eta)
        % Declare function
        f = @(x) r2r_times(n(kk),eta(p),RHO, x);                                    % Define function for a given n & eta value
        % Find final values 
            [final_val(1:n(kk)+1,p), f_eval] = fsolve(f, X, OPTIONS);               % solve for F(X) = 0
            % check values are close to zero
            check = r2r_times(n(kk),eta(p),RHO, final_val(1:n(kk)+1,p));            % calculate F(X)
            if check > tol                                                          % check F(X) < tolerance value (approx. 0)
                while check > tol
                f = @(x) norm(r2r_times(n(kk), eta(p), RHO, x));                    % anonymous function - norm of function
                X = fminsearch(f, final_val);                                       % find minimum of norm
                [final_val(1:n(kk)+1,p), f_eval] = fsolve(f, final_val, OPTIONS);   % solve for new initial conditions
                end
            end
    end
    %Output values
rest_times(kk,:) = final_val(1,:);
for cellcount = 1:kk
    d_n{cellcount}(kk-cellcount+1,:) = final_val(cellcount+1,:);
end
final_val = zeros(n(length(n))+1,length(eta));
end

%% -------------------------------------------------------------------------------------------------------------------------------------- %%
% ---------------------------------------------------------------------------------------------------------------------------------------- %
% ----------------------------------------------------------- Section 2: ----------------------------------------------------------------- %
% -----------------------------------Solving for the Response of Acceleration Limited Time Optimal Control-------------------------------- %
% ---------------------------------------------------------------------------------------------------------------------------------------- %
% ---------------------------------------------------------------------------------------------------------------------------------------- %
%                          THIS SECTION CALCULATES THE 1 & 2% SETTLING
%                          TIMES FOR THE TIME OPTIMAL SYSTEM. THE OUTPUT IS
%                          PRINTED TO A FILE.
% ---------------------------------------------------------------------------------------------------------------------------------------- %
% ---------------------------------------------------------------------------------------------------------------------------------------- %
% Input chosen variables n and eta - acceleration limit, length, omega. 
n_vals = n;                                             % Range of n
L = 1;                                                  % Length of system
% Create File
fileID = fopen('SettlingTimes.txt', 'w');
fprintf(fileID, '1%% & 2%% Settling Times Calculations for Time Optimal Control\n');
fprintf(fileID, '\n------------------------------------------\n\n');
fclose(fileID);
for var_eta = 1:length(eta_range)                       % loop for range of eta
    eta_val = eta_range(var_eta);                        % Find eta in question
    Ubar = (omega^2)*L/(2*eta_val);                     % Calculate Acceleration Limit
    for var_n = 1:length(n_vals)
    n = n_vals(var_n);
    D_N = zeros(n,1);                                       % switching times d_n - create vector 
    [row, col] = find(eta == eta_val);                      % find value of (eta) for settling time calculations
    t_final = round(rest_times(n,col)*(10^6))/(10^6);       % find rest-to-rest time to 6 decimal places for chosen (n, eta)
    % Find switching time Values - 2l + 1 values, where l is = n
    for q = 1:n
        D_N(q) = round(d_n{q}(n+1-q,col)*(10^6))/(10^6);
    end
    % Find Switching Times of Bang-Bang Actuation
    st_val = zeros(2*n+3, 1);                               % 2n + 1 switching times w/ t_final and 0 makes 2n+3
    st_val(2*n+3,1) = t_final;                              % set final time as last switching time
    st_val(n+2) = t_final/2;                                % set n+2 switching time
    for q = 1:n                                             % fill switching time vector with values from rest-to-rest time calculations
        st_val(q+1) = t_final/2 - D_N(q);
        st_val((2*n+3)-q) = t_final/2 +D_N(q);
    end
    %  Create Samples of Switching Times
    delta = 1E-06;                                          % set sampling time distance
    t = omega*[0:delta:st_val(2*n+3,1)-delta];              % Create vector of time samples
    switch_ind = zeros(length(st_val),1);                   % create vector to hold sampling times
    for t_switch = 1:length(st_val)                         % increase to the last switching time
        [samp_row,samp_col] = find(t <= st_val(t_switch), 1, 'last');   % find index locations of sampling times
        switch_ind(t_switch) = samp_col;                    % store in vector
    end
    % Calculate Forcing Term - x_0
    a = zeros(2*n+2,1);                                     % Co-efficient vector for input forcing term calculation, a_n
    for ind = 1:(2*n+2)                                     % Fill a_n
        a(ind) = ((-1)^(ind-1))*Ubar;
    end
    b = zeros(2*n+2,1);                                     % Co-efficient vector for input forcing term calculation, b_n
    for ind = 2:(2*n+2)                                     % Fill b_n
        for count = 2:ind
            b(ind) = b(ind) + ((-1)^(count))*2*Ubar*st_val(count); % series of values increasing for value of n
        end
    end
    c = zeros(2*n+2, 1);                                    % Co-efficient vector for input forcing term calculation, c_n
    for ind = 2:2*n+2                                       % Fill c_n
        for count = 2:ind % series calculation with no. of terms increasing for value of n
            c(ind) = c(ind) + ((-1)^(count-1))*Ubar*st_val(count)^2;
        end
    end
    % Calculate Samples of Input Forcing Term
    x0 = zeros(length(t), 1);                               % Create input forcing term matrix                           
    for t_switch = 1:(length(switch_ind)-1)                     % Fill matrix with linear combination of coefficients, sampled with switching time calculations
        x0(switch_ind(t_switch):switch_ind(t_switch+1)) = a(t_switch)*(t(switch_ind(t_switch):switch_ind(t_switch+1)).^2)/2 + b(t_switch)*(t(switch_ind(t_switch):switch_ind(t_switch+1))) + c(t_switch);
    end
    % State-Space
    % K Matrix
    switch (n)
        case 1
            K = -1;
        case 2
            K = [-2 1; 1 -1];
        case 3
            K = [-2 1 0;
                1 -2 1;
                0 1 -1
                ];
        otherwise
            K_1 = [ -2 1;
                    1 -1
                    ];
                K = -2*eye(n);
                for i = 1:n-1
                    K(i,1+i) = 1;
                    K(1+i,i) = 1;
                end
                K(n-1:n,n-1:n) = K_1;
    end
    A = [zeros(n,n) eye(n);
        K zeros(n,n)];                                      % A - State Matrix
    B = [zeros(n,1);                                        % B - Input Matrix
        omega^2*1 
        zeros((n-1),1)];                                              
    C = [zeros(1,n-1) 1 zeros(1,n)];                        % C - Output Matrix - find the response of the final mass
    D = 0;                                                  % D - Feedthrough Matrix
    x_ic = [zeros(2*n,1)];                                  % Initial Conditions - Initial displacement is zero for all masses, Initial velocity is zero for all masses
    % Find Settling Times of Masses
    sys = ss(A, B, C, D);                                   % create state space
    y = lsim(sys, x0, t, x_ic);                             % find response
    % Find the 2% Settling Time
    [row2s, col2s] = find(y > L-0.02,1, 'first');       % Find column of 2% setttling time
    st_2 = round(100*t(row2s))/100;                     % 2% Settling Time
    [row1s, col2s] = find(y > L-0.01,1, 'first');       % Find column of 1% settling time
    st_1 = round(100*t(row1s))/100;                     % 1% Settling Time
    % Output Settling Times
    % Open Files
    fileID = fopen('SettlingTimes.txt', 'a+');
    fprintf(fileID, '\n\nFinal mass settles at %2.1f for n = %1.0f, eta of %1.1f\n 1%% Settling Time: %2.2f sec\n 2%% Setttling Time: %2.2f sec\n', y(length(y)), n, eta_val, st_1, st_2);
    fprintf(fileID, ' Rest-to-Rest Time is: %2.4f\n', t_final);
    fclose(fileID);
    end
    fileID = fopen('SettlingTimes.txt', 'a+');
fprintf(fileID, '\n------------------------------------------\n\n');
fclose(fileID);
end

