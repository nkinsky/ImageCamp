function [h, cm_out] = imagesc_nan(a,cm)
% function [h, hcb] = imagesc_nan(a,...)
%  Plots just like imagesc, but with any nans labeled as nanclr
%
% a = matrix to plot with imagesc
% cm = colormap to use (e.g. cm = colormap('jet');
% nanclr = rgb color triplet, e.g. nanclr = [1 1 1] sets all NaN values to
% white
% CLim(optional) - if you want to adjust the scale of CLim artificially, enter
% 'CLim',[cmin cmax]. If left blank the max and min values will be set by
% the max and min of a.

if nargin < 2
    cm = 'jet';
end

h = imagesc(a);
set(h,'alphadata',~isnan(a));
cm_out = colormap(cm);

if nansum(a(:)) == 0
    caxis([0 1])
end

%% Old try
% imagesc_nan(im_plot, varargin)
% Works just like imagesc but takes nans and sets them to the color of your
% choosing, default is white

% n_arg = nargin - 1;
% b = imagesc(im_plot, varargin{1:n_arg}); 
% set(b,'AlphaData',~isnan(im_plot));

%% New try (found online at http://stackoverflow.com/questions/8481324/contrasting-color-for-nans-in-imagesc)
%# find minimum and maximum
% if nargin < 4
%     amin=min(a(:));
%     amax=max(a(:));
% elseif nargin == 4
%     amin = CLim(1);
%     amax = CLim(2);
% end
% %# size of colormap
% n = size(cm,1);
% %# color step
% dmap=(amax-amin)/n;
% 
% %# standard imagesc
% him = imagesc(a);
% %# add nan color to colormap
% if amin ~= amax % Scale normally if you have a range of values
%     cm_out = colormap([nanclr; repmat(cm(1,:),4,1); cm]);
% elseif amin == amax % Set new colormap to min value in cm and nanclr if there is only one unique non-NaN value
%     cm_out = colormap([nanclr; cm(1,:)]);
%     
% end
% %# changing color limits
% try
%     if amin ~= amax
%         caxis([amin-dmap amax]);
%     elseif amin == amax
%         caxis([amin-2*eps amax]);
%         
%         % Now do a bunch of unnecessarily complicated stuff to make sure future
%         % caxis calls don't override the above
%         cdata_temp = false(size(him.CData));
%         cdata_temp(~isnan(him.CData(:))) = true;
%         set(him,'CData',cdata_temp,'CDataMapping','direct');
%     end
% catch
%     % Skip this step if it fails
% end
% 
% % If all non-NaN values are zero, make zero come out at the base value of your
% % colormap... this is a hack for sure
% if nansum(a(:)) == 0
%     set(gca,'CLim',[-1, 50])
% end
% 
% 
% %# place a colorbar
% % hcb = colorbar;
% hcb = '';
% %# change Y limit for colorbar to avoid showing NaN color
% % ylim(hcb,[amin amax])
% 
% %keyboard
% 
% if nargout > 0
%     h = him;
% end

end

