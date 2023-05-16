% Define the error handling function
function [id,entryTime,exitTime,logicalApproach,distanceBeforeTone, ...
    velocityBeforeTone,distanceAfterTone,velocityAfterTone, ...
    distanceAfterToneUntilLimitingTimeStamp,velocityAfterToneUntilLimitingTimeStamp, ...
    distanceAfterToneUntilEntryTimeStamp,velocityAfterToneUntilEntryTimeStamp, ...
    distanceAfterEntryTimeStampUntilLimitingTimeStamp, ...
    velocityAfterEntryTimeStampUntilLimitingTimeStamp, ...
    distanceAfterExitTimeStamp,velocityAfterExitTimeStamp, ...
    distanceAfterExitTimeStampUntilLimitingTimeStamp, ...
    velocityAfterExitTimeStampUntilLimitingTimeStamp] = entryExitTimeStampErrorHandler(S,id,varargin)

% warning(S,S);

entryTime = nan;
exitTime = nan;
logicalApproach = nan;
distanceBeforeTone = nan;
velocityBeforeTone = nan;
distanceAfterTone = nan;
velocityAfterTone = nan;
distanceAfterToneUntilLimitingTimeStamp = nan;
velocityAfterToneUntilLimitingTimeStamp = nan;
distanceAfterToneUntilEntryTimeStamp = nan;
velocityAfterToneUntilEntryTimeStamp = nan;
distanceAfterEntryTimeStampUntilLimitingTimeStamp = nan;
velocityAfterEntryTimeStampUntilLimitingTimeStamp = nan;
distanceAfterExitTimeStamp = nan;
velocityAfterExitTimeStamp = nan;
distanceAfterExitTimeStampUntilLimitingTimeStamp = nan;
velocityAfterExitTimeStampUntilLimitingTimeStamp = nan;
end