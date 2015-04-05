function ROI = generateRegionsOfInterest(vid)
% INPUT: 
%	Expects vid.cdata with cdata datatype = 'uint8'
% OUTPUT:
%	Array of objects of the 'RegionOfInterest' class, resembling a RegionProps structure
%	(Former Output)
%	Returns structure array, same size as vid, with fields
%			bwvid = 
%				RegionProps: [12x1 struct]
%				bwMask: [1024x1024 logical]

% SUBTRACT BACKGROUND/BASELINE IF NOT DONE ALREADY
if ~isfield(vid(1), 'backgroundMean')
	vid = normalizeVidStruct2Region(vid);
end
% APPLY SMOOTHING FILTER IN TIME DOMAIN TO STABILIZE SIGNAL
if ~isfield(vid, 'issmoothed')
	vid = tempSmoothVidStruct(vid, 2); % windowsize = 1+2(2) = 5;
end

% GET SAMPLE AND DEFINE FILTERS
N = numel(vid);
frameSize = size(vid(1).cdata);
minRoiPixArea = 50;
% H = fspecial('gaussian',[21 21], 4);
S.disk6 = strel('disk',6,8);
S.disk5 = strel('disk',5,8);
S.disk4 = strel('disk',4,8);
S.disk4 = strel('disk',4,8);
S.disk3 = strel('disk',3,8);
rgbImage = cat(3,vid([1 round(N/2) N]).cdata);
h.im = handle(imshow(rgbImage));
h.ax = handle(gca);
h.ax.DrawMode = 'fast';
t=hat;
h.text(1) = handle(text(10,10,sprintf('Assessing TEMPORAL-REGIONAL Signal in Frame #%i (%f secs-per-frame)\n',1, hat-t), 'Color','r'));
h.text(2) = handle(text(10,30,'Falling Edge', 'Color','b'));
stat = getVidStats(vid);
% stat.StdPerc = prctile(double(stat.Std(:)), 1:100);
signalThreshold = stat.Min + uint8(stat.Std.*1.5);
% BEGIN OUTPUT STRUCTURE
[bwmask, signalThreshold] = getAdaptiveHotspots(vid(1).cdata, signalThreshold);
bwvid.bwMask = bwmask;
bwvid.RegionProps = getRegionProps(bwmask);
ROI = RegionOfInterest(bwvid);
set(ROI, 'Frames', 1);
t = hat;
for k = 2:N
	try
		h.text(1).String = sprintf('Assessing TEMPORAL-REGIONAL Signal in Frame #%i (%f secs-per-frame)\n',k, hat-t);
		t = hat;
		% GET HOTSPOT-BASED ROIS
		[bwmask, signalThreshold] = getAdaptiveHotspots(vid(k).cdata, signalThreshold);
		bwvid.bwMask = bwmask;
		% EVALUATE CONNECTED COMPONENTS
		bwRP = getRegionProps(bwmask);
		bwRP = bwRP([bwRP.Area] > minRoiPixArea);	%	Enforce minimum size
		bwvid.RegionProps = bwRP;		
		% FILL ROI OBJECTS
		frameROI = RegionOfInterest(bwvid);
		set(frameROI,'Frames',k);
		ROI = cat(1,ROI, frameROI);
		% SHOW DETECTED ROIS
		rgbImage = cat(3,...
			zeros(frameSize,'uint8'),...
			vid(k).cdata,...
			im2uint8(bwmask));
		% 		bw = imcomplement(bwvid.bwoc);
		% 		imshow(cat(3, zeros(size(bw),'uint8'), vid(k).cdata , uint8(bw)*180))
		h.im.CData = rgbImage;
		drawnow
	catch me
		disp(me.message)
		keyboard
	end
end






% ------------ SUBFUNCTIONS -------------------
	function [bw, sigThresh]  = getAdaptiveHotspots(diffImage, sigThresh)
		% FUNCTION TO MAKE BINARY MASK WITH ADAPTIVE THRESHOLD
		coverageMaxRatio = .01;
		coverageMinPixels = 150;
		thresholdStep = 1;
		% PREVENT RACE CONDITION OR NON-SETTLING THRESHOLD
		persistent depth
		if isempty(depth)
			depth = 0;
		else
			depth = depth + 1;
		end
		if depth > 256
			warning('256 iterations exceeded')
			depth = 0;
			return
		end
		% USE THRESHOLD TO MAKE BINARY IMAGE AND APPLY MORPHOLOGICAL OPERATIONS
		bw = diffImage > sigThresh;
		bw = imclose(imopen( bw, S.disk6), S.disk4);
		% CHECK FOR OVER/UNDER-THRESHOLDING
		numPix = numel(bw);
		sigThreshPix = sum(bw(:));
		binaryCoverage = sigThreshPix/numPix;
		if binaryCoverage > coverageMaxRatio
			sigThresh = sigThresh + thresholdStep;
			h.text(2).String = sprintf('\t+ + + + Increasing signal threshold for HotSpot detection to %g\t(binary-coverage: %0.3f)\n',...
				max(sigThresh(:)), binaryCoverage);
			[bw, sigThresh]  = getAdaptiveHotspots(diffImage, sigThresh);
		elseif sigThreshPix < coverageMinPixels
			sigThresh = sigThresh - thresholdStep;
			h.text(2).String = sprintf('\t- - - - Decreasing signal threshold for HotSpot detection to %g\t(signal-pixels: %g)\n',...
				max(sigThresh(:)), sigThreshPix);
			[bw, sigThresh]  = getAdaptiveHotspots(diffImage, sigThresh);
		else
			% 	fprintf('\tSignal Threshold: %g\tCoverage: %0.3f\tPixels: %g\n',...
			% 		max(sigThresh(:)), binaryCoverage, sigThreshPix)
			depth = 0;
		end
	end

	function c = getRegionProps(sbinary)
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
		% 		cc = bwconncomp(sbinary);
		% 		L = labelmatrix(cc);
		c = regionprops(sbinary,...
			'Centroid', 'BoundingBox','Area',...
			'Eccentricity', 'PixelIdxList');
	end




end



























