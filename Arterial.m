classdef Arterial
    %ARTERIAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        size;
        members;
        dir;
    end
    
    methods
        function obj = Arterial(t, s, m, d)
            if (nargin == 1)
                obj(t) = Arterial();
            elseif (nargin == 3)
                obj.size = s;
                obj.members = m;
                obj.dir = d;
            end
        end
        function b = contains(obj, a)
            b = 0;
            for i=1:obj.size
                if (obj.members(i) == a)
                    b = 1;
                end
            end
        end
    end
end

