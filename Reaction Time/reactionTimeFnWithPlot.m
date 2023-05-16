%% Reaction time analysis
function [logicalOut, runTime, reactionTime1st,reactionTime2nd,reactionTimeOfApproach] ...
= reactionTimeFnWithPlot(~,~,~) %(name,referencetime,'Trial22')
tic;
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
% tablename = "live_table";
query = "SELECT subjectid, mazenumber, feeder, trialname, referencetime," + ...
    " playstarttrialtone, presentcost, coordinatetimes2, xcoordinates2," + ...
    " ycoordinates2 " + ...
    " FROM live_table  ORDER BY id;";
all_data = fetch(conn,query);
%%
% convert date to datetype
%
all_data.referencetime = string(datetime(all_data.referencetime,'Format','dd-MMM-uuuu'));
data_on_date = all_data(all_data.referencetime == "06-Apr-2022",:);

%% convert all table entries from string to usable format
fn_data_on_date();
    function fn_data_on_date()
        data_on_date = convertvars(data_on_date,'mazenumber','categorical');
        data_on_date = convertvars(data_on_date,'subjectid','string');

        %% 
        % convert char to double in feeder column
        %
        all_feeder = cell(length(data_on_date.feeder),1);
        for idx = 1:length(data_on_date.feeder)
            all_feeder{idx,1} = str2double(data_on_date.feeder{idx});
            data_on_date.feeder{idx} = all_feeder{idx,1};
        end

        %% 
        % convert char to double in presentcost column
        %
        all_presentcost = cell(length(data_on_date.presentcost),1);
        for idx = 1:length(data_on_date.presentcost)
            all_presentcost{idx,1} = str2double(data_on_date.presentcost{idx});
            data_on_date.presentcost{idx} = all_presentcost{idx,1};
        end

        %% 
        % convert char to double in playstarttrialtone column
        %
        all_playstarttrialtone = cell(length(data_on_date.playstarttrialtone),1);
        for idx = 1:length(data_on_date.playstarttrialtone)
            all_playstarttrialtone{idx,1} = str2double(data_on_date.playstarttrialtone{idx});
            data_on_date.playstarttrialtone{idx} = all_playstarttrialtone{idx,1};
        end

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
        % Accessing PGArray data as double
        %
        all_coordinatetimes = cell(length(data_on_date.coordinatetimes2),1);
        for idx = 1:length(data_on_date.coordinatetimes2)
            string_all_coordinatetimes = string(data_on_date.coordinatetimes2(idx,1));
            reg_all_coordinatetimes = regexprep(string_all_coordinatetimes,'{|}','');
            split_all_coordinatetimes = split(reg_all_coordinatetimes,',');
            all_coordinatetimes{idx,1} = str2double(split_all_coordinatetimes);
            data_on_date.coordinatetimes2{idx,1} = all_coordinatetimes{idx,1};
        end

        all_xcoordinates = cell(length(data_on_date.xcoordinates2),1);
        for idx = 1:length(data_on_date.xcoordinates2)
            string_all_xcoordinates = string(data_on_date.xcoordinates2(idx,1));
            reg_all_xcoordinates = regexprep(string_all_xcoordinates,'{|}','');
            split_all_xcoordinates = split(reg_all_xcoordinates,',');
            all_xcoordinates{idx,1} = str2double(split_all_xcoordinates);
            data_on_date.xcoordinates2{idx,1} = all_xcoordinates{idx,1};
        end

        all_ycoordinates = cell(length(data_on_date.ycoordinates2),1);
        for idx = 1:length(data_on_date.ycoordinates2)
            string_all_ycoordinates = string(data_on_date.ycoordinates2(idx,1));
            reg_all_ycoordinates = regexprep(string_all_ycoordinates,'{|}','');
            split_all_ycoordinates = split(reg_all_ycoordinates,',');
            all_ycoordinates{idx,1} = str2double(split_all_ycoordinates);
            data_on_date.ycoordinates2{idx,1} = all_ycoordinates{idx,1};
        end
    end
%%
% all 40 trials of subjectid on the date
%
subject_data = data_on_date(data_on_date.subjectid == 'carl',:);
%%
%
xCoordinates2 = subject_data.xcoordinates2{find(subject_data.trialname == 'Trial22',1)};
yCoordinates2 = subject_data.ycoordinates2{find(subject_data.trialname == 'Trial22',1)};
plot(xCoordinates2,yCoordinates2);
ax = gca;
% ax.XAxisLocation = 'origin';
% ax.YAxisLocation = 'origin';
ax.XLim = [min(xCoordinates2) max(xCoordinates2)];
ax.YLim = [min(yCoordinates2) max(yCoordinates2)];
xlabel("X coordinate");
ylabel("Y coordinate");
title("Trajectory of carl, trial 22, 06-Apr-2022");
hold off;

%%
% Collect all coordinatetimes2, xcoordinates2, ycoordinates2 for all subjects on the
% date to define Maze coordinates 
%
coordinatetimes2 = vertcat(data_on_date.coordinatetimes2{:});
xcoordinates2 = vertcat(data_on_date.xcoordinates2{:});
ycoordinates2 = vertcat(data_on_date.ycoordinates2{:});

