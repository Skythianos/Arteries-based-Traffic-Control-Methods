classdef Drawer
    %DRAWER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        b;
    end
    
    methods
        function obj = Drawer(builder)
            obj.b = builder;
        end
        function draw(obj)
            
            dl = 10;
            
            b = obj.b;
            clf;
            hold on;
            axis([0 dl*2*6 0 dl*4]);
            set(gca,'YDir','reverse');
            %set(gca,'Visible','off');
            axis equal;
            axis off;
            
            car1 = imread('car1.png');
            car2 = imread('car2.png');
            car3 = imread('car3.png');
            car4 = imread('car4.png');
            
            
            for i=1:b.numbers(1)
                if (b.crosses(i).light.state == 0)
                    ac = 'red';
                    sc = 'green';
                else
                    ac = 'green';
                    sc = 'red';
                end
                aC = b.crosses(i);
                line([aC.position(2)*dl-dl/4 aC.position(2)*dl-dl/4],[aC.position(1)*dl-dl/4 aC.position(1)*dl+dl/4],'LineWidth',2,'Color',ac);
                line([aC.position(2)*dl+dl/4 aC.position(2)*dl+dl/4],[aC.position(1)*dl-dl/4 aC.position(1)*dl+dl/4],'LineWidth',2,'Color',ac);
                line([aC.position(2)*dl-dl/4 aC.position(2)*dl+dl/4],[aC.position(1)*dl+dl/4 aC.position(1)*dl+dl/4],'LineWidth',2,'Color',sc);
                line([aC.position(2)*dl-dl/4 aC.position(2)*dl+dl/4],[aC.position(1)*dl-dl/4 aC.position(1)*dl-dl/4],'LineWidth',2,'Color',sc);
                for j=1:4
                    for t=-1:2:1
                        if (t==-1)
                            linktemp = b.crosses(i).inBoundLinks(j);
                            if (j == 2 || j == 1)
                                d = -1;
                            else
                                d = 1;
                            end
                        else
                            linktemp = b.crosses(i).outBoundLinks(j);
                            if (j == 3 || j == 4)
                                d = 1;
                            else
                                d = -1;
                            end
                        end
                        
                        if (linktemp.type == 1)
                            c = 'red';
                        else
                            c = 'blue';
                        end
                        
                        if (linktemp.orientation == 0)
                            v = [linktemp.position(1)*dl+d*dl/5 linktemp.position(1)*dl+d*dl/5];
                            h = [linktemp.position(2)*dl-dl linktemp.position(2)*dl+dl];
                            line(h,v,'Color',c);
                            line(h,v-d*dl/5,'LineWidth',2,'Color',c);
                            for v=1:linktemp.length
                                if (linktemp.spaces(v).isVisible == 1)
                                    switch linktemp.spaces(v).type
                                        case 0
                                            actCar = car1;
                                        case 1
                                            actCar = car2;
                                        case 2
                                            actCar = car3;
                                        case 3
                                            actCar = car4;
                                    end
                                    if (j == 4)
                                        actCar = imrotate(actCar, 270);
                                        %plot(linktemp.position(2)*dl-dl+(v-1)*((dl)/(10-1))*2,...
                                        %    linktemp.position(1)*dl+d*dl/10, '.','Color',c);
                                        ho = linktemp.position(1)*dl+d*dl/10;
                                        ve = linktemp.position(2)*dl-dl+(v-1)*((dl)/(10-1))*2;
                                        image([ve-1.5 ve], [ho-0.5 ho+0.5], actCar);
                                    else
                                        actCar = imrotate(actCar, 90);
                                        %plot(linktemp.position(2)*dl+dl-(v-1)*((dl)/(10-1))*2,...
                                        %    linktemp.position(1)*dl+d*dl/10, '.','Color',c);
                                        ho = linktemp.position(1)*dl+d*dl/10;
                                        ve = linktemp.position(2)*dl+dl-(v-1)*((dl)/(10-1))*2;
                                        image([ve ve+1.5], [ho-0.5 ho+0.5], actCar);
                                    end
                                end
                            end
                        else
                            v = [linktemp.position(1)*dl-dl linktemp.position(1)*dl+dl];
                            h = [linktemp.position(2)*dl+d*dl/5 linktemp.position(2)*dl+d*dl/5];
                            line(h,v,'Color',c);
                            line(h-d*dl/5,v,'LineWidth',2,'Color',c);
                            for v=1:linktemp.length
                                if (linktemp.spaces(v).isVisible == 1)
                                    switch linktemp.spaces(v).type
                                        case 0
                                            actCar = car1;
                                        case 1
                                            actCar = car2;
                                        case 2
                                            actCar = car3;
                                        case 3
                                            actCar = car4;
                                    end
                                    if (j == 1)
                                        actCar = imrotate(actCar, 180);
                                        %plot(linktemp.position(2)*dl+d*dl/10,...
                                        %    linktemp.position(1)*dl-dl+(v-1)*((dl)/(10-1))*2, '.','Color',c);
                                        ho = linktemp.position(1)*dl-dl+(v-1)*((dl)/(10-1))*2;
                                        ve = linktemp.position(2)*dl+d*dl/10;
                                        image([ve-0.5 ve+0.5], [ho-1.5 ho], actCar);
                                    else
                                        actCar = imrotate(actCar, 0);
                                        %plot(linktemp.position(2)*dl+d*dl/10,...
                                        %    linktemp.position(1)*dl+dl-(v-1)*((dl)/(10-1))*2, '.','Color',c);
                                        ho = linktemp.position(1)*dl+dl-(v-1)*((dl)/(10-1))*2;
                                        ve = linktemp.position(2)*dl+d*dl/10;
                                        image([ve-0.5 ve+0.5], [ho ho+1.5], actCar);
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            hold off;
            
        end
    end
end