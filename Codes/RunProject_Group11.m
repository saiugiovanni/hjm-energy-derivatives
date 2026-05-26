% runAssignment Project 4  - Option Calibration and Pricing (HJM multifactor)
% Group 11, AY2022-2023
% Anna Mandelli, Carlotta Patroni, Giovanni Saiu, Anna Toschi 

tic

clear
close all
clc
rng(1);                                                                                                             % I fix a seed to get my results replicable
warning('off');                                                                                                     % No warnings
options = optimset('Display','none');                                                                               % Suppress function messages
set(0,'DefaultFigureWindowStyle','docked');                                                                         % Docking figures (more manageble)
format long                                                                                                         % More representation precision

%% Settings

formatData = 'dd/mm/yyyy';                                                                                          % Setting dates format 
FntSz = 20;                                                                                                         % Setting plots fontsize
FntNm = 'Times';                                                                                                    % Setting plots fontname

%% Data

F0 = 482.95;                                                                                                        % Price at 4Q23
load("OIS_data.mat");                                                                                               % Loading OIS_data.mat
load("Tenor.mat");                                                                                                  % Loading Tenor.mat
load('Vol.mat');                                                                                                    % Loading Vol.mat
load("Strike.mat");                                                                                                 % Loading Strike.mat
B = [1,B];                                                                                                          % Discount corresponding to dates ( first is 1 )
dates = [datenum('4-Nov-2022'),dates];                                                                              % Dates ( first is refDate )

%% Calibration Case 1: sigma_1 constant, sigma_2 constant 

T = 8;                                                                                                              % Number of Tenor
N = 21;                                                                                                             % Number of Strike
Price_Market = Compute_PriceMarket(B,dates,T,N,refDate,F0,Strike,Tenor,Vol);                                        % Computing Price_Market considering BS formula
Price_Model_1 =  PriceModel_both_const(B,dates,T,refDate,F0,Strike,Tenor);                                          % Computing Price_Model considering HJM model: sigma_1,sigma_2 costants 
x0 = [0.3; 0.6];                                                                                                    % Initial guess 
nonlcon = @Constraint;                                                                                              % Nonlinear constraints specified as a function handle
[x_opt_both_const,err_both_const] = Minimization_both_const(options,x0,Price_Model_1,Price_Market,nonlcon,T,N);     % Minimization with fmincon             
%% Plotting results  
Price_Model_Opt = Price_Model_1(x_opt_both_const);                                                                  % Computing Price_Model_Opt
figure;                                                                                                             % Creating a figure 
plot(Strike,Price_Market(1,:),'Linewidth',1.5);                                                                     % Plotting the Price_Market related to the first tenor 
hold on 
plot(Strike,Price_Model_Opt(1,:),'Linewidth',1.5);                                                                  % Plotting the Price_Model related to the first tenor
grid on                                                                                                             % Using a grid 
xlabel("Strike");                                                                                                   % Adding a label to the x-axis
title(" Case 1: Prices obtained considering the 1st tenor ");                                                       % Adding a title
legend("Price Market","Price Model");                                                                               % Adding a legend

%% Calibration Case 2: sigma_1 time dependent

Price_Model = PriceModel_sigma1_time_dep(B,dates,T,refDate,F0,Strike,Tenor);                                        % Computing Price_Model considering HJM model: sigma_1 time dependent
x0 = 0.3;                                                                                                           % Initial guess 
nonlcon = @Constraint_sigma1;                                                                                       % Nonlinear constraints specified as a function handle
[x_opt_1_time_dep,err_1_time_dep] = Minimization_sigma1_time_dep(options,x0,Price_Model,Price_Market,nonlcon,T,N);  % Minimization with fmincon

%% Plotting results
Price_Model_Opt = Price_Model(x_opt_1_time_dep(1));                                                                 % Computing Price_Model_Opt 
figure;                                                                                                             % Creating a figure 
plot(Strike,Price_Market(1,:),'Linewidth',1.5);                                                                     % Plotting the Price_Market related to the first tenor 
hold on 
plot(Strike,Price_Model_Opt(1,:),'Linewidth',1.5);                                                                  % Plotting the Price_Model related to the first tenor
grid on                                                                                                             % Using a grid 
xlabel("Strike");                                                                                                   % Adding a label to the x-axis
title("Case 2: Prices obtained considering the 1st tenor ");                                                        % Adding a title
legend("Price Market","Price Model");                                                                               % Adding a legend


