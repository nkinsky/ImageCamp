avi = false;
if avi
	[fname,fpath] = uiputfile('*.avi','Please choose a folder and file-name for avi-video');
	fileName = fullfile(fpath,fname);
end
tLast = hat;
% waitfor(msgbox('Select a Region of Interest'))
% 	[~, crFixed] = imcrop(imadjust(im2single(vid(1).cdata)));
% 	close(gcf)
% 	drawnow
% crFixed = [442.51, 484.51, 40.98, 43.98];


%% LOAD TIFF FILE
vid = loadTif; %38ms/f
% vid = loadTifPar; %40fps loading 4 files
N = numel(vid);
nSampleFrames = min(N, 100);
nominalVidMax = max(max(cat(1,vid(round(linspace(1,N,nSampleFrames))).cdata),[],2),[],1);
safeScaleFactor = round(.9 * 65535/max(vid(1).cdata(:)));
t.load = hat - tLast;
tLast = hat;

%% PRE-FILTER WITH FAST HOMOMORPHIC FILTER (REMOVE UNEVEN ILLUMINATION)
vidHomFilt = generateHomomorphicFilters(vid);	
t.genPreFilter = hat - tLast;
tLast = hat;

vid = applyHomomorphicFilters(vid, vidHomFilt);	%	6ms/f
t.applyPreFilter = hat - tLast;
tLast = hat;


%% CORRECT FOR MOTION (IMAGE STABILIZATION)
motCorPoints = 10;
c = highEntropyCentroids(vid, motCorPoints);
% for k = 1:numel(c)	
% 	xcMulti(k,:) = generateXcOffset(vid, c(k).BoundingBox);	
% end
% keyboard
% xc =
% xc = generateXcOffset(vid, crFixed); % 85ms/f TODO: automate roi selection
xc = generateXcOffset(vid, c.BoundingBox);
% fn = fields(xc);
% for k=1:numel(xcc)
% xck = xcc{k}; 
% for n=1:3
% xc6.(fn{n})(:,k)=cat(1,xck.(fn{n}))
% end
% end
t.genMotionOffset = hat - tLast;% 80ms/f
tLast = hat;

vid = applyXcOffset(vid,xc); %	8ms/f
t.applyMotionOffset = hat - tLast;
tLast = hat;

%% POST-FILTER WITH SLOW HOMOMORPHIC FILTER (MOTION-INDUCED ILLUMINATION)
vid = slowHomomorphicFilter(vid); %	27ms/f
t.postFilter = hat - tLast;
tLast = hat;

%% SAVE TO AVI OR H-264 ENCODED FILE
if avi
	writeVidStruct2Avi(vid,fileName) %	39ms/f
	t.write2Avi = hat - tLast;
end

%% CONVERT BACK TO UINT16
% vid = vidStruct2uint16(vid);

%% STATISTICS OF EACH FRAME (MIN, MEAN, MAX)
% vid = generateStats(vid);
impc = prctile(cat(3,vid(round(linspace(1,numel(vid),min(300,numel(vid))))).cdata),1:99,3);

%%	difference image
dsvid = tempSmoothVidStruct(vid, 5);
dsvid = generateDifferenceImage(dsvid,impc);

% dsimpc = prctile(cat(3,dsvid(round(linspace(1,numel(dsvid),min(300,numel(dsvid))))).cdata),1:99,3);
% dsimpc = prctile(cat(3,dsvid.cdata),1:100,3);

%% ROIs
% p90 = dsimpc(:,:,90);
% lev = mean(p90(:));
% cellMinCoverage = .0025;
% cellMaxCoverage = .05;
% sigPercentile = 95;
% se = strel('disk', 3);
% for k = 1:numel(dsvid)
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



	
	
	
	
	
	
	
	
	
	
	
	
% clearvars -except vid dvid	xc t

	



	
	
	
	

