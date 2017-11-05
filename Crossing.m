classdef Crossing < handle
    properties
        id;
        inBoundLinks;
        outBoundLinks;
        light;
        position;
        timers;
        timeDelay;
    end
    methods
        function obj = Crossing(n)
            if nargin ~= 0
                obj(n) = Crossing();
            end
        end
        function initialize(obj, ID, p)
            obj.id = ID;
            obj.light = Light();
            obj.inBoundLinks = Link(4);
            obj.outBoundLinks = Link(4);
            obj.position = p;
            obj.timers = zeros(1,4);
            obj.timeDelay = 0;
        end
        function attachOutLink(obj, n, l)
            obj.outBoundLinks(n) = l;
        end
        function attachInLink(obj, n, l)
            obj.inBoundLinks(n) = l;
        end
        function switchLight(obj)
            if (obj.light.state == 0)
                obj.light.state = 1;
                obj.inBoundLinks(2).cango = 1;
                obj.inBoundLinks(4).cango = 1;
                obj.inBoundLinks(1).cango = 0;
                obj.inBoundLinks(3).cango = 0;
            else
                obj.light.state = 0;
                obj.inBoundLinks(1).cango = 1;
                obj.inBoundLinks(3).cango = 1;
                obj.inBoundLinks(2).cango = 0;
                obj.inBoundLinks(4).cango = 0;
            end
        end
        function setTimers(obj)
            for i=1:4
                obj.timers(i) = obj.inBoundLinks(i).length - 2*obj.inBoundLinks(i).nenv;
            end
        end
        function ret = updateCrossing(obj)
            ret = 0;
            for i=1:4
                obj.inBoundLinks(i).lC = obj.inBoundLinks(i).updateLink();
                obj.outBoundLinks(i).lC = obj.outBoundLinks(i).updateLink();
                if (obj.inBoundLinks(i).lC.isVisible == 1)
                    obj.inBoundLinks(i).lC.isActive = 1;
                    obj.outBoundLinks(i).addVehicle(obj.inBoundLinks(i).lC);
                    ret = 1;
                end
            end
        end
        function [r, c] = updateLight(obj, gt, cycle)
            c = 0;
            r = 0;
            if (obj.light.time_left == 0)
                obj.switchLight();
                if (obj.light.state == 1)
                    obj.light.time_left = gt;
                    if (obj.light.rdy == 0)
                        r = 1;
                        return
                    end
                else
                    c = 1;
                    obj.light.time_left = obj.light.next(cycle);
                    obj.light.rdy = 0;
                end
            else
                obj.light.time_left = obj.light.time_left - 1;
            end
        end
        function clear(obj)
            placeHolder = Vehicle;
            placeHolder.init(1, 0);
            for i=1:4
                if (obj.outBoundLinks(i).uptodate == 1)
                    obj.outBoundLinks(i).uptodate = 0;
                    obj.outBoundLinks(i).lC = placeHolder;
                end
                if (obj.inBoundLinks(i).uptodate == 1)
                    obj.inBoundLinks(i).uptodate = 0;
                    obj.inBoundLinks(i).lC = placeHolder;
                end
            end
        end
    end
end