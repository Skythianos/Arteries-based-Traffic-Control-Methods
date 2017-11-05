function [ gts, rts, off ] = time_calc( city )
%TIME_CALC Summary of this function goes here
%   Detailed explanation goes here

[ f, A, b, Aeq, beq, lb, ub, ints ] = generate_milp( city );
x = milp_solver(f, A, b, Aeq, beq, lb, ub, ints, 1);

rts = zeros(1,city.numbers(1));
off = zeros(1,city.numbers(1))-1;
idx = 6;

C = round(1/x(1));

for i = 1 : city.numbers(3)
    for j = 1 : city.arterials(i).size
        if (rts(city.arterials(i).members(j)) == 0)
            rts(city.arterials(i).members(j)) = round(x(idx)*C);
        end
        idx = idx + 4;
    end
    idx = idx + 1;
end

gts = C - rts;

for i = 1 : city.numbers(3)
    for j = 1 : city.arterials(i).size
        if (off(city.arterials(i).members(j)) == -1)
            off(city.arterials(i).members(j)) = mod((j-1)*10-gts(i)/2,C);
        end
        idx = idx + 4;
    end
    idx = idx + 1;
end

end

