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

%% Step 0 overall: Set base sessions

% For Part 2 - set file to do comparisons on.  Might want to make this
% multiple different files/animals later
base_reg_file = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working\RegistrationInfo-GCamp6f_30-11_19_2014-session2.mat';
reginfo = importdata(base_reg_file);

base_session.Animal = reginfo.mouse;
base_session.Date = reginfo.base_date;
base_session.Session = reginfo.base_session;
base_session.dir = ChangeDirectory_NK(base_session,0);

reg_session.Animal = reginfo.mouse;
reg_session.Date = reginfo.register_date;
reg_session.Session = reginfo.register_session;
reg_session.dir = ChangeDirectory_NK(reg_session,0);

%% P2 - Step 1: Generate Intentionally shifted image registration transforms
% shift 1 - 10 pixels, each at 45 degree angles (8 total shifts per
% registration)

dist_shift = 1:10; % Number of pixels to shift
angle_shift = 0:pi/4:2*pi; % Angles to shift

reg_dir = ChangeDirectory_NK(reg_session,0);

% Load Neuron ROIs for each session
load(fullfile(base_session.dir,'ProcOut.mat'),'NeuronImage');
base_session.dir = NeuronImage;
load(fullfile(reg_session.dir,'ProcOut.mat'),'NeuronImage');
reg_session.dir = NeuronImage;

for j = 1:length(dist_shift)
    dist_use = dist_shift(j);
    for k = 1:length(angle_shift)
        
        % First, generate the shift matrix
        angle_use = angle_shift(k);
        shift_mat = [1 0 0 ; 0 1 0 ; dist_use*cos(angle_use)...
            dist_use*sin(angle_use) 1];
        
        % Next, get the neuron mapping for each shift
        neuron_map(:,j,k) = image_register_simple( base_session.Animal, base_session.Date,...
            base_session.Session, reg_session.Date, reg_session.Session, 0, ...
            'add_jitter', shift_mat,['_shift_' num2str(dist_shift(j)) 'pix_' num2str(k)]);
        
        % Register all neuron ROIs to base session
        imwarp(BinBlobs_temp{j}{k},tform_use(j).tform,...
                'OutputView',tform_use(j).base_ref,'InterpolationMethod','nearest');
        
        % Get differences between centroids, axis ratio, major axis angle
        [ neuron_cm, cm_dist, neuron_axisratio, ratio_diff, neuron_orientation, ...
            orientation_diff ] = dist_bw_reg_sessions( BinBlobs_reg );
        
        
    end
end


%% P2 - Step 2: Get differences between centroids, axis ratio, major axis angle
[ neuron_cm, cm_dist, neuron_axisratio, ratio_diff, neuron_orientation, ...
    orientation_diff ] = dist_bw_reg_sessions( BinBlobs_reg );
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
