function stopTimeFunOnInputArray(startRow,endRow)
tic;
% startRow = 65000; endRow = 65005;
loadfile = load('input_data.mat');
input_data = loadfile.input_data;

[id,stopTime] = arrayfun(@(id) stopTimeFun(id), ...
    input_data.id(startRow:endRow),'UniformOutput',false,'ErrorHandler',@(S,id)stopTimeFunErrorHandler(S,id));
outputFileName = sprintf('stopTime%dto%d',startRow,endRow);
save(outputFileName,'id','stopTime');
toc;
end