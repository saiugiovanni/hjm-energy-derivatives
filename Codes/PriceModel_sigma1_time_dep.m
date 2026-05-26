function Price_Model = PriceModel_sigma1_time_dep(B,dates,T,refDate,F0,Strike,Tenor)

% function that returns the model price when considering sigma1 time dependent and sigma2=0

% INPUT  -->    B               -   vector of dicounts
%               dates           -   vector of dates associated to discount factors
%               T               -   maturity
%               refDate         -   reference date 04/11/2022
%               F0              -   price of the future at refDate
%               Strike          -   vector of strikes
%               Tenor           -   vector of tenor
% OUTPUT  -->   Price_Model     -   function handle modelling the price

Price_Model=@(x)[];                                                                         % Initialization

for ii = 1:T
    Expiry = dateAdd(datenum(refDate),Tenor(ii),'y');                                       % Computing the expiry
    D = GetDiscounts(Expiry,dates',B');                                                     % Computing the discount factor at the expiry         
    d2 = @(x) (log(F0./Strike)-0.5*x)./sqrt(x);                                             % Computing d2's function handle of x=sigma1
    d1 = @(x) d2(x)+sqrt(x);                                                                % Computing d1's function handle of x=sigma1
    Price_Model = @(x) [Price_Model(x); D*(F0*normcdf(d1(x))-Strike.*normcdf(d2(x)))];      % Computing the model price's function handle
end

end 