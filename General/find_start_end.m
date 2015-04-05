function [ starts, ends] = find_start_end( index )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

m = 1;
n = 1;

keyboard

for j = 1:length(index)-1
    
    % Check for starts
    if index(j) == 0 && index(j+1) == 1
        starts(m) = j+1;
        m = m + 1;
    elseif j == 1 && index(j) == 1
        starts(m) = 1;
        m = m + 1;
    end
    
    % Check for ends
    if index(j) == 1 && index(j+1) == 0
        ends(n) = j+1;
        n = n + 1;
    elseif j == length(index)-1 && index(j+1) == 1; 
        ends(n) = j+1;
        n = n + 1;
    end
    
end


end

