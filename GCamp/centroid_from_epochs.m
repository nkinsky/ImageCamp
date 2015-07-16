function [ activations ] = centroid_from_epochs( epoch_use, FT, TMap, Tcent_cm, varargin)
%[ epoch_w_cents ] = centroid_from_epochs( epoch, FT, Tcent_cm,...)
%   Determines if, during active frames defined in epoch variable, each
%   cell in FT is active, and if it is, spits out the centroid of its
%   coordinates into activations as well as summing up the TMap values...
%
%   INPUTS
%       epoch_use: a structure with fields "start" and "end" which denote the
%       beginning and ending frames for occupancy in each section of the maze
%
%       FT: from PlaceMaps.mat, needs to match frames in epoch_use
%
%       TMap: from PlaceMaps.mat - heatmaps of all cells with valid
%       placefields, cell ID matches rows in FT
%       
%       Tcent_cm: centroids of all cells identified in FT
%
%       Optional: specify 'exclude', section_bounds, TPixelList to exclude
%       activations from all cells whose placefield are within section
%       bounds.  section_bounds and TPixelList must have the same
%       coordinate reference frame to work properly
%
%   OUTPUTS
%       activations: contains the following:
%           - AllTMap: sum of all the TMaps for the active frames in the
%           epoch_use variable
%           - AllTMap_bin: same as AllTMap but unweighted, i.e. every TMap
%           is 0 in areas not active, and 1 in areas that are active
%           - AllTMap_bin_out: same as AllTMap_bin but only includes cells
%           whose placefield do not extend into the exlcluded area. NaN if
%           no excluded section is specified
%           - AllTcent_cm: centroids of the active place-fields for the
%           given epochs


AllTMap = zeros(size(TMap{1})); % set up TMap
AllTMap_bin = AllTMap; % set up binary TMap (0 = no activation, 1 = activation)
AllTMap_bin_out = AllTMap;
AllTcent_cm = [];
% keyboard

%% Get varagin into usable form

if strcmpi(varargin{1},'exclude')
    exclude = 1;
    section_bounds = varargin{2};
    TPixelList = varargin{3};
else
    exclude = 0;
end

% keyboard
%% Meat of the function
n_frames = 0;
for j = 1:length(epoch_use)
   frames_use = epoch_use(j).start:epoch_use(j).end; % Get frames to use for a given epoch
   n_frames = n_frames + length(frames_use); % Total number of frames in whole epoch
   FT_epoch = FT(:,frames_use); % Pull only valid frames from FT
   activity_wt = sum(FT_epoch,2); % Sum up activity of cells
   
   active_cells = find(activity_wt ~= 0); % Get indices for active cells
   
   epoch_TMap = zeros(size(TMap{1}));
   epoch_TMap_bin = epoch_TMap;
   epoch_TMap_bin_out = epoch_TMap;
   epoch_Tcent_cm = [];
   for k = 1:length(active_cells)
       % Sum up TMap of each cell multiplied by number of activations in
       % an epoch
       epoch_TMap(:) = nansum([epoch_TMap(:) activity_wt(active_cells(k))*TMap{active_cells(k)}(:)],2);
       % Same thing for binary TMap
       TMap_bin = make_binary_TMap(TMap{active_cells(k)});
       epoch_TMap_bin(:) = nansum([epoch_TMap_bin(:) activity_wt(active_cells(k))*TMap_bin(:)],2);
       
       % List centroids of each active cell
       epoch_Tcent_cm(k,1:2) = Tcent_cm(active_cells(k),:);
       % Put in something here to exclude cells whose TMaps extend into the
       % location of the mouse... THIS DOES NOT APPEAR TO BE WORKING
       % YET!!!! fields in the area we are looking at are included!!!
       if exclude == 1 && ~isempty(TPixelList{active_cells(k)})
          temp2 = inpolygon(TPixelList{active_cells(k)}(:,1),...
              TPixelList{active_cells(k)}(:,2), section_bounds.x,...
              section_bounds.y);
          if sum(temp2) == 0 % Include in AllTMap_out only if no pixels from the TMap are in the excluded section
              epoch_TMap_bin_out(:) = nansum([epoch_TMap_bin_out(:) ...
                  activity_wt(active_cells(k))*TMap_bin(:)],2);
          end
       else
           epoch_TMap_bin_out = nan(size(TMap{1}));
       end
       
       
       epoch_Tcent_cm(k,3) = activity_wt(active_cells(k)); % Get number of times active
   end
   
   AllTMap(:) = nansum([AllTMap(:) epoch_TMap(:)],2); % Combine each epochs active TMaps into an overall set
   AllTMap_bin(:) = nansum([AllTMap_bin(:) epoch_TMap_bin(:)],2); % Combine each epochs active TMaps into an overall set
   AllTMap_bin_out(:) = nansum([AllTMap_bin_out(:) epoch_TMap_bin_out(:)],2); % Combine each epochs active TMaps into an overall set
   AllTcent_cm = [AllTcent_cm ; epoch_Tcent_cm];
   
end


%% Dump into activations variable
activations.AllTMap = AllTMap;
activations.AllTMap_bin = AllTMap_bin;
activations.AllTMap_bin_out = AllTMap_bin_out;
activations.AllTcent_cm = AllTcent_cm;
activations.n_frames = n_frames;

% keyboard

end

