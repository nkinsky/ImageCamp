% Generate random placements for cups for sequential order task

clear all
close all

Location = {'NW' 'NE' 'SE' 'SW' 'W'};
Names = {'SO1' 'SO2' 'SO3' 'SO4'};


for j = 1:5
day{j} = randi(5,[30,4]); % each column is for a given mouse, rows 1-15 are AM, 16-30 PM
end

for k = 1:5
   for m = 1:4
       for p = 1:15
       AM{15*(m-1) + p,k} = Location{day{k}(p,m)};
       PM{15*(m-1) + p,k} = Location{day{k}(15+p,m)};
       
       AM_test(15*(m-1) + p,k) = day{k}(p,m);
       PM_test(15*(m-1) + p,k) = day{k}(15+p,m);
       end
   end
end

% Make sure distributions more or less even
placements = zeros(30*5,4);
for m = 1:4
    for j = 1:5
        placements(30*(j-1)+1:30*j,m) =  day{j}(:,m);
    end
end

figure
for m = 1:4
subplot(2,2,m)
[n{m} x{m}] = hist(placements(:,m),1:5); 
bar(x{m},n{m});xlabel('Position'); ylabel('Count')
end
