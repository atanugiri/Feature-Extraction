% Author: Atanu Giri
% Date: 01/17/2023
% This function returns the total stoptime in trajectory


function [id,stopTime] = stopTimeFun(id)
close all; clc;
% id = 224732;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% write query
query = sprintf("SELECT id, subjectid, trialname, referencetime, " + ...
    "playstarttrialtone, coordinatetimes2, xcoordinates2, " + ...
    "ycoordinates2, mazenumber, feeder FROM live_table WHERE id = %d;", id); %id
subject_data = fetch(conn,query);
% disp(data_on_date);
%% convert all table entries from string to usable format
    function fn_subject_data()
        % convert char to double in playstarttrialtone column
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

idx = all(isfinite(cleanedDataWithTone{:,:}),2);
cleanedDataWithTone = cleanedDataWithTone(idx,:);

%%
% set playstarttrialtone and exclude the data before playstarttrialtone
%
startingCoordinatetimes = subject_data.playstarttrialtone;
X = cleanedDataWithTone.X(cleanedDataWithTone.t >= startingCoordinatetimes ...
    & cleanedDataWithTone.t <= 20);
Y = cleanedDataWithTone.Y(cleanedDataWithTone.t >= startingCoordinatetimes ...
    & cleanedDataWithTone.t <= 20);
% t = cleanedDataWithTone.t ...
%     (cleanedDataWithTone.t >= startingCoordinatetimes);

% Apply sliding window to find stopping points
% User-adjustable parameters 1
windowSize = [5,5,10,10,20,30]; % Window to scan the array with.
xBoxWidth = [0.01,0.02,0.01,0.02,0.1,0.1];
yBoxWidth = [0.01,0.02,0.01,0.02,0.1,0.1];
stopTime = zeros(1,numel(windowSize));
bulbIndexes = cell(1,numel(windowSize));
% Scan array looking for clustered points all within the defined box width.
for method = 1:numel(windowSize)
    bulbIndexes{method} = false(numel(X), 1);
    for k = 2 : numel(X) - windowSize(method)
        % See if all x and y points in the window are within the box.
        xWindow = X(k : k + windowSize(method) - 1);
        yWindow = Y(k : k + windowSize(method) - 1);
        if range(xWindow) < xBoxWidth(method) && range(yWindow) < yBoxWidth(method)
            bulbIndexes{method}(k : k + windowSize(method) - 1) = true;
        end
    end
    stoppingPts = sum(bulbIndexes{method});
    stopTime(method) = 0.1*stoppingPts;
end

% % Plot data
% h = trajectoryPlot(id);
% hold on;
% methodNo = 6;
% scatter(X(bulbIndexes{methodNo}),Y(bulbIndexes{methodNo}),20,"filled",'MarkerFaceColor',[1 0.4 0.6]);
% title('Stopping Points in Baseline Trajectory',Interpreter='latex');
% legendObj = findobj(h,'Type','Legend');
% legendObj.String{6} = 'stopping points';
% figName = sprintf('stop_time_%d',id);
% savefig(h,sprintf('%s.fig',figName));
% print(h,figName,'-dpng','-r400');
end