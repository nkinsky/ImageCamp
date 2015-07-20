function [ intact ] = RegNeuron_intact( Reg_NeuronIDs, base_struct_check, reg_struct_check )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

base_check = strcmpi(Reg_NeuronIDs(1).mouse,base_struct_check(1).Animal) & ...
    strcmpi(Reg_NeuronIDs(1).base_date,base_struct_check(1).Date) & ...
    (Reg_NeuronIDs(1).base_session == base_struct_check(1).Session);

auto_fail = length(Reg_NeuronIDs) ~= length(reg_struct_check);

if base_check == 0 || auto_fail == 1
    intact = 0;
else
    n = 0;
    for j = 1:length(reg_struct_check)
        temp = arrayfun(@(a) strcmpi(a.mouse,reg_struct_check(j).Animal) & ...
            strcmpi(a.reg_date,reg_struct_check(j).Date) & ...
            (a.reg_session == reg_struct_check(j).Session), ...
            Reg_NeuronIDs);
        n = n + sum(temp);
    end
    intact = n == length(reg_struct_check);
end

end

