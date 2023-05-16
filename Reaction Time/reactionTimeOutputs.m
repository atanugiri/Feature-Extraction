function reactionTimeOutputs = reactionTimeOutputs()
loadfile = load('input_data.mat');
reactionTimeOutputs1to80705 = load("reactionTimeOutputs1to80705.mat");
reactionTimeOutputs = reactionTimeOutputs1to80705.reactionTimeOutputs;
reactionTimeFnWOPlot80706to86180 = load('reactionTimeFnWOPlot80706to86180.mat');
reactionTimeFnWOPlot86181to88000 = load('reactionTimeFnWOPlot86181to88000.mat');
reactionTimeFnWOPlot88001to90000 = load('reactionTimeFnWOPlot88001to90000.mat');
reactionTimeFnWOPlot90001to95000 = load('reactionTimeFnWOPlot90001to95000.mat');
reactionTimeFnWOPlot95001to100000 = load('reactionTimeFnWOPlot95001to100000.mat');
reactionTimeFnWOPlot100001to105000 = load('reactionTimeFnWOPlot100001to105000.mat');
reactionTimeFnWOPlot105001to110600 = load('reactionTimeFnWOPlot105001to110600.mat');
reactionTimeFnWOPlot110601to111136 = load('reactionTimeFnWOPlot110601to111136.mat');

Row = [reactionTimeOutputs.row; reactionTimeFnWOPlot80706to86180.Row;
    reactionTimeFnWOPlot86181to88000.Row;reactionTimeFnWOPlot88001to90000.Row;
    reactionTimeFnWOPlot90001to95000.Row;reactionTimeFnWOPlot95001to100000.Row;
    reactionTimeFnWOPlot100001to105000.Row;reactionTimeFnWOPlot105001to110600.Row;
    reactionTimeFnWOPlot110601to111136.Row];

logicalOut = [reactionTimeOutputs.logicalOut; reactionTimeFnWOPlot80706to86180.logicalOut;
    reactionTimeFnWOPlot86181to88000.logicalOut;reactionTimeFnWOPlot88001to90000.logicalOut;
    reactionTimeFnWOPlot90001to95000.logicalOut;reactionTimeFnWOPlot95001to100000.logicalOut;
    reactionTimeFnWOPlot100001to105000.logicalOut;reactionTimeFnWOPlot105001to110600.logicalOut;
    reactionTimeFnWOPlot110601to111136.logicalOut];

runTime = [reactionTimeOutputs.runTime; reactionTimeFnWOPlot80706to86180.runTime;
    reactionTimeFnWOPlot86181to88000.runTime;reactionTimeFnWOPlot88001to90000.runTime;
    reactionTimeFnWOPlot90001to95000.runTime;reactionTimeFnWOPlot95001to100000.runTime;
    reactionTimeFnWOPlot100001to105000.runTime;reactionTimeFnWOPlot105001to110600.runTime;
    reactionTimeFnWOPlot110601to111136.runTime];

reactionTime1st = [reactionTimeOutputs.reactionTime1st; reactionTimeFnWOPlot80706to86180.reactionTime1st;
    reactionTimeFnWOPlot86181to88000.reactionTime1st;reactionTimeFnWOPlot88001to90000.reactionTime1st;
    reactionTimeFnWOPlot90001to95000.reactionTime1st;reactionTimeFnWOPlot95001to100000.reactionTime1st;
    reactionTimeFnWOPlot100001to105000.reactionTime1st;reactionTimeFnWOPlot105001to110600.reactionTime1st;
    reactionTimeFnWOPlot110601to111136.reactionTime1st];

reactionTime2nd = [reactionTimeOutputs.reactionTime2nd; reactionTimeFnWOPlot80706to86180.reactionTime2nd;
    reactionTimeFnWOPlot86181to88000.reactionTime2nd;reactionTimeFnWOPlot88001to90000.reactionTime2nd;
    reactionTimeFnWOPlot90001to95000.reactionTime2nd;reactionTimeFnWOPlot95001to100000.reactionTime2nd;
    reactionTimeFnWOPlot100001to105000.reactionTime2nd;reactionTimeFnWOPlot105001to110600.reactionTime2nd;
    reactionTimeFnWOPlot110601to111136.reactionTime2nd];

reactionTimeOfApproach = [reactionTimeOutputs.reactionTimeOfApproach; reactionTimeFnWOPlot80706to86180.reactionTimeOfApproach;
    reactionTimeFnWOPlot86181to88000.reactionTimeOfApproach;reactionTimeFnWOPlot88001to90000.reactionTimeOfApproach;
    reactionTimeFnWOPlot90001to95000.reactionTimeOfApproach;reactionTimeFnWOPlot95001to100000.reactionTimeOfApproach;
    reactionTimeFnWOPlot100001to105000.reactionTimeOfApproach;reactionTimeFnWOPlot105001to110600.reactionTimeOfApproach;
    reactionTimeFnWOPlot110601to111136.reactionTimeOfApproach];

reactionTimeOutputs2 = loadfile.input_data;
reactionTimeOutputs2.row = Row;
reactionTimeOutputs2.logicalOut = logicalOut;
reactionTimeOutputs2.runTime = runTime;
reactionTimeOutputs2.reactionTime1st = reactionTime1st;
reactionTimeOutputs2.reactionTime2nd = reactionTime2nd;
reactionTimeOutputs2.reactionTimeOfApproach = reactionTimeOfApproach;
save('reactionTimeOutputs1to111136','reactionTimeOutputs2');
end