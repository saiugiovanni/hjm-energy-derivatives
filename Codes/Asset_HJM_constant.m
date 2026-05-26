function F = Asset_HJM_constant(F0, sigma1, sigma2, T, Nsim, M)

% function that simulates the underlying asset, considering sigma1 and
% sigma2 constant

% INPUT  -->    F0              - forward price
%               sigma1          - calibrated parameter of the HJM model
%               sigma2          - calibrated parameter of the HJM model
%               T               - maturity
%               Nsim            - number of simulations
%               M               - number of monitoring dates
% OUTPUT  -->   F               - simulated underlying asset 

F = zeros(Nsim, M+1);                                       % Initializing
F(:,1) = F0;                                                % The first column is equal to F0
dt = T/M;                                                   % Time interval considered (day)
a = -0.5*(sigma1^2+sigma2^2);                               % Definition of a
for i = 1:M                                                 % Simulation of F over the monitoring dates
    X = a*dt + (sigma1+sigma2)*randn(Nsim,1)*sqrt(dt);      % Dynamic of X
    F(:,i+1) = F(:,i).*exp(X);                              % Computation of the underlyng asset
end

end 