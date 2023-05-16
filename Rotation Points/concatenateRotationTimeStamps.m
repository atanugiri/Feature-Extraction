loadfile = load('rotationPtsOutputs1to111136.mat');
rotationPtsOutputs = loadfile.rotationPtsOutputs2;
rotationTime = rotationPtsOutputs.rotationTime;
% convert the nx1 cell array in each rotationTime cell to 1x1 cell to
% upload in the database
strRotationTime = cell(length(rotationTime),1);
for index = 1:length(rotationTime)
    strRotationTime{index,1} = join(string(rotationTime{index,1})',',');
end
rotationPtsOutputs.rotationTime = strRotationTime;
save('rotationPtsOutputs1to111136final','rotationPtsOutputs');