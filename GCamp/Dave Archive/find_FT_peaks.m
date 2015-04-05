function [ Peaks, locs ] = find_FT_peaks(FT)
%function [ Peaks, locs ] = find_FT_peaks(FT) 
%  Pull out peaks of all calcium transients for each FT.

num_FT = size(FT,1);
locs = cell(1,num_FT);
Peaks = cell(1,num_FT);
for j = 1:size(FT,1)
    [Peaks{j}, locs{j}] = findpeaks(FT(j,:));
    
end


end

