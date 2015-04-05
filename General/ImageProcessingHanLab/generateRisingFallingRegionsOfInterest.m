function bwvid = generateRisingFallingRegionsOfInterest(vid)
% (expects vid.cdata holds uint8 cdata)

% SUBTRACT BACKGROUND/BASELINE IF NOT DONE ALREADY
if ~isfield(vid(1), 'backgroundMean')
	vid = normalizeVidStruct2Region(vid);
end
% APPLY SMOOTHING FILTER IN TIME DOMAIN TO STABILIZE SIGNAL
if ~isfield(vid, 'issmoothed') 
	vid = tempSmoothVidStruct(vid, 2); % windowsize = 1+2(2) = 5;
end

% GET SAMPLE TO BEGIN MOVING AVERAGE
N = numel(vid);
frameSize = size(vid(1).cdata);
H = fspecial('gaussian',[21 21], 4);
Sdisk = strel('disk',4);
tailWinSize = 50;
xRisingStd = 3;
xFallingStd = 3;
tailWinMat = gpuArray(cat(3,vid(1:tailWinSize).cdata));
tailWinMat = imfilter(single(tailWinMat), H);
tailFrameDiffMat = cat(3, abs(diff(tailWinMat,[], 3)));
tailStDev = mean(tailFrameDiffMat, 3);
rgbImage = cat(3,vid([1 round(N/2) N]).cdata);
hImage = handle(imshow(rgbImage));
hText(1) = handle(text(10,30,'Falling Edge', 'Color','b'));
hText(2) = handle(text(10,10,'Rising Edge', 'Color','r'));
vidSample = getVidSample(vid,500);
minImage = min(cat(3,vidSample.cdata),[],3);
% downCounter = 25;
t = hat;
for k = 1:N	
	try
		fprintf('Assessing TEMPORAL-REGIONAL Signal in Frame #%i (%f secs-per-frame)\n',k, hat-t);
		t = hat;
		bwFrame = vid(k).cdata > (minImage+50);
		bwvid(k).bwoc = imclose(imopen(bwFrame, strel('disk',6,8)), strel('disk',3,8));
		bwvid(k).bwcc = getCC(bwvid(k).bwoc);
		% SKIP FIRST 100 FRAMES
		if k <= tailWinSize
			bwvid(k).bwRisingEdge = false(frameSize);
			bwvid(k).bwFallingEdge = false(frameSize);
			bwvid(k).tailStDev = gather(tailStDev);
			continue
		end
		% FILTER CURRENT FRAME
		frame = gpuArray(vid(k).cdata);		
		frame = imfilter(single(frame), H);
		% COMPUTE MEAN AND STANDARD DEVIATION OF TRAILING WINDOW
		%	(putting 2 frames between current frame and trailing window to mitigate temporal-averaging)
		tailMean = mean(tailWinMat(:,:,1:end-2), 3);	
		tailStDev = mean(tailFrameDiffMat(:,:,1:end-2), 3);
		% COMPUTE CHANGE IN FLUORESCENCE FOR CURRENT FRAME
		frameDiff = frame - tailMean;		
		% MAKE BINARY MASK MARKING REGIONS OF SIGNIFICANT FLUORESCENCE CHANGE				
		[bwRisingEdge, xRisingStd] = markSignificantChange( frameDiff, tailStDev, xRisingStd, 'rising');
		[bwFallingEdge, xFallingStd] = markSignificantChange( frameDiff, tailStDev, xFallingStd, 'falling');
		% BINARY MORPHOLOGICAL OPERATIONS
		bwRisingEdge = imopen(imfill(bwRisingEdge,'holes'),Sdisk);	%	25msec/call
		bwFallingEdge = imopen(imfill(bwFallingEdge,'holes'),Sdisk);
		% RETRIEVE BINARY MATRICES FROM VIDEO CARD
		bwRE = gather(bwRisingEdge);
		bwFE = gather(bwFallingEdge);
		% REMOVE BINARY REGIONS MUCH SMALLER THAN A CELL AND FROM BORDER
		bwRE = bwareaopen(bwRE,150);
		bwFE = bwareaopen(bwFE,150);
		bwRE = imclearborder(bwRE);
		bwFE = imclearborder(bwFE);
		% EVALUATE CONNECTED COMPONENTS		
		bwvid(k).conRegRising = getCC(bwRE);
		bwvid(k).conRegFalling = getCC(bwFE);		
		
		
		

		% GATHER & ASSESS
		bwvid(k).bwRisingEdge = bwRE;
		bwvid(k).bwFallingEdge = bwFE;
		bwvid(k).tailStDev = gather(tailStDev);		
		% UPDATE TRAILING WINDOW MATRICES OF FRAMES AND dFRAMES (like 1st & 2nd moment?)
		tailWinMat = cat(3, tailWinMat(:,:, 2:end), frame);
		tailFrameDiffMat = cat(3, tailFrameDiffMat(:,:, 2:end), abs(frameDiff));
		
		% SHOW DETECTED RISING/FALLING EDGE ROIS
		% 		if downCounter <1
		% 			downCounter = 25;
		% 			imshowpair(vid(k).cdata, imfuse(bwvid(k).bwRisingEdge, bwvid(k).bwFallingEdge), 'blend');	%	380msec/call
		rgbImage = cat(3, im2uint8(bwvid(k).bwRisingEdge), vid(k).cdata, im2uint8(bwvid(k).bwoc));
		hImage.CData = rgbImage;
		drawnow
		% 		else
		% 			downCounter = downCounter-1;
		% 		end
	catch me
		keyboard
	end
