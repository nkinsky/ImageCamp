function [ROIavg] = MakeAvgROI(NeuronImage,NeuronAvg)
% MakeAvgROI(NeuronImage,NeuronAvg)
%
%   Makes Avg an average pixel intensity ROI for each neuron 

    nNeurons = length(NeuronImage);
    ROIavg = cell(1,nNeurons);
    for n=1:nNeurons
        ROIavg{n} = NeuronImage{n};
        ROIavg{n}(logical(NeuronImage{n})) = NeuronAvg{n};
    end
    
%     save('MeanBlobs.mat','BinBlobs');
end