data_on_date_table = table(coordinatetimes2, xcoordinates2, ycoordinates2);
%% 4 Mazes based on signs
[Maze2, Maze1, Maze3, Maze4, xCleanedByYAxis2, yCleanedByYAxis2, ...
            xCleanedByYAxis1, yCleanedByYAxis1, xCleanedByYAxis3, yCleanedByYAxis3, ...
            xCleanedByYAxis4, yCleanedByYAxis4] = fn_cleaned_data();
    function [Maze2, Maze1, Maze3, Maze4, xCleanedByYAxis2, yCleanedByYAxis2, ...
            xCleanedByYAxis1, yCleanedByYAxis1, xCleanedByYAxis3, yCleanedByYAxis3, ...
            xCleanedByYAxis4, yCleanedByYAxis4] = fn_cleaned_data()
        Maze2 = data_on_date_table(data_on_date_table.xcoordinates2>=0 ...
            & data_on_date_table.ycoordinates2>=0,:);
        xOriginal2 = Maze2.xcoordinates2;
        yOriginal2 = Maze2.ycoordinates2;
        %%
        % Clean up data/remove outliers separately along X and Y axis
        %
        % clean X axis data
        subplot(2, 2, 1)
        plot(xOriginal2, yOriginal2, 'r.', 'MarkerSize', 8)
        grid on
        title('Original Data')
        subplot(2, 2, 2)
        [countsOfX2, edgesOfX2] = histcounts(xOriginal2, 100);
        bar(edgesOfX2(1:end-1), countsOfX2, 1)
        grid on;
        title('Histogram of X values');
        theCDFofX2 = rescale(cumsum(countsOfX2) / sum(countsOfX2), 0, 100);
        subplot(2, 2, 4)
        plot(edgesOfX2(1:end-1), theCDFofX2, 'b-', 'LineWidth', 2)
        title('CDF of Histogram')
        grid on;
        % Find the index of the 5% and 95% points
        index1ofX2 = find(theCDFofX2 > 5, 1, 'first');
        x1ofMaze2 = edgesOfX2(index1ofX2);
        xline(edgesOfX2(index1ofX2), 'LineWidth', 2, 'Color', 'r')
        % Find the index of the 5% and 95% points
        index2ofX2 = find(theCDFofX2 > 95, 1, 'first');
        x2ofMaze2 = edgesOfX2(index2ofX2);
        xline(edgesOfX2(index2ofX2), 'LineWidth', 2, 'Color', 'r')
        % Get a mask for the x values we want to exclude
        indexesToKeepOfX2 = xOriginal2 >= x1ofMaze2 & xOriginal2 <= x2ofMaze2;
        xCleanedByXAxis2 = xOriginal2(indexesToKeepOfX2);
        yCleanedByXAxis2 = yOriginal2(indexesToKeepOfX2);
        subplot(2, 2, 3)
        plot(xCleanedByXAxis2, yCleanedByXAxis2, 'r.', 'MarkerSize', 8)
        grid on
        title('Cleaned Data by x axis')

        % clean y axis data
        hold off;
        subplot(2, 2, 1)
        plot(xCleanedByXAxis2, yCleanedByXAxis2, 'r.', 'MarkerSize', 8)
        grid on
        title('Original Data')
        subplot(2, 2, 2)
        [countsOfY2, edgesOfY2] = histcounts(yCleanedByXAxis2, 100);
        bar(edgesOfY2(1:end-1), countsOfY2, 1)
        grid on;
        title('Histogram of Y values');
        theCDFofY2 = rescale(cumsum(countsOfY2) / sum(countsOfY2), 0, 100);
        subplot(2, 2, 4)
        plot(edgesOfY2(1:end-1), theCDFofY2, 'b-', 'LineWidth', 2)
        title('CDF of Histogram')
        grid on;
        % Find the index of the 5% and 95% points
        index1ofY2 = find(theCDFofY2 > 5, 1, 'first');
        y1ofMaze2 = edgesOfY2(index1ofY2);
        xline(edgesOfY2(index1ofY2), 'LineWidth', 2, 'Color', 'r')
        % Find the index of the 5% and 95% points
        index2ofY2 = find(theCDFofY2 > 95, 1, 'first');
        y2ofMaze2 = edgesOfY2(index2ofY2);
        xline(edgesOfY2(index2ofY2), 'LineWidth', 2, 'Color', 'r')
        % Get a mask for the x values we want to exclude
        indexesToKeepOfY2 = yCleanedByXAxis2 >= y1ofMaze2 & yCleanedByXAxis2 <= y2ofMaze2;
        xCleanedByYAxis2 = xCleanedByXAxis2(indexesToKeepOfY2);
        yCleanedByYAxis2 = yCleanedByXAxis2(indexesToKeepOfY2);
        subplot(2, 2, 3)
        plot(xCleanedByYAxis2, yCleanedByYAxis2, 'r.', 'MarkerSize', 8)
        grid on
        title('Cleaned Data')
        hold off;

        Maze1 = data_on_date_table(data_on_date_table.xcoordinates2<=0 ...
            & data_on_date_table.ycoordinates2>=0,:);
        xOriginal1 = Maze1.xcoordinates2;
        yOriginal1 = Maze1.ycoordinates2;
        %%
        % Clean up data/remove outliers separately along X and Y axis
        %
        % clean X axis data
        subplot(2, 2, 1)
        plot(xOriginal1, yOriginal1, 'r.', 'MarkerSize', 8)
        grid on
        title('Original Data')
        subplot(2, 2, 2)
        [countsOfX1, edgesOfX1] = histcounts(xOriginal1, 100);
        bar(edgesOfX1(1:end-1), countsOfX1, 1)
        grid on;
        title('Histogram of X values');
        theCDFofX1 = rescale(cumsum(countsOfX1) / sum(countsOfX1), 0, 100);
        subplot(2, 2, 4)
        plot(edgesOfX1(1:end-1), theCDFofX1, 'b-', 'LineWidth', 2)
        title('CDF of Histogram')
        grid on;
        % Find the index of the 5% and 95% points
        index1ofX1 = find(theCDFofX1 > 5, 1, 'first');
        x1ofMaze1 = edgesOfX1(index1ofX1);
        xline(edgesOfX1(index1ofX1), 'LineWidth', 2, 'Color', 'r')
        % Find the index of the 5% and 95% points
        index2ofX1 = find(theCDFofX1 > 95, 1, 'first');
        x2ofMaze1 = edgesOfX1(index2ofX1);
        xline(edgesOfX1(index2ofX1), 'LineWidth', 2, 'Color', 'r')
        % Get a mask for the x values we want to exclude
        indexesToKeepOfX1 = xOriginal1 >= x1ofMaze1 & xOriginal1 <= x2ofMaze1;
        xCleanedByXAxis1 = xOriginal1(indexesToKeepOfX1);
        yCleanedByXAxis1 = yOriginal1(indexesToKeepOfX1);
        subplot(2, 2, 3)
        plot(xCleanedByXAxis1, yCleanedByXAxis1, 'r.', 'MarkerSize', 8)
        grid on
        title('Cleaned Data by x axis')
        hold off;

        % clean y axis data
        subplot(2, 2, 1)
        plot(xCleanedByXAxis1, yCleanedByXAxis1, 'r.', 'MarkerSize', 8)
        grid on
        title('Original Data')
        subplot(2, 2, 2)
        [countsOfY1, edgesOfY1] = histcounts(yCleanedByXAxis1, 100);
        bar(edgesOfY1(1:end-1), countsOfY1, 1)
        grid on;
        title('Histogram of Y values');
        theCDFofY1 = rescale(cumsum(countsOfY1) / sum(countsOfY1), 0, 100);
        subplot(2, 2, 4)
        plot(edgesOfY1(1:end-1), theCDFofY1, 'b-', 'LineWidth', 2)
        title('CDF of Histogram')
        grid on;
        % Find the index of the 5% and 95% points
        index1ofY1 = find(theCDFofY1 > 5, 1, 'first');
        y1ofMaze1 = edgesOfY1(index1ofY1);
        xline(edgesOfY1(index1ofY1), 'LineWidth', 2, 'Color', 'r')
        % Find the index of the 5% and 95% points
        index2ofY1 = find(theCDFofY1 > 95, 1, 'first');
        y2ofMaze1 = edgesOfY1(index2ofY1);
        xline(edgesOfY1(index2ofY1), 'LineWidth', 2, 'Color', 'r')
        % Get a mask for the x values we want to exclude
        indexesToKeepOfY1 = yCleanedByXAxis1 >= y1ofMaze1 & yCleanedByXAxis1 <= y2ofMaze1;
        xCleanedByYAxis1 = xCleanedByXAxis1(indexesToKeepOfY1);
        yCleanedByYAxis1 = yCleanedByXAxis1(indexesToKeepOfY1);
        subplot(2, 2, 3)
        plot(xCleanedByYAxis1, yCleanedByYAxis1, 'r.', 'MarkerSize', 8)
        grid on
        title('Cleaned Data')
        hold off;

        Maze3 = data_on_date_table(data_on_date_table.xcoordinates2<=0 ...
            & data_on_date_table.ycoordinates2<=0,:);
        xOriginal3 = Maze3.xcoordinates2;
        yOriginal3 = Maze3.ycoordinates2;
        %%
        % Clean up data/remove outliers separately along X and Y axis
        %
        % clean X axis data
        subplot(2, 2, 1)
        plot(xOriginal3, yOriginal3, 'r.', 'MarkerSize', 8)
        grid on
        title('Original Data')
        subplot(2, 2, 2)
        [countsOfX3, edgesOfX3] = histcounts(xOriginal3, 100);
        bar(edgesOfX3(1:end-1), countsOfX3, 1)
        grid on;
        title('Histogram of X values');
        theCDFofX3 = rescale(cumsum(countsOfX3) / sum(countsOfX3), 0, 100);
        subplot(2, 2, 4)
        plot(edgesOfX3(1:end-1), theCDFofX3, 'b-', 'LineWidth', 2)
        title('CDF of Histogram')
        grid on;
        % Find the index of the 5% and 95% points
        index1ofX3 = find(theCDFofX3 > 5, 1, 'first');
        x1ofMaze3 = edgesOfX3(index1ofX3);
        xline(edgesOfX3(index1ofX3), 'LineWidth', 2, 'Color', 'r')
        % Find the index of the 5% and 95% points
        index2ofX3 = find(theCDFofX3 > 95, 1, 'first');
        x2ofMaze3 = edgesOfX3(index2ofX3);
        xline(edgesOfX3(index2ofX3), 'LineWidth', 2, 'Color', 'r')
        % Get a mask for the x values we want to exclude
        indexesToKeepOfX3 = xOriginal3 >= x1ofMaze3 & xOriginal3 <= x2ofMaze3;
        xCleanedByXAxis3 = xOriginal3(indexesToKeepOfX3);
        yCleanedByXAxis3 = yOriginal3(indexesToKeepOfX3);
        subplot(2, 2, 3)
        plot(xCleanedByXAxis3, yCleanedByXAxis3, 'r.', 'MarkerSize', 8)
        grid on
        title('Cleaned Data by x axis')        
        hold off;

        % clean y axis data
        subplot(2, 2, 1)
        plot(xCleanedByXAxis3, yCleanedByXAxis3, 'r.', 'MarkerSize', 8)
        grid on
        title('Original Data')
        subplot(2, 2, 2)
        [countsOfY3, edgesOfY3] = histcounts(yCleanedByXAxis3, 100);
        bar(edgesOfY3(1:end-1), countsOfY3, 1)
        grid on;
        title('Histogram of Y values');
        theCDFofY3 = rescale(cumsum(countsOfY3) / sum(countsOfY3), 0, 100);
        subplot(2, 2, 4)
        plot(edgesOfY3(1:end-1), theCDFofY3, 'b-', 'LineWidth', 2)
        title('CDF of Histogram')
        grid on;
        % Find the index of the 5% and 95% points
        index1ofY3 = find(theCDFofY3 > 5, 1, 'first');
        y1ofMaze3 = edgesOfY3(index1ofY3);
        xline(edgesOfY3(index1ofY3), 'LineWidth', 2, 'Color', 'r')
        % Find the index of the 5% and 95% points
        index2ofY3 = find(theCDFofY3 > 95, 1, 'first');
        y2ofMaze3 = edgesOfY3(index2ofY3);
        xline(edgesOfY3(index2ofY3), 'LineWidth', 2, 'Color', 'r')
        % Get a mask for the y values we want to exclude
        indexesToKeepOfY3 = yCleanedByXAxis3 >= y1ofMaze3 & yCleanedByXAxis3 <= y2ofMaze3;
        xCleanedByYAxis3 = xCleanedByXAxis3(indexesToKeepOfY3);
        yCleanedByYAxis3 = yCleanedByXAxis3(indexesToKeepOfY3);
        subplot(2, 2, 3)
        plot(xCleanedByYAxis3, yCleanedByYAxis3, 'r.', 'MarkerSize', 8)
        grid on
        title('Cleaned Data')
        hold off;

        Maze4 = data_on_date_table(data_on_date_table.xcoordinates2>=0 ...
            & data_on_date_table.ycoordinates2<=0,:);
        xOriginal4 = Maze4.xcoordinates2;
        yOriginal4 = Maze4.ycoordinates2;
        %%
        % Clean up data/remove outliers separately along X and Y axis
        %
        % clean X axis data
        subplot(2, 2, 1)
        plot(xOriginal4, yOriginal4, 'r.', 'MarkerSize', 8)
        grid on
        title('Original Data')
        subplot(2, 2, 2)
        [countsOfX4, edgesOfX4] = histcounts(xOriginal4, 100);
        bar(edgesOfX4(1:end-1), countsOfX4, 1)
        grid on;
        title('Histogram of X values');
        theCDFofX4 = rescale(cumsum(countsOfX4) / sum(countsOfX4), 0, 100);
        subplot(2, 2, 4)
        plot(edgesOfX4(1:end-1), theCDFofX4, 'b-', 'LineWidth', 2)
        title('CDF of Histogram')
        grid on;
        % Find the index of the 5% and 95% points
        index1ofX4 = find(theCDFofX4 > 5, 1, 'first');
        x1ofMaze4 = edgesOfX4(index1ofX4);
        xline(edgesOfX4(index1ofX4), 'LineWidth', 2, 'Color', 'r')
        % Find the index of the 5% and 95% points
        index2ofX4 = find(theCDFofX4 > 95, 1, 'first');
        x2ofMaze4 = edgesOfX4(index2ofX4);
        xline(edgesOfX4(index2ofX4), 'LineWidth', 2, 'Color', 'r')
        % Get a mask for the x values we want to exclude
        indexesToKeepOfX4 = xOriginal4 >= x1ofMaze4 & xOriginal4 <= x2ofMaze4;
        xCleanedByXAxis4 = xOriginal4(indexesToKeepOfX4);
        yCleanedByXAxis4 = yOriginal4(indexesToKeepOfX4);
        subplot(2, 2, 3)
        plot(xCleanedByXAxis4, yCleanedByXAxis4, 'r.', 'MarkerSize', 8)
        grid on
        title('Cleaned Data by x axis')
        hold off;

        % clean y axis data
        subplot(2, 2, 1)
        plot(xCleanedByXAxis4, yCleanedByXAxis4, 'r.', 'MarkerSize', 8)
        grid on
        title('Original Data')
        subplot(2, 2, 2)
        [countsOfY4, edgesOfY4] = histcounts(yCleanedByXAxis4, 100);
        bar(edgesOfY4(1:end-1), countsOfY4, 1)
        grid on;
        title('Histogram of Y values');
        theCDFofY4 = rescale(cumsum(countsOfY4) / sum(countsOfY4), 0, 100);
        subplot(2, 2, 4)
        plot(edgesOfY4(1:end-1), theCDFofY4, 'b-', 'LineWidth', 2)
        title('CDF of Histogram')
        grid on;
        % Find the index of the 5% and 95% points
        index1ofY4 = find(theCDFofY4 > 5, 1, 'first');
        y1ofMaze4 = edgesOfY4(index1ofY4);
        xline(edgesOfY4(index1ofY4), 'LineWidth', 2, 'Color', 'r')
        % Find the index of the 5% and 95% points
        index2ofY4 = find(theCDFofY4 > 95, 1, 'first');
        y2ofMaze4 = edgesOfY4(index2ofY4);
        xline(edgesOfY4(index2ofY4), 'LineWidth', 2, 'Color', 'r')
        % Get a mask for the y values we want to exclude
        indexesToKeepOfY4 = yCleanedByXAxis4 >= y1ofMaze4 & yCleanedByXAxis4 <= y2ofMaze4;
        xCleanedByYAxis4 = xCleanedByXAxis4(indexesToKeepOfY4);
        yCleanedByYAxis4 = yCleanedByXAxis4(indexesToKeepOfY4);
        subplot(2, 2, 3)
        plot(xCleanedByYAxis4, yCleanedByYAxis4, 'r.', 'MarkerSize', 8)
        grid on
        title('Cleaned Data')
        hold off;

        %%
        % plot raw data vs cleaned data on same graph
        subplot(2, 1, 1);
        plot(xOriginal2, yOriginal2, 'r.', 'MarkerSize', 8);
        hold on;
        plot(xOriginal1, yOriginal1, 'r.', 'MarkerSize', 8);
        plot(xOriginal3, yOriginal3, 'r.', 'MarkerSize', 8);
        plot(xOriginal4, yOriginal4, 'r.', 'MarkerSize', 8);
        ax = gca;
        ax.XAxisLocation = 'origin';
        ax.YAxisLocation = 'origin';
        xlabel("X Center");
        ylabel("Y Center");
        hold off;
        title('Raw Data');
        subplot(2, 1, 2);
        plot(xCleanedByYAxis2, yCleanedByYAxis2, 'r.', 'MarkerSize', 8);
        hold on;
        plot(xCleanedByYAxis1, yCleanedByYAxis1, 'r.', 'MarkerSize', 8);
        plot(xCleanedByYAxis3, yCleanedByYAxis3, 'r.', 'MarkerSize', 8);
        plot(xCleanedByYAxis4, yCleanedByYAxis4, 'r.', 'MarkerSize', 8);
        ax = gca;
        ax.XAxisLocation = 'origin';
        ax.YAxisLocation = 'origin';
        xlabel("X Center");
        ylabel("Y Center");
        hold off;
        title('Cleaned Data');
    end

