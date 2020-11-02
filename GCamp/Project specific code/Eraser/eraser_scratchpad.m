% Eraser scratchpad
all_mice_list = {'Marble06', 'Marble07', 'Marble11', 'Marble12', 'Marble14', ...
    'Marble17', 'Marble18', 'Marble19', 'Marble20', 'Marble24', ...
    'Marble25', 'Marble27', 'Marble29'};
%% Register sessions!
[MD, ~, ref] = MakeMouseSessionListEraser('Nat');

mice_use = {'Marble18'};
for m = 1:length(mice_use)
    mouse_use = mice_use{m};% mouse_use = 'Marble27';
    MDuse = MD(ref{find(strcmpi(mouse_use,ref(:,1))),2}: ...
        ref{find(strcmpi(mouse_use,ref(:,1))),3}); %#ok<FNDSB>
    nsesh = length(MDuse);
    hw = waitbar(0,['Registering Sessions for ' mouse_use '...']);
    n = 0;
    fail_bool2 = false(nsesh);
    for j = 1:(nsesh-1)
        for k = (j+1):nsesh
            try
                neuron_registerMD(MDuse(j), MDuse(k));
                close gcf
                close gcf
                close gcf
            catch
                fail_bool2(j,k) = true;
            end
            waitbar(n/(nsesh*(nsesh-1)/2),hw);
            n = n+1;
        end
        
    end
    close(hw)
end

%% When done with above, run to qc registrations - use plot_registration
use_batch_map = true;
mice_use = all_mice_list;
for j = 1:length(mice_use)
    mouse_use = mice_use{j};
    MDuse = MD(ref{find(strcmpi(mouse_use,ref(:,1))),2}: ...
        ref{find(strcmpi(mouse_use,ref(:,1))),3}); %#ok<FNDSB>
    num_sessions = length(MDuse);
    % fail_bool{j} = false(num_sessions, num_sessions);
    num_comps = (num_sessions-1)*num_sessions/2;
    % disp(['Running pair-wise registration check for Mouse ' num2str(j)])
    hw = waitbar(0,['Registration Check Progress for ' mouse_use]);
    n = 0;
    for k = 1:num_sessions - 1
        %     hfig = figure;
        for ll = k+1:num_sessions
            %         if ll == num_sessions %&& k == (num_sessions - 1)
            %             num_shuffles = 100;
            %         else
            %             num_shuffles = 0;
            %         end
            try
                if ~use_batch_map
                    ha = plot_registration(MDuse(k), MDuse(ll));
                    name_append = '';
                elseif use_batch_map
                    name_append = '_batchmap';
                    ha = plot_registration(MDuse(k), MDuse(ll), '', ...
                        [], MDuse(1));
                end
                hf = ha.Parent;
            catch
                hf = figure; set(gcf,'Position',[700 220 980 720]);
                text(0.5,0.5, ['Error for ' MDuse(k).Date '-s' num2str(MDuse(k).Session)...
                    ' to ' MDuse(ll).Date '-s' num2str(MDuse(ll).Session)])
            end
            printNK([MDuse(1).Animal ' - Registration QC plot' name_append], ...
                'eraser', 'append', true, 'hfig', hf);
            close(gcf)
            n = n+1;
            waitbar(n/num_comps,hw);
        end
        %     reg_qc_plot_batch(MDuse(k), MDuse(k+1:num_sessions), 'hfig', hfig,...
        %         'num_shuffles', num_shuffles);
        %     make_figure_pretty(hfig)
        %     printNK([MDuse(1).Animal ' - Registration QC plot' ...
        %         num2str(k)],'eraser')
    end
    close(hw)
end

%% Now run batch registration qc for all different combos of sessions
num_shuffles = 100;
batch_mode = 1;
if batch_mode == 1; name_append = '_batchmap'; elseif batch_mode == 0; name_append = ''; end

