loadfile = load('effectiveRunningTime1to111136.mat');
effectiveRunningTimeOutputs = loadfile.effectiveRunningTimeOutputs;
row = effectiveRunningTimeOutputs.row;
result = zeros(length(row),1);
for index = 1:length(row)
    if isequal(index,row(index))
        result(index) = 1;
    end
end