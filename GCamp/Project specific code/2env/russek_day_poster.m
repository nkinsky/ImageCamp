%% Russek Day poster script
% Any code snippets necessary for creating and tweaking this poster
save_dir = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Presentations\Russek Day 2017\Poster';
%% All Neuron Plot
sesh_use = ref.G45.twoenv(1);

ChangeDirectory_NK(MD(sesh_use));
min_proj = imread('ICmovie_min_proj.tif');
max_proj = imread('ICmovie_max_proj.tif');

figure;
imagesc_gray(min_proj)
PlotNeuronOutlines_NK(NeuronImage,gca)
colorbar off

print([MD(sesh_use).Animal '_allneurons'],'-dpdf', '-bestfit')

%% Plot cells across days
% 1 = square, 2 = square rotated with cells following local cues, 3 =
% square rotated, 4 = circle
sesh_use = cat(2,G30_square(1), G30_square(3), G30_square(4), G30_oct(1));
base_sesh = G30_square(1);

base_dir = ChangeDirectory_NK(base_sesh,0);
load(fullfile(base_dir,'batch_session_map_trans.mat'));
base_index = match_session(batch_session_map.session, base_sesh);

% Assemble cells to plot
PF_plot = cell(1,length(sesh_use));
for j = 1:length(sesh_use)
    dirstr = ChangeDirectory_NK(sesh_use(j),0);
    [~, rot] = get_rot_from_db(sesh_use(j));
    load(fullfile(dirstr,['Placefields_rot' num2str(rot) '.mat']),'TMap_gauss');
    sesh_use(j).tmap = TMap_gauss;
    sesh_use(j).nanmap = TMap_gauss{1};
    sesh_use(j).nanmap(~isnan(TMap_gauss{1})) = 0;
    sesh_use(j).sesh_index = match_session(batch_session_map.session, sesh_use(j));
end
sparse_map = batch_session_map.map(:,arrayfun(@(a) a.sesh_index, sesh_use)+1); % get map for just the 4 days in question
good_ind = find(sum(sparse_map ~= 0 & ~isnan(sparse_map),2) == 4); % neurons active on all 4 days
good_ind = [50 71 368]; %[71 135 50 303 368]; %[70 71 72 82 135 224 230 242 89 122]; % [71 230 135]; %

num_cols = length(sesh_use);
num_rows = 3;

figure

neurons_plot = 1:num_rows;
for m = 1:20
    for k = 1:length(sesh_use)
        map_use = get_neuronmap_from_batchmap(batch_session_map.map, ...
            base_index, sesh_use(k).sesh_index);
        for j = 1:length(neurons_plot)
            neuron_use = map_use(good_ind(neurons_plot(j)));
            subplot(num_rows, num_cols, num_cols*(j-1)+k)
            if isnan(neuron_use)
                title('Sketchy neuron mapping')
            elseif neuron_use == 0
                imagesc_nan(sesh_use(k).nanmap);
                title('Neuron not active')
            elseif neuron_use > 0
                imagesc_nan(sesh_use(k).tmap{neuron_use});
                title(num2str(neuron_use))
            end
        end
    end
    neurons_plot = (max(neurons_plot)+1):(max(neurons_plot)+num_rows);
    waitforbuttonpress
end