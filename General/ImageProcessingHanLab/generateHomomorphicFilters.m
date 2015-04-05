function vidHomFilt = generateHomomorphicFilters(vidInput, varargin)
% 
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
if isstruct(vidInput)
	N = numel(vidInput);
	nSampleFrames = min(N, 1000);
	vidInput = cat(3, vidInput( round(linspace(1,N,nSampleFrames)) ).cdata );
else
	N = size(vidInput,3);
	nSampleFrames = min(N, 1000);
	vidInput = vidInput(:,:, round(linspace(1,N,nSampleFrames)) );
end
if nargin>1
	filtSize = varargin{1};
else
	filtSize = round(size(vidInput,1)/10);
end

%% GET MEAN (OR MIN...) IMAGE FROM SUPPLIED SAMPLE OF FRAMES
vidHomFilt.minImage = mean( prctile(single(vidInput), 5, 3), 3);
vidHomFilt.minValue = min(vidHomFilt.minImage(:));
% vidHomFilt.minImage = im2single(min(vidInput,[],3));
% vidHomFilt.minValue = mean(vidHomFilt.minImage(:));

% USE MEAN TO DETERMINE A SCALAR/EVEN ILLUMINATION INTENSITY IN LOG DOMAIN
vidHomFilt.io = log(vidHomFilt.minValue);

% LOWPASS-FILTER IN LOG-DOMAIN TO REMOVE UNEVEN ILLUMINATION
vidHomFilt.h = fspecial('average',filtSize);
try
	vidHomFilt.lp = imfilter(log(vidHomFilt.minImage),vidHomFilt.h,'replicate');
catch me
	keyboard
end

% FOR EFFICIENCY SUBTRACT THE SAME LOWPASS IMAGE REPRESENTING UNEVEN ILLUMINATION

%filtim = exp(log(im2single(im)) - vidHomFilt.lpMean + vidHomFilt.ioMean);
