% Author: Atanu Giri
% date: 01/17/2024

function [reactionTimeMethod1, reactionTimeMethod2, reactionTimeMethod3, ...
    reactionTimeMethod4] = reactionTimeFun(id)
%
% This algorithm calculates the reaction time by movemedian method.
%

% id = 2;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% write query
liveTableQuery = sprintf("SELECT id, referencetime, playstarttrialtone, " + ...
    "coordinatetimes2, xcoordinates2, ycoordinates2 FROM live_table WHERE id = %d", id);
subject_data = fetch(conn, liveTableQuery);


try
    subject_data.playstarttrialtone = str2double(subject_data.playstarttrialtone);
    if isnan(subject_data.playstarttrialtone)
        subject_data.playstarttrialtone = 2;
    end

    % Accessing PGArray data as double
    for column = size(subject_data,2) - 2:size(subject_data,2)
        stringAllRows = string(subject_data.(column));
        regAllRows = regexprep(stringAllRows,'{|}','');
        splitAllRows = split(regAllRows,',');
        doubleData = str2double(splitAllRows);
        subject_data.(column){1} = doubleData;
    end

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

    X = cleanedDataWithTone.X;
    Y = cleanedDataWithTone.Y;
    t = cleanedDataWithTone.t;

    startingCoordinatetimes = subject_data.playstarttrialtone;
    limitingTimeIndex = 20;
    X = X(t >= startingCoordinatetimes & t <= limitingTimeIndex);
    Y = Y(t >= startingCoordinatetimes & t <= limitingTimeIndex);
    t = t(t >= startingCoordinatetimes & t <= limitingTimeIndex);

    % Calculate velocity
    Vx = diff(X) ./ diff(t); % velocity in the X direction
    Vy = diff(Y) ./ diff(t); % velocity in the Y direction

    % Append a zero at the beginning to make the size of V match the size of t
    Vx = [0; Vx];
    Vy = [0; Vy];

    % Calculate acceleration
    Ax = diff(Vx) ./ diff(t); % acceleration in the X direction
    Ay = diff(Vy) ./ diff(t); % acceleration in the Y direction

    % Append a zero at the beginning to make the size of A match the size of t
    Ax = [0; Ax];
    Ay = [0; Ay];

    % Total acceleration magnitude
    A = sqrt(Ax.^2 + Ay.^2);

    % Calculate acceleration outlier
    accOutlierFilterM1 = isoutlier(A(2:end),"movmedian",5);
    IdxM1 = find(accOutlierFilterM1, 1);
    reactionTimeMethod1 = t(IdxM1+1);

    accOutlierFilterM2 = isoutlier(A(2:end), 'movmedian', 5, ...
        'ThresholdFactor', 2);
    IdxM2 = find(accOutlierFilterM2, 1);
    reactionTimeMethod2 = t(IdxM2+1);

    accOutlierFilterM3 = isoutlier(A(2:end), 'movmedian', 5, ...
        'ThresholdFactor', 1);
    IdxM3 = find(accOutlierFilterM3, 1);
    reactionTimeMethod3 = t(IdxM3+1);

    accOutlierFilterM4 = isoutlier(A(2:end), 'movmedian', 10);
    IdxM4 = find(accOutlierFilterM4, 1);
    reactionTimeMethod4 = t(IdxM4+1);
catch
    sprintf("An error occured for id = %d\n", id);
end

end