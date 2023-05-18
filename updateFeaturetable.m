% Author: Atanu Giri
% Date: 12/14/2022
% This script update the existing featuretable with new feture columns.
% Then it deletes the old eturetable and upload the updated
% featuretable

% connect database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
query = "SELECT * FROM featuretable2 ORDER BY id;";
featuretableData = fetch(conn,query);
loadFile = load('passingCentralZoneRejectInitialPresence.mat');
passingCentralZoneRejectInitialPresence = loadFile.passingCentralZoneRejectInitialPresence;
passingCentralZoneRejectInitialPresence = table(passingCentralZoneRejectInitialPresence, ...
    'VariableNames',{'passingCentralZoneRejectInitialPresence'});
% newFeaturetable = innerjoin(approachData,featuretableData,'Keys','id');
newFeaturetable = [featuretableData passingCentralZoneRejectInitialPresence];
newFeaturetable = [newFeaturetable(:,1:55) newFeaturetable(:,57:58) newFeaturetable(:,56) newFeaturetable(:,59)];
save('newFeaturetable','newFeaturetable');
% delete old and upload new featuretable
deleteQuery = "DROP TABLE featuretable2;";
execute(conn,deleteQuery);
sqlwrite(conn,'featuretable2',newFeaturetable);