%% Determine in which feeder category the reward was offered
feeder_category = fn_feeder_zones();
    function feeder_category = fn_feeder_zones()
        %% 
        % define feeder zone around extereme/terminal points
        % central points of the feeder zones
        %
        %%
        % determine extereme points of Mazes dynamically
        %
        xMaxMaze2 = max(xCleanedByYAxis2); xMinMaze2 = min(xCleanedByYAxis2);
        yMaxMaze2 = max(yCleanedByYAxis2); yMinMaze2 = min(yCleanedByYAxis2);
        %%
        % Change the NaN values for Xcen and Ycen if the Maze is empty
        %
        if isequal(xMaxMaze2,xMinMaze2)
            xMaxMaze2 = 600;
            xMinMaze2 = 100;
        end
        if isequal(yMaxMaze2,yMinMaze2)
            yMaxMaze2 = 600;
            yMinMaze2 = 100;
        end

        xMaxMaze1 = max(xCleanedByYAxis1); xMinMaze1 = min(xCleanedByYAxis1);
        yMaxMaze1 = max(yCleanedByYAxis1); yMinMaze1 = min(yCleanedByYAxis1);
        if isequal(xMaxMaze1,xMinMaze1)
            xMaxMaze1 = -100;
            xMinMaze1 = -600;
        end
        if isequal(yMaxMaze1,yMinMaze1)
            yMaxMaze1 = 600;
            yMinMaze1 = 100;
        end

        xMaxMaze3 = max(xCleanedByYAxis3); xMinMaze3 = min(xCleanedByYAxis3);
        yMaxMaze3 = max(yCleanedByYAxis3); yMinMaze3 = min(yCleanedByYAxis3);
        if isequal(xMaxMaze3,xMinMaze3)
            xMaxMaze3 = -100;
            xMinMaze3 = -600;
        end
        if isequal(yMaxMaze3,yMinMaze3)
            yMaxMaze3 = -100;
            yMinMaze3 = -600;
        end

        xMaxMaze4 = max(xCleanedByYAxis4); xMinMaze4 = min(xCleanedByYAxis4);
        yMaxMaze4 = max(yCleanedByYAxis4); yMinMaze4 = min(yCleanedByYAxis4);
        if isequal(xMaxMaze4,xMinMaze4)
            xMaxMaze4 = 600;
            xMinMaze4 = 100;
        end
        if isequal(yMaxMaze4,yMinMaze4)
            yMaxMaze4 = -100;
            yMinMaze4 = -600;
        end
        
        Xcen = [xMaxMaze2 xMinMaze2 xMinMaze2 xMaxMaze2, ...
            xMaxMaze1 xMinMaze1 xMinMaze1 xMaxMaze1, ...
            xMaxMaze3 xMinMaze3 xMinMaze3 xMaxMaze3, ...
            xMaxMaze4 xMinMaze4 xMinMaze4 xMaxMaze4];
        Ycen = [yMaxMaze2 yMaxMaze2 yMinMaze2 yMinMaze2, ...
            yMaxMaze1 yMaxMaze1 yMinMaze1 yMinMaze1, ...
            yMaxMaze3 yMaxMaze3 yMinMaze3 yMinMaze3, ...
            yMaxMaze4 yMaxMaze4 yMinMaze4 yMinMaze4];
        %%
        % Add labels on central points of the feeder zones 
        %
        clf;
        textCell = arrayfun(@(x,y) sprintf('(%d, %d)',x,y),Xcen,Ycen,'UniformOutput',0);
        scatter(Xcen, Ycen, 12, "black", "filled");
        for ii = 1:numel(Xcen)
            text(Xcen(ii)+2, Ycen(ii)+2,textCell{ii},'FontSize',10)
        end
        ax = gca;
        ax.XAxisLocation = 'origin';
        ax.YAxisLocation = 'origin';
        xlabel("X Center");
        ylabel("Y Center");
        title('central points of the feeder zones')
        hold off;
        %%
        % define the size of the zone
        %
        width2 = 0.25*(xMaxMaze2 - xMinMaze2); width1 = 0.25*(xMaxMaze1 - xMinMaze1);
        width3 = 0.25*(xMaxMaze3 - xMinMaze3); width4 = 0.25*(xMaxMaze4 - xMinMaze4);
        height2 = 0.25*(yMaxMaze2 - yMinMaze2); height1 = 0.25*(yMaxMaze1 - yMinMaze1);
        height3 = 0.25*(yMaxMaze3 - yMinMaze3); height4 = 0.25*(yMaxMaze4 - yMinMaze4);
        TotalWidth = [width2 width2 width2 width2, ...
            width1 width1 width1 width1, ...
            width3 width3 width3 width3, ... 
            width4 width4 width4 width4];
        TotalHeight = [height2 height2 height2 height2, ...
            height1 height1 height1 height1, ...
            height3 height3 height3 height3, ...
            height4 height4 height4 height4];

        %%
        % create two empty arrays to store coordinates of limiting points
        %
        xLim = ones(1, length(Xcen));
        yLim = ones(1, length(Xcen));
        %% 
        % X coordinates of the limiting points
        %
        for i = 1:4:length(Xcen)
            xLim(1, i) = Xcen(i)-TotalWidth(i);
        end
        for i = 4:4:length(Xcen)
            xLim(1, i) = Xcen(i)-TotalWidth(i);
        end
        for i = 2:4:length(Xcen)
            xLim(1, i) = Xcen(i)+TotalWidth(i);
        end
        for i = 3:4:length(Xcen)
            xLim(1, i) = Xcen(i)+TotalWidth(i);
        end

        %% 
        % Y coordinates of the limiting points
        %
        for i = 1:4:length(Xcen)
            yLim(1, i) = Ycen(i)-TotalHeight(i);
        end
        for i = 2:4:length(Xcen)
            yLim(1, i) = Ycen(i)-TotalHeight(i);
        end
        for i = 3:4:length(Xcen)
            yLim(1, i) = Ycen(i)+TotalHeight(i);
        end
        for i = 4:4:length(Xcen)
            yLim(1, i) = Ycen(i)+TotalHeight(i);
        end

        %% 
        % Add labels on limiting points
        %
        textCell = arrayfun(@(x,y) sprintf('(%d, %d)',x,y),xLim,yLim, ...
            'UniformOutput',0);
        scatter(xLim, yLim, 12, "black", "filled");
        for ii = 1:numel(xLim)
            text(xLim(ii)+2, yLim(ii)+2,textCell{ii},'FontSize',10)
        end
        ax = gca;
        ax.XAxisLocation = 'origin';
        ax.YAxisLocation = 'origin';
        xlabel("X Center");
        ylabel("Y Center");
        title('limiting points of feeder zones');

        %% 
        % Extract all coordinates on the trial date in the zone
        %
        %% 
        % q1 of 4 mazes
        %
        feeder1 = {'q4Maze2', 'q2Maze1', 'q4Maze3', 'q2Maze4'};
        feeder1{1} = Maze2(Maze2.xcoordinates2>=xLim(1,4) & Maze2.ycoordinates2<=yLim(1,4),:);
        feeder1{2} = Maze1(Maze1.xcoordinates2<=xLim(1,6) & Maze1.ycoordinates2>=yLim(1,6),:);
        feeder1{3} = Maze3(Maze3.xcoordinates2>=xLim(1,12) & Maze3.ycoordinates2<=yLim(1,12),:);
        feeder1{4} = Maze4(Maze4.xcoordinates2<=xLim(1,14) & Maze4.ycoordinates2>=yLim(1,14),:);


        %% 
        % q2 of 4 mazes
        %
        feeder2 = {'q3Maze2', 'q3Maze1', 'q1Maze3', 'q1Maze4'};
        feeder2{1} = Maze2(Maze2.xcoordinates2<=xLim(1,3) & Maze2.ycoordinates2<=yLim(1,3),:);
        feeder2{2} = Maze1(Maze1.xcoordinates2<=xLim(1,7) & Maze1.ycoordinates2<=yLim(1,7),:);
        feeder2{3} = Maze3(Maze3.xcoordinates2>=xLim(1,9) & Maze3.ycoordinates2>=yLim(1,9),:);
        feeder2{4} = Maze4(Maze4.xcoordinates2>=xLim(1,13) & Maze4.ycoordinates2>=yLim(1,13),:);


        %% 
        % q3 of 4 mazes
        %
        feeder3 = {'q2Maze2', 'q4Maze1', 'q2Maze3', 'q4Maze4'};
        feeder3{1} = Maze2(Maze2.xcoordinates2<=xLim(1,2) & Maze2.ycoordinates2>=yLim(1,2),:);
        feeder3{2} = Maze1(Maze1.xcoordinates2>=xLim(1,8) & Maze1.ycoordinates2<=yLim(1,8),:);
        feeder3{3} = Maze3(Maze3.xcoordinates2<=xLim(1,10) & Maze3.ycoordinates2>=yLim(1,10),:);
        feeder3{4} = Maze4(Maze4.xcoordinates2>=xLim(1,16) & Maze4.ycoordinates2<=yLim(1,16),:);

        %% 
        % q4 of 4 mazes
        %
        feeder4 = {'q1Maze2', 'q1Maze1', 'q3Maze3', 'q3Maze4'};
        feeder4{1} = Maze2(Maze2.xcoordinates2>=xLim(1,1) & Maze2.ycoordinates2>=yLim(1,1),:);
        feeder4{2} = Maze1(Maze1.xcoordinates2>=xLim(1,5) & Maze1.ycoordinates2>=yLim(1,5),:);
        feeder4{3} = Maze3(Maze3.xcoordinates2<=xLim(1,11) & Maze3.ycoordinates2<=yLim(1,11),:);
        feeder4{4} = Maze4(Maze4.xcoordinates2<=xLim(1,15) & Maze4.ycoordinates2<=yLim(1,15),:);

        %% 
        % collect all the coordinates in feeder zones
        %
        hold off;
        feeder1_sum = vertcat(feeder1{:});
        scatter(feeder1_sum.xcoordinates2, feeder1_sum.ycoordinates2);
        hold on;
        feeder2_sum = vertcat(feeder2{:});
        scatter(feeder2_sum.xcoordinates2, feeder2_sum.ycoordinates2);
        feeder3_sum = vertcat(feeder3{:});
        scatter(feeder3_sum.xcoordinates2, feeder3_sum.ycoordinates2);
        feeder4_sum = vertcat(feeder4{:});
        scatter(feeder4_sum.xcoordinates2, feeder4_sum.ycoordinates2);
        ax = gca;
        ax.XAxisLocation = 'origin';
        ax.YAxisLocation = 'origin';
        xlabel("X Center");
        ylabel("Y Center");
        legend('feeder1','feeder2','feeder3','feeder4','Location','northeast')
        hold off;

        feeder_category = [{feeder1_sum}, {feeder2_sum}, {feeder3_sum}, {feeder4_sum}];
    end
