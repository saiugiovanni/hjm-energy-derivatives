function [x_opt,err_time_dep] = Minimization_time_dep(options,x0,Price_Model,Price_Market,nonlcon,T,N)

% function that returns the optimal value of sigma1 and the error related minimizing the distance 
% between model price and market price in the case of both sigma1 and sigma2 time dependent

% INPUT  -->    options                 -   optimization structure 
%               x0                      -   initial guess
%               Price_Model             -   function hadle modelling the price
%               Price_Market            -   matrix of market prices (one for each tenor and strike)
%               nonlcon                 -   function hadle of constrains
%               T                       -   number of tenors
%               N                       -   number of strikes
% OUTPUT  -->   sigma1_opt              -   optimal value of sigma1
%               err_sigma1_time_dep     -   mean root square error

x_opt = zeros(2,8);                                                                    % Initialization  
for ii = 1:T
    Distance = @(x) sum(abs(Price_Model(x)-Price_Market(ii,:)).^2,'all');              % Computing the distance's function handle
    x_opt(:,ii) = fmincon(Distance,x0,[],[],[],[],[],[],nonlcon,options);              % Minimizing using fmincon 
    % x_opt(:,ii)=lsqnonlin(@(x) Price_Model(x)-Price_Market(ii,:),x0,[0 0],[]);       % Minimizing using lsqnonlin 
end 

dist_opt = Distance(x_opt);                                                            % Optimal distance

err_time_dep = sqrt(dist_opt/(T*N));                                                   % Computing the mean root square error

end 