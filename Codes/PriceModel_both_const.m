function Price_Model = PriceModel_both_const(B,dates,T,refDate,F0,Strike,Tenor)

% function that returns the a function handle containing model prices in a matrix form
%
% INPUT  -->    B               -   vector of dicounts coming from "OIS_data.mat"
%               dates           -   vector of dates associated to discount factors coming from "OIS_data.mat"
%               T               -   maturity
%               refDate         -   reference date 04/11/2022
%               F0              -   price of the future at refDate
%               Strike          -   vector of strikes
%               Tenor           -   vector of tenor
% OUTPUT  -->   Price_Model     -   function handle modelling the price

%%
Price_Model1=@(x)[];                                                                             % Initializing the matrix of model prices  

for ii=1:T
    Expiry = dateAdd(datenum(refDate),Tenor(ii),'y');                                            % Computing the expiry
    D = GetDiscounts(Expiry,dates',B');                                                          % Computing the discount factor at the expiry    
    d2 = @(x) (log(F0./Strike)-0.5*(x(1)^2+x(2)^2)*(Tenor(ii)))/sqrt((x(1)^2+x(2)^2)*Tenor(ii)); % Computing d2's function handle of x = [sigma1 sigma2]
    d1 = @(x) d2(x)+sqrt((x(1)^2+x(2)^2)*Tenor(ii));                                             % Computing d1's function handle of x = [sigma1 sigma2]

    Price_Model1= @(x) [Price_Model1(x); D*(F0*normcdf(d1(x))-Strike.*normcdf(d2(x)))];          % Computing the model price's function handle
end
Price_Model = Price_Model1;
end 