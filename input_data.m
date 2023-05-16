function input_data()
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
query1 = "SELECT id, subjectid, trialname, referencetime " + ...
    "FROM live_table WHERE id > 87311 ORDER BY id;";
liveTableData = fetch(conn,query1);

query2 = "SELECT id FROM featuretable2 ORDER BY id;";
featuretable2Id = fetch(conn,query2);

requiredId = ~ismember(liveTableData.id,featuretable2Id.id);
input_data = liveTableData(requiredId,:);
%% 
% convert referencetime to datetype
%
input_data.referencetime = string(datetime(input_data.referencetime, "Format","MM/dd/yyyy"));
input_data = convertvars(input_data,'subjectid','string');
%%
% Remove extra white space between characters in trialname column
%
all_trialname = cell(length(input_data.trialname),1);
for idx = 1:length(input_data.trialname)
    all_trialname{idx,1} = strrep(input_data.trialname{idx}, ' ', '');
    input_data.trialname{idx} = all_trialname{idx,1};
end
input_data.trialname = string(categorical(input_data.trialname));
save('input_data','input_data');
end