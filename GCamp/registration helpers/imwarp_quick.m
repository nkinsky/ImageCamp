function [ im_out ] = imwarp_quick( im_in, input1, input2)
% [ im_out ] = imwarp_quick( im_in, ... )
%   Quick way to use imwarp with default properties.  First input is image
%   you wish to transform.  The following inputs can be of the form:
%       - ...RegistrationInfoX): contains tform and base_ref, OR
%       - ...tform,base_ref).

if nargin == 2
    tform = input1.tform;
    base_ref = input1.base_ref;
elseif nargin == 3
    tform = input1;
    base_ref = input2;
end
im_out = imwarp(im_in,tform,'OutputView',...
        base_ref,'InterpolationMethod','nearest');

end

