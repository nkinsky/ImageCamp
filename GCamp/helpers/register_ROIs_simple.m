function [ ROIs1, ROIs2 ] = register_ROIs_simple( MD1, MD2, name_append )
% [ ROIs1, ROIs2 ] = register_ROIs_simple( MD1, MD2, varargin )
%   Registers all ROIs in MD2 to MD1 so that you can overlay them.
%  name_append is appended to the image registration file calculated using
%  image_registerX.

sesh = MD1; sesh(2) = MD2; % Dump into same structure array
sesh = complete_MD(sesh); % Fill in fields
reginfo = image_registerX(MD1.Animal, MD1.Date, MD1.Session, MD2.Date,...
    MD2.Session, 'name_append', name_append,'suppress_output',true);
for j = 1:2
   load(fullfile(sesh(j).Location,'FinalOutput.mat'),'NeuronImage');
   sesh(j).ROIs = NeuronImage;
end
ROIs_reg = register_ROIs(sesh(2).ROIs, reginfo);
ROIs1 = sesh(1).ROIs;
ROIs2 = ROIs_reg;

end

