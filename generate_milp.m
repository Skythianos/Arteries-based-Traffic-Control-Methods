function [ f, A, b, Aeq, beq, lb, ub, ints ] = generate_milp( city )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%load(city);
vidx = 1;
hidx = 4;
iidx = 1;

%inequalities
for i=1:city.numbers(3)
    bpos = hidx - 2;
    f(bpos:bpos+1) = [-1,-1];
    for j=1:city.arterials(i).size
        A(vidx,hidx:hidx+2) = [1, 0, 1];
        A(vidx,bpos) = 1;
        b(vidx,1) = 1;
        vidx = vidx + 1;
        A(vidx,hidx+1:hidx+2) = [1, 1];
        A(vidx,bpos+1) = 1;
        b(vidx,1) = 1;
        vidx = vidx + 1;
        hidx = hidx + 4;
    end
    hidx = hidx + 1;
end

vidx = 1;
hidx = 4;
Aeq = zeros(1,size(A,2));
f(size(A,2)) = 0;

%equalities
for i=1:city.numbers(3)
    for j=1:city.arterials(i).size-1
        Aeq(vidx,hidx:hidx+6) = [1,1,0,-1,-1,-1,-2];
        Aeq(vidx,1) = 40;
        beq(vidx,1) = 0;
        ints(iidx) = hidx + 3;
        vidx = vidx + 1;
        hidx = hidx + 4;
        iidx = iidx + 1;
    end
    hidx = hidx + 5;
end

for i = 1 : city.numbers(3)
    for j = 1 : city.arterials(i).size
        for k = i + 1 : city.numbers(3)
            for l = 1 : city.arterials(k).size
                if (city.arterials(i).members(j) == city.arterials(k).members(l))
                    idx = 0;
                    for m = 1 : i-1
                        idx = idx + city.arterials(m).size * 4 + 1;
                    end
                    idx = idx + (j-1)*4 + 6;
                    Aeq(vidx,idx) = 1;
                    idx = 0;
                    for m = 1 : k-1
                        idx = idx + city.arterials(m).size * 4 + 1;
                    end
                    idx = idx + (l-1)*4 + 6;
                    Aeq(vidx,idx) = 1;
                    beq(vidx,1) = 1;
                    vidx = vidx + 1;
                end
            end
        end
    end
end

lb = zeros(1,size(A,2)) + 0.1;
ub = zeros(1,size(A,2)) + 10;
lb(1) = 1/45;
ub(1) = 1/15;

end

