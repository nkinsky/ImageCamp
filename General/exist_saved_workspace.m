function [ exist_logical, dirstr] = exist_saved_workspace(fileout_base, varargin )
% exist_logical = exist_saved_workspace(fileout_base, varargin )
% Checks existing folder for saved workspace in the format fileout_base_#_.mat 
% where different numbers have unique combinations of the variables 
% specified in varargin.  E.g. if you want to run multiple sweeps of a 
% script with different parameters n and f changing in each, you would get 
% fileout_base_1.mat for f = 1 and n = 1, fileout_base_2.mat for f = 1 and
% n = 2, fileout_base_3.mat for f = 2 and n = 1, etc.  
% syntax: exist_saved_workspace(fileout_base,'f',1,'n',2,...)

num_vars = length(varargin)/2; % Number of variables to check for

%%
% Get list of files matching fileout_base_#_.mat format
file_list = ls([fileout_base '*.mat']);

dirstr = ''; % Leave empty if no appropriate file is found
if isempty(file_list)
    exist_logical = 0;
    dirstr = '';
elseif ~isempty(file_list)
    
    for j = 1:size(file_list,1)
        if ~isempty(regexpi(file_list(j,:),'\s')) % Check for whitespace at end
            file_end_ind = min(regexpi(file_list(j,:),'\s'))-1; % End = first whitespace - 1
        else
            file_end_ind = size(file_list,2); % No whitespace at end = use full length
        end
        filename_load = file_list(j,1:file_end_ind);
        % Load each file and all the appropriate varargins, and check if each
        % exists
        
        exist_logical = true; % Starting point for logical read-out
        for k = 1:num_vars
            try
                load(filename_load,varargin{2*k-1});
                value_check = eval(varargin{2*k-1});
                exist_logical = exist_logical & (value_check == varargin{2*k}); % Check if existing variable matches that specified in varargin
            catch
              exist_logical = false;
            end
        end
        
        % Exit for loop if all the variables already exist in a workspace
        % variable
        if exist_logical == 1
            dirstr = filename_load;
            break
        end
        
        
    end
end


end

