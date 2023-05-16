% Author: Atanu Giri
% date: 11/19/2022
% This figure plots velocity, acceleration and jerkness, and outliers
% corresponding to a id.

function [jerkOutlierMethod1,jerkOutlierQuartiles] = velocityAccelerationJerknessPlot(id)
close all; clc;
% id = 98484;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% write query
query = sprintf("SELECT id, subjectid, trialname, referencetime, " + ...
    "playstarttrialtone, coordinatetimes2, xcoordinates2, " + ...
    "ycoordinates2 FROM live_table WHERE id = %d;", id); %id
subject_data = fetch(conn,query);
% disp(data_on_date);
%% convert all table entries from string to usable format
    function fn_subject_data()
        % convert char to double in playstarttrialtone column
        subject_data.playstarttrialtone = str2double(subject_data.playstarttrialtone);
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
%%
% set playstarttrialtone and exclude the data before playstarttrialtone
%
starting_coordinatetimes = subject_data.playstarttrialtone;
subject_data_table = subject_data_table_with_tone(subject_data_table_with_tone.coordinatetimes2 >= ...
    starting_coordinatetimes,:);

[jerkOutlierMethod1,jerkOutlierQuartiles] = fn_jerkPoints();
    function [jerkOutlierMethod1,jerkOutlierQuartiles] = fn_jerkPoints()
        if height(subject_data_table) < 15
            jerkOutlierMethod1 = nan;
            jerkOutlierQuartiles = nan;
        else
            % Difference data
            diffData = diff(table2array(subject_data_table));
            distData = sqrt(diffData(:,2).^2+diffData(:,3).^2);
            %% velocity analysis
            velocity = distData./diffData(:,1);
            velocityTable = table(subject_data_table.coordinatetimes2(1:end-1,:),velocity, ...
                'VariableNames',{'coordinatetimes2', 'velocity'});
            % Only plot between 5 and 17 seconds
            limitedVelocityTable = velocityTable(velocityTable.coordinatetimes2 >= 5.0 ...
                & velocityTable.coordinatetimes2 <= 17.0,:);
            velocityFig = figure;
            plot(limitedVelocityTable.coordinatetimes2,limitedVelocityTable.velocity);
            hold on;
            velocityAx = gca;
            xlabel('time','Interpreter','latex'); ylabel('velocity','Interpreter','latex');
%             velocityAx.YLim = [0 1500];
            velocityAx.FontSize = 13;
            sgtitle(sprintf('Velocity\nid:%d',id));
            velFigName = sprintf('Velocity_%d',id);
            print(velocityFig,velFigName,'-dpng','-r400');
            hold off; clf;
            %% Acceleration analysis
            accelaration = diff(velocity)./diffData(1:end-1,1);
            accelarationTable = table(subject_data_table.coordinatetimes2(1:end-2,:),accelaration, ...
                'VariableNames',{'coordinatetimes2', 'accelaration'});
            % Only plot between 5 and 17 seconds
            limitedAccelarationTable = accelarationTable(accelarationTable.coordinatetimes2 >= 5.0 ...
                & accelarationTable.coordinatetimes2 <= 17.0,:);
            accelarationFig = figure;
            plot(limitedAccelarationTable.coordinatetimes2,limitedAccelarationTable.accelaration);
            hold on;
            accelarationAx = gca;
            xlabel('time','Interpreter','latex'); ylabel('accelaration','Interpreter','latex');
%             accelarationAx.YLim = [-2000 2000];
            accelarationAx.FontSize = 13;
            sgtitle(sprintf('Accelaration\nid:%d',id));
            accelarationFigName = sprintf('Accelaration_%d',id);
            print(accelarationFig,accelarationFigName,'-dpng','-r400');
            hold off; clf;
            %% Jerkness analysis
            jerkness = diff(accelaration)./diffData(1:end-2,1);
            jerknessTable = table(subject_data_table.coordinatetimes2(1:end-3,:),jerkness, ...
                'VariableNames',{'coordinatetimes2', 'jerkness'});
            % Only plot between 5 and 17 seconds
            limitedJerknessTable = jerknessTable(jerknessTable.coordinatetimes2 >= 5.0 ...
                & jerknessTable.coordinatetimes2 <= 17.0,:);
            jerknessFig = figure;
            plot(limitedJerknessTable.coordinatetimes2,limitedJerknessTable.jerkness);
            hold on;
            jerknessAx = gca;
            xlabel('time','Interpreter','latex'); ylabel('jerkness','Interpreter','latex');
%             jerknessAx.YLim = [-4000 4000];
            jerknessAx.FontSize = 13;
            sgtitle(sprintf('Jerkness\nid:%d',id));
            jerknessFigName = sprintf('Jerkness_%d',id);
            print(jerknessFig,jerknessFigName,'-dpng','-r400');
            hold off; clf;

            jerknessFilter  = sgolayfilt(jerknessTable.jerkness, 3, 11);
            % calculate jerkness outlier method1
            minJerkness = islocalmin(jerknessFilter);
            maxJerkness = islocalmax(jerknessFilter);
            jerkOutlierMethod1 = nnz(minJerkness) + nnz(maxJerkness);
            % plot data
            h = figure;
            plot(jerknessTable.coordinatetimes2,jerknessTable.jerkness);
            xlabel("Coordinatetime"); ylabel("jerkness");
            ylim([-10*10^4 10*10^4]);
            hold on;
            plot(jerknessTable.coordinatetimes2(minJerkness | maxJerkness), ...
                jerknessTable.jerkness(minJerkness | maxJerkness),'ro');
            % calculate jerkness outlier by Median
            outlierFilterQuartiles = isoutlier(jerknessFilter,"quartiles");
            jerkOutlierQuartiles = nnz(outlierFilterQuartiles);
            % plot jerkness outlier by Median
            plot(jerknessTable.coordinatetimes2(outlierFilterQuartiles), ...
                jerknessTable.jerkness(outlierFilterQuartiles),'g*','MarkerSize',10);
            hold off;
            % title of graph
            name = string(subject_data.subjectid);
            trialname = strrep(string(subject_data.trialname),' ','');
            date = string(datetime(subject_data.referencetime, "Format","dd/MM/uuuu"));
            sgtitle(sprintf('Jerkness\nid:%d\n%s, %s, %s',id,name,trialname,date));
            %             outlierFilterMoveMeidan = isoutlier(jerknessFilter,"movmedian",5);
            %             jerkOutlierMoveMedian = nnz(outlierFilterMoveMeidan);
            %             plot(jerknessTable.coordinatetimes2(outlierFilterMoveMeidan), ...
            %                 jerknessTable.jerkness(outlierFilterMoveMeidan),'gx','MarkerSize',10);
            fig_name = sprintf('id%d',id);
%             print(h,fig_name,'-dpng','-r400');
        end
    end
end