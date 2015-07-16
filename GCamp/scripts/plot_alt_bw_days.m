% Script to plot place-fields of cells from one day to the next

day(1).folder = 'J:\GCamp Mice\Working\alternation\11_12_2014\Working';
day(2).folder = 'J:\GCamp Mice\Working\alternation\11_13_2014\Working';

%% Load TMaps for each session
for j = 1:length(day)
   cd(day(j).folder);
   load('PlaceMaps.mat','TMap','OccMap')
   load('ProcOut.mat','NeuronImage')
   day(j).TMap = TMap;
   day(j).OccMap = OccMap;
   day(j).NeuronImage = NeuronImage;
end

%% Run image registration
try
    load(fullfile(day(1).folder, 'neuron_map.mat'))
    neuron_id = neuron_map.neuron_id;
    load(fullfile(day(1).folder, 'RegistrationInfoX.mat'));
catch
    [neuron_id, same_neuron, num_bad_cells] = image_register_simple(fullfile(day(1).folder, 'ICMovie_min_proj.tif'),...
        fullfile(day(2).folder, 'ICMovie_min_proj.tif'),0);
    load(fullfile(day(1).folder, 'RegistrationInfoX.mat'));
end
% Get registration info
[tform_struct ] = get_reginfo(day(1).folder, day(2).folder, RegistrationInfoX );

%% Plot stuff
figure(600)
for j = 1:length(day(1).TMap)
    % Register 2nd TMap to the 1st
    if ~isempty(neuron_id{j}) && ~isnan(neuron_id{j})
        % Register 2nd neuron's outline to 1st neuron
        neuron2_reg = imwarp(day(2).NeuronImage{neuron_id{j}},tform_struct.tform,'OutputView',...
            tform_struct.base_ref,'InterpolationMethod','nearest');
        TMap2 = day(2).TMap{neuron_id{j}};
    else
        % Make 2nd neuron mask all zeros if no cell maps to the 1st
        neuron2_reg = zeros(size(day(1).NeuronImage{1}));
        TMap2 = zeros(size(day(2).TMap{1}));
    end
    % Plot Neuron masks
    subplot(2,3,1)
    imagesc(day(1).NeuronImage{j}); title('Session 1');
    subplot(2,3,4)
    imagesc(day(1).NeuronImage{j} + 2*neuron2_reg); 
    title('Session 1 + Session 2'); % colorbar; colormap jet;
    subplot(2,3,[2 3])
    [~, TMap1_nan] = make_nan_TMap(day(1).OccMap, day(1).TMap{j});
    [~, TMap2_nan] = make_nan_TMap(day(2).OccMap, TMap2);
    imagesc_nan(rot90(TMap1_nan,1))
    title(['Neuron ' num2str(j)])
    subplot(2,3,[5 6])
    imagesc_nan(rot90(TMap2_nan,1))
    title(['Neuron ' num2str(neuron_id{j})]);
    
    waitforbuttonpress
    
    
end

%% Look at correlations
% Hack to get TMaps the same size...not very exact, but does scale TMaps to
% be the same size...
sizing = [size(day(2).TMap{1}); size(day(1).TMap{1})];
size_use = min(sizing,[],1);
for j = 1:length(day(1).TMap)
    
    if ~isempty(neuron_id{j}) && ~isnan(neuron_id{j})
        % Register 2nd neuron's outline to 1st neuron
        neuron2_reg = imwarp(day(2).NeuronImage{neuron_id{j}},tform_struct.tform,'OutputView',...
            tform_struct.base_ref,'InterpolationMethod','nearest');
        TMap2 = day(2).TMap{neuron_id{j}};
    else
        % Make 2nd neuron mask all zeros if no cell maps to the 1st
        neuron2_reg = zeros(size(day(1).NeuronImage{1}));
        TMap2 = zeros(size(day(2).TMap{1}));
    end
    % resize matrices so that they are the same size...
    if isempty(neuron_id{j}) || isnan(neuron_id{j}) || sum(isnan(day(1).TMap{j}(:))) ~= 0 || sum(isnan(day(2).TMap{neuron_id{j}}(:))) ~= 0
        corr_bw_sesh{j} = nan;
    else
        TMap1 = resize(day(1).TMap{j},size_use);
        TMap2 = resize(TMap2,size_use);
        temp = corrcoef(TMap1(:),TMap2(:));
        corr_bw_sesh{j} = temp(1,2);
    end
end