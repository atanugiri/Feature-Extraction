% Author: Atanu Giri
% Date: 01/17/2024

datasource = 'live_database';
conn = database(datasource,'postgres','1234');

loadFile = load("emptyIDs.mat");
emptyIDs = loadFile.emptyIDs;
idList = emptyIDs.id;

tableName = 'featuretable2';

for index = 1:length(idList)
    id = idList(index);
    try
        [reactionTimeMethod1, reactionTimeMethod2, reactionTimeMethod3, ...
            reactionTimeMethod4] = reactionTimeFun(id);

        % Convert NaN values to NULL
        reactionTimeMethod1 = handleNaN(reactionTimeMethod1);
        reactionTimeMethod2 = handleNaN(reactionTimeMethod2);
        reactionTimeMethod3 = handleNaN(reactionTimeMethod3);
        reactionTimeMethod4 = handleNaN(reactionTimeMethod4);

        % Handle empty values
        reactionTimeMethod1 = handleEmpty(reactionTimeMethod1);
        reactionTimeMethod2 = handleEmpty(reactionTimeMethod2);
        reactionTimeMethod3 = handleEmpty(reactionTimeMethod3);
        reactionTimeMethod4 = handleEmpty(reactionTimeMethod4);

        % Convert NaN values to 'NULL' for text columns
        reactionTimeMethod1 = convertToString(reactionTimeMethod1);
        reactionTimeMethod2 = convertToString(reactionTimeMethod2);
        reactionTimeMethod3 = convertToString(reactionTimeMethod3);
        reactionTimeMethod4 = convertToString(reactionTimeMethod4);

        updateQuery = sprintf("UPDATE %s SET reactiontime_method1=%s, " + ...
            "reactiontime_method2=%s, reactiontime_method3=%s, " + ...
            "reactiontime_method4=%s WHERE id=%d", ...
            tableName, reactionTimeMethod1, reactionTimeMethod2, ...
            reactionTimeMethod3, reactionTimeMethod4, id);

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