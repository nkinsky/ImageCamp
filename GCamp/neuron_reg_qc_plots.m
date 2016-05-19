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

base_sesh_index = ref.G45.twoenv(1)+2; % Specify the base 2env session to use
base_sesh = MD(base_sesh_index);
% Session references:
% ref.G30.two_env(1) - good
% ref.G45.twoenv(1) - ok, but remaps between session 1 and session 2
% ref.G31.two_env(1) + 2 - good, the square remaps between sessions

PF_filterspec = 4; % 3 = use only neurons with a valid PF in BOTH session, 4 = either session
PF_pval_thresh = 0.05; % pval threshold on spatial information for filtering out neurons
num_shuffles = 100;
reg_self = 0; % 0 = register to next session indicated below, 1 = register session to itself
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
    dist_shift = 0:10; % Number of pixels to shift
    angle_shift = 0:pi/4:2*pi-0.05; % Angles to shift
elseif fine_res == 1
    dist_shift = [0, 2:0.2:3, 10];
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
            shift_map = image_register_simple( session(1).Animal, session(1).Date,...
                session(1).Session, session(2).Date, session(2).Session, 0, ...
                'add_jitter', shift_mat, ['_shift_' num2str(dist_shift(j)) 'pix_' num2str(k)]);
            
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
        [f,x] = ecdf(cent_dist_all{j});
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
xlabel('Distance between centroids (pixels)')
legend(h2,h2legend)
    
h3legend = h2legend;
h3legend{length(h2legend) + 1} = 'Shuffled';
subplot(2,2,3)
% h = get(gca,'Children'); % Get line handles
xlabel('Axis ratio difference')
legend(h3,h3legend)

subplot(2,2,4)
% h = get(gca,'Children'); % Get line handles
xlabel('Axis orientation difference (radians)')
legend(h4,h3legend)


%% Plot the mean values of the above
figure(2) 

% Get the mean value for each
cent_dist_all_mean = cellfun(@(a) nanmean(a), cent_dist_all);
axratio_diff_all_mean = cellfun(@(a) nanmean(abs(a)), axratio_diff_all);
orient_diff_all_mean = cellfun(@(a) nanmean(abs(a)), orient_diff_all);

% subplot(2,2,1)
% plot(dist_shift,cent_dist_all_mean(1:end-1),'b',...
%     [dist_shift(1) dist_shift(end)], repmat(cent_dist_all_mean(end),1,2), 'r--')
% xlabel('Registration Shift (pixels)')
% ylabel('Distance b/w Neuron ROI centroids (pixels)') 

subplot(2,2,2)
plot(dist_shift,cent_dist_all_mean(1:end-1),'b')
xlabel('Registration Shift (pixels)')
ylabel('Mean Distance b/w Neuron ROI centroids (pixels')

subplot(2,2,3)
[ax22, h22(1), h22(2)] = plotyy(dist_shift,axratio_diff_all_mean(1:end-1),...
    dist_shift, p_axratio_v_actual(1:end-1)); hold on;
h22(3) = plot([dist_shift(1) dist_shift(end)], repmat(axratio_diff_all_mean(end),1,2), 'r--');
hold off
% plot(dist_shift,axratio_diff_all_mean(1:end-1),'b',...
%     [dist_shift(1) dist_shift(end)], repmat(axratio_diff_all_mean(end),1,2), 'r--')
xlabel('Registration Shift (pixels)')
ylabel(ax22(1),'Mean Axis ratio difference')
ylabel(ax22(2),'p-value')
legend(h22,{'Shifted Data','p-value v actual data','Shuffled'})

subplot(2,2,4)
plot(dist_shift,orient_diff_all_mean(1:end-1),'b',...
    [dist_shift(1) dist_shift(end)], repmat(orient_diff_all_mean(end),1,2), 'r--')
xlabel('Registration Shift (pixels)')
ylabel('Mean Axis orientation difference (radians)')



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
