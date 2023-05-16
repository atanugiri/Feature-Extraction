% Author: Atanu Giri
% Date: 12/19/2022
% This function returns the runtime of an animal in a trial. This is a
% complementary feature to approachavoidtime in the live_table.

%% Invokes coordinateNormalization, centralZoneEdges, trajectoryPlot function

function [id,entryTime,exitTime,logicalApproach,distanceBeforeTone, ...
    velocityBeforeTone,distanceAfterTone,velocityAfterTone, ...
    distanceAfterToneUntilLimitingTimeStamp,velocityAfterToneUntilLimitingTimeStamp, ...
    distanceAfterToneUntilEntryTimeStamp,velocityAfterToneUntilEntryTimeStamp, ...
    distanceAfterEntryTimeStampUntilLimitingTimeStamp, ...
    velocityAfterEntryTimeStampUntilLimitingTimeStamp, ...
    distanceAfterExitTimeStamp,velocityAfterExitTimeStamp, ...
    distanceAfterExitTimeStampUntilLimitingTimeStamp, ...
    velocityAfterExitTimeStampUntilLimitingTimeStamp] = entryExitTimeStampFun(id)

close all; clc;
% id = 250690;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
% write query
query = sprintf("SELECT id, subjectid, trialname, referencetime, " + ...
    "playstarttrialtone, coordinatetimes2, xcoordinates2, " + ...
    "ycoordinates2, mazenumber, feeder FROM live_table WHERE id = %d;", id);
subject_data = fetch(conn,query);
% close(conn);
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
badDataWithTone = table(subject_data_table_with_tone.coordinatetimes2,xWithTone,yWithTone, ...
    'VariableNames',{'t','X','Y'});
cleanedDataWithTone = badDataWithTone;
% Find the rows with NaN values
idx = all(isfinite(cleanedDataWithTone{:,:}),2);
cleanedDataWithTone = cleanedDataWithTone(idx,:);

%%
% set playstarttrialtone and exclude the data before playstarttrialtone
%
startingCoordinatetimes = subject_data.playstarttrialtone;
X = cleanedDataWithTone.X(cleanedDataWithTone.t >= startingCoordinatetimes);
Y = cleanedDataWithTone.Y(cleanedDataWithTone.t >= startingCoordinatetimes);
t = cleanedDataWithTone.t ...
    (cleanedDataWithTone.t >= startingCoordinatetimes);

% set flags
toneTimeIndex = find(cleanedDataWithTone.t == startingCoordinatetimes);
limitingTimeIndex = find(t == 20);
maze = {'maze2','maze1','maze3','maze4'};

% get the index in maze array
mazeIndex = find(ismember(maze,subject_data.mazenumber));
feeder = subject_data.feeder;

[~,~,xEdgeOfFeeder,yEdgeOfFeeder] = centralZoneEdges(mazeIndex,0.5,feeder);
entryTime = nan;
for i = 1:length(X)
    if (X(i) >= xEdgeOfFeeder(1) && X(i) <= xEdgeOfFeeder(2)) && ...
            (Y(i) >= yEdgeOfFeeder(1) && Y(i) <= yEdgeOfFeeder(2))
        entryPointIndex = i;
        entryTime = t(i) - t(1);
        break;
    end
end
% Check if entry point was found
if isnan(entryTime)
    exitTime = nan;
else
    % Loop through remaining trajectory data
    for i = entryPointIndex+1:length(X)
        % Check if current x and y coordinates are outside rectangular zone
        if X(i) < xEdgeOfFeeder(1) || X(i) > xEdgeOfFeeder(2) || ...
                Y(i) < yEdgeOfFeeder(1) || Y(i) > yEdgeOfFeeder(2)
            % If coordinates are outside the zone, record index as exit point
            exitPointIndex = i;
            exitTime = t(i) - t(1);
            %             plot(X(i),Y(i),'ko','MarkerSize',10,'LineWidth',2);
            break;
        else
            exitPointIndex = nan;
            exitTime = nan;
        end
    end
end

%% declare approach = true if entryTimeStamp exists
if isnan(entryTime)
    logicalApproach = false;
else
    logicalApproach = true;
end

%% calculate distance and velocity
distanceBeforeTone = 0;
for i = 1:length(cleanedDataWithTone.X(1:toneTimeIndex))-1
    distanceBeforeTone = distanceBeforeTone + ...
        sqrt((cleanedDataWithTone.X(i+1)-cleanedDataWithTone.X(i))^2 + ...
        (cleanedDataWithTone.Y(i+1)-cleanedDataWithTone.Y(i))^2);
end
velocityBeforeTone = distanceBeforeTone/ ...
    (cleanedDataWithTone.t(toneTimeIndex) - cleanedDataWithTone.t(1));

