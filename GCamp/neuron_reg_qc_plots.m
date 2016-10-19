% neuron registration script
% Used to quantify how good our neuron registration actually is
%
% part 1: quantify how good image registration is - use stuff from
% reg_quantification_start to compare to turboreg and reg by neurons.
% Basically recapitulate Ziv et al. stuff, but show that it works with
% minimum projection.
%
% part 2: quantify how good neuron registration is, using a number of
% sessions with no remapping and even a control where you register a
% session to itself!
% z) Add in plot of neuron ROI overlaps to below...
% a) Plot distance between centroids, axis ratio difference,and major axis
% difference as a function of amount of jitter between several sets of 2
% sessions with relatively stable placefields.  Also plot overlap ratio.
% b) Plot distance between place fields using the same method as above
% c) compare each to null distribution where mappings between neurons are
% random.
% d) Do above for both session1 v session2 same day, as well as for a
% session across days!!!
% e) Plot correlations of firing rate in one session v the other...
%
% generate example plots of neuron ROIs across multiple sessions
%

clear
close all

[MD, ref] = MakeMouseSessionList('Nat');

%% Step 0 overall: Set base sessions and variables

base_sesh_index = 1; % Specify the base 2env session to use from below
% Session references:
session_ref(1) = ref.G30.two_env(1); % - good
session_ref(2) = ref.G45.twoenv(1)+2; % - good, other session (square) remaps
session_ref(3) = ref.G31.two_env(1) + 2; % - good, the square remaps between sessions
session_ref(4) = ref.G48.twoenv(1) + 6;
base_sesh = MD(session_ref(base_sesh_index));

PF_filterspec = 4; % 3 = use only neurons with a valid PF in BOTH session, 4 = either session
PF_pval_thresh = 0.05; % pval threshold on spatial information for filtering out neurons
min_thresh = 2; % neurons must be at least this close in pixels to be validly mapped, default = 3
multi_map_method = 2; % method for disambiguating multiple mapping neurons (0 = use most overlap, 1 = use closest, 2 = use smallest shape ratio difference)
num_shuffles = 100;
reg_self = 1; % 0 = register to next session indicated below, 1 = register session to itself
fine_res = 0; % 0, Sets shift difference from 0:10 pixels, 1 sets it from 2:3 pixels

% For Part 2 - set file to do comparisons on.  Might want to make this
% multiple different files/animals later
if reg_self == 0
%     base_reg_file = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working\RegistrationInfo-GCamp6f_30-11_19_2014-session2.mat';
    base_reg_file = fullfile(base_sesh.Location,['RegistrationInfo-' base_sesh.Animal '-' base_sesh.Date '-session' num2str(base_sesh.Session+1) '.mat']);
elseif reg_self == 1
%     base_reg_file = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working\RegistrationInfo-GCamp6f_30-11_19_2014-session1.mat';
    base_reg_file = fullfile(base_sesh.Location,['RegistrationInfo-' base_sesh.Animal '-' base_sesh.Date '-session' num2str(base_sesh.Session) '.mat']);
end
PF_filenames = {'PlaceMaps_rot_to_std.mat','PlaceMaps_rot_to_std.mat'};
reginfo = importdata(base_reg_file);

session.Animal = reginfo.mouse;
session.Date = reginfo.base_date;
session.Session = reginfo.base_session;
session.dir = ChangeDirectory_NK(session(1),0);

session(2).Animal = reginfo.mouse;
session(2).Date = reginfo.register_date;
session(2).Session = reginfo.register_session;
session(2).dir = ChangeDirectory_NK(session(2),0);

%% P2 - Step 1: Generate Intentionally shifted image registration transforms
% shift 1 - 10 pixels, each at 45 degree angles (8 total shifts per
% registration)

if fine_res == 0
    dist_shift = [0 1 2:0.2:3, 4:8]; %0:10; % Number of pixels to shift
    angle_shift = 0:pi/4:2*pi-0.05; % Angles to shift
elseif fine_res == 1
    dist_shift = [0, 2:0.2:3, 4];
    angle_shift = 0:pi/4:2*pi-0.05; % Angles to shift
end

% Load Neuron ROIs for each session
for j = 1:2
    % Temporary fix - should run with T2output in future
    if exist(fullfile(session(j).dir,'T2output.mat'),'file')
        load(fullfile(session(j).dir,'T2output.mat'),'NeuronImage')
        session(j).NeuronROI = NeuronImage;
    else
        disp('Using T1 output!!!! Update for final plots!')
        load(fullfile(session(j).dir,'MeanBlobs.mat'),'BinBlobs');
        session(j).NeuronROI = BinBlobs;
    end
end


%% P2 - Step 2: Get differences between centroids, axis ratio, major axis angle

% Do initial/actual registration
neuron_map_actual = image_register_simple( session(1).Animal, session(1).Date,...
    session(1).Session, session(2).Date, session(2).Session, 0);
num_neurons = length(neuron_map_actual);

neuron_map = nan(num_neurons,length(dist_shift),length(angle_shift));
[ mapped_ROIs_actual, valid_neurons_actual] = map_ROIs( neuron_map_actual.neuron_id, session(2).NeuronROI );

[ cent_actual, cent_dist_actual, aratio_actual, ratio_diff_actual, orient_actual, ...
    orient_diff_actual ] = dist_bw_reg_sessions( {session(1).NeuronROI(valid_neurons_actual), ...
    mapped_ROIs_actual(valid_neurons_actual)} );

