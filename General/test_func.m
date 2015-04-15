function [ output_args ] = test_func( x, varargin )
%function to test out using varagin

opt_args = {'method', 'general_filter'};
%%
for j = 1:2
    if sum(cellfun(@(a) strcmpi(a,'method'),varargin)) == 1
        method = varargin{find(cellfun(@(a) strcmpi(a,'method'),varargin)) + 1};
    else
        method = 'default';
    end
    
    if sum(cellfun(@(a) strcmpi(a,'general_filter'),varargin)) == 1
        general_filter = varargin{find(cellfun(@(a) strcmpi(a,'general_filter'),varargin)) + 1};
    else
        general_filter = [0 0 0 0 ];
    end
end

%%
keyboard

end

