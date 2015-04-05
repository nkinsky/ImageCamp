function vid = slowHomomorphicFilter(vid,varargin)
% Implemented by Mark Bucklin 6/12/2014
% 
% FROM WIKIPEDIA ENTRY ON HOMOMORPHIC FILTERING
% Homomorphic filtering is a generalized technique for signal and image
% processing, involving a nonlinear mapping to a different domain in which
% linear filter techniques are applied, followed by mapping back to the
% original domain. This concept was developed in the 1960s by Thomas
% Stockham, Alan V. Oppenheim, and Ronald W. Schafer at MIT.
%
% Homomorphic filter is sometimes used for image enhancement. It
% simultaneously normalizes the brightness across an image and increases
% contrast. Here homomorphic filtering is used to remove multiplicative
% noise. Illumination and reflectance are not separable, but their
% approximate locations in the frequency domain may be located. Since
% illumination and reflectance combine multiplicatively, the components are
% made additive by taking the logarithm of the image intensity, so that
% these multiplicative components of the image can be separated linearly in
% the frequency domain. Illumination variations can be thought of as a
% multiplicative noise, and can be reduced by filtering in the log domain.
%
% To make the illumination of an image more even, the high-frequency
% components are increased and low-frequency components are decreased,
% because the high-frequency components are assumed to represent mostly the
% reflectance in the scene (the amount of light reflected off the object in
% the scene), whereas the low-frequency components are assumed to represent
% mostly the illumination in the scene. That is, high-pass filtering is
% used to suppress low frequencies and amplify high frequencies, in the
% log-intensity domain.[1]
%
% More info HERE: http://www.cs.sfu.ca/~stella/papers/blairthesis/main/node35.html

%% DEFINE PARAMETERS and PROCESS INPUT
if nargin>1
	filtSize = varargin{1};
else
	filtSize = round(size(vid(1).cdata,1)/5);
end
hLP = gpuArray(fspecial('average',filtSize));

N = numel(vid);
h = waitbar(0,  sprintf('Post-Filtering Frame %g of %g (%f secs/frame)',1,N,0));
tic
for k = 1:N
	vid(k).cdata = gather( filterSingleFrame( gpuArray(vid(k).cdata), hLP));
	waitbar(k/N, h, ...
		sprintf('Post-Filtering Frame %g of %g (%f secs/frame)',k,N,toc));
	tic
end
delete(h);





function im = filterSingleFrame(im, hLP)
if isinteger(im)
	im = im2single(im);
end
% USE MEAN TO DETERMINE A SCALAR/EVEN ILLUMINATION INTENSITY IN LOG DOMAIN
io = log(mean(double( im(:) )));

% LOWPASS-FILTER IN LOG-DOMAIN TO REMOVE UNEVEN ILLUMINATION
lp = imfilter(log(im),hLP,'replicate');

im = exp( imlincomb(1, log(im), -1, lp, io));
