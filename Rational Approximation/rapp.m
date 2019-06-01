function [tf_sys] = rapp(NUM, DEN, omega, n, options)
%% RAPP Rational approximation used for calculating wave-based controllers
% 
%  [sys] = RAPP(NUM, DEN, omega, n)
%
%       This function creates a rational approximation for G and G(\hat)
%       and produces a 1st or 2nd order rational approximation of the 
%       wave-based controller transfer function input.
%
%       sys = rapp(NUM, DEN, omega, n) will produce a rational approximation
%       where the order of approximation used is n,  NUM and DEN are row vector 
%       inputs of the numerator and denominator of the wave-based controller 
%       (in terms of G or Ghat).
%
%
%  Example: Taking the input of the system to have a tranfer function of
%           
%                         G^2 + G
%               -------------------------
%                          G + 1
%
%       and producing a 1st order rational approximation of this system.
%       Then:
%       
%           NUM = [1 1 0];
%           DEN = [1 1];
%           sys = rapp(NUM, DEN, 1, 1) 
%                   
%            sys =
% 
%                           s^3 + 4 s^2 + 5 s + 2
%                       -----------------------------
%                       s^4 + 5 s^3 + 9 s^2 + 7 s + 2
% 
%             Continuous-time transfer function.
%
%      Options can be chosen to find the root wave-transfer function.
%      sys = rapp(NUM, DEN, omega, n, 'root wave tf') will produce an
%      approximation for the root wave transfer function.
%

% Creator: Padraig Basquel, UCD College of Electronic & Comms Engineering
% Revision: 1.02 - updated for n = 1,2 @27/10/2016
%           1.03 - updated for general system @15/4/2017
%           1.04 - updated to include stability check  @16/4/2017
% Date: 21/10/2016

%% Error Check
%Check inputs and outputs
ld = length(DEN) - 1;                                           % order of denominator
ln = length(NUM) - 1;                                           % order of numerator
switch nargin                                                   % input check
    case (1)
        error('\nNot enough input arguements');
    case (2)
        omega = 1;
        n = 1;
        options = 'wave tf';
    case (3)
        n = 1;
        options = 'wave tf';
    case (4)
        options = 'wave tf';
    case(5)
    otherwise
        error('\nToo many inputs')
end
if ld > 15 || ln > 15                                           % order of input is too large
    error('\nThe order of the numerator or denominator is too large.\n');
end
%% Define Rational Approximation for G\hat and G
if strcmp(options, 'root wave tf')
    switch(n)
        case 1
                G = tf([omega],[1/2 omega]);                    % 1st Order approximation
        case 2
                G = tf([omega], [1/8 1/2*omega omega^2]);
        otherwise
            error('1st or 2nd Order Approximation can only be calculated'); % error
    end
% Wave-Transfer Function
elseif strcmp(options, 'wave tf')
    switch(n)
        case 1
                G = tf([omega], [1 omega]);                     % 1st Order approximation
        case 2
                G = tf([omega^2], [(1/2) omega (omega^2)]);     % 2nd Order approximation
        otherwise 
            error('1st or 2nd Order Approximation can only be calculated'); % error
    end
end
%% Output rational approximation of transfer function
tf_num = tf([NUM(ln+1)],[1]);                                   % output numerator
tf_den = tf([DEN(ld+1)],[1]);                                   % output denominator
for i = 1:(ln)
    tf_num = tf_num + NUM(i)*(G^((ln+1)-i));                    % add numerator transfer function
end
for j = 1:(ld)
    tf_den = tf_den + DEN(j)*(G^((ld+1)-j));                    % add denominator transfer functions
end
tf_sys = tf_num/tf_den;                                         % output
%% Stability Check
% Basic stability check if roots are positive, produce warning
[vec_num, vec_den] = tfdata(tf_sys,'v');                        % find the numerator and denominator of the transfer function
p = real(roots(vec_den));
if p(p>0)
    warning('The rational approximation of the system entered is unstable.');
end
end
