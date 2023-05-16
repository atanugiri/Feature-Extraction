% Author: Atanu Giri
% Date: 12/10/2022
% This script takes all the features as a mat file and convert them
% appropriately to upload on postgresql database.

datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% which ids do you want?
loadfile = load('input_data.mat');
input_data = loadfile.input_data;
wantedId = sprintf('%d,', input_data.id); % convert array to string
wantedId = wantedId(1:end-1); % remove last comma

rawTableQuery = sprintf("SELECT id, tasktypedone, intensityofcost1, intensityofcost2, intensityofcost3, " +...
    "rewardconcentration1, rewardconcentration2, rewardconcentration3, rewardconcentration4, " +...
    "lightlevel, approachavoid, approachavoidtimestamp FROM live_table WHERE id IN (%s) ORDER BY id", ...
    wantedId);

rawTableData = fetch(conn,rawTableQuery);
rawTableData.tasktypedone = erase(strtrim(rawTableData.tasktypedone)," "); % remove all white spaces inside string
% remove unit name, decimal places, just keep the value
MyCol = rawTableData.Properties.VariableNames; % extract the column names in an array
for col = 3 : 5
  data = rawTableData.(MyCol{col});
  strData = string(data);
  expression = '(-?\d+(\.\d*)?)|(-?\.\d+)';
  regexData = regexp(strData, expression, 'match', 'once');
  decimalFormatted = cell(numel(regexData),1);
  for ii = 1:length(regexData)
      decimalFormatted{ii} = sprintf('%.1f',regexData(ii));
  end
  decimalString = string(decimalFormatted);
  rawTableData.(MyCol{col}) = decimalString;
end
% reward composition on all dates to group similar rewards if needed 
rewardComposition = strcat(rawTableData.rewardconcentration1,',', rawTableData.rewardconcentration2, ...
    ',',rawTableData.rewardconcentration3,',',rawTableData.rewardconcentration4);
rawTableData.rewardComposition = rewardComposition; % add new column to existing table

% intensityofcost composition on all dates to group similar intensityofcost
% if needed 
intensityofcostComposition = strcat(rawTableData.intensityofcost1,',', rawTableData.intensityofcost2, ...
    ',',rawTableData.intensityofcost3);
rawTableData.intensityofcostComposition = intensityofcostComposition; % add new column to existing table

% group similar intensityofcost together
rawTableData.intensityofcostType = rawTableData.intensityofcostComposition;
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '10.0,64.0,NaN') = 'type1';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '10.0,78.0,NaN') = 'type1';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '15.0,160.0,290.0') = 'type2';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '15.0,160.0,320.0') = 'type2';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '15.0,168.0,162.0') = 'type3';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '15.0,168.0,218.0') = 'type4';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '20.0,168.0,218.0') = 'type4';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '15.0,40.0,240.0') = 'type5';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '15.0,40.0,260.0') = 'type5';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '15.0,40.0,290.0') = 'type5';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '15.0,NaN,NaN') = 'type6';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '36.0,99.0,NaN') = 'type7';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '42.0,109.0,NaN') = 'type7';
rawTableData.intensityofcostType(rawTableData.intensityofcostComposition == '9.0,109.0,NaN') = 'type8';

% remove empty cells from lightlevel coloumn
LightLevel = rawTableData.lightlevel;
strLightLevel = string(LightLevel);
regexLightLevel = regexp(strLightLevel, expression, 'match', 'once');
rawTableData.lightlevel = regexLightLevel;

% Merge input_data and rawTableData
fullTable1 = innerjoin(input_data,rawTableData,'Keys','id');

% convert everything to string
for column=2:18
    fullTable1.(column) = string(fullTable1.(column));
end

% Put dummy value in passingcentralzone column
fullTable1.passingcentralzone = string(false(height(fullTable1),1));

% load passingcentralzonerejectinitialpresence



% load reaction time outputs
reactionTimeOutputs1to111136 = load('reactionTimeOutputs1to111136.mat');
reactionTimeOutputs = reactionTimeOutputs1to111136.reactionTimeOutputs2;

