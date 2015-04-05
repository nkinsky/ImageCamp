function compareVideos(vidOutput)

%% DISPLAY/COMPARE
vonames = fields(vidOutput);
nFrames = numel(vidOutput.(vonames{1}));
for k=1:numel(vonames)
	imin(k) = min(vidOutput.(vonames{k})(1).cdata(2:end)); 
	imax(k) = max(vidOutput.(vonames{k})(1).cdata(2:end));
	nFrames = min(numel(vidOutput.(vonames{k})), nFrames);
end
wid = 1/numel(vonames);
hFig = handle(figure(1));
hFig.Units = 'normalized';
for k=1:numel(vonames)
	axes('parent',hFig,'position', [(k-1)*wid 0 wid 1]);	
	hAx(k) = handle(gca);
	hIm(k) = handle(imshow(vidOutput.(vonames{k})(1).cdata,...
		'DisplayRange', [imin(k) imax(k)],...
		'Parent',hAx(k)));
	hText(k) = handle(text(100,20,sprintf('%s frame: 1',vonames{k})));
	whitebg('k')
end

%% MOVIE
for k=1:nFrames
	for vonum=1:numel(vonames)
		hIm(vonum).CData = vidOutput.(vonames{vonum})(k).cdata;
		hText(vonum).String = sprintf('%s frame %i',vonames{vonum},k);
	end
	drawnow
end