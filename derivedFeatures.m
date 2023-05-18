
% bigaccelerationperunittravel
featuretable3.bigaccelerationperunittravel = ...
str2double(featuretable3.bigAcceleration)./str2double(featuretable3.distanceAfterToneUntilLimitingTimeStamp);

% accoutlier_movemedian_per_unittravel
featuretable3.accoutlier_movemedian_per_unittravel = ...
str2double(featuretable3.accOutlierMoveMedian)./str2double(featuretable3.distanceAfterToneUntilLimitingTimeStamp);

% accoutlier_gesd_per_unittravel
featuretable3.accoutlier_gesd_per_unittravel = ...
str2double(featuretable3.accOutlierGesd)./str2double(featuretable3.distanceAfterToneUntilLimitingTimeStamp);

% accoutlier_method1_per_unittravel
featuretable3.accoutlier_method1_per_unittravel = ...
str2double(featuretable3.accOutlierMethod1)./str2double(featuretable3.distanceAfterToneUntilLimitingTimeStamp);

% effectivevelocitymethod1
featuretable3.effectivevelocitymethod1 = str2double( ...
    featuretable3.distanceAfterToneUntilLimitingTimeStamp)./(20 - str2double(featuretable3.stoptimemethod1));

% stoppingpts_per_unittravel_method6
featuretable3.stoppingpts_per_unittravel_method6 = str2double( ...
    featuretable3.stoptimemethod6)*10./str2double(featuretable3.distanceAfterToneUntilLimitingTimeStamp);

% rotationpts_per_unittravel_method4
featuretable3.rotationpts_per_unittravel_method4 = str2double(...
    featuretable3.rotationptsmethod4)./str2double(featuretable3.distanceAfterToneUntilLimitingTimeStamp);

for col = 2:78
    featuretable3.(col) = string(featuretable3.(col));
end
% Load the input_data and featuretable2 tables
load('input_data.mat');
load('featuretable2.mat');
