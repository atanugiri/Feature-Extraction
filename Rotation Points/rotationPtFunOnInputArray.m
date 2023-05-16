function rotationPtFunOnInputArray(startRow,endRow)
tic;
% startRow = 65000; endRow = 65005;
loadfile = load('input_data.mat');
input_data = loadfile.input_data;

[id,rotationPts] = arrayfun(@(id) rotationPtFun(id), ...
    input_data.id(startRow:endRow),'UniformOutput',false,'ErrorHandler', ...
    @(S,id)rotationPtFunErrorHandler(S,id));
outputFileName = sprintf('rotationPts%dto%d',startRow,endRow);
save(outputFileName,'id','rotationPts');
toc;
end