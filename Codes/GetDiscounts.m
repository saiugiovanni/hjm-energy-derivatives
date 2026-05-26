function DF = GetDiscounts(targetDates, dates, discounts)

% function that returns the discount factors in chosen dates by interpolation on zero
% rates exploiting the DFs curve (dates, discounts) obtained from the bootstrap

% INPUT    -->   targetDates   -   dates (expiries) in which I want to know the discount factor
%                dates         -   dates at which I have the discounts factors, the first element is the settlement date
%                discounts     -   discount factors obtained by the bootstrap

% OUTPUTS  -->   DF            -   discount factors at the "target expiries"


%% DF Computation

zRates = zeroRates(dates,discounts)/100;                                    % compute the zero rates
zRates_interp = interp1(dates,[0;zRates],targetDates,'linear','extrap');    % interpolate the zero rates in the target expiries
YearFrac = yearfrac(dates(1), targetDates, 3);                              % compute the yearfrac, Act/365 and dates(1) is the settlement date
DF = exp(-zRates_interp.*YearFrac);                                         % compute the discount factors


end
    

