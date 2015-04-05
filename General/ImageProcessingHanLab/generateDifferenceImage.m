function vid = generateDifferenceImage(vid, varargin)

if nargin < 2
	impc = prctile(cat(3,vid.cdata),1:99,3);
else
	impc = varargin{1};
end
N = numel(vid);
% minImage = min(cat(3,vid.cdata),[],3);
minImage = mean(impc(:,:,1:20),3);
maxImage = impc(:,:,99);
for k=1:N,
	fprintf('Diffing %i\n',k); 
% 	vid(k).cdata = imlincomb(1,vid(k).cdata, -1, minImage, 1); 
im = imlincomb(1,vid(k).cdata, -1, minImage, 0); 
vid(k).cdata = im ./ maxImage;
end
