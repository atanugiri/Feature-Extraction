function reactionTimeFnWOPlot110601to111136
loadfile = load('input_data.mat');
input_data = loadfile.input_data;
StartRow = 110601;
EndRow = 111136;
Row = (StartRow:EndRow)';
logicalOut = cell(length(Row),1); runTime = cell(length(Row),1);
reactionTime1st = cell(length(Row),1); reactionTime2nd = cell(length(Row),1);
reactionTimeOfApproach = cell(length(Row),1);
for index = 1:length(Row)
    [logicalOut{index}, runTime{index}, reactionTime1st{index}, ...
        reactionTime2nd{index}, reactionTimeOfApproach{index}] ...
= reactionTimeFnWOPlot(string(input_data.subjectid(Row(index))), ...
string(input_data.referencetime(Row(index))), ...
string(input_data.trialname(Row(index))));
    currentRow = eval(sprintf('%d+%d', StartRow, index-1));
    fprintf('Row %d successfully ran.\n',currentRow);
    save('reactionTimeFnWOPlot110601to111136','Row', 'logicalOut', "runTime", ...
        "reactionTime1st","reactionTime2nd","reactionTimeOfApproach");
end
end