function [ gts ] = gaoptim( city, cyc )
%GAOPTIM Summary of this function goes here
%   Detailed explanation goes here

options = gaoptimset('Display', 'iter', 'Generations', 30, 'PopulationSize', 6, 'StallGenLimit', 5);
nvars = city.numbers(1)*cyc;
for i = 1 : nvars
    ints(i) = i;
end
lb = zeros(1,nvars)+15;
ub = zeros(1,nvars)+45;
fcn = @(x) fitnessFcn(x, cyc);
gts = ga(fcn, nvars, [], [], [], [], lb, ub, [], ints, options);

end

