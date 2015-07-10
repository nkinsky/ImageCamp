function [ ] = MakeMeanBlobs_batch( session_struct, suppress_output )
% Takes a structure with .Animal, .Date, and .Session and does a batch run
% of MakeMeanBlobs.  suppress_output = 0 updates progress to your screen

for j = 1:length(session_struct)
    disp(['Processing ' session_struct(j).Date ' Session ' ...
        num2str(session_struct(j).Session)])
    ChangeDirectory_NK(session_struct(j));
    load('ProcOut.mat','c','cTon','GoodTrs')
    MakeMeanBlobs(c, cTon, GoodTrs, 'suppress_output', suppress_output);
end


end

