function [ ] = twoenv_save_rots( Animal_num, rot_type, h1, h2, h3)
% twoenv_save_rots( Animal_num, rot_type, h1, h2, h3)
%  Saves Rotation analysis diagrams spit out by twoenv_rot_analysis_full.
%  Necessary to use because MATLAB does not properly size things when
%  plotting for some reason.  Make sure to size properly before spitting
%  out!

Animal_names = {'GCamp6f_30', 'GCamp6f_31', 'GCamp6f_45', 'GCamp6f_48'};
h_use = cat(1,h1,h2,h3);

file_name = {[Animal_names{Animal_num} ' - ' rot_type ' - Population Rotation Analysis'],...
    [Animal_names{Animal_num} ' - ' rot_type ' - Population Best Angle Histogram'],...
    [Animal_names{Animal_num} ' - ' rot_type ' - Neuron Best Angle Histogram']};
for j = 1:3
    figure(h_use(j))
    printNK(file_name{j},'2env_rot')
end

end

