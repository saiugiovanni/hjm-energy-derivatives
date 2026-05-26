function [sigma1_opt,err_sigma1_time_dep]= Minimization_sigma1_time_dep(options,x0,Price_Model,Price_Market,noncol,T,N)

% function that returns the optimal value of sigma1 and the error related minimizing the distance 
% between model price and market price in the case of sigma1 time dependent and sigma2=0

% INPUT  -->    options                 -   optimization structure 
%               x0                      -   initial guess
%               Price_Model             -   function hadle modelling the price
%               Price_Market            -   matrix of market prices (one for each tenor and strike)
%               nonlcon                 -   function hadle of constrains
%               T                       -   number of tenors
%               N                       -   number of strikes
% OUTPUT  -->   sigma1_opt              -   optimal value of sigma1
%               err_sigma1_time_dep     -   mean root square error  

sigma1_opt = zeros(1,8);                                                                % initialization  
for ii = 1:T
    Distance = @(x) sum(abs(Price_Model(x)-Price_Market(ii,:)).^2,'all');               % computing the distance's function handle
    sigma1_opt(ii) = fmincon(Distance,x0,[],[],[],[],[],[],noncol,options);             % minimizing using fmincon  
    %sigma1_opt(ii) = lsqnonlin(@(x) Price_Model(x)-Price_Market(ii,:),x0,[0 0],[]);
end 

dist_opt = Distance(sigma1_opt(end));                                                   % optimal distance

err_sigma1_time_dep = sqrt(dist_opt/(T*N));                                             % computing the mean root square error

end 