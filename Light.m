classdef Light < handle
    %LIGHT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        time_left;
        next;
        state;
        rdy;
    end
    
    methods
        function obj = Light()
            obj.state = 0;
            obj.rdy = 0;
        end
    end
    
end

