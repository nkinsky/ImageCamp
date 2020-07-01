% Eraser scratchpad

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
mice_use = {'Marble14', 'Marble18', 'Marble20', 'Marble27', 'Marble29'};
for j = 1:length(mice_use)
    mouse_use = mice_use{j};
    MDuse = MD(ref{find(strcmpi(mouse_use,ref(:,1))),2}: ...
        ref{find(strcmpi(mouse_use,ref(:,1))),3}); %#ok<FNDSB>
    num_sessions = length(MDuse);
    % fail_bool{j} = false(num_sessions, num_sessions);
    num_comps = (num_sessions-1)*num_sessions/2;
    % disp(['Running pair-wise registration check for Mouse ' num2str(j)])
    hw = waitbar(0,'Registration Check Progress!');
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
                ha = plot_registration(MDuse(k), MDuse(ll));
                hf = ha.Parent;
            catch
                hf = figure; set(gcf,'Position',[700 220 980 720]);
                text(0.5,0.5, ['Error for ' MDuse(k).Date '-s' num2str(MDuse(k).Session)...
                    ' to ' MDuse(ll).Date '-s' num2str(MDuse(ll).Session)])
            end
            printNK([MDuse(1).Animal ' - Registration QC plot'], ...
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

% mice_use = {'Marble06', 'Marble07', 'Marble11', 'Marble12', 'Marble14',...
%     'Marble17', 'Marble18', 'Marble19', 'Marble20', 'Marble24', 'Marble25', ...
%     'Marble27', 'Marble29'};
mice_use = {'Marble24', 'Marble25',  'Marble29'};
success_bool = false(1,length(mice_use));
for j = 1:length(mice_use)
%     try
        mouse_use = mice_use{j};
        MDuse = MD(ref{find(strcmpi(mouse_use,ref(:,1))),2}: ...
            ref{find(strcmpi(mouse_use,ref(:,1))),3}); %#ok<FNDSB>
        num_sessions = length(MDuse);
        hw = waitbar(0,['Registration Check Progress for ' num2str(mouse_use) '!']);
        n = 0;
        clear reg_stats_chance
        for k = 1:num_sessions - 1
            if k == 1
                nshuf_use = 100;
                [~, reg_stats_chance, hfig] = reg_qc_plot_batch(MDuse(k),...
                    MDuse(k+1:num_sessions), 'num_shuffles', nshuf_use);
            else  % don't overwrite reg_stats for any subsequent runs...
                nshuf_use = 0;
                [~, ~, hfig] = reg_qc_plot_batch(MDuse(k),...
                    MDuse(k+1:num_sessions), 'num_shuffles', nshuf_use);
                reg_qc_plot([], reg_stats_chance.shuffle.orient_diff, ...
                    [], hfig, 'plot_shuf', 1);
            end
            printNK(['Reg qc plots - ' mouse_use], 'eraser', 'hfig', hfig, ...
                'append',  true)
            close(hfig)
            
        end
        close(hw)
        success_bool(j) = true;
%     catch
%         success_bool(j) = false;
%     end
end
            
            
            
            
            