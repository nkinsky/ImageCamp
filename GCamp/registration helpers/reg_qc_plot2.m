function [ ] = reg_qc_plot2( Animal, base_date, base_session, reg_date, reg_session, varargin  )
% reg_qc_plot2( Animal, base_date, base_session, reg_date, reg_session, ... )
%   Wrapper function for reg_qc_batch for one session - same function, different inputs.
%   See reg_qc_plot and neuron_reg_qc for optional arguments

base_struct.Animal = Animal;
base_struct.Date = base_date;
base_struct.Session = base_session;
reg_struct.Animal = Animal;
reg_struct.Date = reg_date;
reg_struct.Session = reg_session;

reg_qc_plot_batch(base_struct, reg_struct, varargin{:})

end

