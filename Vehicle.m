classdef Vehicle < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        isVisible;
        type;
        rt;
        timer;
        isActive;
    end
    
    methods
        function obj = Vehicle(n)
            if nargin ~= 0
                obj(n) = Vehicle;
            end
        end
        function init(obj, rt, v)
            obj.rt = rt;
            obj.timer = 0;
            obj.isVisible = v;
            obj.isActive = 1;
            obj.type = floor(rand(1)*7/2);
        end
    end    
end

