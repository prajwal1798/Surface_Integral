% clear;
% clc;
% close all;
% 
% % Define the number of training cases and the corresponding data sizes
% trainingCases = [20, 40, 80, 160, 320, 640, 1280, 2560];
% nCases = 20;  % Number of test cases in the dataset
% 
% % User input to select a test case for plotting
% testCaseIdx = input('Enter the test case number (1 to 20) to plot the drag values: ');
% 
% % Ensure the input is within valid range
% if testCaseIdx < 1 || testCaseIdx > nCases
%     error('Invalid test case number. Please enter a value between 1 and 20.');
% end
% 
% % Initialize arrays to store predicted drag values for each training case
% predicted_drag = zeros(length(trainingCases), 1);
% 
% % Path to directory containing lift_drag data files
% baseDir = 'D:\\FLITE2D_CNS\\Pre_post\\Lift_Drag\\';
% 
% % Loop over each training case (160, 320, 640, 1280, 2560)
% for i = 1:length(trainingCases)
%     % Construct the file path
%     inputFile = fullfile(baseDir, sprintf('lift_drag_ratios_%d.dat', trainingCases(i)));
% 
%     % Open the file and skip the header line
%     fid = fopen(inputFile, 'r');
%     if fid == -1
%         error('Error opening file: %s', inputFile);
%     end
%     fgetl(fid);  % Skip the header line
% 
%     % Read the numeric data
%     data = fscanf(fid, '%f', [14, inf]);
%     fclose(fid);
% 
%     % Extract the drag value for the interpolated data (Cd_interp is in column 3)
%     Cl_interp = data(6, testCaseIdx);
% 
%     % Extract the drag value for the predicted data (Cd_pred is in column 4)
%     Cl_pred = data(7, testCaseIdx);
% 
%     % Store the predicted drag value for this training case (logarithmic transformation)
%     predicted_drag(i) = (Cl_pred);
% 
%     % Reference drag value (Cd_interp) remains constant (logarithmic transformation)
%     if i == 1
%         reference_drag = (Cl_interp);
%     end
% end
% 
% % Plot the results with LaTeX interpreters for axes, title, and legend
% figure;
% plot(trainingCases, predicted_drag, '-^', 'LineWidth', 2, 'MarkerSize', 8);
% hold on;
% yline(reference_drag, '--r', 'LineWidth', 2);  % Plot reference drag value as a horizontal line
% 
% % Apply LaTeX formatting for the axes, title, and legend
% xlabel('Number of Training Cases', 'Interpreter', 'latex', 'FontSize', 14);
% ylabel('Lift Coefficient $(C_l)$', 'Interpreter', 'latex', 'FontSize', 14);
% title(sprintf('$(C_l)$ Progression for Test Case %d', testCaseIdx), 'Interpreter', 'latex', 'FontSize', 16);
% legend({'Predicted Lift', 'Reference Lift'}, 'Interpreter', 'latex', 'FontSize', 12, 'Location', 'best');
% 
% % Grid and formatting
% grid on;
% set(gca, 'FontSize', 12);
% set(gca, 'TickLabelInterpreter', 'latex');
% 
% fprintf('Plot generated successfully for test case %d.\n', testCaseIdx);
% 

clear;
clc;
close all;

% Define the number of training cases and the corresponding data sizes
trainingCases = [20, 40, 80, 160, 320, 640, 1280, 2560];
nCases = 20;  % Number of test cases in the dataset

% User input to select a test case for plotting
testCaseIdx = input('Enter the test case number (1 to 20) to plot the drag values: ');

% Ensure the input is within a valid range
if testCaseIdx < 1 || testCaseIdx > nCases
    error('Invalid test case number. Please enter a value between 1 and 20.');
end

% Initialize arrays to store predicted drag values for each training case
predicted_drag_N200 = zeros(length(trainingCases), 1);
predicted_drag_N100 = zeros(length(trainingCases), 1);

% Path to directories containing lift_drag data files (D and C drives)
baseDir_D = 'D:\\FLITE2D_CNS\\Pre_post\\Lift_Drag\\';
baseDir_C = 'D:\FLITE2D_CNS\COARSE_MESH\FLITE2D_CNS\Pre_post\Lift_Drag\';

% Loop over each training case (20, 40, 80, ..., 2560)
for i = 1:length(trainingCases)
    % Construct the file paths
    inputFile_D = fullfile(baseDir_D, sprintf('lift_drag_ratios_%d.dat', trainingCases(i)));
    inputFile_C = fullfile(baseDir_C, sprintf('lift_drag_ratios_%d.dat', trainingCases(i)));
    
    % Open the file and skip the header line (for D drive data)
    fid_D = fopen(inputFile_D, 'r');
    if fid_D == -1
        error('Error opening file: %s', inputFile_D);
    end
    fgetl(fid_D);  % Skip the header line
    data_D = fscanf(fid_D, '%f', [14, inf]);
    fclose(fid_D);

    % Open the file and skip the header line (for C drive data)
    fid_C = fopen(inputFile_C, 'r');
    if fid_C == -1
        error('Error opening file: %s', inputFile_C);
    end
    fgetl(fid_C);  % Skip the header line
    data_C = fscanf(fid_C, '%f', [14, inf]);
    fclose(fid_C);

    % Extract the drag values for the interpolated data (Cd_interp in column 3) and predicted data (Cd_pred in column 4)
    Cd_interp_D = data_D(6, testCaseIdx);
    Cd_pred_D = data_D(7, testCaseIdx);
    
    Cd_pred_C = data_C(7, testCaseIdx);

    % Store the log10 of predicted drag values for N200 (D drive) and N100 (C drive)
    predicted_drag_N200(i) = log10(Cd_pred_D);
    predicted_drag_N100(i) = log10(Cd_pred_C);

    % Reference drag value (logarithmic transformation)
    if i == 1
        reference_drag = log10(Cd_interp_D);
    end
end

% Plot the results
figure;
hold on;

% Plot for N200 (from D drive)
plot(log10(trainingCases), predicted_drag_N200, '-^', 'Color', 'b', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerEdgeColor', 'b', 'DisplayName', 'Predicted Lift N200');

% Plot for N100 (from C drive)
plot(log10(trainingCases), predicted_drag_N100, '-s', 'Color', 'k', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'DisplayName', 'Predicted Lift N100');

% Plot reference drag value
yline(reference_drag, '--r', 'LineWidth', 2, 'DisplayName', 'Reference Lift');

% Labels and title with LaTeX interpreter
xlabel('$ log_{10} \,(\texttt{N}_\texttt{tr})$', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('$log_{10} \, (C_l)$', 'Interpreter', 'latex', 'FontSize', 14);
title(sprintf('Log of Lift Progression for Test Case %d', testCaseIdx), 'Interpreter', 'latex', 'FontSize', 16);

% Legend
legend('Interpreter', 'latex', 'FontSize', 12, 'Location', 'best');

% Grid
grid on;
hold off;

fprintf('Drag plot generated successfully for test case %d.\n', testCaseIdx);

