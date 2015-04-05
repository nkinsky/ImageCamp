function playVidArray(vid, varargin)

% DISPLAY/COMPARE
nFrames = size(vid,3);
if nargin < 2
	P = [ 20 99.995];
else
	P = varargin{1};
end
if numel(P) ~=2
	P = [ 20 99.9];
	warning('vidStruct2uint16:InvalidSaturationLimits',...
		'Saturation limits set to 20th (low) and 99.9th (high) percentiles')
end
sampleFrames = unique(round(linspace(1, nFrames, 25)));
sampleVid = vid(:,:, sampleFrames);
Y = prctile(sampleVid(:), P);
imin = Y(1);
imax = Y(2);

hFig = handle(figure(1));
hFig.Units = 'normalized';
hFig.Position = [.2 .1 .6 .8];
axes('parent',hFig,'position', [0 0 1 1]);
hAx = handle(gca);
hIm = handle(imshow(vid(:,:,1),...
	'DisplayRange', [imin imax],...
	'Parent',hAx));
hText = handle(text(100,20,sprintf('Frame: 0/%i',nFrames)));
whitebg('k')

% MOVIE
for k=1:nFrames
	hIm.CData = vid(:,:,k);
	hText.String = sprintf('Frame %i/%i',k,nFrames);
	if nFrames < 100
		pause(.1)
	end
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