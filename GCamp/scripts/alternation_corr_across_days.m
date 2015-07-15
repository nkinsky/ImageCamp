% Script to get correlations between all sessions that pass the transitive
% test

%% 1) Load both Reg_NeuronID files (updatemasks = 0 and updatemasks = 1).
reg_file_updatemask{1} = 'j:\GCamp Mice\Working\G30\alternation\10_16_2014\Working\Reg_NeuronIDs_updatemasks0.mat';
reg_file_updatemask{2} = 'j:\GCamp Mice\Working\G30\alternation\10_16_2014\Working\Reg_NeuronIDs_updatemasks1.mat';

for j = 1:2
    load(reg_file_updatemask{j})
    Reg_NeuronID_trans(j).Reg_NeuronIDs = Reg_NeuronIDs;
    all_session_map(j).map = Reg_NeuronIDs(1).all_session_map;
end

%% 2) Get base directory and directories of all the subsequent registered sessions, ...
% & load up the TMaps for each of these sessions

n = 1;
Animal = Reg_NeuronID_trans(1).Reg_NeuronIDs(1).mouse;
for j = 1:length(Reg_NeuronID_trans(1).Reg_NeuronIDs)
   if j == 1
       ChangeDirectory(Animal, Reg_NeuronID_trans(1).Reg_NeuronIDs(j).base_date,...
           Reg_NeuronID_trans(1).Reg_NeuronIDs(j).base_session);
       load('PlaceMaps.mat','TMap');
       sesh(n).TMap = TMap;
       n = n + 1;
   end
   
   ChangeDirectory(Animal, Reg_NeuronID_trans(1).Reg_NeuronIDs(j).reg_date,...
       Reg_NeuronID_trans(1).Reg_NeuronIDs(j).reg_session);
   load('PlaceMaps.mat','TMap');
   sesh(n).TMap = TMap;
   n = n + 1;
       
end

%% 3) Perform the transitive test and identify ONLY those neurons that are 
% the same across both methods of registering neurons (stringent = only
% keep neurons that are the same across ALL sessions, more lenient =
% don't use any neuron from a given day that is different, but can use
% other days that are the same...)

% This identifies all the neurons that map the same from day-to-day...each
% column is a registered session, each row is a neuron...NOTE that this
% will only work for 3 sessions total...after that, we will have many
% different neurons since small differences in the first set of registered
% neurons will result in a different ordering of the neurons...will need to
% search through and find each neuron from each day separately...YIKES!

% How do I really want to do this?  Probably the best is to rotate through
% each day, look for that cell number, and observe all the subsequent day
% neurons that it maps to and see if they are the same or different (see
% limits below, could do something like that but iteratively)

% Get limits to compare across - look only at the neurons from the first
% day plus the new neurons from the second day (hack)
limits = length(sesh(1).TMap) + length(Reg_NeuronID_trans(j).Reg_NeuronIDs(1).new_neurons);
% look for all neurons that match between each all_neuron_map
trans_test = cellfun(@(a,b) ~((~isempty(a) && isempty(b)) || (isempty(a) && ~isempty(b))) ...
    && ((isempty(a) && isempty(b)) || (isnan(a) && isnan(b)) || ...
    (~isempty(a) && ~isnan(a) && ~isempty(b) && ~isnan(b) && (a == b))), ...
    all_session_map(1).map(1:limits,3:end), all_session_map(2).map(1:limits,3:end));

pass_test1 = find(sum(trans_test,2) == size(trans_test,2)); % neurons that are the same across all sessions

%% Alternative Transitive test - less strict = go through each neuron...find 
% it in the 2nd all_neuron_map and look for matches to the neurons from the
% 1st all_neuron_map

% First, the all_neuron_map to an array rather than a cell so that you can
% do comparisons easier
for m = 1:2
    for j = 1:size(all_session_map(m).map,1)
        for k = 1:size(all_session_map(m).map,2)
            if ~isempty(all_session_map(m).map{j,k}) && ~isnan(all_session_map(m).map{j,k})
                test(m).map(j,k) = all_session_map(m).map{j,k};
            else
                test(m).map(j,k) = 0;
            end
        end
    end
end

max_neuron_num = max(test(1).map,[],1);

row_use_track = [];
for i = 2:length(max_neuron_num)
    % Need to add something in here to start using only the new neurons
    % from each given session!
   for j = 1:max_neuron_num(i)
       % find the appropriate row that matches the neuron from both methods
       % of getting the all_neuron_map neuron
       row_ind_use(1) = test(1).map(:,i) == j;
       row_ind_use(2) = test(2).map(:,i) == j;
       
       if sum(row_ind_use(1)) > 0 && sum(row_ind_use(2)) > 0
           for mm = 1:2
               row_use(m,:) = test(m).map(row_ind_use(m),i:end);
           end
           temp = row_use(1,:) == row_use(2,:);
           trans_test2(
           row_use_track = [row_use_track row_ind_use(1)]; % Keep track of indicies of rows you have already used and don't re-use them
       end  
       
   end
    
end

%% 4) Get correlations between the TMaps for all cells across each day.  

% Visualize with individual cell and all cell confusion matrices? Or just
% bar graphs for day 1 to day 2, day 2 to day 3, and day 1 to day 3?


for j = 1:length(pass_test)
    for k = 1:3
        for ll = k+1:3
            sesh1_neuron = all_session_map(1).map{pass_test(j),k+1};
            sesh2_neuron = all_session_map(1).map{pass_test(j),ll+1};
            if ~isempty(sesh1_neuron) && ~isempty(sesh2_neuron) && ...
                    ~isnan(sesh1_neuron) && ~isnan(sesh2_neuron)
                temp = corrcoef(sesh(k).TMap{sesh1_neuron}(:),...
                    sesh(ll).TMap{sesh2_neuron}(:));
                corr_matrix(k,ll,j) = temp(1,2);
            else
                corr_matrix(k,ll,j) = nan;
            end
        end
        
    end
    
end
