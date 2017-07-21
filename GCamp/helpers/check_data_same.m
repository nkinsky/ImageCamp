%% Check all Pos.mat files to make sure you aren't repeating them...

sesh_check = G48_botharenas; % specify it here

num_sessions = length(sesh_check);

pos_log = true(num_sessions);
PSA_log = true(num_sessions);
for j = 1:num_sessions
    dir1 = ChangeDirectory_NK(sesh_check(j),0);
    for k = 1:num_sessions
        dir2 = ChangeDirectory_NK(sesh_check(k),0);
        PSA_log(j,k) = PSA_same(dir1,dir2);
        pos_log(j,k) = Pos_same(dir1,dir2,1);
    end
end

figure; subplot(1,2,1); imagesc(pos_log);
subplot(1,2,2); imagesc(PSA_log);