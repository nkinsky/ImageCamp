function [ output_args ] = Tenaspis_and_PFA( infile, mask_file, roomstr, rawfile)
%UNTITLED Summary of this function goes here
%% Tenaspis
if ~isempty(mask_file)
    load(mask_file)
    Tenaspis_NK(infile,mask_file)
else
    Tenaspis_NK(infile)
end

%% PFA
PFA(roomstr, rawfile)

end

