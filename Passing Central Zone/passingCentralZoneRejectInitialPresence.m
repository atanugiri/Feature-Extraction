% Author: Atanu Giri
% Date: 12/12/2022
% This function analyzes the trajectory of the subject and determines
% whether the subject passes through the central zone. It outputs nan if
% the subject is already present in the zone initially.

function [id,result] = passingCentralZoneRejectInitialPresence(id,zoneSize)
close all; clc;
% id = 137351; zoneSize = 0.5;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
% write query
query = sprintf("SELECT id, subjectid, trialname, referencetime, " + ...
    "playstarttrialtone, coordinatetimes2, xcoordinates2, " + ...
    "ycoordinates2, mazenumber, feeder FROM live_table WHERE id = %d;", id);
subject_data = fetch(conn,query);
%% convert all table entries from string to usable format
    function fn_subject_data()
        % convert char to double: playstarttrialtone and feeder
        subject_data.playstarttrialtone = str2double(subject_data.playstarttrialtone);
        subject_data.feeder = str2double(subject_data.feeder);
        % remove space from mazenumber
        subject_data.mazenumber = char(lower(strrep(subject_data.mazenumber,' ','')));
        %%
        % Accessing PGArray data as double
        %
        for column = 6:8
            stringAllRows = string(subject_data.(column));
            regAllRows = regexprep(stringAllRows,'{|}','');
            splitAllRows = split(regAllRows,',');
            doubleData = str2double(splitAllRows);
            subject_data.(column){1} = doubleData;
        end
    end
fn_subject_data();
% includes the data before playstarttrialtone
subject_data_table_with_tone = table(subject_data.coordinatetimes2{1}, ...
    subject_data.xcoordinates2{1},subject_data.ycoordinates2{1}, ...
    'VariableNames',{'coordinatetimes2','xcoordinates2', 'ycoordinates2'});
% invoke coordinateNormalization function to normalize the coordinates
[xWithTone, yWithTone] = coordinateNormalization(subject_data_table_with_tone.xcoordinates2, ...
    subject_data_table_with_tone.ycoordinates2,id);

% remove nan entries
badDataWithTone = table(subject_data_table_with_tone.coordinatetimes2,xWithTone,yWithTone,'VariableNames',{'t','X','Y'});
cleanedData = badDataWithTone;
% remove nan values
idx = all(isfinite(cleanedData{:,:}),2);
cleanedData = cleanedData(idx,:);

%%
% set playstarttrialtone and exclude the data before playstarttrialtone
%
startingCoordinatetimes = subject_data.playstarttrialtone;
xNormalized = cleanedData.X(cleanedData.t >= startingCoordinatetimes);
yNormalized = cleanedData.Y(cleanedData.t >= startingCoordinatetimes);

% set figure limit
maze = {'maze2','maze1','maze3','maze4'};
% get the index in maze array
mazeIndex = find(ismember(maze,subject_data.mazenumber));
feeder = subject_data.feeder;
[xEdge,yEdge] = centralZoneEdges(mazeIndex,zoneSize,feeder);
result = false;
% return nan if the subject already present in the central zone
if (xNormalized(1) > xEdge(1) && xNormalized(1) < xEdge(2)) && ...
        (yNormalized(1) > yEdge(1) && yNormalized(1) < yEdge(2))
    result = nan;
    % check if trajectory goes through central zone
else
    for i = 1:length(xNormalized)
        if (xNormalized(i) > xEdge(1) && xNormalized(i) < xEdge(2)) && ...
                (yNormalized(i) > yEdge(1) && yNormalized(i) < yEdge(2))
            result = true;
            continue;
        end
    end
end

%% Plot figure
h = trajectoryPlot(id);
fig_name = sprintf('passingCentralZone id_%d',id);
% print(h,fig_name,'-dpng','-r400');
% savefig(h,sprintf('%s.fig',fig_name));
end