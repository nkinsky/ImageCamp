% Script to run image registration for ALL sessions back to 1st session...

base_sesh = 'J:\GCamp Mice\Working\2env\11_19_2014\1 - 2env square left 201B\Working';
session_ref_path = 'J:\GCamp Mice\Working\2env\session_ref.mat';
square_sesh_path = 'J:\GCamp Mice\Working\2env\square_sessions.mat';
octagon_sesh_path = 'J:\GCamp Mice\Working\2env\octagon_sessions.mat';
load(session_ref_path); load(square_sesh_path); load(octagon_sesh_path);

picture_name = 'ICmovie_min_proj.tif';

for i = 8;% 1:size(day,2)
    for j = 1:size(day(j).session,2)
        [~, folder, ~] = get_folders_from_seshrefstruct(day, square_sessions,...
            octagon_sessions, i, j);
        if i == 1
        image_registerX([base_sesh '\' picture_name],...
            [folder '\' picture_name],1);
        else
            image_registerX([base_sesh '\' picture_name],...
            [folder '\' picture_name],0);
        end
    end
end