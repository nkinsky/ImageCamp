function dvid = scrapDiffIm(vid)
% this function uses a moving average to calculate change in fluorescence and applies a spatial
% gaussian filter to the output
N = numel(vid);
spatfilt = false;
H = fspecial('gaussian', [5 5], .5);
midVal = 32768;
vidRange = single(range(cat(1,vid.min, vid.max)));
vidMin = single(min([vid.min]));
vidMax = single(max([vid.max]));
[sz1 sz2] = size(vid(1).cdata);
% difvid(N).cdata = gather(imlincomb(1, gpuArray(vid(N).cdata), -1, gpuArray(mean(cat(3,vid(1:N-1).cdata), 3)), 128, 'uint8'));
% dvid = cumsum(cat(3,vid.cdata),3).*(intmax('uint16')/vidMax)./repmat(sz1,sz2,1,shiftdim(1:N,-1));
mvAvg = gpuArray( (single(vid(1).cdata)) - vidMin) .* (single(intmax('uint16'))/vidRange) ;
dvid(N).cdata = gather(uint16(mvAvg));
dvid(1).cdata = gather(uint16(mvAvg));
h = waitbar(0,  sprintf('Calculating Difference of Running Average for Frame %g of %g (%f secs/frame)',1,N,0));
tic
for k = 2:numel(vid)
	im = gpuArray( (single(vid(k).cdata)) - vidMin) .* (single(intmax('uint16'))/vidRange) ;	
	im = imlincomb(1, im, -1, mvAvg, midVal, 'single');	
	if spatfilt
		im = imfilter(im, H, midVal);
	end
	dvid(k).cdata = gather(uint16(im));
	mvAvg = imlincomb(k/(k+1), mvAvg, 1/(k+1), im, 'single');
	waitbar(k/N, h, ...
		sprintf('Calculating Difference of Running Average for Frame %g of %g (%f secs/frame)',k,N,toc));
	tic
end	
delete(h)