%% Compare rodent position with feeder zone 
% includes the data before playstarttrialtone
%
subject_data_table_with_tone = table( ...
    subject_data.coordinatetimes2{find(subject_data.trialname == 'Trial22',1)}, ...
    subject_data.xcoordinates2{find(subject_data.trialname == 'Trial22',1)}, ...
    subject_data.ycoordinates2{find(subject_data.trialname == 'Trial22',1)}, ...
    'VariableNames',{'coordinatetimes2','xcoordinates2', 'ycoordinates2'});
%% 
% set playstarttrialtone and exclude the data before playstarttrialtone
%subject_data_table = subject_data_table_with_tone(subject_data_table_with_tone.coordinatetimes2 >= starting_coordinatetimes,:);

starting_coordinatetimes = subject_data.playstarttrialtone{find(subject_data.trialname == 'Trial22',1)}; 
subject_data_table = subject_data_table_with_tone(subject_data_table_with_tone.coordinatetimes2 >= starting_coordinatetimes,:);
which_feeder = subject_data.feeder{find(subject_data.trialname == 'Trial22',1)};
%%
% does the subject go to feeder zone?
%
if ~ismember(which_feeder,[1 2 3 4])
    logicalOut = NaN;
else
    subject_in_feeder = subject_data_table(ismember(subject_data_table,feeder_category{which_feeder}),:);
    scatter(subject_in_feeder.xcoordinates2, subject_in_feeder.ycoordinates2);
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    xlabel("X Center");
    ylabel("Y Center");
    axis([-90 90 -75 75]);
    hold on;
    logicalOut = ~isempty(subject_in_feeder);
