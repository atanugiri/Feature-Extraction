% Author: Atanu Giri
% Date: 11/02/2023

% This function takes the id as input and uses the corresponding date
% to remove the outlier/bad data of all the trials on the date.
% The clean data is used as reference to normalize the data for plotting trajectory

function [xCleanedByYAxis,yCleanedByYAxis] = cleanedDataOnDate(id)

% id = 94461;

datasource = 'live_database';
conn = database(datasource,'postgres','1234');
dateQuery = sprintf("SELECT referencetime FROM live_table WHERE id = %d;", id);
subjectData = fetch(conn,dateQuery);

% We need same tasktype as id for coherent normalization
taskTypeDoneQuery = sprintf("SELECT tasktypedone FROM live_table " + ...
    "WHERE id = %d;", id);
taskTypeDone = fetch(conn,taskTypeDoneQuery);


% drop the timestamps from referencetime for clustering
referencetime = char(subjectData.referencetime);
currentDate = referencetime(1:10);

% Select data of same date and tasktypedone
dataOnDateQuery = sprintf("SELECT id, mazenumber, tasktypedone, xcoordinates2, " + ...
    "ycoordinates2 FROM live_table WHERE referencetime LIKE '%%%s%%' AND " + ...
    "REPLACE(tasktypedone, ' ', '') ILIKE REPLACE('%s', ' ', '') ORDER BY id", ...
    currentDate, string(taskTypeDone.tasktypedone));
dataOnDate = fetch(conn,dataOnDateQuery);
close(conn);


% Accessing PGArray data as double
dataOnDate.xcoordinates2 = transformPgarray(dataOnDate.xcoordinates2);
dataOnDate.ycoordinates2 = transformPgarray(dataOnDate.ycoordinates2);
dataOnDate.mazenumber = string(dataOnDate.mazenumber);

xcoordinates2 = vertcat(dataOnDate.xcoordinates2{:});
ycoordinates2 = vertcat(dataOnDate.ycoordinates2{:});
data_on_date_table = table(xcoordinates2, ycoordinates2);

% remove nan values
idx = all(isfinite(data_on_date_table{:,:}),2);
data_on_date_table = data_on_date_table(idx,:);


% create a container for data for all mazes
Maze = {'Maze2','Maze1','Maze3','Maze4'};
% define the coordinates of the mazes
Maze{1} = data_on_date_table(data_on_date_table.xcoordinates2>=0 ...
    & data_on_date_table.ycoordinates2>=0,:);
Maze{2} = data_on_date_table(data_on_date_table.xcoordinates2<=0 ...
    & data_on_date_table.ycoordinates2>=0,:);
Maze{3} = data_on_date_table(data_on_date_table.xcoordinates2<=0 ...
    & data_on_date_table.ycoordinates2<=0,:);
Maze{4} = data_on_date_table(data_on_date_table.xcoordinates2>=0 ...
    & data_on_date_table.ycoordinates2<=0,:);


% Create a container for clean x and y coordinates
xCleanedByYAxis = {'xCleanMaze2','xCleanMaze1','xCleanMaze3','xCleanMaze4'};
yCleanedByYAxis = {'yCleanMaze2','yCleanMaze1','yCleanMaze3','yCleanMaze4'};

% populate clean x and y ordiantes for each maze using loop
for i = 1:length(Maze)
    xOriginal = Maze{i}.xcoordinates2;
    yOriginal = Maze{i}.ycoordinates2;
%     plot(xOriginal,yOriginal,'k.');
    %%
    % Clean up data/remove outliers separately along X and Y axis
    %
    % clean X axis data
    [countsOfX, edgesOfX] = histcounts(xOriginal, 100);
    theCDFofX = rescale(cumsum(countsOfX) / sum(countsOfX), 0, 100);
    % Find the index of the 5% and 95% points
    index1ofX = find(theCDFofX > 0.1, 1, 'first');
    x1ofMaze = edgesOfX(index1ofX);
    index2ofX = find(theCDFofX > 99.9, 1, 'first');
    x2ofMaze = edgesOfX(index2ofX);
    % Get a mask for the x values we want to exclude
    indexesToKeepOfX = xOriginal >= x1ofMaze & xOriginal <= x2ofMaze;
    xCleanedByXAxis = xOriginal(indexesToKeepOfX);
    yCleanedByXAxis = yOriginal(indexesToKeepOfX);

    % clean y axis data
    [countsOfY, edgesOfY] = histcounts(yCleanedByXAxis, 100);
    theCDFofY = rescale(cumsum(countsOfY) / sum(countsOfY), 0, 100);
    % Find the index of the 5% and 95% points
    index1ofY = find(theCDFofY > 0.1, 1, 'first');
    y1ofMaze = edgesOfY(index1ofY);
    index2ofY = find(theCDFofY > 99.9, 1, 'first');
    y2ofMaze = edgesOfY(index2ofY);
    % Get a mask for the x values we want to exclude
    indexesToKeepOfY = yCleanedByXAxis >= y1ofMaze & yCleanedByXAxis <= y2ofMaze;
    xCleanedByYAxis{i} = xCleanedByXAxis(indexesToKeepOfY);
    yCleanedByYAxis{i} = yCleanedByXAxis(indexesToKeepOfY);
end
end

%% Description of transformPgarray
function transformedData = transformPgarray(pgarrayData)
transformedData = cell(length(pgarrayData),1);
for idx = 1:length(pgarrayData)
    string_all_xcoordinates = string(pgarrayData(idx,1));
    reg_all_xcoordinates = regexprep(string_all_xcoordinates,'{|}','');
    split_all_xcoordinates = split(reg_all_xcoordinates,',');
    transformedData{idx,1} = str2double(split_all_xcoordinates);
end

end