[overlap_ratio_actual, overlap_pixels_actual, total_pixels_actual, ratio2_actual, ratio3_actual ] = ...
    reg_calc_overlap(session(1).NeuronROI(valid_neurons_actual), ...
    mapped_ROIs_actual(valid_neurons_actual));

% Initialize variables to track differences in centroid location, axis
% ratio, and axis orientation
cent_dist_all = cell(1,length(dist_shift));
axratio_diff_all = cell(1,length(dist_shift));
orient_diff_all = cell(1,length(dist_shift));
overlap_ratio_all = cell(1,length(dist_shift));
overlap_pixels_all = cell(1,length(dist_shift));
total_pixels_all = cell(1,length(dist_shift));
overlap_ratio3_all = cell(1,length(dist_shift));

cent_dist_all{1} = squeeze(cent_dist_actual(1,2,:));
axratio_diff_all{1} = squeeze(ratio_diff_actual(1,2,:));
orient_diff_all{1} = squeeze(orient_diff_actual(1,2,:));
overlap_ratio_all{1} = overlap_ratio_actual;
overlap_pixels_all{1} = overlap_pixels_actual;
total_pixels_all{1} = total_pixels_actual;
overlap_ratio3_all{1} = ratio3_actual;

for j = 1:length(dist_shift)
    dist_use = dist_shift(j);
    
    for k = 1:length(angle_shift)
        disp(['Running shift of ' num2str(dist_shift(j)) ' pixels at ' num2str(angle_shift(k)) ' radians.'])
        if dist_use == 0
            neuron_map(valid_neurons_actual,j,k) = cell2mat(neuron_map_actual.neuron_id(valid_neurons_actual));
        elseif dist_use ~= 0
        
            % First, generate the shift matrix
            angle_use = angle_shift(k);
            shift_mat = [1 0 0 ; 0 1 0 ; dist_use*cos(angle_use)...
                dist_use*sin(angle_use) 1];
            
            % Next, get the neuron mapping for each shift
            if multi_map_method == 0 && min_thresh == 3
                shift_map = image_register_simple( session(1).Animal, session(1).Date,...
                    session(1).Session, session(2).Date, session(2).Session, 0, ...
                    'add_jitter', shift_mat, ['_shift_' num2str(dist_shift(j)) 'pix_' num2str(k)]);
            else
               shift_map = image_register_simple( session(1).Animal, session(1).Date,...
                    session(1).Session, session(2).Date, session(2).Session, 0, ...
                    'min_thresh', min_thresh, 'multi_map_method',...
                    multi_map_method, 'add_jitter', shift_mat, ['_minthresh' num2str(min_thresh) ...
                    '_multi' num2str(multi_map_method) '_shift_' num2str(dist_shift(j)) 'pix_' num2str(k)]);
            end
            
            
            disp('Registering shifted neuron ROIs to base session')
            % Register all shifted neuron ROIs to base session
            resol = 1; % Percent resolution for progress bar, in this case 10%
            p = ProgressBar(100/resol);
            update_inc = round(length(session(2).NeuronROI)/(100/resol)); % Get increments for updating ProgressBar
%             p = ProgressBar(length(session(2).NeuronROI));
            ROI_shift = cell(size(session(2).NeuronROI));
            for ll = 1:length(session(2).NeuronROI)
                tform_use = reginfo.tform;
                tform_use.T = tform_use.T*shift_mat;
                ROI_shift{ll} = imwarp(session(2).NeuronROI{ll}, tform_use,...
                    'OutputView', reginfo.base_ref,'InterpolationMethod','nearest');
                if round(ll/update_inc) == (ll/update_inc)
                    p.progress;
                end
            end
            p.stop;
            
            % Get map between shifted neurons and original set
            [ mapped_ROIs, valid_neurons ] = map_ROIs( shift_map.neuron_id, ROI_shift );
            neuron_map(valid_neurons,j,k) = cell2mat(shift_map.neuron_id(valid_neurons)); % Track mapping for each shift
            
            % Get differences between centroids, axis ratio, major axis angle
            [ cent_shift, cent_dist_shift, axratio_shift, axratio_diff_shift, orient_shift, ...
                orient_diff_shift ] = dist_bw_reg_sessions( {session(1).NeuronROI(valid_neurons), ...
                mapped_ROIs(valid_neurons)} );
            
            cent_dist_all{j} = cat(1,cent_dist_all{j},squeeze(cent_dist_shift(1,2,:)));
            axratio_diff_all{j} = cat(1,axratio_diff_all{j},squeeze(axratio_diff_shift(1,2,:)));
            orient_diff_all{j} = cat(1,orient_diff_all{j},squeeze(orient_diff_shift(1,2,:)));
            
            % Get overlap info for each shift
            [overlap_ratio_temp, overlap_pixels_temp, total_pixels_temp, ~, ratio3_temp ] = ...
                reg_calc_overlap( session(1).NeuronROI(valid_neurons), mapped_ROIs(valid_neurons));
            
            overlap_ratio_all{j} = cat(1,overlap_ratio_all{j}, overlap_ratio_temp);
            overlap_pixels_all{j} = cat(1,overlap_pixels_all{j}, overlap_pixels_temp);
            total_pixels_all{j} = cat(1,total_pixels_all{j}, total_pixels_temp);
            overlap_ratio3_all{j} = cat(1,overlap_ratio3_all{j}, ratio3_temp);
        end
        
    end
end

