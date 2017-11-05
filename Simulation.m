classdef Simulation < handle
    %SIMULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        b;
        cars;
        caridx;
    end
    
    methods
        function obj = Simulation(builder)
            obj.b = builder;
            obj.cars = Vehicle(1000);
            obj.caridx = 1;
        end
        function init(obj,g,r,o,threshold,type)
            if (type == 1)
                obj.simulate_1(g,0,threshold);
            else
                obj.simulate_2(g,r,o,0,threshold);
            end
        end
        function v = simulate_1(obj, g, f, threshold)
            %add new vehicles
            for i=1:obj.b.numbers(2)
                car = obj.b.links(i).generateNewVeh(threshold(i));
                if (car.isVisible == 1)
                    obj.cars(obj.caridx) = car;
                    obj.caridx = obj.caridx + 1;
                end
            end
            for i = 1 : obj.caridx
                actCar = obj.cars(i);
                if (actCar.isActive == 1)
                    actCar.timer = actCar.timer + 1;
                end
            end
            obj.b.numbers(4) = 0;
            noa = obj.b.numbers(3);
            for i=1:noa
                if ((obj.b.rdy(i) == 1) || (f == 0))
                    if (f == 0)
                        for j=1:obj.b.arterials(i).size
                             obj.b.crosses(obj.b.arterials(i).members(j)).setTimers();
                        end
                    end
%                 for i=1:obj.b.numbers(3)
                     art = obj.b.arterials(i);
                     a = zeros(1,art.size);
                     temp = zeros(1,art.size);
                     for j=1:art.size
                         a(j) = obj.b.crosses(art.members(j)).timers(art.dir);
                         temp(j) = obj.b.crosses(art.members(j)).timeDelay;
                     end
                     for j=2:art.size
                         a(j)=a(j-1)+a(j);
                     end
                     a = a-min(a);
                     temp = temp + a;
                     for j=1:art.size
                         if (f == 0)
                             obj.b.crosses(art.members(j)).light.time_left = a(j);
                         else
                             next_time = temp(j) - (min(temp) - 10);
                             cross = obj.b.crosses(art.members(j)).id;
                             obj.b.crosses(art.members(j)).light.next(obj.b.cycles(cross)+1) = next_time;
                             obj.b.crosses(art.members(j)).light.rdy = 1;
                         end
                         obj.b.crosses(art.members(j)).timeDelay = max(a)-a(j);
                     end 
                    obj.b.rdy(i) = 0;
%                 end
                end
            end
            for l=1:obj.b.numbers(1)
                ret = obj.b.crosses(l).updateCrossing();
                
                obj.b.numbers(4) = obj.b.numbers(4) + ret;
            end
            for l=1:obj.b.numbers(1)
                c = 1;
                while (c <= obj.b.numbers(3) && ...
                        ~obj.b.arterials(c).contains(obj.b.crosses(l).id))
                    c = c+1;
                end
                [r1, r2] = obj.b.crosses(l).updateLight(g((obj.b.cycles(l)-1)*obj.b.numbers(1)+1),obj.b.cycles(l)+1);
                obj.b.cycles(l) = obj.b.cycles(l) + r2;
                if (r1 == 1)
                    obj.updateCrosses(c,g((obj.b.cycles(l)-1)*obj.b.numbers(1)+1));
                end
            end
            for l=1:obj.b.numbers(1)
                obj.b.crosses(l).clear();
            end
            v = obj.b.numbers(4);
        end
        function updateCrosses(obj,c,gt)
            art = obj.b.arterials(c);
            for i=1:art.size
                a = obj.b.crosses(art.members(i)).inBoundLinks(art.dir);
                a.nenv = max(0, a.nv + a.transfer - ceil(gt/2));
                obj.b.crosses(art.members(i)).outBoundLinks(art.dir).transfer ...
                    = a.nv - a.nenv + a.transfer;
                obj.b.crosses(art.members(i)).setTimers();
                obj.b.crosses(art.members(i)).light.rdy = 1;
            end
            obj.b.rdy(c) = 1;
        end
        function v = simulate_2(obj, g, r, o, f, threshold)
            for i=1:obj.b.numbers(2)
                car = obj.b.links(i).generateNewVeh(threshold(i));
                if (car.isVisible == 1)
                    obj.cars(obj.caridx) = car;
                    obj.caridx = obj.caridx + 1;
                end
            end
            for i = 1 : obj.caridx
                actCar = obj.cars(i);
                if (actCar.isActive == 1)
                    actCar.timer = actCar.timer + 1;
                end
            end
            obj.b.numbers(4) = 0;
            for l=1:obj.b.numbers(1)
                ret = obj.b.crosses(l).updateCrossing();
                obj.b.numbers(4) = obj.b.numbers(4) + ret;
            end
            for l=1:obj.b.numbers(1)
                if (f == 0)
                    obj.b.crosses(l).light.time_left = o(l);
                end
                obj.b.crosses(l).light.next(1) = r(l);
                [r1, r2] = obj.b.crosses(l).updateLight(g(l),1);
                obj.b.cycles(l) = obj.b.cycles(l) + r2;
            end
            for l=1:obj.b.numbers(1)
                obj.b.crosses(l).clear();
            end
            v = obj.b.numbers(4);
        end
        function num = getNumberofVeh(obj, t)
            num = 0;
            for i=1:obj.b.numbers(2)
                if (obj.b.links(i).uptodate == 0)
                    if ((t == 0 && obj.b.links(i).type == 1) || (t == 1))
                        num = num + obj.b.links(i).getTraffic();
                        obj.b.links(i).uptodate = 1;
                    end
                end
            end
            for i=1:obj.b.numbers(2)
                obj.b.links(i).uptodate = 0;
            end
        end
    end
end