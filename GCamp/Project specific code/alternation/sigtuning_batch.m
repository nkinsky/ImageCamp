perf = [];
for j = 1:length(sesh_sigtuning)
    skip_perf = 0;
    ChangeDirectory_NK(sesh_sigtuning(j))
    if exist('sigSplitters.mat','file') ~= 2
        try
            load('PlaceMaps.mat','x','y','FT');
            disp(['Running sigtuningAllCells for session ' num2str(sesh_sigtuning(j).Session) ...
                ' from ' sesh_sigtuning(j).Date])
            sigtuningAllCells(x,y,FT);
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
        perf(j).percentSplitters = numSplitters/length(neuronID);
    end
end