%% Calibration Case 3: sigma_1 time dependent,sigma_2 time dependent 

Price_Model = PriceModel_time_dep(B,dates,T,refDate,F0,Strike,Tenor);                                               % Computing Price_Model considering HJM model: sigma_1 time dependent, sigma_2 time dependent
x0 = [0.3; 0.6];                                                                                                    % Initial guess 
nonlcon = @Constraint;                                                                                              % Nonlinear constraints specified as a function handle
[x_opt_time_dep,err_time_dep] = Minimization_time_dep(options,x0,Price_Model,Price_Market,nonlcon,T,N);             % Minimization with fmincon

%% Plotting results
Price_Model_Opt = Price_Model(x_opt_time_dep(:,1));                                                                 % Computing Price_Model_Opt 
figure;                                                                                                             % Creating a figure
plot(Strike,Price_Market(1,:),'Linewidth',1.5);                                                                     % Plotting the Price_Market related to the first tenor 
hold on 
plot(Strike,Price_Model_Opt(1,:),'Linewidth',1.5);                                                                  % Plotting the Price_Model related to the first tenor
grid on                                                                                                             % Using a grid
xlabel("Strike");                                                                                                   % Adding a label to the x-axis
title("Case 3: Prices obtained considering the 1st tenor ");                                                        % Adding a title
legend("Price Market","Price Model");                                                                               % Adding a legend

%% Down and in Call Option

T = 0.5;                                                                                                            % Maturity
K = 500;                                                                                                            % Strike
L = 450;                                                                                                            % Barrier
F0 = 482.95;                                                                                                        % Price at 4Q23
Mat = dateAdd(datenum(refDate),T,'y');                                                                              % Computing the maturity starting from the refDate
D = GetDiscounts(Mat,dates',B');                                                                                    % Computing discount 
r = -log(D)/T;                                                                                                      % Computing the interest rate 
Nsim = 1e5;                                                                                                         % Number of simulations 
%M = round(12*T);                                                                                                   % Monthly monitoring 
%M = round(52*T);                                                                                                   % Weekly monitoring
M = round(365*T);                                                                                                   % Daily monitoring

%% Case 1: sigma_1 constant, sigma_2 constant 
                                                                                 
F = Asset_HJM_constant(F0,x_opt_both_const(1),x_opt_both_const(2),T,Nsim,M);                                        % Performing the simulation of F: sigma_1,sigma_2 constants 
disc_payoff = exp(-r*T)*max(F(:,end)-K,0).*(min(F,[],2)<L);                                                         % Computing the discounted payoff 
[Price_both_const,~,ci_both_const] = normfit(disc_payoff);                                                          % Obtaining the Price and the Confidence Interval

%% Case 1: sigma_1 constant, sigma_2 constant, closed formula

q = 0;                                                                                                              % No dividends
PriceModel = Price_Model_1(x_opt_both_const);
sigma = blsimpv(F0,K,r,T,PriceModel(end,11));                                                                       % Implied volatility
lambda = (r-q+sigma^2/2)/sigma^2;                                                                                   % Parameters
y = log(L^2/(F0*K))/(sigma*sqrt(T))+lambda*sigma*sqrt(T);                                                           % Parameters
Price_exact = F0*exp(-q*T)*(L/F0)^(2*lambda)*normcdf(y)-K*exp(-r*T)*(L/F0)^(2*lambda-2)*normcdf(y-sigma*sqrt(T));   % B&S formula

%% Case 2: sigma_1 time dependent

Price_sigma1_time_dep = zeros(1,8);                                                                                 % Initializing the vector of Prices
ci_sigma1_time_dep = zeros(2,8);                                                                                    % Initializing the matrix of Confidence Interval
check_sigma1_time_dep = zeros(1,8);                                                                                 % Initializing the vector 

