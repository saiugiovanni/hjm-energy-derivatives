function [x_opt,err_both_const] = Minimization_both_const(options,x0,Price_Model,Price_Market,nonlcon,T,N)

% function that returns the optimal value of x_opt=[sigma1 sigma2] and the error related minimizing the distance 
% between model prices and market prices in the case of both sigma1 and sigma2 being constant.
%
% INPUT  -->    options                 -   optimization structure
%               x0                      -   initial guess
%               Price_Model             -   function hadle modelling the price
%               Price_Market            -   matrix of market prices (one for each tenor and strike)
%               nonlcon                 -   The function that accepts X and returns the vectors C and Ceq, representing the nonlinear inequalities and equalities respectively.
%               T                       -   number of tenors
%               N                       -   number of strikes
% OUTPUT  -->   x_opt                   -   optimal value of x_opt=[sigma1 sigma2]
%               err_both_const          -   mean root square error  

%% X_OPT = [SIGMA1 SIGMA2]
x_opt = zeros(2,1);                                               % Initialization
Distance = @(x) sum(abs(Price_Model(x)-Price_Market).^2,'all');   % Compute the distance function handle 
x_opt = fmincon(Distance,x0,[],[],[],[],[],[],nonlcon,options);   % Performing the minimization using the matlab function fmincon
%x_opt = fminsearch(Distance,x0);                                 % Performing the minimization using the matlab function fminsearch
%x_opt = lsqnonlin(@(x) Price_Model(x)-Price_Market,x0,[0 0],[]); % Performing the minimization using the matlab function lsqnonlin
%% ROOT MEAN SQUARE ERROR
dist_opt = Distance(x_opt);                                       % Optimal Distance
err_both_const = sqrt(dist_opt/(T*N));                            % Computing the mean root square error
end 