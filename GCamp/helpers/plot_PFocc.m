function [ output_args ] = plot_PFocc( x,y,Xedges,Yedges )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

plot(x,y)

for i = 1:length(Xedges)
    z = line([Xedges(i) Xedges(i)],[Yedges(1) Yedges(end)]);
    set(z,'Color','r');
end

for i = 1:length(Yedges)
    z = line([Xedges(1) Xedges(end)],[Yedges(i) Yedges(i)]);
    set(z,'Color','r');
end


end

