
%CITYMAP
map = [0 -2 0  0 -1 0  0 -2 0;
       2  1 0  1  2 0  3  3 0;
       0 -2 0  0 -2 0  0 -1 0;
       0 -2 0  0 -1 0  0 -2 0;
       0  6 2  0  5 2  0  4 4;
       0 -1 0  0 -2 0  0 -1 0];
   
type_m = [0 -2 0 0 -2 0 0 -2 0;
          2  0 1 1  0 1 1  0 1;
          0 -1 0 0 -1 0 0 -1 0;
          0 -1 0 0 -1 0 0 -1 0;
          1  0 1 1  0 1 1  0 2;
          0 -2 0 0 -2 0 0 -2 0];
       
    
%PARAMETERS
number_of_crosses = 6;
number_of_links = 34;
number_of_arterials = 2;
   

%ARTERIALS
arterials{1} = [4,1,2,3];
arterials{2} = [2,4,5,6];


%RANDOM NUMBERS
for i=1:1000000
    rn(i) = rand(1);
end

save('city.mat');