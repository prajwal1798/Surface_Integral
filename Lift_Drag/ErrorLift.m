% Script to compute errors and save them in Errors.dat
clear all
close all
clc

% Define the directories and number of cases
baseDir = 'D:\FLITE2D_CNS\Pre_post\Lift_Drag_Results';
predicted_dirs = {'Case_N80', 'Case_N160', 'Case_N320', 'Case_N640', 'Case_N1280', 'Case_N2560'};
num_cases = 20;

% File containing original lift values
original_lift_file = 'D:\FLITE2D_CNS\Pre_post\Lift_Drag_Results\Original_Lifts.dat';

% Load original lift values, skipping the CaseID column
fid = fopen(original_lift_file, 'r');
fgetl(fid); % Skip the first line with headers
data = textscan(fid, '%d %f');  % Read CaseID (int) and Original_Lift (float)
original_lifts = data{2};  % Extract only the Original_Lift column
fclose(fid);

% Ensure the original lifts match the expected number of cases
if numel(original_lifts) ~= num_cases
    error('Mismatch in the number of original lift values. Expected %d, got %d.', num_cases, numel(original_lifts));
end

% Initialize matrix to store errors (20 rows for cases, 6 columns for each training case set)
errors_matrix = zeros(num_cases, numel(predicted_dirs));

% Iterate through each predicted directory
for dir_idx = 1:numel(predicted_dirs)
    predicted_dir = fullfile(baseDir, predicted_dirs{dir_idx});
    predicted_file = fullfile(predicted_dir, 'Total_Lift.dat');
    
    % Load predicted lift values
    fid = fopen(predicted_file, 'r');
    fgetl(fid); % Skip the first line with headers
    data = textscan(fid, '%d %f');  % Read CaseID (int) and Total_Lift (float)
    predicted_lifts = data{2};  % Extract only the Total_Lift column
    fclose(fid);
    
    % Ensure the predicted lifts have the expected number of values
    if numel(predicted_lifts) ~= num_cases
        error('Mismatch in the number of predicted lift values in %s. Expected %d, got %d.', ...
              predicted_dirs{dir_idx}, num_cases, numel(predicted_lifts));
    end
    
    % Compute the error (difference between original and predicted)
    errors_matrix(:, dir_idx) = predicted_lifts - original_lifts;
end

% Save the errors matrix into Errors.dat
errors_file = fullfile(baseDir, 'Errors.dat');
fid = fopen(errors_file, 'w');
fprintf(fid, '%10s %10s %10s %10s %10s %10s\n', 'Case80', 'Case160', 'Case320', 'Case640', 'Case1280', 'Case2560');
for i = 1:num_cases
    fprintf(fid, '%10.6f %10.6f %10.6f %10.6f %10.6f %10.6f\n', errors_matrix(i, :));
end
fclose(fid);

fprintf('Errors have been successfully computed and saved to Errors.dat.\n');



