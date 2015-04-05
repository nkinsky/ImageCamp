function vid = generateStats(vid)

for k = 1:numel(vid)
	im = gpuArray(vid(k).cdata);
	vid(k).mean = gather(mean2(im));
	vid(k).min = gather(min(im(:)));
	vid(k).max = gather(max(im(:)));
end