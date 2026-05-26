# Heath-Jarrow-Morton Multifactor Model Calibration and Option Pricing

This repository contains a university project developed for a Computational Finance course during my MSc in Mathematical Engineering.

The project focuses on option calibration and pricing using a multifactor Heath-Jarrow-Morton framework applied to energy markets. The analysis is based on the 4Q23 German power swap and includes model calibration, market price computation and Monte Carlo pricing of a down-and-in call option.

## Main objectives

- Implement a multifactor HJM model for energy derivatives
- Compute market option prices using the Black-Scholes formula
- Calibrate model parameters to market prices
- Compare different volatility specifications
- Simulate the underlying asset dynamics under the calibrated model
- Price a down-and-in call option using Monte Carlo simulation
- Compare model prices and market prices through visualisation

## Model specifications

The project considers three calibration settings:

1. Both volatility parameters are constant.
2. `sigma1` is time-dependent and `sigma2` is set to zero.
3. Both `sigma1` and `sigma2` are time-dependent.

These cases are compared in terms of calibration performance and their impact on option pricing.

## Repository structure

- `RunProject_Group11.m` is the main script used to run the full project.
- `Compute_PriceMarket.m` computes market option prices using the Black-Scholes formula.
- `PriceModel_both_const.m` computes model prices when both volatility parameters are constant.
- `PriceModel_sigma1_time_dep.m` computes model prices when `sigma1` is time-dependent.
- `PriceModel_time_dep.m` computes model prices when both volatility parameters are time-dependent.
- `Minimization_both_const.m`, `Minimization_sigma1_time_dep.m` and `Minimization_time_dep.m` perform the calibration procedures.
- `Asset_HJM_constant.m` and `Asset_HJM_time_dep.m` simulate the underlying asset dynamics.
- `GetDiscounts.m`, `zeroRates.m` and `dateAdd.m` contain supporting functions for curve interpolation and date handling.
- `.mat` and `.xlsx` files contain the market data used in the project.
- `Project4HJMMulti.pdf` contains the project assignment.
- `REPORT_GRUPPO11.pdf` contains the final report.

## How to run the code

Open MATLAB and set the working directory to the folder containing the project files.

Then run:

```matlab
RunProject_Group11
