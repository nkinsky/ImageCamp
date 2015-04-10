function [dir_group] = folder_select_batch(append_backslash)
% folder = folder_batch_select()
% UI function to grab a number of folders and dumpt their path into the
% data structure "folder"
% append_backslash = 1 (default) appends a backslash onto the end of the
% folder so that you can easily append files onto it

if nargin == 0
    append_backslash = 0;
end

if append_backslash == 1
    append = '\';
else 
    append = '';
end

folder = cd;

f = 1; p = 1; n = 1;
while f ~= 0
    disp('Select folder(s) you wish to analyze.  Hit Cancel after you have selected your last session to finish.')
    folder = uigetdir(folder,['Select Session ' num2str(n) 'Folder: ']);
    if folder == 0
        f = 0;
    else
        dir_group(n).folder = [folder append];
        n = n + 1;
    end
end

% keyboard

end