end
%%
% do not run further calculations if logical ouput is zero
%
if ~isequal(logicalOut,1)
    runTime = NaN;
else
    %%
    % entering and exiting coordinates in the feeder zone
    %
    entering_data = subject_data_table(subject_data_table.coordinatetimes2<=subject_in_feeder.coordinatetimes2(1),:);
    plot(entering_data.xcoordinates2, entering_data.ycoordinates2, 'Color','g');
    runTime = 0.1*length(entering_data.coordinatetimes2);
end
%% get reaction_time based on velocity and acceleration irrespective of appraoch
[reactionTime1st,reactionTime2nd] = fn_velo_acc();
    function [reactionTime1st,reactionTime2nd] = fn_velo_acc()
        if height(subject_data_table) < 15
            reactionTime1st = NaN;
            reactionTime2nd = NaN;
        else
            velocityData = diff(table2array(subject_data_table));
            distData = sqrt(velocityData(:,2).^2+velocityData(:,3).^2);
            velocity = distData./velocityData(:,1);
%             velocityTable = table(subject_data_table.coordinatetimes2(1:end-1,:),velocity, ...
%                 'VariableNames',{'coordinatetimes2', 'velocity'});
%             subplot(2,1,1);
%             velocity_filt  = sgolayfilt(velocityTable.velocity, 3, 7);
%             min_velocity = islocalmin(velocity_filt);
%             max_velocity = islocalmax(velocity_filt);
%             plot(velocityTable.coordinatetimes2, velocity_filt, ...
%                 velocityTable.coordinatetimes2(min_velocity | max_velocity), ...
%                 velocity_filt(min_velocity | max_velocity), 'r*');
%             lgd = legend;
%             lgd.FontSize = 7;
%             hold on;
%             min_max = table(velocityTable.coordinatetimes2(min_velocity | max_velocity), ...
%                 velocity_filt(min_velocity | max_velocity), 'VariableNames',{'coordinatetimes2', 'velocity'});
%             outlier = isoutlier(min_max.velocity);
%             plot(min_max.coordinatetimes2(outlier), min_max.velocity(outlier), 'c*');
%             legend('velocity','local extrema','outlier','Location','northeast')
%             lgd = legend;
%             lgd.FontSize = 7;
            hold off;
            accelaration = diff(velocity)./velocityData(1:end-1,1);

            accelarationTable = table(subject_data_table.coordinatetimes2(1:end-2,:),accelaration, ...
                'VariableNames',{'coordinatetimes2', 'accelaration'});
