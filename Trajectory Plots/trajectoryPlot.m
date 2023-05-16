% Author: Atanu Giri
% Date: 11/19/2022
% This function generates plots of trajectory when id is provided. The plot
% is normalized for uniform representation of all trials.

%% This function call coordinateNormalization and mazeMethods functions.

function h = trajectoryPlot(id)
close all; clc;
% id = 102377;
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

% % verify it's normalizing correctly
% plot(subject_data_table_with_tone.xcoordinates2,subject_data_table_with_tone.ycoordinates2);
% hold on;

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
% p1 = plot(xWithTone,yWithTone,'Color',[0.9 0.7 0.1],'LineWidth',1.5);
hold on;
p2 = plot(xNormalized,yNormalized,'b','MarkerSize',10,'LineWidth',1.5);
validX = xNormalized(~isnan(xNormalized));
validY = yNormalized(~isnan(xNormalized));
mrkr1 = plot(validX(1),validY(1),'g.','MarkerSize',30);
mrkr2 = plot(validX(end),validY(end),'r.','MarkerSize',30);
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
% gray patch
grayPatch = patch(nan,nan,'k');grayPatch.FaceColor = [0.3 0.3 0.3];
grayPatch.FaceAlpha = 0.3;grayPatch.EdgeColor = "none";
% yellow patch
yellowPatch = patch(nan,nan,'k');yellowPatch.FaceColor = [1 1 0];
yellowPatch.FaceAlpha = 0.3;yellowPatch.EdgeColor = "none";
% red patch
redPatch = patch(nan,nan,'k');redPatch.FaceColor = [1 0 0];
redPatch.FaceAlpha = 0.2;redPatch.EdgeColor = "none";

% add legend
% legend([p1,p2,mrkr1,mrkr2,grayPatch,yellowPatch,redPatch], ...
%     {'movement before tone','trajectory','initial location','final location', ...
%     'feeders','offer','central zone'},'Location','best','Interpreter','latex');

legend([p2,mrkr1,mrkr2,grayPatch,yellowPatch,redPatch], ...
    {'trajectory','initial location','final location', ...
    'feeders','offer','central zone'},'Location','best','Interpreter','latex');

xlabel('x(Normalized)',Interpreter='latex',FontSize=14);
ylabel('y(Normalized)',Interpreter='latex',FontSize=14);

% title of graph
sgtitle(sprintf('trajectory id:%d',id));
fig_name = sprintf('trajectory id_%d',id);
print(h,fig_name,'-dpng','-r400');
% savefig(h,sprintf('%s.fig',fig_name));
end