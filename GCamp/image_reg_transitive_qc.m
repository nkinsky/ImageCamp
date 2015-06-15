%%% Transitive Test %%%
mouse = 'GCamp6f_31';
base_date = '09_29_2014';
mid_date = '10_01_2014';
last_date = '10_03_2014';

%%
for j = 1:length(direct_method); 
    sesh1_ind = find(cellfun(@(a) ~isempty(a) && a == j, base_method(:,2)));
    transitive_test{j,1} = sesh1_ind;
    if isempty(sesh1_ind)
    else
        transitive_test{j,2} = base_method{sesh1_ind,3};
    end
end

side_by_side = cell(size(direct_method,1),2);
side_by_side(:,2) = transitive_test(:,2);
side_by_side(:,1) = direct_method(:,1);

%% QC
for j = 1:size(side_by_side,1); 
    if (isempty(side_by_side{j,1}) && ~isempty(side_by_side{j,2})) || ...
            (isempty(side_by_side{j,2}) && ~isempty(side_by_side{j,1}))
        same_test(j,1) = 0;
    elseif (isempty(side_by_side{j,1}) && isempty(side_by_side{j,2})) || ...
            side_by_side{j,1} == side_by_side{j,2} || ...
            (isnan(side_by_side{j,1}) && isnan(side_by_side{j,2}))
        same_test(j,1) = 1;
        
    elseif size(side_by_side{j,1},1) > 1 || isnan(side_by_side{j,1}) || isnan(side_by_side{j,2})
        same_test(j,1) = nan;
    else
        same_test(j,1) = 0;
    end
end