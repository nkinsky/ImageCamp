function [ ha ] = plot_smooth_curve( curve_in, ha )
% ha = plot_smooth_curve( curve_in )
%   Rough function to make simulated splitting curves for progress report
%   talk

nBins = size(curve_in,2);
bins = [1:0.001:nBins]';
leftFit = fit([1:nBins]',curve_in(1,:)','smoothingspline');
leftCurve = feval(leftFit,bins);
rightFit = fit([1:nBins]',curve_in(2,:)','smoothingspline');
rightCurve = feval(rightFit,bins);

axes(ha);
plot(bins,leftCurve,'r',bins,rightCurve,'b');
hold off
make_plot_pretty(gca);
ylim([-0.1 1])

end

