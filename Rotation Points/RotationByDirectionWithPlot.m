function [RotationPts, rotationTime] = RotationByDirectionWithPlot(~,~,~)
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
query = "SELECT subjectid, trialname, referencetime, playstarttrialtone," + ...
    " coordinatetimes2, xcoordinates2," + ...
    " ycoordinates2, truedirection " + ...
    " FROM live_table;";
all_data = fetch(conn,query);
%%
% convert date to datetype
%
all_data.referencetime = string(datetime(all_data.referencetime,'Format','dd-MMM-uuuu'));
data_on_date = all_data(all_data.referencetime == '06-Apr-2022',:);

%% convert all table entries to input format
fn_data_on_date();
    function fn_data_on_date()
        data_on_date = convertvars(data_on_date,'subjectid','string');
        %%
        % Remove extra white space between characters in trialname column
        %
        all_trialname = cell(length(data_on_date.trialname),1);
        for idx = 1:length(data_on_date.trialname)
            all_trialname{idx,1} = strrep(data_on_date.trialname{idx}, ' ', '');
            data_on_date.trialname{idx} = all_trialname{idx,1};
        end
        data_on_date.trialname = categorical(data_on_date.trialname);
        %%
        % convert char to double in playstarttrialtone column
        %
        all_playstarttrialtone = cell(length(data_on_date.playstarttrialtone),1);
        for idx = 1:length(data_on_date.playstarttrialtone)
            all_playstarttrialtone{idx,1} = str2double(data_on_date.playstarttrialtone{idx});
            data_on_date.playstarttrialtone{idx} = all_playstarttrialtone{idx,1};
        end
    end
subject_data = data_on_date(data_on_date.subjectid == 'carl',:);
trial_data = subject_data(find(subject_data.trialname == 'Trial22',1),:);

%% convert all table entries from string to usable format
fn_trial_data();
    function fn_trial_data
        %%
        % Accessing PGArray data as double
        %
        all_coordinatetimes = cell(length(trial_data.coordinatetimes2),1);
        for idx = 1:length(trial_data.coordinatetimes2)
            string_all_coordinatetimes = string(trial_data.coordinatetimes2(idx,1));
            reg_all_coordinatetimes = regexprep(string_all_coordinatetimes,'{|}','');
            split_all_coordinatetimes = split(reg_all_coordinatetimes,',');
            all_coordinatetimes{idx,1} = str2double(split_all_coordinatetimes);
            trial_data.coordinatetimes2{idx,1} = all_coordinatetimes{idx,1};
        end

        all_xcoordinates = cell(length(trial_data.xcoordinates2),1);
        for idx = 1:length(trial_data.xcoordinates2)
            string_all_xcoordinates = string(trial_data.xcoordinates2(idx,1));
            reg_all_xcoordinates = regexprep(string_all_xcoordinates,'{|}','');
            split_all_xcoordinates = split(reg_all_xcoordinates,',');
            all_xcoordinates{idx,1} = str2double(split_all_xcoordinates);
            trial_data.xcoordinates2{idx,1} = all_xcoordinates{idx,1};
        end

        all_ycoordinates = cell(length(trial_data.ycoordinates2),1);
        for idx = 1:length(trial_data.ycoordinates2)
            string_all_ycoordinates = string(trial_data.ycoordinates2(idx,1));
            reg_all_ycoordinates = regexprep(string_all_ycoordinates,'{|}','');
            split_all_ycoordinates = split(reg_all_ycoordinates,',');
            all_ycoordinates{idx,1} = str2double(split_all_ycoordinates);
            trial_data.ycoordinates2{idx,1} = all_ycoordinates{idx,1};
        end

        all_direction = cell(length(trial_data.truedirection),1);
        for idx = 1:length(trial_data.truedirection)
            string_all_direction = string(trial_data.truedirection(idx,1));
            reg_all_direction = regexprep(string_all_direction,'{|}','');
            split_all_direction = split(reg_all_direction,',');
            all_direction{idx,1} = str2double(split_all_direction);
            trial_data.truedirection{idx,1} = all_direction{idx,1};
        end
    end
%%
% specify subject and trial_name
%
rodent_RecordingTime = trial_data.coordinatetimes2{:};
rodent_XCenter = trial_data.xcoordinates2{:};
rodent_YCenter = trial_data.ycoordinates2{:};
rodent_Direction = trial_data.truedirection{:};

%% Detect rotation time by change change in diretcion deg
directionTableWithPSTT = table(rodent_RecordingTime,rodent_Direction, ...
    rodent_XCenter, rodent_YCenter, 'VariableNames', ...
    {'rodent_RecordingTime','direction','rodent_XCenter','rodent_YCenter'});
PSTTFilter = directionTableWithPSTT.rodent_RecordingTime >= cell2mat(trial_data.playstarttrialtone);
direction_table = directionTableWithPSTT(PSTTFilter,:);
%%
% Apply sliding window to find stopping points
%
% User-adjustable parameters
windowSize = 5; % Window to scan the array with.
DirectionChange = 325;
% Scan array looking for clustered points all within the defined box width.
bulbIndexes = false(numel(direction_table.direction), 1);
for k = 2:numel(direction_table.direction) - windowSize
    % See if all the direction in the window are within the box
    DirectionWindow = direction_table.direction(k : k + windowSize - 1);
    if range(DirectionWindow) > DirectionChange
        %             find the index in the DirectionWindow where max change in
        %             direction is happening
        DiffDirectionWindow = diff(DirectionWindow);
        IndexOfMaxDiffrence = find(abs(DiffDirectionWindow) ...
            == max(abs(DiffDirectionWindow)));
        bulbIndexes(k + IndexOfMaxDiffrence) = true;
    end
