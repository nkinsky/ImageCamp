function [stage_bool] = get_learning_stage(MD, stage_ends)
% [stage_bool] = get_learning_stage(MD, stage_ends)
%  Gets booleans identifying learnings stages whose end session are noted
%  in stage_ends.

nstage = length(stage_ends);
nsesh = length(MD);

% Get all dates as numbers
datenums = arrayfun(@(a) datenum(a.Date), MD); % Gate datenums
datenums(arrayfun(@(a) a.Session >=2, MD)) = ...
    datenums(arrayfun(@(a) a.Session >=2, MD)) + 0.5; % add 0.5 to 2nd session in a day

% Get all sessions ending a learning stage as numbers
end_nums = arrayfun(@(a) datenum(a.Date), stage_ends); % Gate datenums
end_nums(arrayfun(@(a) a.Session >=2, stage_ends)) = ...
    end_nums(arrayfun(@(a) a.Session >=2, stage_ends)) + 0.5;

stage_bool = false(nstage, nsesh);
prior_bool = false(1, nsesh);
for j = 1:nstage
   if j == 1 
       stage_bool(j,:) = datenums <= end_nums(j);
   elseif j >= 1
       stage_bool(j,:) = datenums <= end_nums(j) & ~prior_bool;
   end
   prior_bool = prior_bool | stage_bool(j,:);
end

end

