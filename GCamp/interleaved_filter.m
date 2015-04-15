function [ filter1, filter2 ] = interleaved_filter( valid_length, num_divs )
%[ filter1, filter2 ] = interleaved_filter( valid_length, num_divs )
%   Use this function to create filters to break up data into an arbitrary
%   number of interleaved divisions.  Useful for comparing drift in data over time... 
%   valid_length:   num of data points (e.g. number of frames of data)
%   num_divs:       num of sections to divide your data into (e.g. 4 would
%   divide into quarters)

% filter1 and filter2: logical vectors of size 1 x valid_length which break
% up your data equally in an interleaved fashion.  e.g. if you use num_divs
% = 4, you will get a filter1 that is ones for the 1st and 3rd quarters of
% your data and zeros elsewhere, filter2 will likewise select the 2nd and
% 4th quarters of you data

indices = zeros(num_divs,valid_length);
step = floor(valid_length/num_divs);

% Create filters for each division
for j = 1:num_divs
    indices(j,step*(j-1)+1:step*j) = ones(1,step); 
end

% Combine into filter1 and filter2
filter1 = zeros(1,valid_length); filter2 = zeros(1,valid_length);
for j = 1:num_divs
    if round(j/2) ~= j/2; filter1 = filter1 | indices(j,:); 
    elseif round(j/2) == j/2; filter2 = filter2 | indices(j,:); 
    end
end


end