%             subplot(2,1,2);
            accelaration_filt  = sgolayfilt(accelarationTable.accelaration, 3, 7);
            min_accelaration = islocalmin(accelaration_filt);
            max_accelaration = islocalmax(accelaration_filt);
            plot(accelarationTable.coordinatetimes2, accelaration_filt, ...
                accelarationTable.coordinatetimes2(min_accelaration | max_accelaration), ...
                accelaration_filt(min_accelaration | max_accelaration), 'r*');
            xlabel("Coordinatime");
            ylabel("Acceleration");
            title(sprintf('reaction time based on acceleration\ncarl, trial 22, 06-Apr-2022'));
            hold on;
            min_max = table(accelarationTable.coordinatetimes2(min_accelaration | max_accelaration), ...
                accelaration_filt(min_accelaration | max_accelaration), 'VariableNames',{'coordinatetimes2', 'accelaration'});
            outlier = isoutlier(min_max.accelaration);
            plot(min_max.coordinatetimes2(outlier), min_max.accelaration(outlier), 'c*');
            outlier_data = table(min_max.coordinatetimes2(outlier), min_max.accelaration(outlier), 'VariableNames', ...
                {'coordinatetimes2', 'accelaration'});
            %%
            % how much time the animal takes to react after play start trial tone
            %
            if height(outlier_data) < 1
                reactionTime1st = NaN;
            else
                reactionTime1stStamp = outlier_data.coordinatetimes2(1);
                reactionTime1st = reactionTime1stStamp - starting_coordinatetimes;
                plot(outlier_data.coordinatetimes2(1), outlier_data.accelaration(1),'mo','MarkerSize',15);
                legend('accelaration','local extrema','outlier','reaction time','Location','northeast')
                lgd = legend;
                lgd.FontSize = 7;
                hold off;
                xCoordinatesOfReaction = subject_data_table.xcoordinates2( ...
                    subject_data_table.coordinatetimes2 == outlier_data.coordinatetimes2(1));
                yCoordinatesOfReaction = subject_data_table.ycoordinates2( ...
                    subject_data_table.coordinatetimes2 == outlier_data.coordinatetimes2(1));
                plot(xCoordinates2,yCoordinates2);
                hold on;
                plot(xCoordinates2(1),yCoordinates2(1),'g*','MarkerSize',10);
                plot(xCoordinates2(end),yCoordinates2(end),'r*','MarkerSize',10);
                ax = gca;

                %% Draw the feeder zones
                xMaxMaze2 = max(xCleanedByYAxis2); xMinMaze2 = min(xCleanedByYAxis2);
                yMaxMaze2 = max(yCleanedByYAxis2); yMinMaze2 = min(yCleanedByYAxis2);
                Xcen = [xMaxMaze2 xMinMaze2 xMinMaze2 xMaxMaze2];
                Ycen = [yMaxMaze2 yMaxMaze2 yMinMaze2 yMinMaze2];
                width2 = 0.25*(xMaxMaze2 - xMinMaze2);
                height2 = 0.25*(yMaxMaze2 - yMinMaze2);
                %%
                % create two empty arrays to store coordinates of limiting points
                %
                xLim = ones(1, length(Xcen));
                yLim = ones(1, length(Xcen));
                xLim(1,1) = Xcen(1) - width2; xLim(1,2) = Xcen(2) + width2;
                xLim(1,3) = Xcen(3) + width2; xLim(1,4) = Xcen(4) - width2;
                yLim(1,1) = Ycen(1) - height2; yLim(1,2) = Ycen(2) - height2;
                yLim(1,3) = Ycen(3) + height2; yLim(1,4) = Ycen(4) + height2;
                
                rectangle('Position', [xLim(1,1), yLim(1,1), width2, height2], 'EdgeColor', 'none', ...
                    'FaceColor', [0.3 0.3 0.3 0.3]);
                rectangle('Position', [Xcen(1,2), yLim(1,2), width2, height2], 'EdgeColor', 'none', ...
                    'FaceColor', [0.3 0.3 0.3 0.3]);
                rectangle('Position', [Xcen(1,3), Ycen(1,3), width2, height2], 'EdgeColor', 'none', ...
                    'FaceColor', [1 0 0 0.3]);
                rectangle('Position', [xLim(1,4), Ycen(1,4), width2, height2], 'EdgeColor', 'none', ...
                    'FaceColor', [0.3 0.3 0.3 0.3]);

                xlabel("X coordinate");
                ylabel("Y coordinate");
                title("Trajectory of carl, trial 22, 06-Apr-2022");
                plot(xCoordinatesOfReaction,yCoordinatesOfReaction,'mo','MarkerSize',15);
                legend('trajectory','start','end','reaction time','Location','best');
                lgd = legend;
                lgd.FontSize = 7;
                hold off;
            end
            % get 2nd guess data
            if height(outlier_data) < 2
                reactionTime2nd = NaN;
            else
                reactionTime2ndStamp = outlier_data.coordinatetimes2(2);
                reactionTime2nd = reactionTime2ndStamp - starting_coordinatetimes;
            end
        end
    end
