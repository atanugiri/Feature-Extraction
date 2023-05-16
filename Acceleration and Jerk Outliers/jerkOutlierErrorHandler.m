% Define the error handling function
function [id,totalRunningTime,accOutlierMethod1,bigAcceleration,accOutlierMedian, ...
    accOutlierMoveMedian,accOutlierMean, ...
    accOutlierQuartiles,accOutlierGrubbs,accOutlierGesd,accOutlierThreshold, ...
    jerkOutlierMethod1,bigJerkness,jerkOutlierMedian,jerkOutlierMoveMedian,jerkOutlierMean, ...
    jerkOutlierQuartiles,jerkOutlierGrubbs,jerkOutlierGesd, ...
    jerkOutlierThreshold] = jerkOutlierErrorHandler(S,id,varargin)

% warning(S,S);
totalRunningTime = nan;
accOutlierMethod1 = nan;
bigAcceleration = nan;
accOutlierMedian = nan;
accOutlierMoveMedian = nan;
accOutlierMean = nan;
accOutlierQuartiles = nan;
accOutlierGrubbs = nan;
accOutlierGesd = nan;
accOutlierThreshold = nan;
jerkOutlierMethod1 = nan;
bigJerkness = nan;
jerkOutlierMedian = nan;
jerkOutlierMoveMedian = nan;
jerkOutlierMean = nan;
jerkOutlierQuartiles = nan;
jerkOutlierGrubbs = nan;
jerkOutlierGesd = nan;
jerkOutlierThreshold = nan;
end