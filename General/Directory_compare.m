% Script to compare two directories to one another, to make sure there are
% copies of a given file in each directory for backing up purposes.
% Directory 1 is the one you want backed up, and thus want to check to see
% if the full file is contained in directory2.

% CHECK THIS with file of different size...

directory1 = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_10_2014\test1';
directory2 = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_10_2014\test2';

%% Step 1: Run get_all_files_win for two different directories.  
% Run for multiple different file types (e.g. .h5 and .raw and .txt and
% .prj)
  
[files_out1 sizes_out1] = get_all_files_win(directory1,'*.mat');
[files_out2 sizes_out2] = get_all_files_win(directory2,'*.mat');

%% Step 2: Remove first three letters of path (i.e. drive that it is on).

files_out1 = cellfun(@(a) a(length(directory1)+1:end),files_out1,'UniformOutput',0);
files_out2 = cellfun(@(a) a(length(directory2)+1:end),files_out2,'UniformOutput',0);

%% Step 2: Compare all the files to make sure they match.  If they don't,
% spit out which ones DON'T match.  Check both ways? (File in diretory A
% that aren't in B and vice versa?)

for j = 1:size(files_out1,1)
   for k = 1:size(files_out2,1)
       filename_index(j,k)= strcmp(files_out1{j},files_out2{k});
   end
end

filenames_ok = sum(filename_index,2);
ok_files_index = find(filenames_ok == 1);
missing_files_index = find(filenames_ok ~= 1);
missing_files = files_out1(missing_files_index);

for j = 1:size(ok_files_index)
    for k = 1:size(files_out2,1)
        sizes_index(ok_files_index(j),k) = (sizes_out1(ok_files_index(j))...
            == sizes_out2(k)) & filename_index(ok_files_index(j),k);
    end
end
sizes_ok = sum(sizes_index,2);
ok_sizes_index = find(sizes_ok == 1);
bad_sizes_index = find(sizes_ok ~= 1 & filenames_ok == 1);
bad_sizes_files = files_out1(bad_sizes_index);
