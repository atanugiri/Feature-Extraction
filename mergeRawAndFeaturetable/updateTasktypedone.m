datasource = 'live_database';
conn = database(datasource,'postgres','1234');

loadFile = load("emptyIDs.mat");
emptyIDs = loadFile.emptyIDs;
idList = emptyIDs.id;

tableName = 'featuretable2';

for index = 1:length(idList)
    id = idList(index);

    try
        rawTableQuery = sprintf("SELECT tasktypedone FROM live_table WHERE id = %d", id);
        rawTableData = fetch(conn,rawTableQuery);
        tasktypedone = string(rawTableData.tasktypedone);
        tasktypedone = upper(strrep(tasktypedone, ' ', ''));
        updateQuery = sprintf("UPDATE %s SET tasktypedone='%s' WHERE id=%d", tableName, tasktypedone, id);
        exec(conn, updateQuery);

    catch
        fprintf("Calculation error in %d: %s\n", id);
    end
end
