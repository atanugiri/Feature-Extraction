clear; clc;
% Define the names of the .mat files
matFiles = {'entryExitTimeStamp_1to6765.mat'};

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
entryExitTimeStamp1to6765 = table();

% Loop through the cell arrays and add them as new variables to the table
for i = 1:length(varsCurrent)
    entryExitTimeStamp1to6765.(varsCurrent{i}) = eval(varsCurrent{i});
end

% check for empty cell and replace with nan
entryExitTimeStamp1to6765{:,:}(cellfun(@isempty,entryExitTimeStamp1to6765{:,:})) = {nan};

% convert everything to string
for column = 1:size(entryExitTimeStamp1to6765,2)
    entryExitTimeStamp1to6765.(column) = string(entryExitTimeStamp1to6765.(column));
end
entryExitTimeStamp1to6765.id = str2double(entryExitTimeStamp1to6765.id);

% save the table
save('entryExitTimeStamp1to6765','entryExitTimeStamp1to6765');