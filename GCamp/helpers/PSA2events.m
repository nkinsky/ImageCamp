function [ CAeventbool ] = PSA2events( PSAbool )
% CAeventbool = PSA2events( PSAbool )
%   Takes PSAbool and spits out a similar matrix that tags only the
%   beginning of each Ca event.

num_neurons = size(PSAbool,1);
CAeventbool = false(size(PSAbool));
for j = 1:num_neurons
    epochs = NP_FindSupraThresholdEpochs(PSAbool(j,:),eps,0);
    CAeventbool(j,epochs(:,1)) = true;
end


end

