%% %%%%%%%%%%%%%%%%%%%%%%%%%
%% Absolute Errors
%% %%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc
% Define the path to the errors.dat file
errorsFile = 'D:\FLITE2D_CNS\Pre_post\Lift_Drag_Results\Errors.dat';
% Read the data from errors.dat, skipping the first row (headers)
data = readmatrix(errorsFile, 'NumHeaderLines', 1);
% Extract number of training cases (based on your provided data: 80, 160, ..., 2560)
num_cases = [80, 160, 320, 640, 1280, 2560];
% Approach 1: Absolute Magnitude of Errors
abs_errors = abs(data);  % Compute the absolute value of the errors
% Compute the max, min, and average absolute errors for all test cases
max_abs_errors = max(abs_errors, [], 1);     % Maximum absolute error in each column (training case)
min_abs_errors = min(abs_errors, [], 1);     % Minimum absolute error in each column (training case)
avg_abs_errors = mean(abs_errors, 1);        % Average absolute error across all test cases (rows) for each training case
std_dev_abs_errors = std(abs_errors, 0, 1);  % Standard deviation of absolute errors
% Print out the case numbers with max and min absolute errors
[~, max_abs_case_id] = max(abs_errors, [], 1);
[~, min_abs_case_id] = min(abs_errors, [], 1);
fprintf('Max Absolute Errors:\n');
for i = 1:length(num_cases)
    fprintf('Training Case %d: Case %d with error %f\n', num_cases(i), max_abs_case_id(i), max_abs_errors(i));
end
fprintf('Min Absolute Errors:\n');
for i = 1:length(num_cases)
    fprintf('Training Case %d: Case %d with error %f\n', num_cases(i), min_abs_case_id(i), min_abs_errors(i));
end
% Plot for absolute magnitude of errors
figure;
hold on;
for case_id = 1:size(abs_errors, 1)
    plot(num_cases, log10(abs_errors(case_id, :)), '--', 'LineWidth', 1, 'DisplayName', sprintf('Case %d', case_id));
end
% Plot maximum absolute errors
plot(num_cases, log10(max_abs_errors), '-r', 'LineWidth', 2, 'DisplayName', 'Max Abs Error');
% Plot minimum absolute errors
plot(num_cases, log10(min_abs_errors), '-b', 'LineWidth', 2, 'DisplayName', 'Min Abs Error');
% Plot average absolute errors
plot(num_cases, log10(avg_abs_errors), '-g', 'LineWidth', 2, 'DisplayName', 'Average Abs Error');
% Error bars for standard deviation
errorbar(num_cases, log10(avg_abs_errors), std_dev_abs_errors, '-k', 'LineWidth', 1.5, 'DisplayName', 'Std Dev Abs Error');
xlabel('Number of Training Cases', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$\log \left( |c_{l}^{\mathrm{Target}} - c_{l}^{\mathrm{Predicted}}| \right)$', 'FontSize', 12, 'Interpreter', 'latex');
title('$\log \left( |c_{l}^{\mathrm{targ}} - c_{l}^{\mathrm{pred}}| \right)$ vs. Number of Training Cases', 'FontSize', 14, 'Interpreter', 'latex');
legend('show', 'Location', 'northeastoutside', 'Interpreter', 'latex');
grid on;
hold off;
% Save the plot (optional)
saveas(gcf, 'error_plot_magnitude_all_cases.png');  % Saves the plot as a .png file


%% %%%%%%%%%%%%%%%%%%%%%%%%%
%% Signed Errors
%% %%%%%%%%%%%%%%%%%%%%%%%%%

% % Define the path to the errors.dat file
% errorsFile = '/home/prajwal-bharadwaj/Downloads/FLITE2D_CNS/Pre_post/Lift_Drag_Results/Errors.dat';
% 
% % Read the data from errors.dat, skipping the first row (headers)
% data = readmatrix(errorsFile, 'NumHeaderLines', 1);
% 
% % Extract number of training cases (based on your provided data: 80, 160, ..., 2560)
% num_cases = [80, 160, 320, 640, 1280, 2560];
% 
% % Approach 1: Raw Signed Difference (Preserving the sign)
% signed_errors = data;  % Keep the sign of the errors (raw difference)
% 
% % Compute the max, min, and average signed errors for all test cases
% max_signed_errors = max(signed_errors, [], 1);     % Maximum signed error in each column (training case)
% min_signed_errors = min(signed_errors, [], 1);     % Minimum signed error in each column (training case)
% avg_signed_errors = mean(signed_errors, 1);        % Average signed error across all test cases (rows) for each training case
% std_dev_signed_errors = std(signed_errors, 0, 1);  % Standard deviation of signed errors
% 
% % Print out the case numbers with max and min signed errors
% [~, max_signed_case_id] = max(signed_errors, [], 1);
% [~, min_signed_case_id] = min(signed_errors, [], 1);
% 
% fprintf('Max Signed Errors:\n');
% for i = 1:length(num_cases)
%     fprintf('Training Case %d: Case %d with error %f\n', num_cases(i), max_signed_case_id(i), max_signed_errors(i));
% end
% 
% fprintf('Min Signed Errors:\n');
% for i = 1:length(num_cases)
%     fprintf('Training Case %d: Case %d with error %f\n', num_cases(i), min_signed_case_id(i), min_signed_errors(i));
% end
% 
% % Plot for signed difference of errors
% figure;
% hold on;
% for case_id = 1:size(signed_errors, 1)
%     plot(num_cases, log10(abs(signed_errors(case_id, :))), '--', 'LineWidth', 1, 'DisplayName', sprintf('Case %d', case_id));
% end
% 
% % Plot maximum signed errors
% plot(num_cases, log10(abs(max_signed_errors)), '-r', 'LineWidth', 2, 'DisplayName', 'Max Signed Error');
% 
% % Plot minimum signed errors
% plot(num_cases, log10(abs(min_signed_errors)), '-b', 'LineWidth', 2, 'DisplayName', 'Min Signed Error');
% 
% % Plot average signed errors
% plot(num_cases, log10(abs(avg_signed_errors)), '-g', 'LineWidth', 2, 'DisplayName', 'Average Signed Error');
% 
% % Error bars for standard deviation
% errorbar(num_cases, log10(abs(avg_signed_errors)), std_dev_signed_errors, '-k', 'LineWidth', 1.5, 'DisplayName', 'Std Dev Signed Error');
% 
% % Customize the plot with LaTeX-style axis labels and title
% xlabel('Number of Training Cases', 'FontSize', 12, 'Interpreter', 'latex');
% ylabel('$\log \left( |c_{l}^{\mathrm{Target}} - c_{l}^{\mathrm{Predicted}}| \right)$', 'FontSize', 12, 'Interpreter', 'latex');
% title('$\log \left( |c_{l}^{\mathrm{targ}} - c_{l}^{\mathrm{pred}}| \right)$ vs. Number of Training Cases', 'FontSize', 14, 'Interpreter', 'latex');
% legend('show', 'Location', 'northeastoutside', 'Interpreter', 'latex');
% grid on;
% hold off;
% 
% % Save the plot (optional)
% saveas(gcf, 'error_plot_signed_all_cases.png');  % Saves the plot as a .png file
