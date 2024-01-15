% Author: Atanu Giri
% Date: 01/15/2024

datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% live_table ids in the the date range
ltq = "SELECT id, referencetime FROM live_table ORDER BY id";
ltd = fetch(conn, ltq);
ltd.referencetime = datetime(ltd.referencetime, 'Format', 'MM/dd/yyyy');
ltd = sortrows(ltd, 'referencetime');
startDate = datetime('11/05/2021', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('02/16/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);
ltDataInRange = ltd(ltd.referencetime >= startDate & ltd.referencetime <= endDate, :);


% featuretable2 ids in the the date range
ftIDq = "SELECT id FROM featuretable2 ORDER BY id";
ftIDdata = fetch(conn, ftIDq);
ftIDList = ftIDdata.id;
ftIDList = strjoin(arrayfun(@num2str, ftIDList, 'UniformOutput', false), ',');
ftq = sprintf("SELECT id, referencetime FROM live_table WHERE id IN " + ...
    "(%s) ORDER BY id;", ftIDList);
ftd = fetch(conn, ftq);
ftd.referencetime = datetime(ftd.referencetime, 'Format', 'MM/dd/yyyy');
ftd = sortrows(ftd, 'referencetime');

idList = setdiff(ltDataInRange.id, ftd.id);

%% INSERT ID
tableName = 'featuretable2';
for i = 1:length(idList)
    try
        id = idList(i);
        query = sprintf("INSERT INTO %s (id) VALUES (%d)", tableName, id);
        exec(conn,query);

    catch exception
       fprintf("Error in insert_id for id = %d\n", id);
       disp(exception.message);
    end
end

