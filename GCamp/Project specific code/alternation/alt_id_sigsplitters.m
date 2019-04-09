function [sigbool, stembool] = alt_id_sigsplitters(session, sigthresh)
% [sig_bool, stem_bool] = alt_id_sigsplitters(session, sigthresh)
%  Boolean of splitters identified by having at least sigthresh stem bins
%  with a p-value of less than 0.05. default for sigthresh = 3. Also spits
%  out boolean of neurons who are active on the stem.

if nargin < 2
    sigthresh = 3;
end

dir_use = ChangeDirectory_NK(session, 0);
load(fullfile(dir_use,'sigSplitters'),'sigcurve')
sigbool = cellfun(@(a) sum(a) >= sigthresh, sigcurve); % Get splitters
stembool = ~cellfun(@isempty, sigcurve);

end

