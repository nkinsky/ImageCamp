function [ day ] = lookup_day(arena,session)
% day = lookup_day(arena,session)
%   Takes inputs of arena (1 = square, 2 = circle) and session number (1-8)
%   and outputs day (1-8).  Arena and session are vectors of the same
%   length.

% Day lookup table - first column = arena, second column = session, third
% column = day
day_table = [1 1 1; 1 2 1; 2 1 2; 2 2 2; 2 3 3; 2 4 3; 1 3 4; 1 4 4; 1 5 5; ...
    2 5 5; 1 6 6; 2 6 6; 1 7 7; 1 8 7; 2 7 8; 2 8 8];

day = nan(length(arena),1);
for j = 1:length(arena)
    day(j) = day_table(arena(j) == day_table(:,1) & ...
        session(j) == day_table(:,2),3);
end

end

