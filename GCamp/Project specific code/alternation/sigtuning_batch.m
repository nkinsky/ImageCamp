function [perf] = sigtuning_batch(sesh_sigtuning, PFname)
% perf = sigtuning_batch(sesh_sigtuning, PFname)
%   Run sigtuning on all sessions in sesh_sigtuning. Spits out performance
%   data including hand scored performance, automated performance, percent
%   splitters and total number of splitters. Loads variables from PFname
%   (e.g. Placefields_1cm.mat)

num_sessions = length(sesh_sigtuning);

%% First check if there is an Alternation.mat file and if not create it by running
% postrials.
% for j = 1:num_sessions
%     ChangeDirectory_NK(sesh_sigtuning(j))
%     load(PFname,'x','y');
% %     postrials(x,y,0,'skip_rot_check',skip_rot_check);
% end

%% Then run the rest
for j = 1:num_sessions
    skip_perf = 0;
    ChangeDirectory_NK(sesh_sigtuning(j))
    if exist('sigSplitters.mat','file') ~= 2
        try
            load(PFname,'x','y','PSAbool');
            disp(['Running sigtuningAllCells for session ' ...
                num2str(sesh_sigtuning(j).Session) ...
                ' from ' sesh_sigtuning(j).Date])
            sigtuningAllCells(x,y,PSAbool);
        catch
            disp('Required files missing - skipping for now')
            skip_perf = 1;
        end
    elseif exist('sigSplitters.mat','file') == 2
        disp(['sigTuningAllCells already run for session ' num2str(sesh_sigtuning(j).Session) ...
        ' from ' sesh_sigtuning(j).Date])
    end
    perf(j).Date = sesh_sigtuning(j).Date;
    
    if skip_perf == 0
        load('Alternation.mat');
        perf(j).performance = sum(Alt.summary(:,3))/size(Alt.summary,1);
        load sigSplitters.mat
        perf(j).numSplitters = numSplitters;
        perf(j).ratioSplitters = numSplitters/length(neuronID);
        perf(j).hand_perf = sesh_sigtuning(j).perf;
    end
end



end