end
%     RotationPtsOverEst = sum(bulbIndexes);
% Do not consider consecutive true in the array
[labeledBulb, RotationPts] = bwlabel(bulbIndexes);
RotationIndex = ones(max(labeledBulb),1);
for kk = 1:max(labeledBulb)
    RotationIndex(kk) = find(labeledBulb == kk,1);
end
RotationLogical = false(numel(direction_table.direction),1);
for ii = 1:numel(direction_table.direction)
    if ismember(ii,RotationIndex)
        RotationLogical(ii) = true;
    end
end
%     RotationTableOverEst = direction_table(bulbIndexes,:);
RotationTable = direction_table(RotationLogical,:);
rotationTime = RotationTable.rodent_RecordingTime;
%     subplot(2,1,1);
%     plot(direction_table.rodent_XCenter, direction_table.rodent_YCenter);
%     hold on;
%     plot(RotationTableOverEst.rodent_XCenter,RotationTableOverEst.rodent_YCenter, ...
%         'r.','MarkerSize',8);
%     subplot(2,1,2);
%% We need only this plot
%     plot(direction_table.rodent_XCenter, direction_table.rodent_YCenter);
%     hold on;
%     plot(RotationTable.rodent_XCenter, RotationTable.rodent_YCenter,'r.','MarkerSize', 8);
%     xlabel("X coordinate");
%     ylabel("Y coordinate");
%     title("Rotation points of scar, trial 24, 06-Apr-2022");
%     legend('trajectory','rotation points','Location','best');
%     lgd = legend;
%     lgd.FontSize = 7;
%     hold off;
minOfxCleaned = 20.4186; maxOfxCleaned = 77.9602;
minOfyCleaned = 5.58859; maxOfyCleaned = 63.1704;
xNormalized = 0.2 + (direction_table.rodent_XCenter - minOfxCleaned)/...
    (maxOfxCleaned - minOfxCleaned); % Take it from stopTimeWithPlot function
yNormalized = 0.2 + (direction_table.rodent_YCenter - minOfyCleaned)/...
    (maxOfyCleaned - minOfyCleaned); % Take it from stopTimeWithPlot function
plot(xNormalized,yNormalized);
hold on;
rotationXnorm = 0.2 + (RotationTable.rodent_XCenter - minOfxCleaned)/...
    (maxOfxCleaned - minOfxCleaned); % Take it from stopTimeWithPlot function
rotationYnorm = 0.2 + (RotationTable.rodent_YCenter - minOfyCleaned)/...
    (maxOfyCleaned - minOfyCleaned); % Take it from stopTimeWithPlot function
plot(rotationXnorm, rotationYnorm,'r.','MarkerSize', 8);
% add start and end points
plot(xNormalized(1),yNormalized(1),'g*','MarkerSize',10);
plot(xNormalized(end),yNormalized(end),'r*','MarkerSize',10);
xlabel("X coordinate");
ylabel("Y coordinate");
title("Rotation points of carl, trial 22, 06-Apr-2022");
legend('trajectory','rotation points','start','end','Location','best');
lgd = legend;
lgd.FontSize = 7;
%% Draw the feeder zones
Xcen = [1.2 0.2 0.2 1.2];
Ycen = [1.2 1.2 0.2 0.2];
widthOfFeeder = 0.25*(1.2 - 0.2);
heightOfFeeder = 0.25*(1.2 - 0.2);
%%
% create two empty arrays to store coordinates of limiting points
%
xLim = ones(1, length(Xcen));
yLim = ones(1, length(Xcen));
xLim(1,1) = Xcen(1) - widthOfFeeder; xLim(1,2) = Xcen(2) + widthOfFeeder;
xLim(1,3) = Xcen(3) + widthOfFeeder; xLim(1,4) = Xcen(4) - widthOfFeeder;
yLim(1,1) = Ycen(1) - heightOfFeeder; yLim(1,2) = Ycen(2) - heightOfFeeder;
yLim(1,3) = Ycen(3) + heightOfFeeder; yLim(1,4) = Ycen(4) + heightOfFeeder;
rectangle('Position', [xLim(1,1), yLim(1,1), widthOfFeeder, heightOfFeeder], 'EdgeColor', 'none', ...
    'FaceColor', [0.3 0.3 0.3 0.3]);
rectangle('Position', [Xcen(1,2), yLim(1,2), widthOfFeeder, heightOfFeeder], 'EdgeColor', 'none', ...
    'FaceColor', [1 0 0 0.3]);
rectangle('Position', [Xcen(1,3), Ycen(1,3), widthOfFeeder, heightOfFeeder], 'EdgeColor', 'none', ...
    'FaceColor', [0.3 0.3 0.3 0.3]);
rectangle('Position', [xLim(1,4), Ycen(1,4), widthOfFeeder, heightOfFeeder], 'EdgeColor', 'none', ...
    'FaceColor', [0.3 0.3 0.3 0.3]);
end