function [ im_out ] = imwarp_quick( im_in, RegistrationInfoX )
% [ im_out ] = imwarp_quick( im_in, RegistrationInfoX )
%   Detailed explanation goes here

im_out = imwarp(im_in,RegistrationInfoX.tform,'OutputView',...
    RegistrationInfoX.base_ref,'InterpolationMethod','nearest');

end