end
% bwrL = bwlabeln(cat(3, bwvid.bwRisingEdge));

% FUNCTION TO MAKE BINARY MASK WITH ADAPTIVE THRESHOLD
function [bwEdge, xStd] = markSignificantChange( diffImage, stDevImage, xStd, markRisingOrFalling)
coverageMaxRatio = .10;
coverageMinPixels = 50;
thresholdStep = .1;
switch lower(markRisingOrFalling)
	case 'rising'
		bwEdge = diffImage > (stDevImage * xStd);
	case 'falling'
		bwEdge = diffImage < -(stDevImage * xStd);
	otherwise
		warning('Need to indicate RISING or FALLING edge')
		return
end
% CHECK FOR OVER/UNDER-THRESHOLDING
binaryCoverage = sum(bwEdge(:))/sum(~bwEdge(:));
if binaryCoverage > coverageMaxRatio
	xStd = xStd + thresholdStep;
	fprintf('\t+++++increasing difference threshold for %s-edge detection to %g\n',markRisingOrFalling,xStd)
	[bwEdge, xStd] = markSignificantChange(diffImage, stDevImage, xStd, markRisingOrFalling);	
elseif binaryCoverage < coverageMinPixels/numel(bwEdge)
	xStd = xStd - thresholdStep;
	fprintf('\t-----reducing difference threshold for %s-edge detection to %g\n',markRisingOrFalling,xStd)
	[bwEdge, xStd] = markSignificantChange(diffImage, stDevImage, xStd, markRisingOrFalling);
else
	fprintf('\tDifference threshold for %s-edge detection is %g\n',markRisingOrFalling,xStd)
end



function conStruct = getCC(sbinary)
		cc = bwconncomp(sbinary);
		L = labelmatrix(cc);
		c = regionprops(cc,'Centroid', 'BoundingBox','Area');
		[~,idx] = sort([c.Area]);
		c = c(fliplr(idx));
		conStruct.regionProp = c;
		conStruct.labelMat = L;



% REGIONPROPS		
%	 	'Area'              'EulerNumber'       'Orientation'               
%       'BoundingBox'       'Extent'            'Perimeter'          
%       'Centroid'          'Extrema'           'PixelIdxList' 
%       'ConvexArea'        'FilledArea'        'PixelList'
%       'ConvexHull'        'FilledImage'       'Solidity' 
%       'ConvexImage'       'Image'             'SubarrayIdx'            
%       'Eccentricity'      'MajorAxisLength' 
%       'EquivDiameter'     'MinorAxisLength'                   
      
%       'MaxIntensity'
%       'MeanIntensity'
%       'MinIntensity'
%       'PixelValues'
%       'WeightedCentroid'




% SUPPRESS LARGE objects in image
% imtophat(vid(1000).cdata, strel('disk',15))
%
%
%
% 	try
% 	imbw = gpuArray(dsvid(k).cdata > dsimpc(:,:,sigPercentile));
% 	imbw = imopen(imfill(imbw,'holes'),se);
% 	bwCoverage = sum(imbw(:))/sum(~imbw(:));
% 	fprintf('Finding ROI for frame %i\n',k)
% 	while bwCoverage < cellMinCoverage
% 		sigPercentile = sigPercentile - 1;
% 		if sigPercentile < 50
% 			sigPercentile = 80;
% 			break
% 		end
% 		fprintf('\tSetting sigPercentile to %i\n',sigPercentile)
% 		imbw = dsvid(k).cdata > dsimpc(:,:,sigPercentile);
% 		imbw = imopen(imfill(imbw,'holes'),se);
% 		bwCoverage = sum(imbw(:))/sum(~imbw(:));
% 	end
% 	while bwCoverage > cellMaxCoverage
% 		sigPercentile = sigPercentile + 1;
% 		if sigPercentile > size(dsimpc,3)
% 			sigPercentile = 95;
% 			break
% 		end
% 		fprintf('\tSetting sigPercentile to %i\n',sigPercentile)
% 		imbw = dsvid(k).cdata > dsimpc(:,:,sigPercentile);
% 		imbw = imopen(imfill(imbw,'holes'),se);
% 		bwCoverage = sum(imbw(:))/sum(~imbw(:));
% 	end
% 	dsvid(k).bdata = gather(imbw);
% 	imshowpair(dsvid(k).bdata,dsvid(k).cdata)
% 	drawnow
% 	catch me
% 		keyboard
% 	end
%
% end