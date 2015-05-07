function [] = append_to_filenames(expression,name_append,varargin);
% append_to_filenames(expression, name_append, move_copy)
% Save all files matching 'expression' with the same start but with
% 'name_append' put on the end. Note that this loads and then saves the
% files, so it could take a long time if the files are extra large
% e.g. append_to_filename('corrs*.mat','v1') takes all files in a given
% directory of the form 'corrs........mat' and renames them
% 'corrs.....v1.mat'
% Note that expression MUST contain the file extension (e.g. .mat, .fig,
% .jpg, etc.) for this function to work properly!)
% move_copy specifies if you want to just move/rename the file, or if you
% want to create a copy first! If left blank, copy is assumed, otherwise
% use 'move' or 'copy' to specify

if nargin < 3
    move_copy = 'copy';
else
    move_copy = varargin{1};
end

files = ls(expression);
extension = expression(end-3:end); % Get file extension

% Search for where the .mat occurs and put name_append between it and the
% end
for j = 1:size(files,1)
    temp = files(j,:);
    file_end = regexpi(temp,extension)-1;
    file_source{j} = temp(1:file_end+4); % Get original filename
    file_dest{j} = [temp(1:file_end) name_append extension]; % Create destination file name
    % Move/copy, depending on the move_copy flag
    
    if strcmpi(move_copy,'move')
        movefile(file_source{j}, file_dest{j});
    elseif strcmpi(move_copy,'copy')
        copyfile(file_source{j}, file_dest{j});
    end
end

end