function [success_bool] = T4batch(sesh)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nsesh = length(sesh);
success_bool = false(1,nsesh);
for j = 1:nsesh
   try
       Tenaspis4(sesh(j));
       success_bool(j) = true;
   catch
       disp(['Error running session ' num2str(j)])
   end
end

end

