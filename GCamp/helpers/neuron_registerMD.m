function [ neuron_map ] = neuron_registerMD( MDbase, MDreg, varargin )
% neuron_map = neuron_registerMD( MDbase, MDreg, ... )
%   registers MDreg to MD base usin neuron_register

neuron_map = neuron_register(MDbase.Animal, MDbase.Date, MDbase.Session,...
    MDreg.Date, MDreg.Session, varargin{:});

end

