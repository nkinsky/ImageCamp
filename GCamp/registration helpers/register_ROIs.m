function [ ROIs_reg ] = register_ROIs(ROIs_in, input1, input2 )
% ROIs_reg = register_ROIs(ROIs_in, ...)
%   Takes all the neuron ROIs in ROIs_in (a cell array) and registers them
%   to a different session using the either of the following inputs:
%       - ...RegistrationInfoX): contains tform and base_ref, OR
%       - ...tform,base_ref): direct input of tform and base_ref

if nargin == 2
    tform = input1.tform;
    base_ref = input1.base_ref;
elseif nargin == 3
    tform = input1;
    base_ref = input2;
end

ROIs_reg = cellfun(@(a) imwarp_quick(a, tform, base_ref),ROIs_in,...
    'UniformOutput',0);

end

