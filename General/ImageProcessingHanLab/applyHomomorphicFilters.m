function vid = applyHomomorphicFilters(vid, vidHomFilt)
% vidHomFilt has 2 fields
%	"lp" i.e. "long-pass"
%	"io" i.e "intensity-zero"
%vidHomFilt = generateHomomorphicFilters(vidInput);


for k = 1:numel(vid)
	im = vid(k).cdata;
	vid(k).cdata = exp( log( im2single( im )) - vidHomFilt.lp + vidHomFilt.io);
end

% (this method is no faster than the for-loop above)
% fh = @(frame)( exp(log(im2single(frame.cdata)) - vidHomFilt.lp + vidHomFilt.io));
% filteredFrames = arrayfun(fh, vid, 'UniformOutput',false);
% [vid.cdata] = deal(filteredFrames{:});

