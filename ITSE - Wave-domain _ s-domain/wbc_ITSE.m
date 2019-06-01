function y = wbc_ITSE(W, omega, n)
%% y = wbc_ITSE(W, omega, n)
%
% Computes the integral of time by the square of the error. This command is
% used for calculating the ITSE of a wave-based model.Calculates the ITSE
% for a special case, where the closed-loop transfer function of a system
% using wave-based control is G\^n*W(G), and W(G) = 1.
%
%   Example: To calculate the ITSE for a system with
%   G_cl(G) = 1/2(G^4 + G^5),
%
%           y = wbc_ITSE([0.5 0.5], 1, 4);
%
%             y = 9.1250
%
%

% Creator: Padraig Basquel, SEEE, UCD
% Revision: 3.1 - ITSE of G_c_l(G) = 1/2 + 1/2 G
%           3.2 - ITSE of G_c_l(G) = G(omega0 + omega1*G + W(2)*G^2)
%           added
%           3.3 - Simplified calculations to y = n^2 + ...
% Date: 4/19/2017

k = length(W);
max = 15;                                                   % maximum size

if k <= max                                                 % Limit size of W(G)
   W = [W zeros(1, max-k)];
elseif k > max;
    error('\nMaximum length of W(G) exceeded. Calculations possible up to W(G) of length %d\n', max);
end
s = sum(W);                                                 % Ensure W(G) = 1
if s ~= 1
    error('The coefficients in W(G) must add up to 1')
end
switch nargin                                               % Input check
    case 1
        omega = 1;
        n = 1;
    case 2
        n = 1;
end
% Computing the ITSE
y = 1/2*(1/omega^2)*(n^2 + ((1 - W(1))^2)*(2*n + 1) + ...
    ((1 - W(1) - W(2))^2)*(2*n + 3) + ... 
    ((1 - W(1) - W(2) - W(3))^2)*(2*n + 5) + ...
    ((1 - W(1) - W(2) - W(3) - W(4))^2)*(2*n + 7) + ...
    ((1 - W(1) - W(2) - W(3) - W(4) - W(5))^2)*(2*n + 9) + ...
    ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6))^2)*(2*n + 11) + ...
    ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7))^2)*(2*n + 13) + ...
    ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8))^2)*(2*n + 15) + ...
    ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9))^2)*(2*n + 17) + ...
    ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8)- W(9) - W(10))^2)*(2*n + 19) + ...
    ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9) - W(10) - W(11))^2)*(2*n + 21) + ...
    ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9) - W(10) - W(11) - W(12))^2)*(2*n + 23)) + ...
    ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9) - W(10) - W(11) - W(12) - W(13))^2)*(2*n + 25) + ...
    ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9) - W(10) - W(11) - W(12) - W(13) - W(14))^2)*(2*n + 27) + ...
    ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9) - W(10) - W(11) - W(12) - W(13) - W(14) - W(15))^2)*(2*n + 29);
end

    