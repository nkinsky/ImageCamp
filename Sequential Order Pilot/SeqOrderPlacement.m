% Generate random placements for cups for sequential order task

clear all
close all

Location = {'NW' 'NE' 'E' 'SE' 'SW' 'W'};
Names = {'SO1' 'SO2' 'SO3' 'SO4'};


for j = 1:5
day{j} = randi(6,[2,60]);
end

for k = 1:5
    for m = 1:60
        AM{m,k} = Location{day{k}(1,m)};
        PM{m,k} = Location{day{k}(2,m)};
    end
   
    
end
