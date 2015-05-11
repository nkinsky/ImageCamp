function [file] = file_select_batch(filterspec)
% file = file_batch_select(filterspec, title_text)
% UI function to grab a number of files and dump their full path into the
% data structure "file".
% filterspec selects for the type of file you want, e.g. '*.avi', or
% {'*.avi *.dvt'}.

if nargin == 0
    filterspec = '';
end

curr_dir = cd;

disp('Select file(s) you wish to analyze.  Hit Cancel after you have selected your last session to finish.')

f = 1; p = 1; n = 1;
while f ~= 0
   [f p] = uigetfile(filterspec,['Select Session ' num2str(n) 'File: ']);
   temp(n).path = [p f];
   temp(n).folder = p;
   if f ~= 0
       n = n + 1;
       cd(p);
   end
%    cd(p); % Go to directory of selected file
end

file = temp(1:n-1); % Grab only valid file selections, discard zeros due to hitting "Cancel"
cd(curr_dir); % return to original directory

% keyboard

end