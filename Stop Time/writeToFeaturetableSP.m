% Author: Atanu Giri
% Date: 01/15/2024

datasource = 'live_database';
conn = database(datasource,'postgres','1234');

loadFile = load("emptyIDs.mat");
emptyIDs = loadFile.emptyIDs;
idList = emptyIDs.id;

tableName = 'featuretable2';

for index = 1:length(idList)
    id = idList(index);
    try
        [id,stopTime] = stopTimeFun(id);

        stopTime_method1 = stopTime(1);
        stopTime_method2 = stopTime(2);
        stopTime_method3 = stopTime(3);
        stopTime_method4 = stopTime(4);
        stopTime_method5 = stopTime(5);
        stopTime_method6 = stopTime(6);
        
        % Convert NaN values to NULL
        stopTime_method1 = handleNaN(stopTime_method1);
        stopTime_method2 = handleNaN(stopTime_method2);
        stopTime_method3 = handleNaN(stopTime_method3);
        stopTime_method4 = handleNaN(stopTime_method4);
        stopTime_method5 = handleNaN(stopTime_method5);
        stopTime_method6 = handleNaN(stopTime_method6);

        % Handle empty values
        stopTime_method1 = handleEmpty(stopTime_method1);
        stopTime_method2 = handleEmpty(stopTime_method2);
        stopTime_method3 = handleEmpty(stopTime_method3);
        stopTime_method4 = handleEmpty(stopTime_method4);
        stopTime_method5 = handleEmpty(stopTime_method5);
        stopTime_method6 = handleEmpty(stopTime_method6);


        % Convert NaN values to 'NULL' for text columns
        stopTime_method1 = convertToString(stopTime_method1);
        stopTime_method2 = convertToString(stopTime_method2);
        stopTime_method3 = convertToString(stopTime_method3);
        stopTime_method4 = convertToString(stopTime_method4);
        stopTime_method5 = convertToString(stopTime_method5);
        stopTime_method6 = convertToString(stopTime_method6);

        updateQuery = sprintf("UPDATE %s SET stoptimemethod1=%s, " + ...
            "stoptimemethod2=%s, stoptimemethod3=%s, " + ...
            "stoptimemethod4=%s, stoptimemethod5=%s, " + ...
            "stoptimemethod6=%s WHERE id=%d", ...
            tableName, stopTime_method1, stopTime_method2, ...
            stopTime_method3, stopTime_method4, stopTime_method5, ...
            stopTime_method6, id);

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