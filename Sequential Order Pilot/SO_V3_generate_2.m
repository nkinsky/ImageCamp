% Create detailed layout of experiment

clear all
close all

mice = {'SO1' 'SO2' 'SO3' 'SO4'};
seq{1} = 'ABCDE'; 
seq{2} = 'LMNOP';

num_odors = size(seq{1},2);
num_within = (num_odors-1)/2*num_odors;
num_between = num_odors*(num_odors-1);

% Generate Probe Trials Combinations
n = 1;
for j = 1:num_odors
    for k = j+1:num_odors
        p_within{1,n} = [seq{1}(j) seq{1}(k)];
%         p_within{1,n} = p_within{1,n}(randperm(2)); % Randomly swap
        p_within{2,n} = [seq{2}(j) seq{2}(k)];
%         p_within{2,n} = p_within{2,n}(randperm(2)); % Randomly swap
        n = n+1;
    end
end

% Randomly permute each within probe trial, then swap half between lists
p_within(1,:) = p_within(1,randperm(length(p_within(1,:)))); % Randomize within trials
p_within(2,:) = p_within(2,randperm(length(p_within(2,:)))); % Randomize between trials
bwswap = randperm(num_within,num_within/2); % Randomly choose rows to swap
temp1 = p_within(1,bwswap); temp2 = p_within(2,bwswap); % Swap rows
p_within(1,bwswap) = temp2; p_within(2,bwswap) = temp1;
% You now have half of each probe trial type in each row of your p_within
% cell


% probe_within = {p_within{1,:} p_within{2,:}};
% probe_within = probe_within(randperm(size(probe_within,2))); % Randomize order

m = 1;
for j = 1:num_odors
    for k = 1:num_odors
        if j ~= k 
            probe_bw{1,m} = [seq{1}(j) seq{2}(k)];
            %             probe_bw{1,m} = probe_bw{1,m}(randperm(2)); % Randomly switch order of letters
            % Swap all b/w probes around so that L is always rewarded
            if find(probe_bw{1,m}(1) == seq{1}) > find(probe_bw{1,m}(2) == seq{2})
            probe_bw{1,m} = probe_bw{1,m}([2 1]);
            elseif find(probe_bw{1,m}(1) == seq{1}) < find(probe_bw{1,m}(2) == seq{2})
            end
            m = m+1;
        end
        
    end
    
end

probe_bw = probe_bw(randperm(size(probe_bw,2))); % Randomize order
p_between(1,:) = probe_bw(1:num_within);
p_between(2,:) = probe_bw(1+num_within:2*num_within);

% Randomly swap L & R trials for each probe type
clear tempa tempb tempc tempd
n_order = [ones(1,num_within); 2*ones(1,num_within)];
for j = 1:2
   probeswap_bw = randperm(10,5);
   probeswap_win = randperm(10,5);
   for k = 1:length(probeswap_win)
       tempa = p_within{j,probeswap_win(k)}(1);
       tempb = p_within{j,probeswap_win(k)}(2);
       p_within{j,probeswap_win(k)}(1) = tempb;
       p_within{j,probeswap_win(k)}(2) = tempa;
   end
   for k = 1:length(probeswap_bw)
       tempc = p_between{j,probeswap_bw(k)}(1);
       tempd = p_between{j,probeswap_bw(k)}(2);
       p_between{j,probeswap_bw(k)}(1) = tempd;
       p_between{j,probeswap_bw(k)}(2) = tempc;
   end
   
end

% Combine into Sequence 1 and Sequence 2 trials
probe{1} = {p_within{1,1:num_within} p_between{1,1:num_within}; };
probe{1} = probe{1}(randperm(size(probe{1},2))); % Randomize for sequence 1
probe{2} = {p_within{2,1:num_within} p_between{2,1:num_within}};
probe{2} = probe{2}(randperm(size(probe{2},2))); % Randomize for sequence 2

% Generate vector to get probe trial type with no more than 2 trials of any
% type in a row (within or between)
% Other rules: 1) equal number of each type of probe for each sequence
% 2) L/R appearance of rewarded cup is counterbalanced
% 3) 
temp = [ones(1,num_within*2) 2*ones(1,num_between)];
probe_type = temp(randperm(length(temp))); % not equalized yet...


m = 1; n = 1;
for k = 1:num_within*2 + num_between
    if mod(k,2) == 1
        output{k,1} = seq{1};
        output{k,2} = probe{1}{m}(1);
        output{k,3} = probe{1}{m}(2);
    elseif mod(k,2) == 0
        output{k,1} = seq{2};
        output{k,2} = probe{2}{m}(1);
        output{k,3} = probe{2}{m}(2);
        m = m+1;
    end
    if (isempty(strfind(seq{1},output{k,2})) && isempty(strfind(seq{2},output{k,3}))) || ...
            (isempty(strfind(seq{2},output{k,2})) && isempty(strfind(seq{1},output{k,3})))
        output{k,4} = 'B/W';
    elseif (isempty(strfind(seq{1},output{k,2})) && isempty(strfind(seq{1},output{k,3}))) || ...
            (isempty(strfind(seq{2},output{k,2})) && isempty(strfind(seq{2},output{k,3})))
        output{k,4} = 'W/IN';
    end
    % This currently balances probe types per each trial, but doesn't make
    % sure that no more than 2 of a given type occur in a row...
end


% Get positions and lags for probes
clear temp2
temp2{1} = cellfun(@(a) strfind(seq{1},a),output(:,2:3),'UniformOutput',0);
temp2{2} = cellfun(@(a) strfind(seq{2},a),output(:,2:3),'UniformOutput',0);
for j = 1:size(temp2{1},1)
   for k = 1:size(temp2{1},2)
      if isempty(temp2{1}{j,k}) && isempty(temp2{2}{j,k})
          pos(j,k) = 0;
      elseif isempty(temp2{1}{j,k}) && ~isempty(temp2{2}{j,k})
          pos(j,k) = temp2{2}{j,k};
      elseif ~isempty(temp2{1}{j,k}) && isempty(temp2{2}{j,k})
          pos(j,k) = temp2{1}{j,k};
      end
   end
end

lags = abs(pos(:,2)-pos(:,1)) - 1;
greater_index = [(pos(:,2) < pos(:,1))] ;
num_R_rewarded = sum(greater_index);
R_index = find(greater_index); % get indices for R-rewarded trials
L_index = find(~greater_index);

%% Concatenate a '*' onto the rewarded side only!!!
for m = 1:4*num_within
   if greater_index(m) == 0
      output{m,2} = [output{m,2} '*'];
   elseif greater_index(m) == 1
       output{m,3} = [output{m,3} '*'];
   end
end

output

% Last step - make sure that no more than 2 of any given trial type or
% reward appear in a row???  How to do this?
