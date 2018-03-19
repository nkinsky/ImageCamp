%% Rus sek Day poster script
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
plot_local_aligned = 0; % true = plot with local cues aligned, false = as presented to mouse
sesh_use = G30_square([1 6 7]); %cat(2,G45_square([1:4, 7]),G45_oct(1)); cat(2,G30_oct([1:4,7]),G30_square(1)); % % cat(2, G48_oct(1), G48_oct(5), G48_oct(2), G48_oct(3), G48_square(5), G48_oct(4)); % cat(2, G48_oct(1), G48_oct(2), G48_oct(5), G48_square(5), G48_oct(3)); % cat(2,G30_square(1), G30_square(3), G30_square(4), G30_oct(1), G30_square(6));
base_sesh = G30_square(1); G45_square(1); % G48_square(1); %G30_square(1); % G30_square(1); 
num_cols = length(sesh_use);
best_angle_use = G30_square_best_angle([1 6 7]);% G45_both_best_angle([1 2 7 8 13 3]);
% num_rows = 3;

[base_dir, base_sesh_full] = ChangeDirectory_NK(base_sesh,0);
load(fullfile(base_dir,'batch_session_map.mat'));
batch_session_map_win = batch_session_map;
load(fullfile(base_dir,'batch_session_map_trans.mat'));
base_index = match_session(batch_session_map.session, base_sesh);

% Assemble cells to plot
PF_plot = cell(1,length(sesh_use));
for j = 1:length(sesh_use)
    dirstr = ChangeDirectory_NK(sesh_use(j),0);
    if plot_local_aligned == 0
        [~, rot] = get_rot_from_db(sesh_use(j));
    elseif plot_local_aligned == 1
        rot = 0;
    elseif plot_local_aligned == 2
        rot = best_angle_use(j);
    end
    load(fullfile(dirstr,['Placefields_rot' num2str(rot) '.mat']),'TMap_gauss');
    sesh_use(j).tmap = TMap_gauss;
    sesh_use(j).nanmap = TMap_gauss{1};
    sesh_use(j).nanmap(~isnan(TMap_gauss{1})) = 0;
    sesh_use(j).sesh_index = match_session(batch_session_map.session, sesh_use(j));
    sesh_use(j).rot = rot;
