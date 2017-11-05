classdef Builder < handle
    %BUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        numbers;
        crosses;
        links;
        arterials;
        counters;
        rdy;
        cycles;
    end
    
    methods
        function obj = Builder(s)
            
            def_l = 10;
            
            load(s);
            
            obj.numbers = [number_of_crosses, number_of_links, number_of_arterials, 0];
            
            obj.crosses = Crossing(number_of_crosses);
            obj.links = Link(number_of_links);
            
            obj.cycles = zeros(1,obj.numbers(1))+1;
            
            [m,n] = size(map);
            newmap = zeros(m+2,n+2);
            %CREATE LINKS
            l = 1;
            for i=1:m
                for j=1:n
                    v = abs(map(i,j));
                    if (mod(i,3) == 1)
                        if (mod(j,3) == 2)%1 in
                            obj.links(l).initialize(l,def_l,v,1,[i+0.5,j+1],type_m(i,j));
                            newmap(i+1,j+1) = l;
                            l = l + 1;
                        end
                    elseif (mod(i,3) == 2)
                        if (mod(j,3) == 1)%4 in
                            obj.links(l).initialize(l,def_l,v,0,[i+1,j+0.5],type_m(i,j));
                            newmap(i+1,j+1) = l;
                            l = l + 1;
                        elseif (mod(j,3) == 0)%2 in
                            obj.links(l).initialize(l,def_l,v,0,[i+1,j+1.5],type_m(i,j));
                            newmap(i+1,j+1) = l;
                            l = l + 1;    
                        end
                    elseif (mod(i,3) == 0)
                        if (mod(j,3) == 2)%3 in
                            obj.links(l).initialize(l,def_l,v,1,[i+1.5,j+1],type_m(i,j));
                            newmap(i+1,j+1) = l;
                            l = l + 1;
                        end
                    end
                end
            end
            i = 3;
            while (i < m+2)
                for j=1:n+1:n+2
                    if (j == 1)
                        p = [i,j+0.5];
                        t = type_m(i-1,j);
                    else
                        p = [i,j-0.5];
                        t = type_m(i-1,j-2);
                    end
                    obj.links(l).initialize(l,def_l,0,0,p,sign(t));
                    obj.links(l).cango = 1;
                    newmap(i,j) = l;
                    l = l + 1;
                end
                i = i + 3;
            end
            j = 3;
            while (j < n+2)
                for i=1:m+1:m+2
                    if (i == 1)
                        p = [i+0.5,j];
                        t = type_m(i,j-1);
                    else
                        p = [i-0.5,j];
                        t = type_m(i-2,j-1);
                    end
                    obj.links(l).initialize(l,def_l,0,1,p,sign(t));
                    obj.links(l).cango = 1;
                    newmap(i,j) = l;
                    l = l + 1;
                end
                j = j + 3;
            end%CREATE LINKS END
            
            i = 3;
            j = 3;
            %CREATE CROSSES
            while (i-1<m)
                while (j-1<n)
                    if (map(i-1,j-1) > 0)
                        c = map(i-1,j-1);
                        obj.crosses(c).initialize(c,[i,j]);
                        newmap(i,j) = c;
                        %INLINKS
                        obj.crosses(c).attachInLink(1,obj.links(newmap(i-1,j)));
                        obj.crosses(c).attachInLink(2,obj.links(newmap(i,j+1)));
                        obj.crosses(c).attachInLink(3,obj.links(newmap(i+1,j)));
                        obj.crosses(c).attachInLink(4,obj.links(newmap(i,j-1)));
                        %OUTLINKS
                        obj.crosses(c).attachOutLink(1,obj.links(newmap(i+2,j)));
                        obj.crosses(c).attachOutLink(2,obj.links(newmap(i,j-2)));
                        obj.crosses(c).attachOutLink(3,obj.links(newmap(i-2,j)));
                        obj.crosses(c).attachOutLink(4,obj.links(newmap(i,j+2)));
                        %init lights
                        obj.crosses(c).switchLight();
                        obj.crosses(c).switchLight();
                    end
                    j = j + 3;
                end
                i = i + 3;
                j = 3;
            end%CREATE CROSSES END
            
            %CREATE ARTERIALS
            obj.arterials = Arterial(obj.numbers(3));
            for i=1:obj.numbers(3)
                obj.arterials(i).size = size(arterials{i},2)-1;
                for j=1:obj.arterials(i).size
                    obj.arterials(i).members(j) = arterials{i}(j+1);
                end
                obj.arterials(i).dir = arterials{i}(1);
            end
            
            %OTHERS
            obj.counters = zeros(1,obj.numbers(3));
            obj.rdy = zeros(1,obj.numbers(3));
        end
    end
end

