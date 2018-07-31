function [] = alt_make_forced_folder(sesh)
% alt_make_forced_folder(sesh)
%   Copies over files to forced trials folder for alternation sessions.
%   One-off function.

filenames = {'exclude_frames_forced_free.mat', 'FinalOutput.mat', ...
    'ICmovie_min_proj.tif', 'Placefields_combined_cm1.mat', ...
    'Placefields_forced_cm1.mat'};

num_sesh = length(sesh);

for j = 1:num_sesh
   ChangeDirectory_NK(sesh(j)); 
   mkdir(pwd,'Forced Trials');
   cellfun(@(a) copyfile(fullfile(pwd,a),fullfile(pwd,'Forced Trials',a)),...
       filenames)
   copyfile(fullfile(pwd,'Forced Trials','Placefields_forced_cm1.mat'), ...
       fullfile(pwd,'Forced Trials','Placefields_cm1.mat'))
   disp(['Finished session ' num2str(j) ' of ' num2str(num_sesh)])
   
end

end

