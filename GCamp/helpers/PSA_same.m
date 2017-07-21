function [ PSA_log ] = PSA_same( dir1, dir2 )
% PSA_log = PSA_same( dir1, dir2 )
%   Checks if the variables in PSAbool in dir1 and dir2 are the same or
%   different.

load(fullfile(dir1,'FinalOutput.mat'),'PSAbool'); PSA1 = PSAbool;
load(fullfile(dir2,'FinalOutput.mat'),'PSAbool'); PSA2 = PSAbool;

if length(PSA1(:)) ~= length(PSA2(:))
    PSA_log = false;
else
    PSA_log = sum(PSA1(:) == PSA2(:)) == length(PSA1(:));
end

end

