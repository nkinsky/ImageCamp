function [t_interp_valid, x_interp_valid, y_interp_valid, index_scopix_valid] = AlignImagingToTracking_NK(ICmovie_path, SR, xpos_interp, ypos_interp, t_interp, MoMtime)
%[index_scopix_valid, index_interp_valid] = AlignImagingToTracking_NK(ICmovie_path, xpos_interp, ypos_interp, t_interp, MoMtime)
%   takes xpos_interp and ypos_interp (coordinates already converted to cm) and their
%   accompanying timestamps, t_interp, and spits out updated x, y, and
%   speed vectors...

% End result: I want two sets of arrays, xpos_interp, ypos_interp, and
% time_interp, that contain only valid timestamps for tracking data.
% index_scopix_valid is the length of the full inscopix movie and contains
% the indices of timestamps in the inscopix movie that match the times in
% t_interp_valid

%% Step 0: If SR is left blank, set it to 20

if isempty(SR)
    SR = 20;
end

%% Step 1: Chop interp variables to match length of ICmovie - start at MoMtime, 
% end at end of ICmovie. Create t_scopix to match, and make it the length of the ICmovie.
info = h5info(ICmovie_path,'/Object');
ICmovieLength = info.Dataspace.Size(3);

% Scopix index and time setup
t_scopix = (1:ICmovieLength)/SR;
index_scopix_start = findclosest(MoMtime,t_scopix); % start at MoMtime
t_scopix_valid = t_scopix(index_scopix_start:end); % This now goes from MoMtime and ends at the finish of the movie
% index_scopix_valid = index_scopix_start:ICmovieLength; % This references all the valid timestamps in t_scopix

%% Step 1.5: Fix annoying matlab problem where values that are off by 1e-13 due
% to some weird rounding error are not considered equal
round_pos = 3; % decimal point to round t_interp and t_scopix to
t_scopix = round(t_scopix, round_pos);
t_scopix_valid = round(t_scopix_valid, round_pos);
t_interp = round(t_interp, round_pos);
%% Step 1.75: Continue with Step 1

% Get valid indices in t_interp, e.g. those that match a timestamp in
% t_scopix_valid
n = 1; nn = 1;
for j = 1:length(t_scopix_valid)
    if sum(t_scopix_valid(j) == t_interp) == 0 % Catch cases where there is no matching timestamp in t_interp
        index_scopix_invalid(n) = j;
        n = n + 1;
    else
        index_interp_valid(nn) = find(t_scopix_valid(j) == t_interp);
        nn = nn + 1;
    end
end

t_interp_valid = t_interp(index_interp_valid); % Get t_interp to match timestamps in t_scopix_valid
x_interp_valid = xpos_interp(index_interp_valid);
y_interp_valid = ypos_interp(index_interp_valid);
% Your interp variables should now match the length and times of
% t_scopix_valid

%% Step 2: Step through each timestamp in t_scopix, and check to see if it 
% is in t_interp.  Create a filter of valid indices, index_scopix_valid, that 
% is 0 if the timestamp is not in t_interp, and 1 if it is.  Then, we 
% should not need an index_interp_valid at all, just an index_scopix_valid 
% that matches each value in the interp dataset!!

for j = 1:length(t_scopix)
    if j < index_scopix_start
        index_scopix_valid(j) = 0; % set anything before MoMtime to 0
    elseif j >= index_scopix_start
        if sum(t_scopix(j) == t_interp_valid) == 1
            index_scopix_valid(j) = 1; % Set anything that matches a time in t_interp to 1
            index_scopix_to_interp(j) = find(t_scopix(j) == t_interp_valid); % Get index that frame j in inscopix maps to in t_interp
        elseif sum(t_scopix(j) == t_interp_valid) == 0
            index_scopix_valid(j) = 0; % Set any time values in t_scopix that are missing in t_interp to 0
            index_scopix_to_interp(j) = 0;
        end
    end
end

index_scopix_valid = logical(index_scopix_valid);
index_scopix_valid = find(index_scopix_valid);


valid_length = length(t_scopix_valid);

end