%% Get shuffled values
cent_dist_shuffle = [];
ratio_diff_shuffle = [];
orient_diff_shuffle = [];
ratio_shuf = [];
overlap_pix_shuf = [];
total_pix_shuf = [];

disp('Getting shuffled centroid distances, axis ratio differences, and orientation differences')
p = ProgressBar(num_shuffles);
for j = 1:num_shuffles
    [ ~, cent_dist_temp, ~, ratio_diff_temp, ~, orient_diff_temp ] = ...
        dist_bw_reg_sessions( {session(1).NeuronROI(valid_neurons_actual), ...
        mapped_ROIs_actual(valid_neurons_actual)},1 );
    cent_dist_shuffle = cat(1,cent_dist_shuffle, squeeze(cent_dist_temp(1,2,:)));
    ratio_diff_shuffle = cat(1,ratio_diff_shuffle, squeeze(ratio_diff_temp(1,2,:)));
    orient_diff_shuffle = cat(1,orient_diff_shuffle, squeeze(orient_diff_temp(1,2,:)));

    % This is meaningless - should be close to zero!!
%     [ratio_shuf_temp, overlap_pix_shuf_temp, total_pix_shuf_temp ] = ...
%         reg_calc_overlap( session(1).NeuronROI(valid_neurons_actual), ...
%         mapped_ROIs(valid_neurons_actual(randperm(length(valid_neurons_actual)))));
%             
%     ratio_shuf = cat(1,ratio_shuf, ratio_shuf_temp);
%     overlap_pix_shuf = cat(1, overlap_pix_shuf, overlap_pix_shuf_temp);
%     total_pix_shuf = cat(1, total_pix_shuf, total_pix_shuf_temp);

    p.progress;
    
end
p.stop

% Put shuffled values into the same cell arrays as the rest for ease of
% plotting
num_dist = length(dist_shift);
cent_dist_all{num_dist+1} = cent_dist_shuffle(:);
axratio_diff_all{num_dist+1} = ratio_diff_shuffle(:);
orient_diff_all{num_dist+1} = orient_diff_shuffle(:);

% overlap_ratio_all{num_dist+1} = overlap_ratio_shuf;

%% P2 - Step 3: Get differences between PF centroids - need to filter for good spatial information!

disp('Getting distances between PF centroids for all sessions')
% Get PF centroids for each session
for j = 1:2
    load(fullfile(session(j).dir, PF_filenames{j}),'TMap_gauss','pval','cmperbin');
    session(j).pval = pval;
    [ ~, session(j).max_FR_location ] = get_PF_centroid(TMap_gauss, 0.9, 0);
end

% Get minimum distances
disp('Getting distances for shifted sessions')
min_dist_all = cell(1,length(dist_shift));
min_dist_all_filter = cell(1,length(dist_shift));
for j = 1:length(dist_shift)
    for k = 1:length(angle_shift)
        map_use = squeeze(neuron_map(:,j,k)); % get map between sessions
        min_dist_temp = get_PF_centroid_diff(session(1).max_FR_location, ...
            session(2).max_FR_location, map_use,1); % get min dist for each pair
        
        % Filter cells
        good_neurons = pval_filter_bw_sesh( session(1).pval, session(2).pval,...
            map_use, 'filter_spec',PF_filterspec,'thresh',PF_pval_thresh);
    end
    min_dist_all{j} = cat(1,min_dist_all{j},min_dist_temp);
    min_dist_all_filter{j} = cat(1,min_dist_all_filter{j},min_dist_temp(good_neurons));
end

% Now, shuffle cell identity and do this again
num_shuffles = 1000;
base_map = squeeze(neuron_map(:,1,1));
min_dist_shuffle = [];
disp('Getting distances for shuffled neuron identity')
p = ProgressBar(num_shuffles);
for j = 1:num_shuffles
    shuffle_map = base_map(randperm(length(base_map)));
    temp = get_PF_centroid_diff(session(1).max_FR_location, ...
        session(2).max_FR_location, shuffle_map,1); % get min dist for each pair
    min_dist_shuffle = [min_dist_shuffle; temp];
    
    p.progress;
end
p.stop;

min_dist_all{length(dist_shift)+1} = min_dist_shuffle;

min_dist_all_mean = cellfun(@(a) nanmean(a),min_dist_all);
min_dist_all_filter_mean = cellfun(@(a) nanmean(a),min_dist_all_filter);


%% Do stats
[~, p_axratio_v_actual] = cellfun(@(a) kstest2(axratio_diff_all{1},a),...
    axratio_diff_all);
[~, p_axratio_v_shuf] = cellfun(@(a) kstest2(axratio_diff_all{end},a),...
    axratio_diff_all);
[~, p_min_dist_v_actual] = cellfun(@(a) kstest2(min_dist_all{1},a),...
    min_dist_all);
[~, p_min_dist_v_shuf] = cellfun(@(a) kstest2(min_dist_all{end},a),...
    min_dist_all);


%% Plot the above
figure(1)
for j = 1:length(dist_shift)+1
%     subplot(2,2,1)
%     hold on;
%     [f,x] = ecdf(cent_dist_all{j});
%     h1(j) = stairs(x,f);
%     hold off
    
    if j <= length(dist_shift)
        subplot(2,2,2);
        hold on;
