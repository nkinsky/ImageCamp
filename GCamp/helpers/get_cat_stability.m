function [ stay_prop, coactive_prop, stay_bool, coactive_bool, category2] = ...
    get_cat_stability(categories, neuron_map, cat_designations)
% [stay_prop, coactive_prop, stay_bool, coactive_bool, category2] = ...
%       get_cat_stability(categories, neuron_map, cat_designations)
%
%   Gets 2 cell stability metrics: coactivity probability, and probability 
%   of staying in the same category for neurons in each category designated 
%   in categories variable (length 2 cell with category designation for 
%   neurons in 2 different sessions. Must contain row arrays, and rows must 
%   be integers matching those in cat_designations neuron_map maps neurons 
%   in session 1 to session 2. category2 is the category each neuron in the
%   1st session becomes in the 2nd session (nan = not active in 1st
%   session).

%% Parse Inputs
ip = inputParser;
ip.addRequired('categories', @(a) iscell(a) && length(a) == 2 && ...
    size(a{1},2) == 1 && size(a{2},2) == 1);
ip.addRequired('neuron_map', @isnumeric);
ip.parse(categories, neuron_map);

%% Rearrange and map categories
coactive_bool = ~isnan(neuron_map) & neuron_map ~= 0;

% Dump categories into an array for all the validly mapped cells between each
% session
category_array(:,1) = categories{1}(coactive_bool);
category_array(:,2) = categories{2}(neuron_map(coactive_bool));
stay_bool = category_array(:,1) == category_array(:,2);

%% Now get proportions that stay in each category
stay_prop = zeros(1,length(cat_designations));
for j = 1:length(cat_designations)
    cat_use = cat_designations(j);
    num_stay = sum(stay_bool & (category_array(:,2) == cat_use));
    stay_prop(j) = num_stay/sum((category_array(:,1) == cat_use));
end

%% Now step through and get proportions that are coactive in each category
coactive_prop = zeros(1,length(cat_designations));
for j = 1:length(cat_designations)
    cat_use = cat_designations(j);
    num_coactive = sum(coactive_bool & (categories{1} == cat_use));
    coactive_prop(j) = num_coactive/sum(categories{1} == cat_use);
end

temp = stay_bool;
stay_bool = false(size(coactive_bool));
stay_bool(coactive_bool) = temp;

category2 = nan(size(coactive_bool));
category2(coactive_bool) = category_array(:,2);

end