%% Find the reaction time when subject approach the feeder zone 
reactionTimeOfApproach = reactionTimeOfApproachFn();
    function reactionTimeOfApproach = reactionTimeOfApproachFn()
        %%
        % do not run further calculations if logical ouput is zero
        %
        if ~isequal(logicalOut,1)
            reactionTimeOfApproach = NaN;
            return
        elseif height(entering_data) < 15
            reactionTimeOfApproach = NaN;
            return;
        else
            v_entering_data = diff(table2array(entering_data));
            dist_entering_data = sqrt(v_entering_data(:,2).^2+v_entering_data(:,3).^2);
            entering_velocity = dist_entering_data./v_entering_data(:,1);

            entering_accelaration = diff(entering_velocity)./v_entering_data(1:end-1,1);
            entering_accelaration_table = table(entering_data.coordinatetimes2(1:end-2,:),entering_accelaration, ...
                'VariableNames',{'coordinatetimes2', 'entering_accelaration'});
            accelaration_filt  = sgolayfilt(entering_accelaration_table.entering_accelaration, 2, 7);
            min_accelaration = islocalmin(accelaration_filt);
            max_accelaration = islocalmax(accelaration_filt);
            min_max = table(entering_accelaration_table.coordinatetimes2(min_accelaration | max_accelaration), ...
                accelaration_filt(min_accelaration | max_accelaration), 'VariableNames',{'coordinatetimes2', 'entering_accelaration'});
            outlier = isoutlier(min_max.entering_accelaration);
            outlier_data = table(min_max.coordinatetimes2(outlier), min_max.entering_accelaration(outlier), 'VariableNames', ...
                {'coordinatetimes2', 'entering_accelaration'});
            %%
            % if outlier_data table is empty then there is no raectionTimeOfApproach
            %
            if height(outlier_data) < 1
                reactionTimeOfApproach = NaN;
                return;
            else
                reactionTimeOfApproach = outlier_data.coordinatetimes2(1) - starting_coordinatetimes;
            end
        end
    end
toc;
end