%         [f,x] = ecdf(cent_dist_all{j});
        [f, x] = ecdf(overlap_ratio_all{j});
        h2(j) = stairs(x,f);
        hold off
    end
    
    subplot(2,2,3);
    hold on;
    [f,x] = ecdf(axratio_diff_all{j});
    h3(j) = stairs(x,f);
    hold off
    
    subplot(2,2,4);
    hold on;
    [f,x] = ecdf(orient_diff_all{j});
    h4(j) = stairs(x,f);
    hold off
    
end

% Label everything

% subplot(2,2,1)
% % h = get(gca,'Children'); % Get line handles
% xlabel('Distance between centroids (pixels)')
% legend([h1(1) h1(end)],{' Shifted ','Shuffled'})

h2legend = arrayfun(@(a) [num2str(a) ' pixels'],dist_shift,'UniformOutput',0);
subplot(2,2,2)
% h = get(gca,'Children'); % Get line handles
% xlabel('Distance between centroids (pixels)')
xlabel('Neuron ROI overlap percentage')
legend(h2,h2legend)
    
h3legend = h2legend;
h3legend{length(h2legend) + 1} = 'Shuffled';
subplot(2,2,3)
set(h3(end),'LineStyle','--')
% h = get(gca,'Children'); % Get line handles
xlabel('Axis ratio difference')
legend(h3,h3legend)

subplot(2,2,4)
% h = get(gca,'Children'); % Get line handles
set(h4(end),'LineStyle','--')
xlabel('Axis orientation difference (radians)')
legend(h4,h3legend)


%% Plot the mean values of the above
figure(2) 

% Get the mean value for each
cent_dist_all_mean = cellfun(@(a) nanmean(a), cent_dist_all);
axratio_diff_all_mean = cellfun(@(a) nanmean(abs(a)), axratio_diff_all);
orient_diff_all_mean = cellfun(@(a) nanmean(abs(a)), orient_diff_all);
overlap_ratio_all_mean = cellfun(@nanmean, overlap_ratio_all);

% subplot(2,2,1)
% plot(dist_shift,cent_dist_all_mean(1:end-1),'b',...
%     [dist_shift(1) dist_shift(end)], repmat(cent_dist_all_mean(end),1,2), 'r--')
% xlabel('Registration Shift (pixels)')
% ylabel('Distance b/w Neuron ROI centroids (pixels)') 

subplot(2,2,2)
% plot(dist_shift,cent_dist_all_mean(1:end-1),'b')
plot(dist_shift(1:end),overlap_ratio_all_mean,'b')
xlabel('Registration Shift (pixels)')
% ylabel('Mean Distance b/w Neuron ROI centroids (pixels')
ylabel('Mean overlap ratio of Neuron ROIs')

subplot(2,2,3)
[ax23, h23(1), h23(2)] = plotyy(dist_shift,axratio_diff_all_mean(1:end-1),...
    dist_shift, p_axratio_v_actual(1:end-1)); hold on;
h23(3) = plot([dist_shift(1) dist_shift(end)], repmat(axratio_diff_all_mean(end),1,2), 'r--');
hold off
% plot(dist_shift,axratio_diff_all_mean(1:end-1),'b',...
%     [dist_shift(1) dist_shift(end)], repmat(axratio_diff_all_mean(end),1,2), 'r--')
xlabel('Registration Shift (pixels)')
ylabel(ax23(1),'Mean Axis ratio difference')
ylabel(ax23(2),'p-value')
legend(h23,{'Shifted Data','p-value v actual data','Shuffled'})

subplot(2,2,4)
plot(dist_shift,orient_diff_all_mean(1:end-1),'b',...
    [dist_shift(1) dist_shift(end)], repmat(orient_diff_all_mean(end),1,2), 'r--')
xlabel('Registration Shift (pixels)')
ylabel('Mean Axis orientation difference (degrees)')


%% Plot the above - need to do for same session with shifting...

figure(1)
for j = 1:length(dist_shift)+1
    subplot(2,2,1)
    hold on
    [f,x] = ecdf(min_dist_all{j}*cmperbin);
    h5(j) = stairs(x,f);
    hold off
end
xlabel('Distance between PF centroids (cm)')
legend(h5,h3legend)

shuf_dist = nanmean(min_dist_shuffle);
figure(2)
subplot(2,2,1)
[ax21, h21(1), h21(2)] = plotyy(dist_shift,min_dist_all_mean(1:end-1)*cmperbin,...
    dist_shift,p_min_dist_v_actual(1:end-1)); hold on;
h21(3) = plot(dist_shift, min_dist_all_filter_mean*cmperbin,'g');
h21(4) = plot([min(dist_shift) max(dist_shift)],[shuf_dist shuf_dist],'r--'); hold off;
legend(h21,{'Unfiltered','p-value v actual data','Filtered','Shuffled'},'Location','SouthEast')
xlabel('Registration Shift (pixels)')
ylabel(ax21(1),'Mean PF Centroid Shift (cm)')
ylabel(ax21(2),'p-value')


%% Save workspace 

% save(['neuron_reg_qc_plots_workspace-' datestr(now,1)])

%% Get neuron axis ratios across all sessions

clear session

% sesh_use = ref.G45.twoenv(1) + [0 1 6 7 9 13:15]; % square sessions 
% ref.G45.twoenv(1) + [0:7 9 10 12:17]; % all sessions % 
% ref.G45.twoenv(1) + [2:5 10 12 16:17]; % octagon sessions 
sesh_use = ref.G30.two_env(1) + [0 1 6 7 8 11 12 13]; % G30 square sessions
% sesh_use = ref.G30.two_env(1) + [2 3 4 5 9 10 14 15]; % G30 octagon sessions

