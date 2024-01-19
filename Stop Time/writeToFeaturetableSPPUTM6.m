datasource = 'live_database';
conn = database(datasource,'postgres','1234');

loadFile = load("emptyIDs.mat");
emptyIDs = loadFile.emptyIDs;
idList = emptyIDs.id;
idListStr = strjoin(arrayfun(@num2str, idList, 'UniformOutput', false), ',');

query = sprintf("SELECT id, stoptimemethod6, distanceaftertoneuntillimitingtimestamp " + ...
    "FROM featuretable2 WHERE id IN (%s) ORDER BY id", idListStr);
data = fetch(conn,query);

data.stoptimemethod6 = str2double(data.stoptimemethod6);
data.distanceaftertoneuntillimitingtimestamp = str2double(data.distanceaftertoneuntillimitingtimestamp);

tableName = 'featuretable2';

newData = ((data.stoptimemethod6)*10)./data.distanceaftertoneuntillimitingtimestamp;

for index = 1:length(idList)
    id = idList(index);
    try
        st_pts_per_unit_travel = newData(index);
        st_pts_per_unit_travel = handleNaN(st_pts_per_unit_travel);
        st_pts_per_unit_travel = handleEmpty(st_pts_per_unit_travel);
        st_pts_per_unit_travel = convertToString(st_pts_per_unit_travel);

        updateQuery = sprintf("UPDATE %s SET stoppingpts_per_unittravel_method6=%s WHERE id=%d", ...
            tableName, st_pts_per_unit_travel, id);
        exec(conn, updateQuery);

    catch
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