distanceAfterTone = 0;
for i = 1:length(X(1:end))-1
    distanceAfterTone = distanceAfterTone + ...
        sqrt((X(i+1)-X(i))^2 + (Y(i+1)-Y(i))^2);
end
velocityAfterTone = distanceAfterTone/(t(end) - t(1));

distanceAfterToneUntilLimitingTimeStamp = 0;
for i = 1:length(X(1:limitingTimeIndex))-1
    distanceAfterToneUntilLimitingTimeStamp = distanceAfterToneUntilLimitingTimeStamp + ...
        sqrt((X(i+1)-X(i))^2 + (Y(i+1)-Y(i))^2);
end
velocityAfterToneUntilLimitingTimeStamp = distanceAfterToneUntilLimitingTimeStamp/ ...
    (t(limitingTimeIndex) - t(1));

if ~isnan(entryTime)
    %%
    distanceAfterToneUntilEntryTimeStamp = 0;
    for i = 1:length(X(1:entryPointIndex))-1
        distanceAfterToneUntilEntryTimeStamp = distanceAfterToneUntilEntryTimeStamp + ...
            sqrt((X(i+1)-X(i))^2 + (Y(i+1)-Y(i))^2);
    end
    velocityAfterToneUntilEntryTimeStamp = distanceAfterToneUntilEntryTimeStamp/ ...
        (t(entryPointIndex) - t(1));
    %%
    if limitingTimeIndex > entryPointIndex
        distanceAfterEntryTimeStampUntilLimitingTimeStamp = 0;
        for i = 1:length(X(entryPointIndex:limitingTimeIndex))-1
            distanceAfterEntryTimeStampUntilLimitingTimeStamp = ...
                distanceAfterEntryTimeStampUntilLimitingTimeStamp + ...
                sqrt((X(i+1)-X(i))^2 + (Y(i+1)-Y(i))^2);
        end
        velocityAfterEntryTimeStampUntilLimitingTimeStamp = ...
            distanceAfterEntryTimeStampUntilLimitingTimeStamp/(t...
            (limitingTimeIndex) - t(entryPointIndex));
    else
        distanceAfterEntryTimeStampUntilLimitingTimeStamp = nan;
        velocityAfterEntryTimeStampUntilLimitingTimeStamp = nan;
    end
else
    distanceAfterToneUntilEntryTimeStamp = nan;
    velocityAfterToneUntilEntryTimeStamp = nan;
    distanceAfterEntryTimeStampUntilLimitingTimeStamp = nan;
    velocityAfterEntryTimeStampUntilLimitingTimeStamp = nan;
end
%%
if ~isnan(entryTime) && ~isnan(exitTime)
    distanceAfterExitTimeStamp = 0;
    for i = 1:length(X(exitPointIndex:end))-1
        distanceAfterExitTimeStamp = distanceAfterExitTimeStamp + ...
            sqrt((X(i+1)-X(i))^2 + (Y(i+1)-Y(i))^2);
    end
    velocityAfterExitTimeStamp = distanceAfterExitTimeStamp/(t(end) ...
        - t(exitPointIndex));
    %%
    if limitingTimeIndex > exitPointIndex
        distanceAfterExitTimeStampUntilLimitingTimeStamp = 0;
        for i = 1:length(X(exitPointIndex:limitingTimeIndex))-1
            distanceAfterExitTimeStampUntilLimitingTimeStamp = ...
                distanceAfterExitTimeStampUntilLimitingTimeStamp + ...
                sqrt((X(i+1)-X(i))^2 + (Y(i+1)-Y(i))^2);
        end
        velocityAfterExitTimeStampUntilLimitingTimeStamp = ...
            (t(limitingTimeIndex) - ...
            t(exitPointIndex));
    else
        distanceAfterExitTimeStampUntilLimitingTimeStamp = nan;
        velocityAfterExitTimeStampUntilLimitingTimeStamp = nan;
    end
else
    distanceAfterExitTimeStamp = nan;
    velocityAfterExitTimeStamp = nan;
    distanceAfterExitTimeStampUntilLimitingTimeStamp = nan;
    velocityAfterExitTimeStampUntilLimitingTimeStamp = nan;
end

% %% If need to plot data
% h = trajectoryPlot(id);
% hold on;
% % plot(X(entryPointIndex),Y(entryPointIndex),'c.','MarkerSize',25,'LineWidth',2);
% plot(X(1:limitingTimeIndex),Y(1:limitingTimeIndex),'Color', ...
%     [0.6350 0.0780 0.1840],'LineWidth',2);
% legendObj = findobj(h,'Type','Legend');
% legendObj.String{6} = sprintf('distance travelled\nafter 20 seconds');
% title('Distance Travelled in Baseline',Interpreter='latex');
% % save figure
% fig_name = sprintf('Distance travelled id_%d',id);
% print(h,fig_name,'-dpng','-r400');
% savefig(h,sprintf('%s.fig',fig_name));
end