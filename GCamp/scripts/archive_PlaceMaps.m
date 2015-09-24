%% Quick code to save/archive previously run PlaceMaps.mat files in case you want to re-run them later.
% simply change the filename in the 2nd entry in copyfile.
n = 1;

sessions = [ref.G30.two_env(1):ref.G30.two_env(2), ref.G31.two_env(1):ref.G31.two_env(2)];
name_append = '_1cmperbin_7minspeed';
for j = sessions
    ChangeDirectory_NK(MD(j))
    success(n,1) = copyfile(fullfile(pwd,'PlaceMaps.mat'),...
        fullfile(pwd,['PlaceMaps' name_append '.mat']));
    success(n,2) = copyfile(fullfile(pwd,'PlaceMaps_rot_to_std.mat'),...
        fullfile(pwd,['PlaceMaps_rot_to_std' name_append '.mat']));
    n = n + 1;
end

%% Run PFA_batch multiple times
PFA_batch(MD(sessions),'201b',1,'rotate_to_std',0,'cmperbin',1,'calc_half',1);
PFA_batch(MD(sessions),'201b',1,'rotate_to_std',1,'cmperbin',1,'calc_half',1);