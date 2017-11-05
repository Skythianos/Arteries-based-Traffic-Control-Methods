function [ objective ] = fitnessFcn_2d( x )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

objective = 0;

for i=1:3
    objective = objective + x((i-1)*7+2) + x((i-1)*7+3);
end

objective = -objective/2;

end

