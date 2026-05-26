function Price_Market = Compute_PriceMarket(B,dates,T,N,refDate,F0,Strike,Tenor,Vol)

% function that returns a matrix containing market prices computed according to the Black & Scholes formula. 
%
% INPUT  -->    B               -   vector of dicounts coming from "OIS_data.mat"
%               dates           -   vector of dates associated to discount factors coming from "OIS_data.mat"
%               T               -   number of Tenors
%               N               -   Number of strikes
%               refDate         -   reference date 04/11/2022
%               F0              -   price of the future at refDate
%               Strike          -   vector of strikes
%               Tenor           -   vector of tenor
%               Vol             -   matriof volatilities taken from the Excel form
% OUTPUT  -->   Price_Model     -   function handle modelling the price

Price_Market1 = zeros(T,N);                                               % Initializing 
for ii = 1:T
    Expiry = dateAdd(datenum(refDate),Tenor(ii),'y');                     % Computing the expiry 
    D = GetDiscounts(Expiry,dates',B');                                   % Computing the discount factor at the expiry 
    zrate = -(log(D)/(Tenor(ii)));                                        % Computing the zero rate
    Price_Market1(ii,:) = blkprice(F0,Strike,zrate,Tenor(ii),Vol(ii,:));  % Computing futures option prices using Black's model.
end 

Price_Market = Price_Market1;                                             % Returning the market prices matrix
end