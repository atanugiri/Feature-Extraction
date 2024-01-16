% Author: Atanu Giri
% Date: 01/16/2024

datasource = 'live_database';
conn = database(datasource,'postgres','1234');

loadFile = load("emptyIDs.mat");
emptyIDs = loadFile.emptyIDs;
idList = emptyIDs.id;

tableName = 'featuretable2';

for index = 1:length(idList)
    id = idList(index);
    try
        [~,entryTime,exitTime,logicalApproach,distanceBeforeTone, ...
            velocityBeforeTone,distanceAfterTone,velocityAfterTone, ...
            distanceAfterToneUntilLimitingTimeStamp,velocityAfterToneUntilLimitingTimeStamp, ...
            distanceAfterToneUntilEntryTimeStamp,velocityAfterToneUntilEntryTimeStamp, ...
            distanceAfterEntryTimeStampUntilLimitingTimeStamp, ...
            velocityAfterEntryTimeStampUntilLimitingTimeStamp, ...
            distanceAfterExitTimeStamp,velocityAfterExitTimeStamp, ...
            distanceAfterExitTimeStampUntilLimitingTimeStamp, ...
            velocityAfterExitTimeStampUntilLimitingTimeStamp] = entryExitTimeStampFun(id);

        % Convert NaN values to NULL
        entryTime = handleNaN(entryTime);
        exitTime = handleNaN(exitTime);
        logicalApproach = handleNaN(logicalApproach);
        distanceBeforeTone = handleNaN(distanceBeforeTone);
        velocityBeforeTone = handleNaN(velocityBeforeTone);
        distanceAfterTone = handleNaN(distanceAfterTone);
        velocityAfterTone = handleNaN(velocityAfterTone);
        distanceAfterToneUntilLimitingTimeStamp = handleNaN(distanceAfterToneUntilLimitingTimeStamp);
        velocityAfterToneUntilLimitingTimeStamp = handleNaN(velocityAfterToneUntilLimitingTimeStamp);
        distanceAfterToneUntilEntryTimeStamp = handleNaN(distanceAfterToneUntilEntryTimeStamp);
        velocityAfterToneUntilEntryTimeStamp = handleNaN(velocityAfterToneUntilEntryTimeStamp);
        distanceAfterEntryTimeStampUntilLimitingTimeStamp = handleNaN(distanceAfterEntryTimeStampUntilLimitingTimeStamp);
        velocityAfterEntryTimeStampUntilLimitingTimeStamp = handleNaN(velocityAfterEntryTimeStampUntilLimitingTimeStamp);
        distanceAfterExitTimeStamp = handleNaN(distanceAfterExitTimeStamp);
        velocityAfterExitTimeStamp = handleNaN(velocityAfterExitTimeStamp);
        distanceAfterExitTimeStampUntilLimitingTimeStamp = handleNaN(distanceAfterExitTimeStampUntilLimitingTimeStamp);
        velocityAfterExitTimeStampUntilLimitingTimeStamp = handleNaN(velocityAfterExitTimeStampUntilLimitingTimeStamp);

        % Handle empty values
        entryTime = handleEmpty(entryTime);
        exitTime = handleEmpty(exitTime);
        logicalApproach = handleEmpty(logicalApproach);
        distanceBeforeTone = handleEmpty(distanceBeforeTone);
        velocityBeforeTone = handleEmpty(velocityBeforeTone);
        distanceAfterTone = handleEmpty(distanceAfterTone);
        velocityAfterTone = handleEmpty(velocityAfterTone);
        distanceAfterToneUntilLimitingTimeStamp = handleEmpty(distanceAfterToneUntilLimitingTimeStamp);
        velocityAfterToneUntilLimitingTimeStamp = handleEmpty(velocityAfterToneUntilLimitingTimeStamp);
        distanceAfterToneUntilEntryTimeStamp = handleEmpty(distanceAfterToneUntilEntryTimeStamp);
        velocityAfterToneUntilEntryTimeStamp = handleEmpty(velocityAfterToneUntilEntryTimeStamp);
        distanceAfterEntryTimeStampUntilLimitingTimeStamp = handleEmpty(distanceAfterEntryTimeStampUntilLimitingTimeStamp);
        velocityAfterEntryTimeStampUntilLimitingTimeStamp = handleEmpty(velocityAfterEntryTimeStampUntilLimitingTimeStamp);
        distanceAfterExitTimeStamp = handleEmpty(distanceAfterExitTimeStamp);
        velocityAfterExitTimeStamp = handleEmpty(velocityAfterExitTimeStamp);
        distanceAfterExitTimeStampUntilLimitingTimeStamp = handleEmpty(distanceAfterExitTimeStampUntilLimitingTimeStamp);
        velocityAfterExitTimeStampUntilLimitingTimeStamp = handleEmpty(velocityAfterExitTimeStampUntilLimitingTimeStamp);

        % Convert NaN values to 'NULL' for text columns
        entryTime = convertToString(entryTime);
        exitTime = convertToString(exitTime);
        logicalApproach = convertToString(logicalApproach);
        distanceBeforeTone = convertToString(distanceBeforeTone);
        velocityBeforeTone = convertToString(velocityBeforeTone);
        distanceAfterTone = convertToString(distanceAfterTone);
        velocityAfterTone = convertToString(velocityAfterTone);
        distanceAfterToneUntilLimitingTimeStamp = convertToString(distanceAfterToneUntilLimitingTimeStamp);
        velocityAfterToneUntilLimitingTimeStamp = convertToString(velocityAfterToneUntilLimitingTimeStamp);
        distanceAfterToneUntilEntryTimeStamp = convertToString(distanceAfterToneUntilEntryTimeStamp);
        velocityAfterToneUntilEntryTimeStamp = convertToString(velocityAfterToneUntilEntryTimeStamp);
        distanceAfterEntryTimeStampUntilLimitingTimeStamp = convertToString(distanceAfterEntryTimeStampUntilLimitingTimeStamp);
        velocityAfterEntryTimeStampUntilLimitingTimeStamp = convertToString(velocityAfterEntryTimeStampUntilLimitingTimeStamp);
        distanceAfterExitTimeStamp = convertToString(distanceAfterExitTimeStamp);
        velocityAfterExitTimeStamp = convertToString(velocityAfterExitTimeStamp);
        distanceAfterExitTimeStampUntilLimitingTimeStamp = convertToString(distanceAfterExitTimeStampUntilLimitingTimeStamp);
        velocityAfterExitTimeStampUntilLimitingTimeStamp = convertToString(velocityAfterExitTimeStampUntilLimitingTimeStamp);

        updateQuery = sprintf("UPDATE %s SET entrytime=%s, " + ...
            "exittime=%s, logicalapproach=%s, " + ...
            "distancebeforetone=%s, velocitybeforetone=%s, " + ...
            "distanceaftertone=%s, velocityaftertone=%s, " + ...
            "distanceaftertoneuntillimitingtimestamp=%s, " + ...
            "velocityaftertoneuntillimitingtimestamp=%s, " + ...
            "distanceaftertoneuntilentrytimestamp=%s, " + ...
            "velocityaftertoneuntilentrytimestamp=%s, " + ...
            "distanceafterentrytimestampuntillimitingtimestamp=%s, " + ...
            "velocityafterentrytimestampuntillimitingtimestamp=%s, " + ...
            "distanceafterexittimestamp=%s, " + ...
            "velocityafterexittimestamp=%s, " + ...
            "distanceafterexittimestampuntillimitingtimestamp=%s, " + ...
            "velocityafterexittimestampuntillimitingtimestamp=%s WHERE id=%d", ...
            tableName, entryTime, exitTime, ...
            logicalApproach, distanceBeforeTone, velocityBeforeTone, ...
            distanceAfterTone, velocityAfterTone, distanceAfterToneUntilLimitingTimeStamp, ...
            velocityAfterToneUntilLimitingTimeStamp, distanceAfterToneUntilEntryTimeStamp, ...
            velocityAfterToneUntilEntryTimeStamp, distanceAfterEntryTimeStampUntilLimitingTimeStamp, ...
            velocityAfterEntryTimeStampUntilLimitingTimeStamp, distanceAfterExitTimeStamp, ...
            velocityAfterExitTimeStamp, distanceAfterExitTimeStampUntilLimitingTimeStamp, ...
            velocityAfterExitTimeStampUntilLimitingTimeStamp, id);

        exec(conn, updateQuery);
        fprintf("index %d\n", index);

    catch ME
        fprintf("Calculation error in %d: %s\n", id, ME.message);
        continue;
    end
end

function value = handleNaN(value)
if isnan(value)
    value = 'NULL';
end
end

function value = handleEmpty(value)
if isempty(value)
    value = 'NULL';
end
end

function value = convertToString(value)
% Convert to numeric if not NaN or empty
if all(~isnan(value)) && all(~isempty(value))
    value = num2str(value); % Convert to string for uniformity
end
end