logicalOutput1to25000 = load('logicalOutput1to25000.mat');
logicalOutput25001to50000 = load('logicalOutput25001to50000.mat');
logicalOutput50001to75000 = load('logicalOutput50001to75000.mat');
logicalOutput75001to100000 = load('logicalOutput75001to100000.mat');
logicalOutput100001to111136 = load('logicalOutput100001to111136.mat');

logicalOutput1to25000 = logicalOutput1to25000.logicalOutput;
logicalOutput25001to50000 = logicalOutput25001to50000.logicalOutput;
logicalOutput50001to75000 = logicalOutput50001to75000.logicalOutput;
logicalOutput75001to100000 = logicalOutput75001to100000.logicalOutput;
logicalOutput100001to111136 = logicalOutput100001to111136.logicalOutput;

passingCentralZoneRejectInitialPresence = [logicalOutput1to25000; ...
    logicalOutput25001to50000;logicalOutput50001to75000;logicalOutput75001to100000; ...
    logicalOutput100001to111136];
passingCentralZoneRejectInitialPresence = string(passingCentralZoneRejectInitialPresence);
save('passingCentralZoneRejectInitialPresence','passingCentralZoneRejectInitialPresence');