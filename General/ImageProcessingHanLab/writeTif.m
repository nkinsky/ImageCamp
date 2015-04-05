function writeTif(imStack,varargin)
if nargin>1
	fileName = varargin{1};
else
	[fileName, fileDir] = uiputfile('*.tif','Please choose filename and location for TIFF file','imstack.tif');
	fileName = fullfile(fileDir,fileName);
end
t = Tiff(fileName,'w8');
try
imFrame = imStack(1).cdata;

tagstruct.ImageLength = size(imFrame,1);
tagstruct.ImageWidth = size(imFrame,2);
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = 16;
tagstruct.SamplesPerPixel = 1;
tagstruct.RowsPerStrip = size(imFrame,1);
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software = 'MATLAB';


t.setTag(tagstruct)
t.write(imFrame)
tic
for k = 2:numel(imStack)
    fprintf('writing frame %g of %g\n',k,numel(imStack));
    t.writeDirectory();
    t.setTag(tagstruct);
    imFrame = imStack(k).cdata;
    t.write(imFrame);
% 	t.nextDirectory
end
t.close;
toc

catch me
	disp(me.message)
	t.close
	disp('failure')
end