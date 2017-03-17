function [ reg_stats] = neuron_reg_qc2( Animal, base_date, base_session, reg_date, reg_session, varargin )
% reg_stats = neuron_reg_qc2( Animal, base_date, base_session, reg_date, reg_session, varargin )
%   Calculates registration statistics between two sessions.  Wrapper
%   function for neuron_reg_qc - see that for full documentation and
%   optional inputs

base_struct.Animal = Animal;
base_struct.Date = base_date;
base_struct.Session = base_session;
reg_struct.Animal = Animal;
reg_struct.Date = reg_date;
reg_struct.Session = reg_session;

reg_stats = neuron_reg_qc( base_struct, reg_struct, varargin{:});


end

