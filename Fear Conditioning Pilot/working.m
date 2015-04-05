session_list = arrayfun(@(a) a.session.session_name,analyzed_data.animal,...
    'UniformOutput',0);
context_list = arrayfun(@(a) a.session.context,analyzed_data.animal,...
    'UniformOutput',0);
num_animals = size(analyzed_data.animal,2);

%% Get Mean and Std for freeze ratio and average speed
session_list = {};
context_list = {};
freezing_list = [];
speed_list = [];
for j = 1:num_animals
    clear temp_s temp_c temp_f temp_sp
    
    temp_s = arrayfun(@(a) a.session_name,analyzed_data.animal(j).session,...
        'UniformOutput',0);
    session_list = {session_list{:} temp_s{:}};
    
    temp_c = arrayfun(@(a) a.context,analyzed_data.animal(j).session,...
        'UniformOutput',0);
    context_list = {context_list{:} temp_c{:}};
    
    temp_f = arrayfun(@(a) a.freeze_ratio_k,analyzed_data.animal(j).session);
    freezing_list = [freezing_list temp_f];
    
    temp_sp = arrayfun(@(a) a.avg_speed_k,analyzed_data.animal(j).session);
    speed_list = [speed_list temp_sp];
    
    
end
