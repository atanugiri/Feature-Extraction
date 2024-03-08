id = 4985;

[~,~,~, ~, ~, ~, ~, ~,~,~,~, ~,~,~,~,~, ~,~,~,~, h1, accOutlierTime] = jerkOutlierWOPlot(id);
set(gcf, 'Windowstyle', 'docked');
h2 = trajectoryPlot(id, accOutlierTime);
set(gcf, 'Windowstyle', 'docked');