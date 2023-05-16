% 03/14/2023
% Author: Atanu Giri

% This function overlays the trajectory plots. This function keeps the
% colors and legends intact as the original plots.

close all; clc;
% open each figure and store them in variables
f1 = openfig('trajectory id_134830.fig');
f2 = openfig('trajectory id_137342.fig');
f3 = openfig('trajectory id_137350.fig');
f4 = openfig('trajectory id_137502.fig');
f5 = openfig('trajectory id_138178.fig');

% find the legend object in the f1 figure and turn off its AutoUpdate property
leg = findall(f1,'Type','legend');
leg.AutoUpdate = 'off';

% finds the axes object
ax = findall(f1,'Type','axes');

% iterate over the line objects in f2, f3, f4, and f5 and copy and stack them to the axes object in f1
for i = 2:5
    ln = findall(eval(sprintf('f%d',i)),'Type','line');
    ln_copy = copyobj(ln,ax);
    uistack(ln_copy,'bottom');
end

% set the current figure to f1
figure(f1);

% title of graph
sgtitle('Food Deprivation Trajectories', 'Interpreter', 'latex');

% save figure
savefig(f1, 'fdTrajectories.fig');