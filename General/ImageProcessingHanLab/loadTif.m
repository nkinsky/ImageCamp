function f = loadTif(varargin)
% same as loadTifStacks

% PROCESS ARGUMENTS (fileName) OR ASK TO PICK FILE
if nargin
	fname = varargin{1};
	switch class(fname)
		case 'char'
			fileName = cellstr(fname);
		case 'cell'
			for n = 1:numel(fname)
				fileName{n} = which(fname{n});
			end
	end
else
	[fname,fdir] = uigetfile('*.tif','MultiSelect','on');
	switch class(fname)
		case 'char'
			fileName{1} = [fdir,fname];
		case 'cell'
			for n = 1:numel(fname)
				fileName{n} = [fdir,fname{n}];
			end
	end
end

% GET INFO FROM EACH TIF FILE
for n = 1:numel(fileName)
	tifFile(n).fileName = fileName{n};
	tifFile(n).tifObj = Tiff(fileName{n},'r');
	tifFile(n).vidInfo = imfinfo(fileName{n});
	tifFile(n).nFrames = numel(tifFile(n).vidInfo);
	tifFile(n).firstFrame = tifFile(n).tifObj.read();
	tifFile(n).frameSize = size(tifFile(n).firstFrame);
end
nTotalFrames = sum([tifFile(:).nFrames]);
lastFrameIndices = cumsum([tifFile(:).nFrames]);
firstFrameIndices = [0 lastFrameIndices(1:end-1)]+1;

% PREINSTANTIATE STRUCTURE ARRAY FOR IMAGE DATA
blankFrame = zeros(tifFile(1).frameSize, 'uint16');
f = struct('cdata',repmat({blankFrame},nTotalFrames,1),...
	'frame',repmat({0},nTotalFrames,1),...
	'subframe',repmat({0},nTotalFrames,1),...
	'info',repmat({tifFile(1).vidInfo(1)},nTotalFrames,1),...
	'colormap',[],...
	'timestamp',struct('hours',NaN,'minutes',NaN,'seconds',NaN));

% GATHER DATA FROM TIF-FILES
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning')
warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning
h = waitbar(0,  sprintf('Loading frame %g of %g (%f secs/frame)',0,nTotalFrames,0));
for n = 1:numel(tifFile)
	try
		firstFrame = firstFrameIndices(n);
		lastFrame = lastFrameIndices(n);
		tic
		subk = 1;
		tifInfo = tifFile(n).vidInfo;
		for k = firstFrame:lastFrame
			f(k).cdata = tifFile(n).tifObj.read();
			f(k).frame = k;
			f(k).subframe = subk;
			f(k).info = tifInfo(subk);
			try
				f(k).timestamp = getHcTimeStamp(f(k).info);
			catch me
			end
			f(k).colormap = [];
			waitbar(k/nTotalFrames, h, ...
				sprintf('Loading frame %g of %g (%f secs/frame)',k,nTotalFrames,toc));
			tic
			if tifFile(n).tifObj.lastDirectory()
				break
			else
				tifFile(n).tifObj.nextDirectory();
				subk = subk+1;
			end
		end
		close(tifFile(n).tifObj);
	catch me
		disp(me.message)
		if nargout==0
			assignin('base','vid',f);
		end
		close(tifFile(n).tifObj);
		return
	end
end
close(h)

if nargout==0
	assignin('base','vid',f);
end









