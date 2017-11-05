classdef Link < handle
    properties 
        id;
        nv = 0;
        nenv = 0;
        spaces;
        length;
        cango;
        uptodate;
        orientation;
        position;
        transfer;
        lC;
        isSource;
        type;
    end
    methods
        function obj = Link(n)
            if nargin ~= 0
                obj(n) = Link;
            end
        end
        function initialize(obj, id, l, v, o, p, s)
            obj.id = id;
            obj.length = l;
            obj.nv = abs(v);
            obj.nenv = abs(v);
            obj.transfer = 0;
            obj.spaces = Vehicle(l);
            for i = 1 : v
                obj.spaces(l-i+1).init(sign(s), 1);
            end
            for i = v+1 : l
                obj.spaces(l-i+1).init(sign(s), 0);
            end
            obj.cango = 0;
            obj.uptodate = 0;
            obj.orientation = o;
            obj.position = p;
            obj.isSource = sign(s)*(abs(s)-1);
            obj.type = sign(s);
        end
        function addVehicle(obj, newV)
            obj.nv = obj.nv + 1;
            obj.spaces(1) = newV;
        end
        function v = getTraffic(obj)
            v = obj.nv;
        end
        function removeVehicle(obj)
            obj.nv = obj.nv - 1;
            obj.spaces(obj.length).isActive = 0;
            placeHolder = Vehicle;
            placeHolder.init(obj.type, 0);
            obj.spaces(obj.length) = placeHolder;
        end
        function id = updateLink(obj)
            placeHolder = Vehicle;
            placeHolder.init(obj.type, 0);
            if (obj.uptodate == 0)
                obj.uptodate = 1;
                i = 1;
                id = placeHolder;
                while (i<=obj.length)
                    if (obj.spaces(i).isVisible > 0 && i==obj.length)
                        if (obj.cango == 1)
                            id = obj.spaces(i);
                            obj.removeVehicle();
                        end
                    else
                        if (obj.spaces(i).isVisible>0 && obj.spaces(i+1).isVisible==0)
                            obj.spaces(i+1) = obj.spaces(i);
                            obj.spaces(i) = placeHolder;
                            i = i+1;
                        end
                    end
                    i = i+1;
                end
            else
                id = obj.lC;
            end
        end
        function v = generateNewVeh(obj, random)
            newV = Vehicle;
            newV.init(obj.isSource,1);
            newV.isActive = 1;
            v = Vehicle;
            v.init(obj.isSource,0);
            if (obj.isSource == 1 && random > 0.7 && obj.spaces(2).isVisible == 0)
                obj.addVehicle(newV);
                v = newV;
            end
            if (obj.isSource == -1 && random > 0.9 && obj.spaces(2).isVisible == 0)
                obj.addVehicle(newV);
                v = newV;
            end
        end
    end
end