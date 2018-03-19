function [ DI, num_silent ] = getDI( session1, session2, PSAfile )
%[ DI, num_silent] = getDI( session1, session2,... )
%   Gets discrimination index (event_rate1 - event_rate2)/(event_rate1 +
%   event_rate2) between all neurons in session1 and session2. Also spits
%   out the total number of cells active in EITHER session (excluding any
%   with overlapping ROIs that might be misclassified due to conservative
%   neuron registration). Optional 3rd argument with file name
%   grabs putative spiking activity from that file instead of
%   FinalOutput.mat (must be from a placefields file currently

if nargin < 3
    PSAfile = 'FinalOutput.mat';
end

%% Get map between cells and coactive/silent/new cells
[ good_map, become_silent, new_cells] = classify_cells(session1, session2, ...
    0);
valid_bool = ~isnan(good_map) & good_map ~= 0;

% num_legit_cells = sum(valid_bool) + length(become_silent) + length(new_cells);
num_silent = length(become_silent) + length(new_cells);

%% Load up PSA for each session and calculate mean event rate
sesh = session1;
sesh(2) = session2;
for j = 1:2
   dirstr = ChangeDirectory_NK(sesh(j),0);
   
   if strcmpi(PSAfile,'FinalOutput.mat')
       load(fullfile(dirstr,PSAfile), 'PSAbool');
   else
       load(fullfile(dirstr,PSAfile), 'PSAbool','x','y','xEdges','yEdges');
       valid_ind  = x >= min(xEdges) & x <= max(xEdges) & ...
           y >= min(yEdges) & y <= max(yEdges);
       PSAbool = PSAbool(:,valid_ind);
   end
   
   meanER =  mean(PSAbool,2)/size(PSAbool,2);
   sesh(j).meanER = nan(length(good_map),1);
   if j == 1
       sesh(j).meanER(valid_bool) = meanER(valid_bool);
   elseif j == 2
       sesh(j).meanER(valid_bool) = meanER(good_map(valid_bool));
   end
end

%% Calculate DI
DI = (sesh(1).meanER - sesh(2).meanER)./(sesh(1).meanER + sesh(2).meanER);

end

