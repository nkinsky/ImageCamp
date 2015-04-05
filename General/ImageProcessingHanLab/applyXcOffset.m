function vid = applyXcOffset(vid,xc)
dx = [xc.xoffset];
dy = [xc.yoffset];
dx = dx-min(dx)+1;
dy = dy-min(dy)+1;
[xsize, ysize] = size(vid(1).cdata);
cxsize = xsize - ceil(max(dx(:)));
cysize = ysize - ceil(max(dy(:)));
padsize = [ysize-cysize xsize-cxsize];
padval = mean(vid(1).cdata(:));
Xq = gpuArray.colon(1, 1, cxsize);
Yq = gpuArray.colon(1, 1, cysize);
% xvec = round(dx(1)+1:cxsize+dx(1));
% yvec = round(dy(1)+1:cysize+dy(1));
N=numel(vid);
h = waitbar(0,  sprintf('Applying normalized cross-corellation offset. Frame %g of %g (%f secs/frame)',1,N,0));
tic
for k=1:N,
	movingImage = gpuArray(vid(k).cdata);
	% 	vid(k).cdata = movingImage(yvec,xvec);
	% 	[Xq, Yq] = meshgrid(dx(k)+1:dx(k)+cxsize, dy(k)+1:dy(k)+cysize);
	xq = Xq + dx(k);
	yq = Yq + dy(k);
	stableImage = interp2( im2single(movingImage), xq', yq, 'linear');
	stableImage = padarray(stableImage, padsize, padval ,'post');
	vid(k).cdata = gather(stableImage);
	waitbar(k/N, h, ...
		sprintf('Applying normalized cross-corellation offset. Frame %g of %g (%f secs/frame)',k,N,toc));
	tic
end
delete(h)
