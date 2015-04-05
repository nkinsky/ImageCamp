function playVidStruct(vid)

% DISPLAY/COMPARE
nFrames = numel(vid);
imin = min(vid(nFrames).cdata(:));
imax = max(vid(nFrames).cdata(:));
nFrames = min(numel(vid), nFrames);
hFig = handle(figure(1));
hFig.Units = 'normalized';
axes('parent',hFig,'position', [0 0 1 1]);
hAx = handle(gca);
hIm = handle(imshow(vid(1).cdata,...
	'DisplayRange', [imin imax],...
	'Parent',hAx));
hText = handle(text(100,20,sprintf('Frame: 0/%i',nFrames)));
whitebg('k')

% MOVIE
for k=1:nFrames
	hIm.CData = vid(k).cdata;
	hText.String = sprintf('Frame %i/%i',k,nFrames);
	drawnow
end
close(hFig)


% t = timer('ExecutionMode','fixedRate',...
% 	'BusyMode','drop',...
% 	'TasksToExecute',nFrames,...
% 	'TimerFcn',@nextFrame,...
% 	'Period',1/fps);
% set(gcf,'CloseRequestFcn','stop(t),delete(t)')
% hTitle = title(sprintf('frame %g of %g',1,nFrames));
% start(t)


% 	function nextFrame(obj,evnt)
% 		frameNum = obj.TasksExecuted + 1;
% 		vp.step(imadjust(vid(frameNum).cdata,[imLow imHigh]));
% 	end
% end