% registration scratchpad

%% Get distribution of multiple mapping neurons across all sessions in batch_session map
name_append = '_updatemasks1';
batch_map = fix_batch_session_map(importdata('batch_session_map.mat'));
base_path = ChangeDirectory_NK(batch_map.session(1),0);

multi_overlaps = []; % all 
multi_overlaps2 = []; % only those that have 2 or more overlapping neurons
multi_overlaps3 = []; % 
for j = 2:length(batch_map.session)
    if j == 2
        name_append_use = '';
    else
        name_append_use = name_append;
    end
    unique_filename = fullfile(base_path,['neuron_map-' batch_map.session(j).Animal '-' ...
        batch_map.session(j).Date '-session' ...
        num2str(batch_map.session(j).Session) name_append_use '.mat']);
    neuronmap = importdata(unique_filename);
    [temp, temp2] = reg_calc_samemap_overlap( neuronmap,'batch_mode',1 );
    two_or_more = find(cellfun(@(a) ~isempty(a) && a ~= 0,temp(:,1)) & ...
        cellfun(@(a) ~isempty(a) && a ~= 0,temp(:,2))); % find legit multiple mapping neurons
    multi_overlaps = [multi_overlaps; cell2mat(temp(:))];
    multi_overlaps2 = [multi_overlaps2; cell2mat(temp(two_or_more,1))];
    multi_overlaps3 = [multi_overlaps3; cell2mat(temp2(two_or_more,1))];
end
