function [ COM_map ] = COM_register( COM1, COM2, BinBlobs1, BinBlobs2 )
% COM_map = COM_register( COM1, COM2 )
%   Registers all the neurons in COM2 (session 2) to those in COM2 (session 
%   1).  
%   
%   COM1 and COM2 are lists of x,y coordinates for the center-of-masses of 
%   each neuron mask in sessions 1 and 2.
%
%   BinBlobs1 and BinBlobs2 are cell arrays of mean blob masks, all
%   registered to the same reference session.  Used to disambiguate
%   situations where multiple in session1 map to the same neuron in
%   session2.

%% Magic Numbers
% Pixel threshold - maximum distance neurons can be apart to be considered 
% the same.  Only applies if closest neuron exceeds this distance.
min_thresh = 10; 

%% Calculate distances faster hopefully
num_neuron1 = size(COM1,1);
num_neuron2 = size(COM2,1);

cm_dist = 100*ones(num_neuron1,num_neuron2); % Set all values to arbitrarily large distances to start.
for j = 1:num_neuron1
    % Get euclidean distance from all neurons in COM2 to neuron j in COM1
    temp = sqrt(sum((COM2 - repmat(COM1(j,:),num_neuron2,1)).^2,2));
    cm_dist(j,:) = temp';
end

%% Register each neuron from session 2 to session 1 by choosing the closest

cm_dist_min = min(cm_dist,[],2); % Get minimum distance to nearest neighbor for all cells

n = 0;
COM_map = zeros(size(COM1,1),1);
for j = 1:length(cm_dist_min)
    % Exclude any neurons whose cms are outside the distance threshold or
    % whose cms reside at 0,0 (meaning that they have disappeared due to
    % registtration)
    if isnan(cm_dist_min(j)) || (~isnan(cm_dist_min(j)) && cm_dist_min(j) > min_thresh || (COM1(j,1) == 0 && COM1(j,2) == 0))
        COM_map(j,1) = nan;
        n = n+1;
    else
        COM_map(j,1) = find(cm_dist_min(j) == cm_dist(j,:));
    end
    
end

%% Separate out neurons in session 1 that have the same closest neuron in session 2
% using BinBlobs

if exist('BinBlobs1','var') && exist('BinBlobs2','var')

    % Initialize same_neuron variable
    same_neuron = zeros(num_neuron1,num_neuron2);
    COM_map_nan = COM_map;
    for j = 1:num_neuron2
        % Find cases where more than one neuron in the 1st session maps to
        % the same neuron in the second session
        try % Debugging!
            same_ind = find(COM_map == j);
        catch
            disp('error')
            keyboard
        end
        if length(same_ind) > 1
            %         keyboard
            overlap_ratio = zeros(1,length(same_ind)); % Pre-allocate
            for k = 1:length(same_ind)
                % Note neurons in the 1st session that map to the same cell
                % in the 2nd session and set their values to NaN in the
                % COM_map variable
                same_neuron(same_ind(k),j) = 1;
                COM_map_nan(same_ind(k)) = nan;
                % Calculate overlapping pixels
                overlap_pixels = sum(BinBlobs1{same_ind(k)}(:) & ...
                    BinBlobs2{j}(:));
                total_pixels = sum(BinBlobs1{same_ind(k)}(:) | ...
                    BinBlobs2{j}(:));
                %             min_neuron_size = min([sum(BinBlobs1{same_ind(k)}(:)) ...
                %                 sum(BinBlobs2{j}(:))]);
                %             overlap_ratio(k) = overlap_pixels/min_neuron_size;
                overlap_ratio(k) = overlap_pixels/total_pixels;
            end
            % Get neuron whose mask has the most overlap with the cell in the registration session
            most_overlap = find(max(overlap_ratio) == overlap_ratio);
            most_overlap_logical = max(overlap_ratio) == overlap_ratio;
            least_overlap = find(~most_overlap_logical);
            if length(most_overlap) == 1 % Only choose the cell with the most overlap if it is truly the most
                COM_map(same_ind(most_overlap)) = j;
            elseif length(most_overlap) > 1 % send all to nans if more than one neuron is completely inside the other
                for m = 1: length(most_overlap)
                    COM_map(same_ind(most_overlap(m))) = nan;
                end
            end
            for m = 1:length(least_overlap)
                COM_map(same_ind(least_overlap(m))) = nan;
            end
        end
        
    end
    
else
    disp('BinBlobs variables not entered - can''t disambiguate multiple mapping neurons')
    
end

end

