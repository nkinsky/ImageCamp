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

clear all
close all

%% Step 0 overall: Set base sessions

% For Part 2 - set file to do comparisons on.  Might want to make this
% multiple different files/animals later
base_reg_file = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working\RegistrationInfo-GCamp6f_30-11_19_2014-session2.mat';
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

dist_shift = 0:10; % Number of pixels to shift
angle_shift = 0:pi/4:2*pi; % Angles to shift

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


% Initialize variables to track differences in centroid location, axis
% ratio, and axis orientation
cent_dist_all = cell(1,length(dist_shift));
axratio_diff_all = cell(1,length(dist_shift));
orient_diff_all = cell(1,length(dist_shift));

cent_dist_all{1} = squeeze(cent_dist_actual(1,2,:));
axratio_diff_all{1} = squeeze(ratio_diff_actual(1,2,:));
orient_diff_all{1} = squeeze(orient_diff_actual(1,2,:));
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
            
            % Register all shifted neuron ROIs to base session
            p = ProgressBar(length(session(2).NeuronROI));
            ROI_shift = cell(size(session(2).NeuronROI));
            for ll = 1:length(session(2).NeuronROI)
                tform_use = reginfo.tform;
                tform_use.T = tform_use.T*shift_mat;
                ROI_shift{ll} = imwarp(session(2).NeuronROI{ll}, tform_use,...
                    'OutputView', reginfo.base_ref,'InterpolationMethod','nearest');
                p.progress;
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
        end
        
    end
end

% Get shuffled values
cent_dist_shuffle = [];
ratio_diff_shuffle = [];
orient_diff_shuffle = [];
disp('Getting shuffled centroid distances, axis ratio differences, and orientation differences')
for j = 1:1000
    [ ~, cent_dist_temp, ~, ratio_diff_temp, ~, orient_diff_temp ] = ...
        dist_bw_reg_sessions( {session(1).NeuronROI(valid_neurons_actual), ...
        mapped_ROIs_actual(valid_neurons_actual)},1 );
    cent_dist_shuffle = cat(1,cent_dist_shuffle, cent_dist_temp);
    ratio_diff_shuffle = cat(1,ratio_diff_shuffle, ratio_diff_temp);
    orient_diff_shuffle = cat(1,orient_diff_shuffle, orient_diff_temp);

end

% Put shuffled values into the same cell arrays as the rest for ease of
% plotting
num_dist = length(dist_shift);
cent_dist_all{num_dist+1} = cent_dist_shuffle;
ratio_diff_all{num_dist+1} = ratio_diff_shuffle;
orient_diff_all{num_dist+1} = orient_diff_shuffle;

%% Plot the above
figure(1)
for j = 1:length(dist_shift)+1
    subplot(2,2,1)
    hold on;
    ecdf(cent_dist_all{j});
    hold off
    
    subplot(2,2,2)
    hold on;
    ecdf(ratio_diff_all{j});
    hold off
    
    subplot(2,2,3)
    hold on;
    ecdf(orient_diff_all{j});
    hold off
    
end

figure(1)
subplot(2,2,1)
xlabel('Distance between centroids (pixels)')
% legend(

subplot(2,2,2)
xlabel('Axis ratio difference')

subplot(2,2,3)
xlabel('Axis orientation difference (radians)')


%% P2 - Step 3: Get differences between PF centroids


% disp('Getting distances between PF centroids for all sessions')
% min_dist_temp = cell(num_sessions,num_sessions);
% for j = 1:num_sessions-1
%     for k = j + 1: num_sessions
%         map_use = get_neuronmap_from_batchmap(batch_session_map.map,j,k);
%         min_dist_temp{j,k} = get_PF_centroid_diff(PFcentroid_use{j}, ...
%             PFcentroid_use{k}, map_use,1);
%     end
% end

%% Save workspace 

% save(['neuron_reg_qc_plots_workspace-' datestr(now,1)])
