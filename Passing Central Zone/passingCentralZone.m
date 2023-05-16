% Author: Atanu Giri
% Date: 12/02/2022
% This function analyzes the trajectory of the subject and determines
% whether the subject passes through the central zone.

function result = passingCentralZone(id,zoneSize)
close all; clc;
% id = 10233; zoneSize = 0.5;
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
% normalize the coordinates
[xWithTone, yWithTone] = coordinateNormalization(subject_data_table_with_tone.xcoordinates2, ...
    subject_data_table_with_tone.ycoordinates2,id);
%%
% set playstarttrialtone and exclude the data before playstarttrialtone
%
startingCoordinatetimes = subject_data.playstarttrialtone;
xNormalized = xWithTone(subject_data_table_with_tone.coordinatetimes2 >= startingCoordinatetimes);
yNormalized = yWithTone(subject_data_table_with_tone.coordinatetimes2 >= startingCoordinatetimes);
% plot normalized data
h = figure;
p1 = plot(xWithTone,yWithTone,'Color',[0.9 0.7 0.1],'LineWidth',1.5);
hold on;
p2 = plot(xNormalized,yNormalized,'b','LineWidth',1.5);
validX = xNormalized(~isnan(xNormalized));
validY = yNormalized(~isnan(xNormalized));
mrkr1 = plot(validX(1),validY(1),'go','MarkerSize',10,'LineWidth',2);
mrkr2 = plot(validX(end),validY(end),'ro','MarkerSize',10,'LineWidth',2);
% set figure limit
maze = {'maze2','maze1','maze3','maze4'};
figureLimit = {{[-0.2 1.2],[-0.2 1.2]},{[-1.2 0.2],[-0.2 1.2]}, ...
    {[-1.2 0.2],[-1.2 0.2]},{[-0.2 1.2],[-1.2 0.2]}};
% get the index in maze array
mazeIndex = find(ismember(maze,subject_data.mazenumber));
feeder = subject_data.feeder;
xlim(figureLimit{mazeIndex}{1}); ylim(figureLimit{mazeIndex}{2});
% shade feeder zones by calling mazeMethods
mazeMethods(mazeIndex,feeder);
[xEdge, yEdge] = centralZoneEdges(mazeIndex,zoneSize,feeder);
%%
% check if trajectory goes through central zone
%
result = false;
for i = 1:length(xNormalized)
    if (xNormalized(i) > xEdge(1) && xNormalized(i) < xEdge(2)) && ...
        (yNormalized(i) > yEdge(1) && yNormalized(i) < yEdge(2))
        result = true;
        continue;
    end
end
end