% Author: Atanu Giri
% Date : 12/04/2022
% This function invokes the function 'passingCentralZone' and run on the id
% present in the 'input_data' file. The output file contains the logical
% array if the subject passes through the central zone or not.

function passingCentralZoneOnInputArray(startRow,endRow)
tic;

% startRow = 4001; endRow = 4005;
loadfile = load('input_data.mat');
input_data = loadfile.input_data;

[id,logicalOutput] = arrayfun(@(id) passingCentralZoneRejectInitialPresence(id,0.5), ...
    input_data.id(startRow:endRow),'UniformOutput',false,'ErrorHandler', ...
    @(S,id)passingCentralZoneRejectInitialPresenceErrorHandler(S,id));
outputFileName = sprintf('logicalOutput%dto%d',startRow,endRow);
save(outputFileName,"id","logicalOutput");

toc;
end