for ii=1:8

    [F,check_sigma1_time_dep(ii)] = Asset_HJM_time_dep(F0,x_opt_1_time_dep(ii),0,T,Nsim,M);                         % Performing the simulation of F:  sigma_1 time dependent  
    disc_payoff = exp(-r*T)*max(F(:,end)-K,0).*(min(F,[],2)<L);                                                     % Computing the discounted payoff 
    [Price_sigma1_time_dep(ii),~,ci_sigma1_time_dep(:,ii)] = normfit(disc_payoff);                                  % Obtaining the Price and the Confidence Interval

end

diff_sigma1_time_dep = check_sigma1_time_dep - x_opt_1_time_dep*T;                                                  % Checking the Normality

%% Case 3: sigma_1 time dependent,sigma_2 time dependent

Price_both_time_dep = zeros(1,8);                                                                                   % Initializing the vector of Prices
ci_both_time_dep = zeros(2,8);                                                                                      % Initializing the matrix of Confidence Interval
check_both_time_dep = zeros(1,8);                                                                                   % Initializing the vector
for ii=1:8

   [F,check_both_time_dep(ii)] = Asset_HJM_time_dep(F0,x_opt_time_dep(1,ii),x_opt_time_dep(2,ii),T,Nsim,M);         % Performing the simulation of F:  sigma_1,sigma_2 costants 
    disc_payoff = exp(-r*T)*max(F(:,end)-K,0).*(min(F,[],2)<L);                                                     % Computing the discounted payoff
   [Price_both_time_dep(ii),~,ci_both_time_dep(:,ii)] = normfit(disc_payoff);                                       % Obtaining the Price and the Confidence Interval

end

diff_both_time_dep = check_both_time_dep - (x_opt_time_dep(1,:) + x_opt_time_dep(2,:))*T;                           % Checking the Normality
                                             
toc

%% Results 


disp(' ')
disp(' <strong>Project - Option Calibration and Pricing (HJM multifactor)</strong>')
disp(' ')
disp(' ')
fprintf(['<strong> Calibration Case 1</strong>:              sigma1:  %.10f\n ' ...
    '                                 sigma2:  %.10f\n  ']  , x_opt_both_const(1),x_opt_both_const(2));
disp(' ')
disp(' ')
mat_sigma1_time_dep=x_opt_1_time_dep';
disp('<strong> Calibration Case 2 </strong>:             integral_sigma1: ')
fprintf('                                   %.10f\n ', mat_sigma1_time_dep )
disp(' ')
disp(' ')

mat_both_time_dep=[x_opt_time_dep(1,:);x_opt_time_dep(2,:)];
disp('<strong> Calibration Case 3 </strong>:            integral_sigma1:       integral_sigma2: ')
fprintf('                                   %.10f           %.10f\n ', mat_both_time_dep )
disp(' ')
disp(' ')

disp('<strong> Down and In Call Option - Pricing </strong>')
disp(' ')
fprintf('<strong>Case 1 </strong>:              Price_both_const     :   %.10f\n'  , Price_both_const)
fprintf('                      Lower bound          :   %.10f \n    ', ci_both_const(1))
fprintf('                  Upper bound          :   %.10f \n    ', ci_both_const(2))
disp(' ')
disp(' ')

fprintf('<strong>Case 2 </strong>:              Price_sigma1_time_dep:   %.10f\n'  , Price_sigma1_time_dep(end))
fprintf('                      Lower bound          :   %.10f \n    ', ci_sigma1_time_dep(1,end))
fprintf('                  Upper bound          :   %.10f \n    ', ci_sigma1_time_dep(2,end))
disp(' ')
disp(' ')

fprintf('<strong>Case 3 </strong>:              Price_both_time_dep  :   %.10f\n'  , Price_both_time_dep(end))
fprintf('                      Lower bound          :   %.10f \n    ', ci_both_time_dep(1,end))
fprintf('                  Upper bound          :   %.10f \n    ', ci_both_time_dep(2,end))
disp(' ')




