function [ ] = MakeMeanBlobs_batch( session_struct, suppress_output )
% MakeMeanBlobs_batch( session_struct, suppress_output )
% Takes a structure with .Animal, .Date, and .Session and does a batch run
% of MakeMeanBlobs.  suppress_output = 0 updates progress to your screen
% via a simple progress bar.

%% Check for existence of all the appropriate files
for j = 1:length(session_struct)
    ChangeDirectory_NK(session_struct(j));
    proc_exist(j) = exist('ProcOut.mat','file') == 2;
    cc_exist(j) = exist('CC.mat','file') == 2;
    segments_exist(j) = exist('Segments.mat','file') == 2;
end

if sum(segments_exist & cc_exist & proc_exist) == length(session_struct) % proceed if all is ok
    disp('All required files are in the working directories - proceeding!')
else
    segments_missing = find(segments_exist == 0);
    cc_missing = find(cc_exist == 0);
    proc_missing = find(proc_exist == 0);
    for k = 1:length(segments_missing)
        disp(['Segments.mat missing for ' session_struct(segments_missing(k)).Date ...
             ' session #' num2str(session_struct(segments_missing(k)).Session)])
    end
    
    for k = 1:length(proc_missing)
       disp(['ICmovie_min_proj.tif missing for ' session_struct(proc_missing(k)).Date ...
           ' session #' num2str(session_struct(proc_missing(k)).Session)]) 
    end
    
    for k = 1:length(cc_missing)
       disp(['CC.mat missing for ' session_struct(cc_missing(k)).Date ...
           ' session #' num2str(session_struct(cc_missing(k)).Session)]) 
    end
    
    return
end


%% Run MakeMeanBlobs
for j = 1:length(session_struct)
    disp(['Processing ' session_struct(j).Date ' Session ' ...
        num2str(session_struct(j).Session)])
    ChangeDirectory_NK(session_struct(j));
    load('ProcOut.mat','c','cTon','GoodTrs')
    MakeMeanBlobs(c, cTon, GoodTrs, 'suppress_output', suppress_output);
end


end