% load rotation time outputs
rotationPtsOutputs1to111136final = load('rotationPtsOutputs1to111136final.mat');
rotationPtsOutputs = rotationPtsOutputs1to111136final.rotationPtsOutputs;

% load stoptime outputs
stopTimeOutputs1to111136 = load('stopTimeOutputs1to111136.mat');
stopTimeOutputs = stopTimeOutputs1to111136.stopTimeOutputs2;

% load jerkness outputs
jerkness1to111136 = load('jerkness1to111136.mat');
jerknessOutputs = jerkness1to111136.jerknessOutputs;

% load jerk outlier ouputs
jerkOutlierOutputs1to111136 = load('jerkOutlierOutputs1to111136.mat');
jerkOutlierOutputs = jerkOutlierOutputs1to111136.jerkOutlierOutputs;

% covert the empty entries to nan
for column = 6:21
    jerkOutlierOutputs.(column)(cellfun(@isempty,jerkOutlierOutputs.(column))) = {nan};
end

% load effective running time
effectiveRunningTime1to111136 = load('effectiveRunningTime1to111136.mat');
effectiveRunningTimeOutputs = effectiveRunningTime1to111136.effectiveRunningTimeOutputs;

% merge rawtable and feauretable
fullTable1 = innerjoin(reactionTimeOutputs,rawTableData,'Keys','id');
fullTable2 = innerjoin(rotationPtsOutputs,fullTable1);
fullTable3 = innerjoin(stopTimeOutputs,fullTable2);
fullTable4 = innerjoin(jerknessOutputs,fullTable3);
fullTable5 = innerjoin(jerkOutlierOutputs,fullTable4);
fullTable6 = innerjoin(effectiveRunningTimeOutputs,fullTable5);

% calculate some features based on existing columns
fullTable6.Properties.VariableNames{'effectiveRunningTime'} = 'totalRunningTime';
hesitationPoints = cell2mat(fullTable6.RotationPts) + cell2mat(fullTable6.stoppingPts);
fullTable6.hesitationPointsPerUnitTravel = hesitationPoints./cell2mat(fullTable6.travelPixel);
fullTable6.effectiveVelocity = cell2mat(fullTable6.travelPixel)./(cell2mat(fullTable6.totalRunningTime) - cell2mat(fullTable6.stopTime));
fullTable6.bigAccelerationPerUnitTravel = cell2mat(fullTable6.bigAcceleration)./cell2mat(fullTable6.travelPixel);
fullTable6.bigJerkPerUnitTravel = cell2mat(fullTable6.bigJerk)./cell2mat(fullTable6.travelPixel);

% Rearrange the table
fullTable6.row = [];
fullTable6 = [fullTable6(:,1:4) fullTable6(:,34:45) fullTable6(:,29:33) ...
    fullTable6(:,27:28) fullTable6(:,24:26) fullTable6(:,5:23) fullTable6(:,46:49)];

fullTable6.accOutlierMethod1PerUnitTravel = cell2mat(fullTable6.accOutlierMethod1)./cell2mat(fullTable6.travelPixel);
fullTable6.accOutlierMedianPerUnitTravel = cell2mat(fullTable6.accOutlierMedian)./cell2mat(fullTable6.travelPixel);
fullTable6.accOutlierQuartilesPerUnitTravel = cell2mat(fullTable6.accOutlierQuartiles)./cell2mat(fullTable6.travelPixel);
fullTable6.jerkOutlierMethod1PerUnitTravel = cell2mat(fullTable6.jerkOutlierMethod1)./cell2mat(fullTable6.travelPixel);
fullTable6.jerkOutlierMedianPerUnitTravel = cell2mat(fullTable6.jerkOutlierMedian)./cell2mat(fullTable6.travelPixel);
fullTable6.jerkOutlierQuartilesPerUnitTravel = cell2mat(fullTable6.jerkOutlierQuartiles)./cell2mat(fullTable6.travelPixel);

% convert everything to string
for column=2:55
    fullTable6.(column) = string(fullTable6.(column));
end