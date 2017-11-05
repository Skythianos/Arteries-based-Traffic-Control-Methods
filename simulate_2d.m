function [ objective, graph] = simulate_2d( gts, rts, o, t, p )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load('city.mat');
i = 1;
k = 1;

objective = 0;

b = Builder('city_2d.mat');
s = Simulation(b);

if (p > 0)
    figure;
    d = Drawer(b);
end

veh = s.simulate_2(gts,rts,o,0,rn(i:i+b.numbers(2)));
objective  = objective + veh;

while (max(b.cycles) < t)

    i = i + b.numbers(2);
    
    veh = s.simulate_2(gts,rts,o,1,rn(i:i+b.numbers(2)));
    objective = objective + veh;
    
    if (p > 0)
        d.draw();
        pause(p);
    end
    
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

temp / idx

objective = objective - s.getNumberofVeh(1);

end

