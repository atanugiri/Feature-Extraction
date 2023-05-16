function rotationPtsOutputs2()
loadfile = load('input_data.mat');
rotationPtsOutputs1to80705 = load('rotationPtsOutputs1to80705.mat');
rotationPtsOutputs = rotationPtsOutputs1to80705.rotationPtsOutputs;
rotationPts80706to81604 = load('rotationPts80706to81604.mat');rotationPts81605to84956 = load('rotationPts81605to84956.mat');
rotationPts84957to90000 = load('rotationPts84957to90000.mat');rotationPts90001to100000 = load('rotationPts90001to100000.mat');
rotationPts100001to110000 = load('rotationPts100001to110000.mat');rotationPts110001to111136 = load('rotationPts110001to111136.mat');

Row = [rotationPtsOutputs.row;rotationPts80706to81604.Row;rotationPts81605to84956.Row;
    rotationPts84957to90000.Row;rotationPts90001to100000.Row;rotationPts100001to110000.Row;
    rotationPts110001to111136.Row];

RotationPts = [rotationPtsOutputs.RotationPts;rotationPts80706to81604.RotationPts; rotationPts81605to84956.RotationPts;rotationPts84957to90000.RotationPts;
rotationPts90001to100000.RotationPts; rotationPts100001to110000.RotationPts; rotationPts110001to111136.RotationPts];

rotationTime = [rotationPtsOutputs.rotationTime;rotationPts80706to81604.rotationTime; rotationPts81605to84956.rotationTime;rotationPts84957to90000.rotationTime;
rotationPts90001to100000.rotationTime; rotationPts100001to110000.rotationTime; rotationPts110001to111136.rotationTime];

rotationPtsOutputs2 = loadfile.input_data;
rotationPtsOutputs2.row = Row;
rotationPtsOutputs2.RotationPts = RotationPts;
rotationPtsOutputs2.rotationTime = rotationTime;
save('rotationPtsOutputs1to111136','rotationPtsOutputs2');
end