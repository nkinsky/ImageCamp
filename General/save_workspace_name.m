function [savefile_name] = save_workspace_name(fileout_base)
%  savefile_name = save_workspace(fileout_base)
%  Saves workspace under 'fileout_base_#.mat', where # is 1 + the largest
%  already saved number.  Should be used in conjunction with
%  exist_saved_workspace to save only unique workspace configurations

%% Search for and find all files that match fileout_base, get new number to append

file_list = ls([fileout_base '*.mat']);

if isempty(file_list)
    num_use = 1;
else
    
    num_id = nan(size(file_list,1),1);
    for j = 1:size(file_list,1)
        % Get number at end of file
        if ~isempty(regexpi(file_list(j,:),fileout_base))
            num_id(j) = str2num(file_list(j,(regexpi(file_list(j,:),fileout_base) + ...
                length(fileout_base) + 1):(regexpi(file_list(j,:),'.mat')-1)));
        end
    end
    
    num_use = max(num_id) + 1;
end

savefile_name = [fileout_base '_' num2str(num_use) '.mat'];

end

