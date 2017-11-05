function [ objective, M] = simulate_1d( gts, t, p )
% %BLABLA Summary of this function goes here
% %   Detailed explanation goes here
%

load('city.mat');
i = 1;
k = 1;
M = 0;

objective = 0;

b = Builder('city.mat');
s = Simulation(b);

if (p > 0)
    d = Drawer(b);
    figure;
end

gts = floor(gts);

%---------
%set(gcf,'Visible','on');
%d.draw();
%pause;
%---------

veh = s.simulate_1(gts,0,rn(i:i+b.numbers(2)));
%objective = objective + veh;

while (max(b.cycles) < t)
        
    i = i + b.numbers(2);
    
    if (p > 0)
        d.draw();
        pause(p);
    end
    
    veh = s.simulate_1(gts,1,rn(i:i+b.numbers(2)));
    objective = objective + veh;
    
    M(k) = getframe(gcf);
    k = k + 1;

end

temp = 0;
idx = 0;
global traveltimes;

traveltimes = 0;

for i = 1 : s.caridx - 1
    actCar = s.cars(i);
    if (s.cars(i).isActive == 0 && s.cars(i).rt == 1)
        temp = temp + s.cars(i).timer;
        idx = idx + 1;
        traveltimes(idx) = actCar.timer;
    end
end

objective = -(objective - s.getNumberofVeh(1));