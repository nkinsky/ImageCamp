function subStack = loadTifResizeCatParFilt(varargin)

% imScale = .5;
filtSize = 50;

% PROCESS ARGUMENTS (fileName) OR ASK TO PICK FILE
if nargin
    fname = varargin{1};
    for n = 1:numel(fname)
        fileName{n} = which(fname{n});
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
	tifFile(n).firstFrame = imresize(tifFile(n).tifObj.read(),imScale);
    tifFile(n).frameSize = size(tifFile(n).firstFrame);
    close(tifFile(n).tifObj);
end
nTotalFrames = sum([tifFile(:).nFrames]);
lastFrameIndices = cumsum([tifFile(:).nFrames]);
firstFrameIndices = [0 lastFrameIndices(1:end-1)]+1;

% CONSTRUCT FILTER COMPONENTS
vidSample.meanImage = mean(im2single(cat(3,tifFile(:).firstFrame)),3);
vidSample.meanValue = mean(vidSample.meanImage(:));
vidHomFilt.h = fspecial('average',filtSize);
vidHomFilt.io = log(vidSample.meanValue);
vidHomFilt.lp = imfilter(log(vidSample.meanImage),vidHomFilt.h,'replicate');
%filtim = exp(log(im2single(im)) - vidHomFilt.lp + vidHomFilt.io);


% PREINSTANTIATE ARRAYS FOR IMAGE DATA
blankFrame = zeros(tifFile(1).frameSize, 'uint16');
for n = 1:numel(tifFile)
    nSubFrames = tifFile(n).nFrames;
    subStack{n,1} = struct('cdata',repmat({blankFrame},nSubFrames,1),...
        'frame',repmat({0},nSubFrames,1),...
        'subframe',repmat({0},nSubFrames,1),...
        'info',repmat({tifFile(1).vidInfo(1)},nSubFrames,1),...
        'colormap',[]);
end
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning')
warning('off','MATLAB:imagesci:Tiff')
tic

% GATHER DATA FROM TIF-FILES IN PARALLEL
parfor n = 1:numel(tifFile)    
    warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning')
    warning('off','MATLAB:imagesci:Tiff')
    tifObj = Tiff(fileName{n},'r')
    firstFrame = firstFrameIndices(n);
    lastFrame = lastFrameIndices(n);
    nSubFrames = tifFile(n).nFrames;
    fprintf('Loading frames %g to %g from %s\n',firstFrame,lastFrame,tifFile(n).fileName);
    f = subStack{n,1};
    tic
    for k = 1:nSubFrames
        imFrame = imresize(tifObj.read(),imScale);
        f(k).cdata = im2uint16(exp(log(im2single(imFrame)) - vidHomFilt.lp + vidHomFilt.io));
        f(k).frame = firstFrame+k-1;
        f(k).subframe = k;
        f(k).info = tifFile(n).vidInfo(k);
        f(k).colormap = [];        
        fprintf('\tLoading frame %g in substack %g (%0.3f secs/frame)\n',firstFrame+k-1,n,toc);
        tic
        if tifObj.lastDirectory()
            subStack{n,1} = f;
        else
            tifObj.nextDirectory();
        end
    end    
end
totalTime = toc;
fprintf('Finished in %0.3f seconds (%0.3f frames/sec)\n',totalTime,nTotalFrames/totalTime)

subStack = cat(1,subStack{:});
if nargout==0
    assignin('base','vid',subStack);
end