mice_use = {'Marble24', 'Marble25', 'Marble29'}; %{'Marble07', 'Marble11', 'Marble12', 'Marble14', ...
%     'Marble17', 'Marble18', 'Marble19', 'Marble20', 'Marble24', ...
%     'Marble25', 'Marble27', 'Marble29'};
success_bool = false(1,length(mice_use));
for j = 1:length(mice_use)
%     try
        mouse_use = mice_use{j};
        MDuse = MD(ref{find(strcmpi(mouse_use,ref(:,1))),2}: ...
                ref{find(strcmpi(mouse_use,ref(:,1))),3}); %#ok<FNDSB>
            
        % Now remove shock day 0 session from the following mice who had
        % errors during that recording...
        if any(strcmp(mouse_use, {'Marble24','Marble25','Marble29'}))
            MDuse = MDuse([1:5, 7:14]);
        end
        num_sessions = length(MDuse);
        hw = waitbar(0,['Registration Check Progress for ' num2str(mouse_use) '!']);
        n = 0;
        clear reg_stats_chance
        for k = 1:num_sessions - 1
            disp(k)
            if k == 1
                nshuf_use = 100;
                [~, reg_stats_chance, hfig] = reg_qc_plot_batch(MDuse(k),...
                    MDuse(k+1:num_sessions), 'num_shuffles', nshuf_use,...
                    'save_stats', true, 'batch_mode', batch_mode, ...
                    'name_append', name_append, 'batchmap_dir', MDuse(1).Location);
            else  % don't overwrite reg_stats for any subsequent runs...
                nshuf_use = 0;
                [~, ~, hfig] = reg_qc_plot_batch(MDuse(k),...
                    MDuse(k+1:num_sessions), 'num_shuffles', nshuf_use, ...
                    'save_stats', true, 'batch_mode', batch_mode, ...
                    'name_append', name_append, 'batchmap_dir', MDuse(1).Location);
                reg_qc_plot([], reg_stats_chance.shuffle.orient_diff, ...
                    [], hfig, 'plot_shuf', 1);
            end
            printNK(['Reg qc plots - ' mouse_use name_append], 'eraser', ...
                'hfig', hfig, 'append',  true)
            close(hfig)
            waitbar(k/(num_sessions-1), hw);
        end
        close(hw)
        success_bool(j) = true;
%     catch
%         success_bool(j) = false;
%     end
end

%% Now run batch reg for ALL mice
mice_use = {'Marble06', 'Marble07', 'Marble11', 'Marble12', 'Marble14', ...
    'Marble17', 'Marble18', 'Marble19', 'Marble20', 'Marble24', ...
    'Marble25', 'Marble27', 'Marble29'};
noshock2_mice = {'Marble24', 'Marble25', 'Marble29'};  % mice without a shock day session 2 recording.
mice_use = noshock2_mice;
success_bool = false(1,length(mice_use));
errorME = cell(size(mice_use));
for j = 1:length(mice_use)
    mouse_use = mice_use{j};
    MDuse = MD(ref{find(strcmpi(mouse_use,ref(:,1))),2}: ...
        ref{find(strcmpi(mouse_use,ref(:,1))),3}); %#ok<FNDSB>
    if any(strcmp(mouse_use, noshock2_mice))  % get rid of 0 hour session 2 if one of these mice.
        MDuse = MDuse([1:5 7:14]);
    end
    
    hw = waitbar(0, ['Running batch reg for ' mouse_use]);
    try
        neuron_reg_batch(MDuse(1), MDuse(2:end));
        success_bool(j) = true;
    catch ME
        errorME{j} = ME;
        success_bool(j) = false;
    end
    close(hw);
    
end

%% Now copy over all the good batch_session_maps to dropbox!
mice_use = {'Marble06', 'Marble07', 'Marble11', 'Marble12', 'Marble14', ...
    'Marble17', 'Marble18', 'Marble19', 'Marble20', 'Marble24', ...
    'Marble25', 'Marble27', 'Marble29'};
dropbox_base_folder = 'C:\Users\kinsky\Dropbox\Imaging Project\Manuscripts\Eraser\Figures\Registration Quality\batch_session_maps for Orlin';
for j = 1:length(mice_use)
    mouse_use = mice_use{j};
    MDuse = MD(ref{find(strcmpi(mouse_use,ref(:,1))),2}: ...
        ref{find(strcmpi(mouse_use,ref(:,1))),3}); %#ok<FNDSB>
    base_dir = MDuse.Location;
    
    drop_dir_mouse = fullfile(dropbox_base_folder, mouse_use);
    mkdir(drop_dir_mouse);
    load(fullfile(base_dir, 'batch_session_map'), 'batch_session_map');
    save(fullfile(drop_dir_mouse, 'batch_session_map'), 'batch_session_map');
    
end

                