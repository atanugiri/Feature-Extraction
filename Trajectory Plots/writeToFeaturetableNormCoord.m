% Author: Atanu Giri
% Date: 12/11/2023

% clear; clc;
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% live_table ids in the the date range
ltq = "SELECT id, referencetime FROM live_table ORDER BY id";
ltd = fetch(conn, ltq);
ltDataInRange = fetchIDs(ltd);
ltIDs = ltDataInRange.id;

% featuretable2 ids in the the date range
ftq = "SELECT id, referencetime FROM featuretable2 ORDER BY id";
ftd = fetch(conn, ftq);
ftDataInRange = fetchIDs(ftd);
ftIDs = ftDataInRange.id;

idList = setdiff(ltIDs, ftIDs);

tableName = 'ghrelin_featuretable';

for index = 1:length(idList)
    id = idList(index);
    try
        [normT, normX, normY] = extractNormalizedCoordinate(id);

        norm_t_string = sprintf('ARRAY[%s]', strjoin(cellstr(num2str(normT, '%.6f')), ','));
        norm_x_string = sprintf('ARRAY[%s]', strjoin(cellstr(num2str(normX, '%.6f')), ','));
        norm_y_string = sprintf('ARRAY[%s]', strjoin(cellstr(num2str(normY, '%.6f')), ','));


        updateQuery = sprintf("UPDATE %s SET norm_t=%s, norm_x=%s, norm_y=%s " + ...
            "WHERE id=%d", tableName, norm_t_string, norm_x_string, norm_y_string, id);

        exec(conn, updateQuery);

    catch ME
        fprintf("Calculation error in %d: %s\n", id, ME.message);
        continue;
    end
end