function [image_out ] = imwarp_NK( image_in, RegistrationInfoX )
% [im_out ] = imwarp_NK( im_in, RegistrationInfoX )
%
%imwarp function with super easy inputs - takes the neurons image, and
%RegistrationInfoX, and that's it!

image_out = imwarp(image_in,RegistrationInfoX.tform,'OutputView',...
                RegistrationInfoX.base_ref,'InterpolationMethod','nearest');

end

