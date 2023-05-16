clear; clc;
% Define the names of the .mat files
matFiles = {'stopTime1to6765.mat'};

% Initialize an empty cell array to keep track of the variabnles that have already been loaded and concatenated
vars = {};

for i = 1:length(matFiles)
    % Load the variables from the current .mat file
    data = load(matFiles{i});
    % Get the list of variables in the current .mat file
    varsCurrent = fieldnames(data);
    % Loop through the variables in the current .mat file
    for j = 1:length(varsCurrent)
        % Check if the variable exists in the previous .mat files
        if exist(varsCurrent{j},'var')
            % Concatenate the variable with the previous variable
            eval([varsCurrent{j} '=' 'vertcat(' varsCurrent{j} ', data.' varsCurrent{j} ');']);
        else
            % Add the variable to the workspace
            eval([varsCurrent{j} '= data.' varsCurrent{j} ';']);
            % Add the variable to the list of variables
            vars = [vars; varsCurrent{j}];
        end
    end
end

% Initialize the table
stopTime1to6765 = table();

% Loop through the cell arrays and add them as new variables to the table
for i = 1:length(varsCurrent)
    stopTime1to6765.(varsCurrent{i}) = eval(varsCurrent{i});
end

% check for empty cell and replace with nan
stopTime1to6765{:,:}(cellfun(@isempty,stopTime1to6765{:,:})) = {nan};

stopTimeOutputs = nan(height(stopTime1to6765),6);
% Extract the 1x4 double arrays from each cell
for i = 1:size(stopTimeOutputs,1)
    stopTimeOutputs(i,:) = stopTime1to6765.stopTime{i};
end

stopTime_1to6765 = array2table(stopTimeOutputs,"VariableNames", ...
    ["stoptimemethod1","stoptimemethod2","stoptimemethod3","stoptimemethod4", ...
    "stoptimemethod5","stoptimemethod6"]);

% convert everything to string
for column = 1:size(stopTime_1to6765,2)
    stopTime_1to6765.(column) = string(stopTime_1to6765.(column));
end

stopTime_1to6765.id = cell2mat(stopTime1to6765.id);
% save the table
save('stopTime_1to6765','stopTime_1to6765');