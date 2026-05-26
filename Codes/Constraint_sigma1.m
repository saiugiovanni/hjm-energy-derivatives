function [c,ceq] = Constraint_sigma1(x)

% function that returns a polynomial expression of the input

% INPUT  -->    x   -   variable (3x1)
% OUTPUT -->    c   -   condition s.t. c<=0
%               ceq -   condition s.t. ceq=0

%% Expressions 

c(1) = -x(1); % Imposing sigma1 greater than 0 
ceq = [];

end