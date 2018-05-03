function [ diff_mat ] = twoenv_entry_ang_mat( sesh1, sesh2 )
% diff_mat = twoenv_entry_ang_mat( sesh1, sesh2 )
%   Gets differences in entry angle, entry direction angle, and land
%   direction for all sessions in sesh1. If circ2square comparisons are
%   desired, then sesh1 must be all square sessions and sesh2 must be all
%   oct/circle sessions. spits out a 3 x nsesh1 x nsesh2 mat, where first
%   dimensions of the matrix contains delta_theta_enter,
%   delta_theta_enterdir, and delta_theta_landdir.

nsesh1 = length(sesh1);
if nargin == 1
    diff_mat = nan(3,nsesh1,nsesh1);
    for j = 1:nsesh1-1
        thetas1 = nan(1,3);
        try
            thetas1 = twoenv_get_entry_angles(sesh1(j));
        catch ME
            if strcmpi(ME.identifier, 'MATLAB:load:couldNotReadFile')
                warning(['File Not Found sesh1 ' num2str(j)])
            else
                error('Some other error')
            end
        end
        for k = (j+1):nsesh1
            thetas2 = nan(1,3);
            try
                thetas2 = twoenv_get_entry_angles(sesh1(k));
            catch ME
                if strcmpi(ME.identifier, 'MATLAB:load:couldNotReadFile')
                    warning([ 'File Not Found sesh1 ' num2str(k)])
                else
                    error('Some other error')
                end
            end
            diff_mat(:,j,k) = thetas2 - thetas1;
        end
    end
    
elseif nargin == 2
    nsesh2 = length(sesh2);
    diff_mat = nan(3,nsesh1,nsesh2);
    for j = 1:nsesh1
        thetas1 = nan(1,3);
        try
            thetas1 = twoenv_get_entry_angles(sesh1(j));
        catch ME
            if strcmpi(ME.identifier, 'MATLAB:load:couldNotReadFile')
                warning(['File Not Found sesh1 ' num2str(j)])
            else
                error('Some other error')
            end
        end
        for k = 1:nsesh2
            thetas2 = nan(1,3);
            try
                thetas2 = twoenv_get_entry_angles(sesh2(k));
            catch ME
                if strcmpi(ME.identifier, 'MATLAB:load:couldNotReadFile')
                    warning([ 'File Not Found sesh2 ' num2str(k)])
                else
                    error('Some other error')
                end
            end
            diff_mat(:,k,j) = thetas2 - thetas1;
        end
    end
end


end

