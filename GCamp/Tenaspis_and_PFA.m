function [ ] = Tenaspis_and_PFA( infile, mask_file, roomstr, rawfile)
% Tenaspis_and_PFA( infile, mask_file, roomstr, rawfile)
%% Tenaspis
if ~isempty(mask_file)
    load(mask_file)
    Tenaspis_NK(infile,mask)
else
    Tenaspis_NK(infile)
end

%% PFA
PFA(roomstr, rawfile)

end

