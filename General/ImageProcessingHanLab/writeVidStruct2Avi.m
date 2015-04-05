function writeVidStruct2Avi(vid,varargin)

upperSat = .999;
lowerSat = .05;
fps = 60;
if nargin > 1
	fileName = varargin{1};
else
	[fname,fpath] = uiputfile('*.avi','Please choose a folder and file-name for avi-video');
	fileName = fullfile(fpath,fname);
end

% GET LOW AND HIGH LIMITS FROM SAMPLE FRAMES
nFrames = numel(vid);
sampleIndices = round(linspace(1,nFrames,min(1000,nFrames)));
for n = 1:numel(sampleIndices)
    k = sampleIndices(n);
    sl(:,n) = stretchlim(vid(k).cdata,[lowerSat upperSat]);
end
imLow = min(sl(1,:));
imHigh = max(sl(2,:));
% vidMax = max(cat(3,vid(:).cdata),[],3);
% vidMin = min(cat(3,vid(:).cdata),[],3);
% slMax = stretchlim(vidMax,[lowerSat upperSat]);
% slMin = stretchlim(vidMin,[lowerSat upperSat]);


vidWriteObj = VideoWriter(fileName,'Grayscale Avi');
vidWriteObj.FrameRate = fps;
vidWriteObj.open

N=numel(vid);
h = waitbar(0,  sprintf('Writing frame %g of %g (%f secs/frame)',1,N,0));
tic
for k = 1:N
    f.cdata = im2single(imadjust(vid(k).cdata,[imLow imHigh]));
    f.colormap = [];
    writeVideo(vidWriteObj,f)
	waitbar(k/N, h, ...
		sprintf('Writing frame %g of %g (%f secs/frame)',k,N,toc));
	tic
end
delete(h)

close(vidWriteObj)