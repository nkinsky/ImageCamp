% Script to save first 100 ICs ONLY from FinalTraces.mat

clear all
close all

size_to_load = 100;

temp = importdata('FinalTraces.mat');

FT = temp.FT(1:size_to_load,:);
IC = temp.IC(1,1:size_to_load);
ICnz = temp.ICnz(1,1:size_to_load);
NumICA = size_to_load;
NumFrames = temp.NumFrames;
c = temp.c;
t = temp.t;
x = temp.x(1,1:size_to_load);
y = temp.y(1,1:size_to_load);

save FinalTraces_abbrev.mat c FT IC ICnz NumFrames NumICA t x y