% Other possibilites
%ref.G45.twoenv(1) + [0:7 9 10 12:17]; % square sessions %ref.G48.twoenv(1):ref.G48.twoenv(end); % 

ChangeDirectory_NK(MD(sesh_use(1)));
base_dir = pwd;
if exist(fullfile(base_dir,'T2output.mat'),'file')
    load(fullfile(base_dir,'T2output.mat'),'NeuronImage')
    ROI_base = NeuronImage;
else
    disp('Using T1 output!!!! Update for final plots!')
    load(fullfile(base_dir,'MeanBlobs.mat'),'BinBlobs');
    ROI_base = BinBlobs;
end

% Load anc calc initial session PF info
load(fullfile(base_dir, 'PlaceMaps_rot_to_std.mat'),'TMap_gauss','pval','cmperbin');
session(1).pval = pval;
[ ~, session(1).max_FR_location ] = get_PF_centroid(TMap_gauss, 0.9, 0);
num_neurons = length(TMap_gauss);

% Get neurons that are validly mapped across all sessions
neuron_map_all_log = true(num_neurons,1);
for j = 2:length(sesh_use)
    session(j).dir = MD(sesh_use(j)).Location;
    load(fullfile(session(j).dir, 'PlaceMaps_rot_to_std.mat'),'pval','TMap_gauss','cmperbin');
    session(j).pval = pval;
    load(fullfile(base_dir,['neuron_map-' MD(sesh_use(j)).Animal '-' MD(sesh_use(j)).Date '-session' num2str(MD(sesh_use(j)).Session) '.mat']))
    [ ~, session(j).max_FR_location ] = get_PF_centroid(TMap_gauss, 0.9, 0);
    [ mapped_ROIs, valid_neurons ] = map_ROIs(neuron_map.neuron_id, [], 0 );
    num_neurons = length(neuron_map.neuron_id);
    neuron_map_use = nan(num_neurons,1);
    neuron_map_use(valid_neurons) = cell2mat(neuron_map.neuron_id(valid_neurons));
    min_dist_bymouse{j} = get_PF_centroid_diff(session(1).max_FR_location, ...
        session(j).max_FR_location, neuron_map_use,1); % get min dist for each pair
    good_neurons = pval_filter_bw_sesh( session(1).pval, session(j).pval,...
        neuron_map_use, 'filter_spec',PF_filterspec,'thresh',PF_pval_thresh);
    
    min_dist_bymouse_filter{j} = min_dist_bymouse{j}(good_neurons);
    
    % Assemble logical neuron map for all sessions to get final set of
    % neurons active across all sessions!
    temp = false(num_neurons,1);
    temp(good_neurons) = true;
    neuron_map_all_log = neuron_map_all_log & temp;
end

AllActiveMap{1} = create_AllICmask(ROI_base(neuron_map_all_log));

