fileName = 'Ali9_Filtered_2x2Spatial2xTemporalBin.tif';
t = Tiff(fileName,'w8');
try
tempBin = 2;
imframe = uint16(sum(cat(3,subStack(1:tempBin).cdata),3));

tagstruct.ImageLength = size(imframe,1);
tagstruct.ImageWidth = size(imframe,2);
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = 16;
tagstruct.SamplesPerPixel = 1;
tagstruct.RowsPerStrip = size(imframe,1);
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software = 'MATLAB';


t.setTag(tagstruct)
t.write(imframe)
tic
fprintf('writing %g binned by %g frames to %s - %0.6g',numel(subStack),tempBin,fileName,1);
for k = tempBin+1:tempBin:numel(subStack)-tempBin+1;
    fprintf('%0.6g\n',k);
    t.writeDirectory();
    t.setTag(tagstruct);
    imframe = uint16(sum(cat(3,subStack(k:k+tempBin-1).cdata),3));
    t.write(imframe);
end
t.close;
toc

catch me
	disp(me.message)
	t.close
	disp('failure')
end