function [F, check] = Asset_HJM_time_dep(F0, sigma1, sigma2, T, Nsim, M)

% function that simulates the underlying asset, considering sigma1 and 
% sigma2 time dependent

% INPUT  -->    F0              - forward price
%               sigma1          - integral of sigma1^2 in dt: calibrated 
%                                 parameter of the HJM model
%               sigma2          - integral of sigma2^2 in dt: calibrated 
%                                 parameter of the HJM model
%               T               - maturity
%               Nsim            - number of simulations
%               M               - number of monitoring dates
% OUTPUT  -->   F               - simulated underlying asset
%               check           - the sum of the increments must be equal to the variance of the process    

F = zeros(Nsim,M+1);                                                % Initializing
F(:,1) = F0;                                                        % The first column is equal to F0
dt = T/M;                                                           % Time interval considered (day)
a = -0.5*(sigma1+sigma2);                                           % Definition of the integral of a
check = 0;                                                          % Initialization to 0
for i = 1:M                                                         % Simulation of F over the monitoring dates
    X = a*dt + sqrt(sigma1+sigma2)*randn(Nsim,1)*sqrt(dt);          % Dynamic of X
    check = check + (sigma1+sigma2)*dt;                             % Sum every increment
    F(:,i+1) = F(:,i).*exp(X);                                      % Computation of the underlyng asset
end

end 
