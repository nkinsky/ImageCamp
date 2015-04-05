% Script to mess around with swapping L/R and Win/Bw trials so that no more
% than 2 of either kind occur in a row!!!

% clear all
% close all
% 
% load test.mat; % Goes into output vector

out_bin(:,1) = 1*cellfun(@(a) strcmp(a,'ABCDE'),output(:,1)); %Assigns 1s to ABCDE and 0s to LMNOP
out_bin(:,2) = cellfun(@(a) ~isempty(strfind(a,'*')),output(:,2)); % Assigns a 1 if rewarded in left, 0 if rewarded in right
out_bin(:,3) = cellfun(@(a) strcmp(a,'W/IN'),output(:,4));
out_bin(:,4) = out_bin(:,1)*4+out_bin(:,2)*2+out_bin(:,3); % Assign each combination to a different category from 0-7

keep = out_bin(:,3);

% Count up number of within or between trials in a row
m = 1; a(1,1) = 0;
for k = 1:length(out_bin(:,3))-1
    if out_bin(k+1,3) == out_bin(k,3)
        m = m + 1;
    else
        m = 1;
    end
       a(k+1,1) = m; 
    
end

% Get indices of where 2 or more within or between trials occur in a row
w_in_2to4 = find(a > 2 & a <4); 
w_in_2to4_type = out_bin(w_in_2to4,4); % get types for these

swap = [1 0 3 2 5 4 7 6];
for k = 1:length(w_in_2to4)
    available = find(swap(w_in_2to4_type(k)+1) == out_bin(:,4));
    pick = available(randi(5));
    temp = out_bin(available(randi(5)),:);
    temp2 = out_bin(w_in_2to4(k),:);
    out_bin(w_in_2to4(k),:) = temp;
    out_bin(pick,:) = temp2;
end

% Run this again until you end up with only a two in a row?
% Next, run for L versus R trials until you end up with less than 2
% everywhere?
% OR, better yet, make this a function and then alternate running it for
% trial type and L/R trials until constraints are satisfied...