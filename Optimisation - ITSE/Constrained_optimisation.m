%% Optimisation of coefficients of normalised nth order system 
%
% m.file will running multiple initial guesses and output the optimum
% coefficients for minimising the chosen criterion, either ISE, ITSE or
% IT2SE
%
% TUTORIAL: - GUESS will be the matrix of input (guessed coefficients)
%           - initial_ISE will be the criterion value (ISE, ITSE or IT2SE) of
%           initial guess
%           - OPT_COEFFICIENTS is the output matrix of minimized
%           coefficients
%           - final_ISE is the output criterion value of the minimized
%           denominators
%           NB: Coefficients are only optimal if final_ISE agrees on
%           minimal value
%
% VARIABLES THAT NEED TO BE CHANGED IN ORDER TO FIND nth ORDER MINIMIZED
% COEFFICIENTS:
%               order
%               denom_order
%               maxcount
%               x0
%               f - change the amount of input coefficients, i.e. x(1) x(2) .. x(n)

% Creator:  Padraig Basquel, SEEE, UCD
% Revision: 3.2 - use of fminsearch function only
% Date:     10/4/2017

%% Define system and initialise variables
% x0 = [2.8 5.0 5.5 3.4]; % Guesses from ITAE calculations
order = 2;                                                      % I T^order S E
denom_order = 2;                                                % nth Order Transfer Function
n = denom_order - 1;                                            % variable
maxcount = 100;                                                 % max number of iterations
GUESS = [ones(maxcount, 1) zeros(maxcount, n) ones(maxcount, 1)]; % input guesses
initial_ISE = [ones(maxcount, 1)];                              % input guesses criterion value
OPT_COEFFICIENTS = [ones(maxcount, 1) zeros(maxcount, n) ones(maxcount, 1)]; % maxcount x 3 matrix
final_ISE = [ones(maxcount, 1)];                                % output minimal criterion value

%% RUN maxcount ITERATIONS AND FIND MINIMAL COEFFICIENTS
for i = 1: maxcount
% x0 = [(1.2+1.3*rand) (5+4*rand) (5+5.5*rand) (6+9*rand) (1+2.8*rand) (4+6*rand)];
x0 = [(1.2+0.8*rand)];
GUESS(i, 2:(n+1)) = x0(:);                                      % record initial guesses
initial_ISE(i, 1) = ITSE(tf([1],[1 x0 1]), order);              % record criterion value (IT^orderSE value) of initial guesses
f = @(x) ITSE(tf([1],[1 x(1) 1]), order);                       % create objective function
result = fminsearch(f, x0);                                     % find optimal coefficients
OPT_COEFFICIENTS(i,2:(n+1)) = result(:);                        % pass into output matrix
final_ISE(i, 1) = ITSE(tf([1],[1 result 1]), order);            % calculate output criterion value
end