for j = 2:length(sesh_use)
    
    load(fullfile(base_dir,['neuron_map-' MD(sesh_use(j)).Animal '-' MD(sesh_use(j)).Date '-session' num2str(MD(sesh_use(j)).Session) '.mat']))
    ChangeDirectory_NK(MD(sesh_use(j)));
    if exist(fullfile(pwd,'T2output.mat'),'file')
        load(fullfile(pwd,'T2output.mat'),'NeuronImage')
        ROI_reg = NeuronImage;
    else
        disp('Using T1 output!!!! Update for final plots!')
        load(fullfile(pwd,'MeanBlobs.mat'),'BinBlobs');
        ROI_reg = BinBlobs;
    end
    

    load(fullfile(base_dir,['RegistrationInfo-' MD(sesh_use(j)).Animal '-' MD(sesh_use(j)).Date '-session' num2str(MD(sesh_use(j)).Session) '.mat']))
    disp('Warping reg session ROIs to base session')
    % Register all shifted neuron ROIs to base session
    resol = 1; % Percent resolution for progress bar, in this case 10%
    p = ProgressBar(100/resol);
    update_inc = round(length(ROI_reg)/(100/resol)); % Get increments for updating ProgressBar
    for ll = 1:length(ROI_reg)
        tform_use = RegistrationInfoX.tform;
        ROI_reg{ll} = imwarp(ROI_reg{ll}, tform_use,...
            'OutputView', RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
        if round(ll/update_inc) == (ll/update_inc)
            p.progress;
        end

    end
    p.stop;
    
    [ mapped_ROIs, valid_neurons ] = map_ROIs(neuron_map.neuron_id, ROI_reg );
    
    AllActiveMap{j} = create_AllICmask(mapped_ROIs(neuron_map_all_log));
    
    % Get differences between centroids, axis ratio, major axis angle
    [ cent_shift, cent_dist_shift, axratio_shift, axratio_diff_shift, orient_shift, ...
        orient_diff_shift ] = dist_bw_reg_sessions( {ROI_base(valid_neurons), ...
        mapped_ROIs(valid_neurons)} );
    
    axratio_diff_bymouse{j} = squeeze(axratio_diff_shift(1,2,:));
    orient_diff_bymouse{j} = squeeze(orient_diff_shift(1,2,:));
    
    % Get overlap info for each shift
    [overlap_ratio_temp, overlap_pixels_temp, total_pixels_temp, ~, ratio3_temp ] = ...
        reg_calc_overlap( ROI_base(valid_neurons), mapped_ROIs(valid_neurons));
    
    overlap_ratio_bymouse{j} = overlap_ratio_temp;
    
%     disp('Getting PF centroid distances')
%     session(j).dir = MD(sesh_use(j)).Location;
%     load(fullfile(session(j).dir, 'PlaceMaps_rot_to_std.mat'),'TMap_gauss','pval','cmperbin');
%     session(j).pval = pval;
%     [ ~, session(j).max_FR_location ] = get_PF_centroid(TMap_gauss, 0.9, 0);
%     %%% Get PF stats
%     num_neurons = length(neuron_map.neuron_id);
%     neuron_map_use = nan(num_neurons,1);
%     neuron_map_use(valid_neurons) = cell2mat(neuron_map.neuron_id(valid_neurons));
%     min_dist_bymouse{j} = get_PF_centroid_diff(session(1).max_FR_location, ...
%         session(j).max_FR_location, neuron_map_use,1); % get min dist for each pair
%     
%     % Filter cells
%     good_neurons = pval_filter_bw_sesh( session(1).pval, session(j).pval,...
%         neuron_map_use, 'filter_spec',PF_filterspec,'thresh',PF_pval_thresh);
%     
    
    
end

% Save the above
cd(base_dir)
save neuron_qc_bymouse axratio_diff_bymouse orient_diff_bymouse ...
    overlap_ratio_bymouse axratio_diff_all orient_diff_all overlap_ratio_all ...
    min_dist_bymouse min_dist_bymouse_filter

%% Plot the above
figure(3)
for j = 2:16
   subplot(2,2,1)
   hold on
   ecdf(axratio_diff_bymouse{j});
   hold off
   
   subplot(2,2,2)
   hold on
   ecdf(overlap_ratio_bymouse{j});
   hold off
   
   subplot(2,2,3)
   hold on
   ecdf(orient_diff_bymouse{j});
   hold off
   
   
end

plot_legend = arrayfun(@(a) [mouse_name_title(a.Date) ' - ' num2str(a.Session)], ...
    MD(sesh_use(2:end)),'UniformOutput',0);

% Add in shuffled values, axis titles, and legends
subplot(2,2,1)
hold on
[f, x] = ecdf(axratio_diff_all{end});
h31s = stairs(x,f);
hold off
set(h31s,'LineStyle','--')
xlabel('Axis ratio difference')
legend({plot_legend{:} 'Shuffled'})

subplot(2,2,2)
xlabel('Overlap ratio')
legend(plot_legend)

subplot(2,2,3)
hold on
[f, x] =  ecdf(orient_diff_all{end});
h33s = stairs(x,f);
set(h33s,'LineStyle','--')
hold off
xlabel('Orientation difference (degrees)')
legend({plot_legend{:} 'Shuffled'})


%% Aggregate results across mice
sessions_plot = 1:3;
compare_type = 1:2; % 1 = same session, 2 = session 1 to session 2
compare_str = {'samesession', 'session1_session2'};
color_spec = {'r', 'b', 'g', 'y'};

for k = compare_type
    % Dump everything into one variable
    
    clear agg_session test
    for j = sessions_plot
        
        temp = load(fullfile(MD(session_ref(j)).Location,['neuron_qc_plots_' compare_str{compare_type(k)} '_shifted.mat']),...
            'dist_shift','min_dist_all','min_dist_all_filter','cent_dist_all',...
            'axratio_diff_all','orient_diff_all','overlap_ratio_all', 'min_dist_all_mean','min_dist_all_filter_mean',...
            'cent_dist_all_mean','axratio_diff_all_mean','orient_diff_all_mean');
        agg_session(j) = temp;
        test(j).overlap_ratio_all_mean = cellfun(@nanmean, temp.overlap_ratio_all);
        
    end
    
    [agg_session.overlap_ratio_all_mean] = deal(test.overlap_ratio_all_mean);
    
    aratio_shuf_plot = mean(arrayfun(@(a) a.axratio_diff_all_mean(end), agg_session));
    orient_shuf_plot = mean(arrayfun(@(a) a.orient_diff_all_mean(end), agg_session));
    min_dist_shuf_plot = mean(arrayfun(@(a) a.min_dist_all_mean(end), agg_session));
    
    % Run through and plot everything on one graph
    
    figure(545)
    for j = sessions_plot
        
        % Plot distance between PF centroids
        hh{1}(k) = subplot(4,2,k);
        hold on;
        plot(agg_session(j).dist_shift,agg_session(j).min_dist_all_filter_mean)
        if j == max(sessions_plot)
            plot(agg_session(j).dist_shift([1, end]), [min_dist_shuf_plot, min_dist_shuf_plot], 'k--')
        end
        hold off;
        xlabel('Distance shifted (pixels)');
        ylabel('PF centroid distance (cm)');
        
        % Plot overlap ratios
        hh{2}(k) = subplot(4,2,k+2);
        hold on;
        plot(agg_session(j).dist_shift,agg_session(j).overlap_ratio_all_mean)
        hold off;
        xlabel('Distance shifted (pixels)');
        ylabel('Neuron ROI overlap ratio');
        
        % Plot overlap ratios
        hh{3}(k) = subplot(4,2,k+4);
        hold on;
        plot(agg_session(j).dist_shift,agg_session(j).axratio_diff_all_mean(1:end-1))
        if j == max(sessions_plot)
            plot(agg_session(j).dist_shift([1, end]), [aratio_shuf_plot, aratio_shuf_plot], 'k--')
        end
        hold off;
        xlabel('Distance shifted (pixels)');
        ylabel('Neuron axis ratio (shape) difference');
        
        % Plot overlap ratios
        hh{4}(k) = subplot(4,2,k+6);
        hold on;
        plot(agg_session(j).dist_shift,agg_session(j).orient_diff_all_mean(1:end-1))
        if j == max(sessions_plot)
            plot(agg_session(j).dist_shift([1, end]), [orient_shuf_plot, orient_shuf_plot], 'k--')
        end
        hold off;
        xlabel('Distance shifted (pixels)');
        ylabel('Neuron Orientation Difference (radians)');
        
        
    end
    
    % Add legends and titles
    for j = 1:4
        subplot(4,2,(j-1)*2+k)
        legend(arrayfun(@(a) ['Mouse ' num2str(a)],sessions_plot,'UniformOutput',0))
        if j == 1
            title(mouse_name_title(compare_str{k}))
        end
    end

end

for j = 1:4
    linkaxes(hh{j},'y')
end

%% Figure 1: PF centroid distance and Aratio diff for shifted for one mouse,
% Then aratio diff for actual sessions for one mouse, then mean (with
% pvalue) of PF centroid diff OR all mice combined for PF centroid shift?

mouse_use = 1; 
% sesh_use = ref.G45.twoenv(1) + [2:5 10 12 16:17]; % octagon sessions 
% ref.G45.twoenv(1) + [0 1 6 7 9 13:15]; % square sessions 
% ref.G45.twoenv(1) + [0:7 9 10 12:17]; % all sessions % 
sesh_use = ref.G30.two_env(1) + [0 1 6 7 8 11 12 13]; % G30 square sessions
% sesh_use = ref.G30.two_env(1) + [2 3 4 5 9 10 14 15]; % G30 octagon sessions
PF_plots_use = 2:length(sesh_use); %[2 7 8 9 12 13 14]; %[7 9 12 14];

load(fullfile(MD(session_ref(mouse_use)).Location,'neuron_qc_plots_session1_session2_shifted.mat'));
load(fullfile(MD(sesh_use(1)).Location,'neuron_qc_bymouse.mat'));

% Define Plot legends for below
h2legend = arrayfun(@(a) [num2str(a) ' pixels'],dist_shift,'UniformOutput',0);
h3legend = h2legend;
h3legend{length(h2legend) + 1} = 'Shuffled';
% plot_legend = arrayfun(@(a) [mouse_name_title(a.Date) ' - ' num2str(a.Session)], ...
%     MD(sesh_use(2:end)),'UniformOutput',0);
plot_legend = {'Same Day','1 Day: Session 1','1 Day: Session 2','3 Days', ...
    '4 Days', '5 Days: Session 1', '5 Days: Session 2'};

figure(560)
shift_to_plot = [1:7, 12]; % 0-6 + shuffle % [1:2:7, 12]; % 0 2 4 6 shuffle % 
n = 1;
clear hf1 hf3
for j = shift_to_plot % 1:length(dist_shift)+1
    
    % Shifted PF centroid distance distances
    subplot(2,2,3)
    hold on
    [f,x] = ecdf(min_dist_all{j}*cmperbin);
    hf1(n) = stairs(x,f);
    hold off
    
    % Shifted axis orientation differences
    subplot(2,2,1);
    hold on;
    [f,x] = ecdf(orient_diff_all{j});
    hf3(n) = stairs(x,f);
    hold off
    
    n = n + 1;
    
end

subplot(2,2,3)
set(hf1(end),'LineStyle','--')
xlabel('Distance between PF centroids (cm)')
ylabel('Cumulative Proportion')
legend(hf1,h3legend(shift_to_plot))
% title('Day 1: Session 1 to Session 2 with Image Reg. Shifted')
title('Shifted Transformation')

subplot(2,2,1)
set(hf3(end),'LineStyle','--')
xlabel('Orientation difference (degrees)')
ylabel('Cumulative Proportion')
legend(hf3,h3legend(shift_to_plot))
% title('Day 1: Session 1 to Session 2 with Image Reg. Shifted')
title('Shifted Transformation')

% Plot axis orientation difference for all sessions
for j = 2:length(orient_diff_bymouse)
    subplot(2,2,2)
    hold on
    ecdf(orient_diff_bymouse{j});
    hold off
    
    % Play with 'defaultAxesColorOrder' or set(gca,'ColorOrder') to get a
    % better idea of which sessions are which!!!
    subplot(2,2,4)
    hold on
    if ismember(j,PF_plots_use)
        set(gca,'LineStyleOrder','-')
        ecdf(min_dist_bymouse_filter{j})
    else
%         set(gca,'LineStyleOrder',':')
    end
    hold off
end

subplot(2,2,2)
hold on
[f, x] =  ecdf(orient_diff_shuffle);
hf4 = stairs(x,f);
set(hf4,'LineStyle','--')
hold off
xlabel('Orientation difference (degrees)')
ylabel('Cumulative Proportion')
legend({plot_legend{:} 'Shuffled'})
% title('8/28/2015 Session 1 to multiple other sessions')
title('Multiple Days')

subplot(2,2,4)
hold on
[f, x] =  ecdf(min_dist_shuffle);
hf2 = stairs(x,f);
set(hf2,'LineStyle','--')
hold off
xlabel('Distance between PF centroids (cm)')
ylabel('Cumulative Proportion')
% legend({plot_legend{:} 'Shuffled'})
legend({plot_legend{PF_plots_use-1} 'Shuffled'})
% title('8/28/2015 Session 1 to multiple other sessions')
title('Multiple Days')

% Get stats for above vs. shuffled
p_cutoff = 1e-15; % p-value cutoff for good registrations (vs. shuffled reg) for orientation difference
[h_os, p_os, ksstat_os] = cellfun(@(a) kstest2(orient_diff_shuffle,a,'alpha',p_cutoff),orient_diff_all(shift_to_plot)); % Shifted ROI orientation diff vs. shuffle
[h_ds, p_ds, ksstat_ds] = cellfun(@(a) kstest2(min_dist_shuffle,a),min_dist_all(shift_to_plot)); % Shifted PF distance vs. shuffle
[h_o, p_o, ksstat_o] = cellfun(@(a) kstest2(orient_diff_shuffle,a,'alpha',p_cutoff),orient_diff_bymouse(2:end)); % Actual ROI orientataion diff vs. shuffle
[h_d, p_d, ksstat_d] = cellfun(@(a) kstest2(min_dist_shuffle,a),min_dist_bymouse_filter(2:end)); % Actual PF distance vs. shuffle

%%% This plots only the lines for the first and last two registered
%%% sessions for clarity.
% for j = [2 3 15 16]
%     subplot(2,2,2)
%     hold on
%     ecdf(orient_diff_bymouse{j});
%     hold off
% end
% hold on
% [f, x] =  ecdf(orient_diff_all{end});
% hf2 = stairs(x,f);
% set(hf2,'LineStyle','--')
% hold off
% xlabel('Orientation difference (degrees)')
% legend({plot_legend{[1 2 14 15]} 'Shuffled'})

%%% Get neurons active in EVERY session

%% Run Ziv style reg for all neurons
% sesh_use = ref.G30.two_env(1) + [0 1 6 7 8 11 12 13]; % G30 square sessions
sesh_use = ref.G31.two_env(1) + [2 3 4 5 9 10 14 15]; % G31 octagon sessions
% sesh_use = ref.G48.twoenv(1) + [0 1 6 7 8 11 12 13]; % G48 square sessions
% sesh_use = ref.G45.twoenv(1) + [2:5 10 12 16:17]; % octagon sessions 
% ref.G45.twoenv(1) + [0 1 6 7 9 13:15]; % square sessions 
% ref.G45.twoenv(1) + [0:7 9 10 12:17]; % all sessions % 

phi_diff = nan(length(sesh_use),1);
xy_diff = nan(length(sesh_use),2);
dist_neurons = cell(1,length(sesh_use));

figure(50)
dirstr = ChangeDirectory_NK(MD(sesh_use(1)),0);
for j = 2:length(sesh_use)
    disp(['Calculating Neuron v min projection reg diff for session ' num2str(j)])
    mouse_name = MD(sesh_use(j)).Animal;
    reg_date = MD(sesh_use(j)).Date;
    reg_session = MD(sesh_use(j)).Session;
    regfile = fullfile(dirstr,['RegistrationInfo-' mouse_name '-' reg_date '-session' ...
        num2str(reg_session) '.mat']);
    regfile_byneurons = fullfile(dirstr,['RegistrationInfo-' mouse_name '-' reg_date '-session' ...
        num2str(reg_session) '_regbyallactive.mat']);
    reginfo = importdata(regfile);
    reginfo_byactive = importdata(regfile_byneurons);
    
    tform_diff = reginfo.tform.T-reginfo_byactive.tform.T;
    phi = acosd(reginfo.tform.T(1,1));
    phi_byneurons = acosd(reginfo_byactive.tform.T(1,1));
    phi_diff(j) = phi-phi_byneurons;
    xy_diff(j,:) = reginfo.tform.T(3,[1 2]) - reginfo_byactive.tform.T(3,[1 2]);
    
    % ok, the best thing to do would be to take all the neurons masks from each
    % session, have them go through each transformation, and then compare their
    % distances from one another in the end to see how far off they were
    regstr = ChangeDirectory_NK(MD(sesh_use(j)),0);
    load(fullfile(regstr,'MeanBlobs.mat'),'BinBlobs');
    
    ROI_warp1 = cellfun(@(a) imwarp_quick(a,reginfo),BinBlobs,'UniformOutput',0);
    ROI_warp2 = cellfun(@(a) imwarp_quick(a,reginfo_byactive),BinBlobs,'UniformOutput',0);
    subplot(3,3,j)
    allROI1 = create_AllICmask(ROI_warp1);
    allROI2 = create_AllICmask(ROI_warp2);
    imagesc(allROI1 + allROI2);
    
    dist_temp = nan(length(ROI_warp1),1);
    for k = 1:length(ROI_warp1)
        cent1 = regionprops(ROI_warp1{k},'Centroid');
        cent2 = regionprops(ROI_warp2{k},'Centroid');
        if  length(cent1) ~= 1 || length(cent2) ~= 1% If registration moves the ROI off the edge of the screen, skip below
            continue
        end
        cent_diff = cent1.Centroid - cent2.Centroid; 
        dist_temp(k) = sqrt(cent_diff(1).^2 + cent_diff(2).^2);
    end
    dist_neurons{j} = dist_temp;
end

dist_diff_rough = sqrt(xy_diff(:,1).^2 + xy_diff(:,2).^2);

mu = nanmean(cat(1,dist_neurons{:}));
rho = nanstd(cat(1,dist_neurons{:}));

