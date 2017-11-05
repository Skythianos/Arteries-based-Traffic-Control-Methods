%clear;

map = [0 -2 0  0 -1 0  0 -2 0;
       2  1 0  1  2 0  3  3 0;
       0 -2 0  0 -2 0  0 -1 0;
       0 -2 0  0 -1 0  0 -2 0;
       0  6 2  0  5 2  0  4 4;
       0 -1 0  0 -2 0  0 -1 0];
   
type_m = [0 2 0 0 -2 0 0 2 0;
        2 0 1 1 0 1 1 0 2;
        0 1 0 0 -1 0 0 1 0;
        0 1 0 0 -1 0 0 1 0;
        2 0 1 1 0 1 1 0 2;
        0 2 0 0 -2 0 0 2 0];
       
number_of_crosses = 6;
number_of_links = 34;
number_of_arterials = 4;
   
arterials{1} = [4,1,2,3];
arterials{2} = [2,4,5,6];
arterials{3} = [3,3,4];
arterials{4} = [1,6,1];

for i=1:10000
    rn(i) = rand(1);
end

save('city_2d.mat');