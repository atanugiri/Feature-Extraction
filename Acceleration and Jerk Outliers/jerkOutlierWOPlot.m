% Author: Atanu Giri
% date: 11/13/2022
% This algorithm calculates the number of outliers by analyzing subject's
% acceleration and jerkness. Various different mathematical methods have
% been used to calculate the outlers.

function [id,totalRunningTime,accOutlierMethod1, bigAcceleration, accOutlierMedian, accOutlierMoveMedian, accOutlierMean, ...
    accOutlierQuartiles,accOutlierGrubbs,accOutlierGesd,accOutlierThreshold, ...
    jerkOutlierMethod1,bigJerkness,jerkOutlierMedian,jerkOutlierMoveMedian,jerkOutlierMean, ...
    jerkOutlierQuartiles,jerkOutlierGrubbs,jerkOutlierGesd, ...
    jerkOutlierThreshold, varargout] = jerkOutlierWOPlot(id)
close all; clc;
% id = 4985;
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

% remove nan entries
badDataWithTone = table(subject_data.coordinatetimes2{1}, ...
    subject_data.xcoordinates2{1},subject_data.ycoordinates2{1}, ...
    'VariableNames',{'t','X','Y'});
cleanedDataWithTone = badDataWithTone;
% remove nan values
idx = all(isfinite(cleanedDataWithTone{:,:}),2);
cleanedDataWithTone = cleanedDataWithTone(idx,:);

totalRunningTime = cleanedDataWithTone.t(end);

%%
% set playstarttrialtone and exclude the data before playstarttrialtone
%
starting_coordinatetimes = subject_data.playstarttrialtone;
subject_data_table = cleanedDataWithTone(cleanedDataWithTone.t >= ...
    starting_coordinatetimes,:);

%% calculate the outputs
% Difference data
diffData = diff(table2array(subject_data_table));
distData = sqrt(diffData(:,2).^2+diffData(:,3).^2);
velocity = distData./diffData(:,1);

%% Acceleration analysis
accelaration = diff(velocity)./diffData(1:end-1,1);
accelarationTable = table(subject_data_table.t(1:end-2,:),accelaration, ...
    'VariableNames',{'coordinatetimes2', 'accelaration'});
accelaration_filt  = sgolayfilt(accelarationTable.accelaration, 3, 11);
% calculate acceleration outlier method1
min_accelaration = islocalmin(accelaration_filt);
max_accelaration = islocalmax(accelaration_filt);
accOutlierMethod1 = nnz(min_accelaration) + nnz(max_accelaration);

% outlier of outliers for bigacceleration
allOutlierAcceleration = accelaration_filt(min_accelaration | max_accelaration);
logicalBigAcceleration = isoutlier(allOutlierAcceleration);
bigAcceleration = nnz(logicalBigAcceleration);

% calculate acceleration outlier by median
accOutlierMedian = nnz(isoutlier(accelaration_filt));
accOutlierMoveMedian = nnz(isoutlier(accelaration_filt,"movmedian",5));


% calculate acceleration outlier by mean
accOutlierMean = nnz(isoutlier(accelaration_filt,"mean"));
% calculate acceleration outlier by quartiles
accOutlierQuartiles = nnz(isoutlier(accelaration_filt,"quartiles"));
% calculate acceleration outlier by grubbs
accOutlierGrubbs = nnz(isoutlier(accelaration_filt,"grubbs"));
% calculate acceleration outlier by gesd
accOutlierGesd = nnz(isoutlier(accelaration_filt,"gesd"));
% calculate acceleration outlier by threshold
accOutlierThreshold = nnz(isoutlier(accelaration_filt,"percentiles",[30 70]));

%% Jerkness analysis
jerkness = diff(accelaration)./diffData(1:end-2,1);
jerknessTable = table(subject_data_table.t(1:end-3,:),jerkness, ...
    'VariableNames',{'coordinatetimes2', 'jerkness'});
jerknessFilter  = sgolayfilt(jerknessTable.jerkness, 3, 11);
% calculate jerkness outlier method1
minJerkness = islocalmin(jerknessFilter);
maxJerkness = islocalmax(jerknessFilter);
jerkOutlierMethod1 = nnz(minJerkness) + nnz(maxJerkness);

% outlier of outliers for bigacceleration
allOutlierJerkness = jerknessFilter(minJerkness | maxJerkness);
logicalBigJerkness = isoutlier(allOutlierJerkness);
bigJerkness = nnz(logicalBigJerkness);

% calculate jerkness outlier by median
jerkOutlierMedian = nnz(isoutlier(jerknessFilter));
jerkOutlierMoveMedian = nnz(isoutlier(jerknessFilter,"movmedian",5));
% calculate jerkness outlier by mean
jerkOutlierMean = nnz(isoutlier(jerknessFilter,"mean"));
% calculate jerkness outlier by quartiles
jerkOutlierQuartiles = nnz(isoutlier(jerknessFilter,"quartiles"));
% calculate jerkness outlier by grubbs
jerkOutlierGrubbs = nnz(isoutlier(jerknessFilter,"grubbs"));
% calculate jerkness outlier by gesd
jerkOutlierGesd = nnz(isoutlier(jerknessFilter,"gesd"));
% calculate jerkness outlier by threshold
jerkOutlierThreshold = nnz(isoutlier(jerknessFilter,"percentiles",[30 70]));

%% Plot data
h = figure;
plot(accelarationTable.coordinatetimes2,accelarationTable.accelaration,'b','LineWidth',1.5);
hold on;
myFilter = isoutlier(accelaration_filt,"movmedian",5);
% myFilter = isoutlier(accelaration_filt);
% % indexes = find(min_accelaration | max_accelaration);
% % myFilter = indexes(logicalBigAcceleration);
accOutlierTime = accelarationTable.coordinatetimes2(myFilter);
plot(accOutlierTime, accelarationTable.accelaration(myFilter),'r.','MarkerSize',20);
xlim([2, 20]);
% xlabel('Time',Interpreter='latex',FontSize=14);
% ylabel('Acceleration',Interpreter='latex',FontSize=14);
% title('Acceleration Outliers Per Unit Travel in Baseline',Interpreter='latex');

varargout{1} = h;
varargout{2} = accOutlierTime;
end