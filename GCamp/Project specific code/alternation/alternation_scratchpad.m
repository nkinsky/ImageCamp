% Alternation scratchpad


%% Run Tenaspis
% sesh_use = cat(2,G30_alt(1),G31_alt(1),G45_alt(1),G48_alt(1));
% pause(3600)
alternation_reference;
sesh_use = cat(2,G30_alt(1:end), G31_alt(1:end), G45_alt(1:end), G48_alt(1:end));

success_bool = [];
for j = 1:length(sesh_use)
   try
       [~, sesh_run] = ChangeDirectory_NK(sesh_use(j));
       if exist(fullfile(pwd,'FinalOutput.mat'),'file')
           disp(['Sesiion #' num2str(j) ' - already run'])
           success_bool(j) = true;
       else
           Tenaspis4(sesh_run)
           success_bool(j) = true;
       end
   catch
       success_bool(j) = false;
   end
    
end

%% Check above

success_bool = [];
for j = 1:length(sesh_use)
    try
        [~, sesh_run] = ChangeDirectory_NK(sesh_use(j));
        success_bool(j) = exist(fullfile(pwd,'FinalOutput.mat'),'file');
    catch
        success_bool(j) = false;
    end
    
end

%% Register all sessions to one another pair-wise fashion
fail_bool = cell(4,1);
for j = 1:4
    MD_use = alt_all_cell{j};
    num_sessions = length(MD_use);
    fail_bool{j} = false(num_sessions, num_sessions);
    for k = 1:num_sessions - 1
        for ll = k+1:num_sessions
            try
                neuron_map_simple(MD_use(k),MD_use(ll));
            catch
                fail_bool{j}(k,ll) = true;
            end
        end
    end
end

%% When done with above, run to qc registrations - use plot_registration
for j = 1:4
    MD_use = alt_all_cell{j};
    num_sessions = length(MD_use);
    fail_bool{j} = false(num_sessions, num_sessions);
    for k = 1:num_sessions - 1
        for ll = k+1:num_sessions
            plot_registration(MD_use(k),MD_use(ll));
        end
    end
end



