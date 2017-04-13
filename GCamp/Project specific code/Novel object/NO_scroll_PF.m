function [ ] = NO_scroll_PF( sesh1_struct, other_structs, start_cell )
% NO_scroll_PF( sesh1_struct, other_structs, start_cell )
%   sesh1_struct is the first (habituation) day of a given experiment and
%   should be entered as MD(#).
%   other_structs are the 3 testing days for the same experiment.

if nargin < 3
    start_cell = 1;
end

sesh = cat(2,sesh1_struct, other_structs);
num_sessions = length(sesh);

aviSR = 30.0003;
%% Load Placefields for each session
curr_dir = cd;
for j = 1:num_sessions
   [dirstr, sesh_full] = ChangeDirectory_NK(sesh(j),1);
   load(fullfile(dirstr,'Placefields.mat'),'TMap_gauss','RunOccMap','PSAbool','isrunning','x','y');
   sesh(j).TMap_gauss = TMap_gauss;
   sesh(j).ZeroMap = nan(size(RunOccMap));
   sesh(j).ZeroMap(RunOccMap ~= 0) = 0;
   sesh(j).PSAbool = PSAbool;
   sesh(j).x = x;
   sesh(j).y = y;
   sesh(j).isrunning = isrunning;
   load(fullfile(dirstr,'FinalOutput.mat'),'PSAbool')
   [~,~,~,~,~,~,sesh(j).AVItime] = AlignImagingToTracking(sesh_full.Pix2CM,...
       PSAbool,0); % Get aviTimes corresponding to PSAbool in Placefields.mat
   pos_dir = fullfile(fileparts(dirstr),'cineplex');
   avi_file = ls(fullfile(pos_dir, '*.avi'));
   avi_file = fullfile(pos_dir, avi_file);
   vidObj = VideoReader(avi_file);
   sesh(j).arena_frame = readFrame(vidObj);
   load(fullfile(dirstr,'Pos.mat'),'xAVI','yAVI','AVItime_interp','time_interp');
   sesh(j).xAVI = xAVI;
   sesh(j).yAVI = yAVI;
end
cd(curr_dir);

% Load batch map
base_dir = ChangeDirectory_NK(sesh(1),0);
load(fullfile(base_dir,'batch_session_map.mat'));

NumNeurons = size(batch_session_map.map,1);

%% Plot them out

n = start_cell;
stay_in = true;
while stay_in
    for j = 1:num_sessions
        neuron_use = batch_session_map.map(n,j+1);
        
        subplot(2,4,j)
        if ~isnan(neuron_use) && neuron_use ~= 0
            imagesc_nan(rot90(sesh(j).TMap_gauss{neuron_use},1));
            title([mouse_name_title(sesh(j).Date) ' - neuron ' num2str(neuron_use)])
        elseif neuron_use == 0
            imagesc_nan(rot90(sesh(j).ZeroMap,1));
            title([mouse_name_title(sesh(j).Date) ' - Neuron not active'])
        elseif isnan(neuron_use)
            imagesc_nan(rot90(nan(size(sesh(j).ZeroMap)),1));
            title([mouse_name_title(sesh(j).Date) ' - Ambiguous neuron identity'])
        end
        
        good_ind = find(sesh(j).isrunning); % get indices where the mouse was active
        if ~isnan(neuron_use) && neuron_use ~= 0
            PSAbool_ind = sesh(j).PSAbool(neuron_use,:); % get PS epochs for a given neuron
            PSA_ind_full = good_ind(PSAbool_ind); % get PS epochs for full session (not speed thresholded)
%             PSA_AVItime = AVItime_interp(PSA_ind_full); % get PS epochs in PSAtime
            PSA_AVItime = sesh(j).AVItime(PSA_ind_full);
            AVI_time_full = (1:1:length(sesh(j).xAVI))/aviSR; % get AVI times for full session
            PSA_AVIind = arrayfun(@(a) findclosest(a,AVI_time_full),PSA_AVItime); % get putative-spiking AVI indices
        else
            PSA_AVIind = [];
            PSAbool_ind = [];
        end
        
        subplot(2,4,4+j)
        imagesc(flipud(sesh(j).arena_frame))
        hold on
        plot(sesh(j).xAVI,sesh(j).yAVI,'b',sesh(j).xAVI(PSA_AVIind),sesh(j).yAVI(PSA_AVIind),'r.')
        set(gca,'YDir','normal')
        hold off
        
%         subplot(3,4,8+j)
%         plot(sesh(j).x, sesh(j).y, 'b', sesh(j).x(PSAbool_ind), ...
%             sesh(j).y(PSAbool_ind), 'r.')
        
%         keyboard
    
    end
    [n, stay_in] = LR_cycle(n,[1 NumNeurons]);
end


end

