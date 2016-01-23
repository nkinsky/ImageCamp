function [] = twoenv_qc_arena_rotation(session_struct)
% twoenv_qc_arena_rotation(session_struct)
%
% Prints out arenas for 2env task to make sure you have properly applied all
% the rotations when aligning local cues

figure(100)
for j = 1:length(session_struct)
    ChangeDirectory_NK(session_struct(j))
    if j == 5 || j == 6 % go to correct place for connected sessions
        cd ..
    end
    cd ..
    cd Cineplex
    avi_file = ls('*.avi');
    if size(avi_file,1) > 1
        avi_file = avi_file(1,:)
    end
    obj = VideoReader(avi_file);
    frame_use = readFrame(obj);
    rot_use = get_rot_from_db(session_struct(j))/90;
    subplot(2,4,j)
    imagesc(rot90(frame_use,rot_use))

end