end
sparse_map = batch_session_map.map(:,arrayfun(@(a) a.sesh_index, sesh_use)+1); % get map for just the 4 days in question
good_ind = find(sum(sparse_map ~= 0 & ~isnan(sparse_map),2) == num_cols); % neurons active on all 4 days
% good_ind = [63 21 22 7 42];
% good_ind = [63 7 42]; % [7 21 42 63 74 113 143]; % Use this code to get the
% appropriate neurons from the base session for G48 (G48_square(1) which
% isn't plotted: arrayfun(@(a) find(a == batch_session_map.map(:,4)), G48_oct1_good_neurons)
% good_ind = [50 71 368]; %[71 135 50 303 368]; %[70 71 72 82 135 224 230
% 242 89 122]; % [71 230 135]; % All for G30
% good_ind = [50 128 212 268]; %[50 224 268 174];% G45_square(1:4,7) + G45_oct(1)
% [56 69 161 392]; %[37 50 56 69 161 180 207 323 361 392]; % G48 square(1) + all circle sessions
num_rows = 4; 
% num_rows = length(good_ind);

figure; set(gcf,'Position',[2100 20 750 875]);

neurons_plot = 1:num_rows;
base_dir = ChangeDirectory_NK(sesh_use(1),0);
for m = 1:(floor(length(good_ind)/num_rows))
    for k = 1:length(sesh_use)
        map_use = get_neuronmap_from_batchmap(batch_session_map.map, ...
            base_index, sesh_use(k).sesh_index);
        %%% Run Correlation Analysis to eventually put into the plot? %%%
%         if k > 1 
%             [~, sesh_use_full] = ChangeDirectory_NK(sesh_use(k),0);
%             if regexpi(base_sesh_full.Env,'square') && regexpi(sesh_use_full.Env,'square') 
%                 batch_map_use = batch_session_map_win;
%                 rot_array = 0:90:270;
%                 trans = false;
%             elseif regexpi(base_sesh_full.Env,'octagon') && regexpi(sesh_use_full.Env,'octagon')
%                 batch_map_use = batch_session_map_win;
%                 rot_array = 0:15:345;
%                 trans = false;
%             else
%                 batch_map_use = batch_session_map;
%                 rot_array = 0:15:345;
%                 trans = true;
%             end
%             corr_mat = corr_rot_analysis( sesh_use(1), sesh_use(k), batch_map_use, ...
%                 rot_array, 'trans', trans);
%         end
        for j = 1:length(neurons_plot)
            neuron_use = map_use(good_ind(neurons_plot(j)));
%             corr_use = 
            subplot(num_rows + 1, num_cols, num_cols*(j-1)+k)
            if isnan(neuron_use)
                title('Sketchy neuron mapping')
            elseif neuron_use == 0
                imagesc_nan(rot90(sesh_use(k).nanmap,1));
                title('Neuron not active')
            elseif neuron_use > 0
                if sum(isnan(sesh_use(k).tmap{neuron_use}(:))) == length(sesh_use(k).tmap{neuron_use}(:)) % edge case where bug in Placefields has cause TMap_gauss to be all NaNs
                    imagesc_nan(rot90(sesh_use(k).nanmap,1));
                else
                    imagesc_nan(rot90(sesh_use(k).tmap{neuron_use},1));                    
                end
                if k == 1 % only label neuron in first session
                       title({['Neuron ' num2str(neuron_use)], ['Rot = ' ...
                           num2str(sesh_use(k).rot)]})
                elseif j == 1 && k ~= 1
                    title(['Rot = ' num2str(sesh_use(k).rot)])
                end
            end
%             axis equal 
            axis tight
            axis off
            try
            if j == 1
                dirstr = ChangeDirectory_NK(sesh_use(k),0);
                load(fullfile(dirstr,'FinalOutput.mat'),'NeuronImage');
                reg_filename = fullfile(base_dir,['RegistrationInfo-' sesh_use(k).Animal '-' sesh_use(k).Date '-session' num2str(sesh_use(k).Session) '.mat']);
                load(reg_filename);
                if neuron_use ~= 0 && ~isnan(neuron_use)
                    ROI_reg = imwarp_quick(NeuronImage{neuron_use}, RegistrationInfoX);
                    b = bwboundaries(ROI_reg,'noholes');
                    
                    subplot(num_rows + 1, num_cols, num_cols*num_rows+k)
                    plot(b{1}(:,2),b{1}(:,1));
                    if k == 1
                        cent_ROI = mean(b{1},1);
                        xlims = [cent_ROI(2) - 15, cent_ROI(2) + 15];
                        ylims = [cent_ROI(1) - 15, cent_ROI(1) + 15];
                    end
                    xlim(xlims); ylim(ylims);
                elseif neuron_use == 0 || isnan(neuron_use)
                    subplot(num_rows + 1, num_cols, num_cols*num_rows+k)
                    text(0.1,0.5,'Bad Neuron Mapping - no ROI out')
                end
%                 axis equal
                axis tight
                axis off
            end
            catch
                disp('Some error in plotting ROIs')
            end
                
        end

    end
    neurons_plot = (max(neurons_plot)+1):(max(neurons_plot)+num_rows);
    waitforbuttonpress
end

% Plot figure showing neuron outlines from above
ncolors = [1 0 0; 0 1 0; 0 0 1; 1 0 1]; % Plot example neurons as r g b cyan
ncolors = resize(ncolors, [length(good_ind), 3]); % Add in more intermediate colors if needed
figure; set(gcf,'Position',[2500 150 950 770])
h = gca;
load(fullfile(base_dir,'FinalOutput.mat'),'NeuronImage')
hall = plot_neuron_outlines(nan,NeuronImage,h,'colors',[0.5 0.5 0.5]);
hold on
[~, ~, hneuron] = plot_neuron_outlines(nan,NeuronImage(good_ind((end-3):end)),hall,...
    'colors', ncolors, 'scale_bar', false);
legend(hneuron,arrayfun(@(a) ['Neuron ' num2str(a)], ...
    good_ind,'UniformOutput',false))
axis tight
%% Plot cell recruitment 1st v 2nd environment
sesh_use = G45_square(6); %G45_square(5); %G45_square(5);

dirstr = ChangeDirectory_NK(sesh_use,0);
load(fullfile(dirstr,'FinalOutput.mat'),'PSAbool','NeuronTraces');
num_neurons = size(PSAbool,1);
num_frames = size(PSAbool,2);
 
% Stuff you need to specify
% For G45_square(5)
% env_t = [6750 13200 19550]/20; % Times of entry into 2nd env, 1st env, and 2nd env
% cells1 = 1:660; % cells recruited in 1st env
% cells2 = 670:num_neurons; % cells recruited in 2nd env

% For G45_square(6)
env_t = [358 690 1000]; % Times of entry into 2nd env, 1st env, and 2nd env
cells1 = 1:645; % cells recruited in 1st env
cells2 = 646:num_neurons; % cells recruited in 2nd env

% For G30_square(5)
% env_t = [320 750 1075];
% cells1 = 1:690;
% cells2 = 691:num_neurons;

% For G30_square(6)
% env_t = [340 670 1000];
% cells1 = 1:700;
% cells2 = 701:num_neurons;

[PSAbool_sort, sort_ind] = sortPSA(PSAbool);
PSAbool_sort2 = double(PSAbool_sort);
PSAbool_sort2(cells2,:) = PSAbool_sort2(cells2,:)*2;
LPtrace_sort = NeuronTraces.LPtrace(sort_ind,:);
time_plot = (1:num_frames)/20;

figure(100); set(gcf,'Position',[231         150        1055         739])
h1 = subplot(6,1,2:6);
imagesc(time_plot,1:num_neurons,PSAbool_sort2); 
% colormap('gray')
colormap([1 1 1; 1 0 0; 0 0 1])
hold on
for j = 1:3
    plot([env_t(j) env_t(j)],[1 num_neurons],'k--');
end
plot([1 max(time_plot)], [cells1(end) cells1(end)],'k--')
xlabel('Time (s)')
ylabel('Neuron #')
hold off
% imagesc_gray(PSAbool_sort); colorbar off;
h2 = subplot(6,1,1);
smth_win_sec = 10; % Smoothing window to use in seconds
plot_type = 'PSAbool';
switch plot_type; case 'PSAbool'; act_plot = PSAbool_sort; case 'LPtrace'; act_plot = LPtrace_sort; end
plot(time_plot, convtrim(mean(act_plot(cells1,:),1), ones(20*smth_win_sec,1))/smth_win_sec,'r'); 
hold on; 
plot(time_plot, convtrim(mean(act_plot(cells2,:),1), ones(20*smth_win_sec,1))/smth_win_sec,'b'); 
ylims = get(gca,'YLim');
% for j = 1:3; plot([env_t(j) env_t(j)],ylims,'k--'); end
hold off
axis tight
axis off

% Attempt to do above but sort by discrimination index instead...
DI_use = squeeze(Mouse(3).DI(6,6,:));
sesh_ind2 = [12 11]; % session indices in 16 session format, square always first
base_sesh = Mouse(3).sesh.circ2square(1);
base_dir = ChangeDirectory_NK(base_sesh,0);
load(fullfile(base_dir,'batch_session_map_trans.mat'));
map_use = batch_session_map.map(:,sesh_ind2(1)+1);
valid_map_log = ~isnan(map_use) & map_use ~= 0;
DI2 = nan(num_neurons,1);
DI2(map_use(valid_map_log)) = DI_use(valid_map_log);

[PSAbool_sortDI, sort_indDI] = sortPSA(PSAbool,'alt_sort',DI2);
PSAbool_sort2DI = double(PSAbool_sortDI);
% PSAbool_sort2DI(cells2,:) = PSAbool_sort2(cells2,:)*2;
% LPtrace_sort = NeuronTraces.LPtrace(sort_ind,:);
time_plot = (1:num_frames)/20;

figure(101)
imagesc(time_plot,1:num_neurons,PSAbool_sort2DI);
hold on
for j = 1:3
    plot([env_t(j) env_t(j)],[1 num_neurons],'k--');
end
hold off
xlabel('Time (s)')
ylabel('Low DI bottom (circle pref) - High DI top (square pref)')
title('PSAbool sorted by discrimination index')

