function [success_bool] = T4batch(sesh)
% success_bool = T4batch(sesh)
% Run Tenaspis4 in batch mode. Spit out a boolean letting you know if each
% session ran properly or not.

nsesh = length(sesh);
success_bool = false(1,nsesh);
for j = 1:nsesh
    if exist(fullfile(sesh(j).Location,'FinalOutput.mat'),'file')
        disp(['FinalOutput.mat found for ' mouse_name_title(sesh(j).Date) ...
            ' - session ' num2str(sesh(j).Session)])
        success_bool(j) = true;
        continue
    end
    try
        Tenaspis4(sesh(j));
        success_bool(j) = true;
    catch
        disp(['Error running session ' num2str(j)])
    end
end

end

