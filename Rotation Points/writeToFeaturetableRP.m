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
        [id, rotationPts] = rotationPtFun(id);
        rotationPts_method1 = rotationPts(1);
        rotationPts_method2 = rotationPts(2);
        rotationPts_method3 = rotationPts(3);
        rotationPts_method4 = rotationPts(4);
        
        % Convert NaN values to NULL
        rotationPts_method1 = handleNaN(rotationPts_method1);
        rotationPts_method2 = handleNaN(rotationPts_method2);
        rotationPts_method3 = handleNaN(rotationPts_method3);
        rotationPts_method4 = handleNaN(rotationPts_method4);

        % Handle empty values
        rotationPts_method1 = handleEmpty(rotationPts_method1);
        rotationPts_method2 = handleEmpty(rotationPts_method2);
        rotationPts_method3 = handleEmpty(rotationPts_method3);
        rotationPts_method4 = handleEmpty(rotationPts_method4);


        % Convert NaN values to 'NULL' for text columns
        rotationPts_method1 = convertToString(rotationPts_method1);
        rotationPts_method2 = convertToString(rotationPts_method2);
        rotationPts_method3 = convertToString(rotationPts_method3);
        rotationPts_method4 = convertToString(rotationPts_method4);


        updateQuery = sprintf("UPDATE %s SET rotationptsmethod1=%s, " + ...
            "rotationptsmethod2=%s, rotationptsmethod3=%s, " + ...
            "rotationptsmethod4=%s WHERE id=%d", ...
            tableName, rotationPts_method1, rotationPts_method2, ...
            rotationPts_method3, rotationPts_method4, id);

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