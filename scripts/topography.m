load CIBA120_data.mat
% variables ep_cong_s1, ep_incong_s1, ep_cong_s2, ep_incong_s2, time_points, and inputNames are loaded

% ntervals
% int_400 = find(time_points > 300 & time_points < 500); % Broad N400 window
int_3545 = find(time_points > 350 & time_points < 450); % Narrower N400 window

% Average across time points and epochs for both conditions and subjects

% Interval 350-450 ms
% Subject 1
ave_data3545c1 = squeeze(mean(mean(ep_cong_s1(:, :, int_3545), 3), 1));
ave_data3545i1 = squeeze(mean(mean(ep_incong_s1(:, :, int_3545), 3), 1));
% Subject 2
ave_data3545c2 = squeeze(mean(mean(ep_cong_s2(:, :, int_3545), 3), 1));
ave_data3545i2 = squeeze(mean(mean(ep_incong_s2(:, :, int_3545), 3), 1));



% Combine gradiometer pairs using absolute values
% Interval 350-450 ms
% Subject 1
ave_data3545c1_2 = abs(ave_data3545c1(1:2:end))' + abs(ave_data3545c1(2:2:end))';
ave_data3545i1_2 = abs(ave_data3545i1(1:2:end))' + abs(ave_data3545i1(2:2:end))';
% Subject 2
ave_data3545c2_2 = abs(ave_data3545c2(1:2:end))' + abs(ave_data3545c2(2:2:end))';
ave_data3545i2_2 = abs(ave_data3545i2(1:2:end))' + abs(ave_data3545i2(2:2:end))';

%contrasts
% Interval 350-450 ms
contrast13545 = ave_data3545c1_2 - ave_data3545i1_2; % Subject 1
contrast23545 = ave_data3545c2_2 - ave_data3545i2_2; % Subject 2

%ranges for CW and IW across both intervals
% Subject 1 (300–500 ms and 350–450 ms)
subject1_min = min([min(ave_data3545c1_2), min(ave_data3545i1_2)]);
subject1_max = max([max(ave_data3545c1_2), max(ave_data3545i1_2)]);

% Subject 2 (300–500 ms and 350–450 ms)
subject2_min = min([min(ave_data3545c2_2), min(ave_data3545i2_2)]);
subject2_max = max([max(ave_data3545c2_2), max(ave_data3545i2_2)]);


%balanced range for contrast maps across all intervals and subjects
% For Subject 1
contrast_range_s1 = max(abs([min(contrast13545), max(contrast13545)]));

% For Subject 2
contrast_range_s2 = max(abs([min(contrast23545), max(contrast23545)]));

% Use inputNames for sensor labels in topography plots
figure;
subplot(1, 3, 1);
plot_topography_mod(inputNames(1:2:end),ave_data3545c1_2,false,'grad_loc.mat',false,true,1000);
set(gca, 'clim', [subject1_min, subject1_max]);
title('S1: Congruent (350-450 ms)');
subplot(1, 3, 2);
plot_topography_mod(inputNames(1:2:end),ave_data3545i1_2,false,'grad_loc.mat',false,true,1000);
set(gca, 'clim', [subject1_min, subject1_max]);
title('S1: Incongruent (350-450 ms)');

subplot(1, 3, 3);
plot_topography_mod(inputNames(1:2:end),contrast13545,false,'grad_loc.mat',false,true,1000);
set(gca, 'clim', [-contrast_range_s1, contrast_range_s1]);
title('Contrast - S1 (350-450)');


figure;
subplot(1, 3, 1);
plot_topography_mod(inputNames(1:2:end),ave_data3545c2_2,false,'grad_loc.mat',false,true,1000);
set(gca, 'clim', [subject2_min, subject2_max]);
title('S2: Congruent (350-450 ms)');

subplot(1, 3, 2);
plot_topography_mod(inputNames(1:2:end),ave_data3545i2_2,false,'grad_loc.mat',false,true,1000);
set(gca, 'clim', [subject2_min, subject2_max]);
title('S2: Incongruent (350-450 ms)');

subplot(1, 3, 3);
plot_topography_mod(inputNames(1:2:end),contrast23545,false,'grad_loc.mat',false,true,1000);
set(gca, 'clim', [-contrast_range_s2, contrast_range_s2]);
title('Contrast - S2 (350-450)');



% finding 5 lowest sensors for each condition using sorting
% Subject 1
[sorted_c1, sort_idx_c1] = sort(ave_data3545c1_2, 'ascend'); % Congruent
[sorted_i1, sort_idx_i1] = sort(ave_data3545i1_2, 'ascend'); % Incongruent

% Subject 2
[sorted_c2, sort_idx_c2] = sort(ave_data3545c2_2, 'ascend'); % Congruent
[sorted_i2, sort_idx_i2] = sort(ave_data3545i2_2, 'ascend'); % Incongruent

% Find the indices of the 5 lowest sensors for each condition
lowest_sensors_c1 = sort_idx_c1(1:5); % Subject 1, Congruent
lowest_sensors_i1 = sort_idx_i1(1:5); % Subject 1, Incongruent
lowest_sensors_c2 = sort_idx_c2(1:5); % Subject 2, Congruent
lowest_sensors_i2 = sort_idx_i2(1:5); % Subject 2, Incongruent
disp(['5 Lowest sensors for S1 (Congruent): ', strjoin(inputNames(lowest_sensors_c1), ', ')]);
disp(['5 Lowest sensors for S1 (Incongruent): ', strjoin(inputNames(lowest_sensors_i1), ', ')]);
disp(['5 Lowest sensors for S2 (Congruent): ', strjoin(inputNames(lowest_sensors_c2), ', ')]);
disp(['5 Lowest sensors for S2 (Incongruent): ', strjoin(inputNames(lowest_sensors_i2), ', ')]);

% Plot time-series for Subject 1
figure;
plot(time_points, squeeze(mean(ep_cong_s1(:, c1sensoridx3545, :)))); % Congruent condition
hold on;
plot(time_points, squeeze(mean(ep_incong_s1(:, i1sensoridx3545, :))), 'r'); % Incongruent condition
xlabel('Time [ms]');
legend(['Gradiometer ', inputNames{sortidxc13545(1)}], ['Gradiometer ', inputNames{sortidxi13545(1)}]);
ylabel('Signal');
title('Subject 1');
set(gca, 'xlim', [-167, 833]);

% Plot time-series for Subject 2
figure;
plot(time_points, squeeze(mean(ep_cong_s2(:, c2sensoridx3545, :)))); % Congruent condition
hold on;
plot(time_points, squeeze(mean(ep_incong_s2(:, i2sensoridx3545, :))), 'r'); % Incongruent condition
xlabel('Time [ms]');
legend(['Gradiometer ', inputNames{sortidxc23545(1)}], ['Gradiometer ', inputNames{sortidxi23545(1)}]);
ylabel('Signal');
title('Subject 2');
set(gca, 'xlim', [-167, 833]);

% Highlight and label the 5 lowest sensors for each condition
load('grad_loc.mat', 'locations'); % Ensure the grad_loc.mat file contains sensor locations

% Normalize sensor locations
locations = locations / max(abs(locations(:)));

% Plot and highlight for each condition
% Subject 1 - Congruent
figure;
subplot(1,2,1);
plot_topography_mod(inputNames(1:2:end), ave_data3545c1_2, false, 'grad_loc.mat', false, true, 1000);
hold on;
for i = 1:5
    scatter(locations(lowest_sensors_c1(i), 1), locations(lowest_sensors_c1(i), 2), 100, 'r', 'filled'); % Highlight sensor
    text(locations(lowest_sensors_c1(i), 1), locations(lowest_sensors_c1(i), 2) + 0.05, inputNames{lowest_sensors_c1(i)}, ...
        'Color', 'red', 'FontSize', 10); % Label sensor
end
title('S1 Congruent: 5 Lowest Sensors');

% Subject 1 - Incongruent
subplot(1,2,2);
plot_topography_mod(inputNames(1:2:end), ave_data3545i1_2, false, 'grad_loc.mat', false, true, 1000);
hold on;
for i = 1:5
    scatter(locations(lowest_sensors_i1(i), 1), locations(lowest_sensors_i1(i), 2), 100, 'r', 'filled'); % Highlight sensor
    text(locations(lowest_sensors_i1(i), 1), locations(lowest_sensors_i1(i), 2) + 0.05, inputNames{lowest_sensors_i1(i)}, ...
        'Color', 'red', 'FontSize', 10); % Label sensor
end
title('S1 Incongruent: 5 Lowest Sensors');

% Subject 2 - Congruent
figure;
subplot(1,2,1);
plot_topography_mod(inputNames(1:2:end), ave_data3545c2_2, false, 'grad_loc.mat', false, true, 1000);
hold on;
for i = 1:5
    scatter(locations(lowest_sensors_c2(i), 1), locations(lowest_sensors_c2(i), 2), 100, 'r', 'filled'); % Highlight sensor
    text(locations(lowest_sensors_c2(i), 1), locations(lowest_sensors_c2(i), 2) + 0.05, inputNames{lowest_sensors_c2(i)}, ...
        'Color', 'red', 'FontSize', 10); % Label sensor
end
title('S2 Congruent: 5 Lowest Sensors');

% Subject 2 - Incongruent
subplot(1,2,2);
plot_topography_mod(inputNames(1:2:end), ave_data3545i2_2, false, 'grad_loc.mat', false, true, 1000);
hold on;
for i = 1:5
    scatter(locations(lowest_sensors_i2(i), 1), locations(lowest_sensors_i2(i), 2), 100, 'r', 'filled'); % Highlight sensor
    text(locations(lowest_sensors_i2(i), 1), locations(lowest_sensors_i2(i), 2) + 0.05, inputNames{lowest_sensors_i2(i)}, ...
        'Color', 'red', 'FontSize', 10); % Label sensor
end
title('S2 Incongruent: 5 Lowest Sensors');



% BEFORE AND AFTER BREAK
% Compute averages before and after the break for both conditions and subjects
% Subject 1 - Before break (epochs 1 to 54)
ave_cbefrest1 = squeeze(mean(mean(ep_cong_s1(1:54, :, int_3545), 3), 1));
ave_ibefrest1 = squeeze(mean(mean(ep_incong_s1(1:54, :, int_3545), 3), 1));

% Subject 1 - After break (epochs 55 to 108)
ave_cafrest1 = squeeze(mean(mean(ep_cong_s1(55:108, :, int_3545), 3), 1));
ave_iafrest1 = squeeze(mean(mean(ep_incong_s1(55:108, :, int_3545), 3), 1));

% Subject 2 - Before break (epochs 1 to 54)
ave_cbefrest2 = squeeze(mean(mean(ep_cong_s2(1:54, :, int_3545), 3), 1));
ave_ibefrest2 = squeeze(mean(mean(ep_incong_s2(1:54, :, int_3545), 3), 1));

% Subject 2 - After break (epochs 55 to 108)
ave_cafrest2 = squeeze(mean(mean(ep_cong_s2(55:108, :, int_3545), 3), 1));
ave_iafrest2 = squeeze(mean(mean(ep_incong_s2(55:108, :, int_3545), 3), 1));

% Combine orthogonal gradiometer pairs using absolute values
% Subject 1
ave_cbefrest1_2 = abs(ave_cbefrest1(1:2:end))' + abs(ave_cbefrest1(2:2:end))';
ave_ibefrest1_2 = abs(ave_ibefrest1(1:2:end))' + abs(ave_ibefrest1(2:2:end))';
ave_cafrest1_2 = abs(ave_cafrest1(1:2:end))' + abs(ave_cafrest1(2:2:end))';
ave_iafrest1_2 = abs(ave_iafrest1(1:2:end))' + abs(ave_iafrest1(2:2:end))';

% Subject 2
ave_cbefrest2_2 = abs(ave_cbefrest2(1:2:end))' + abs(ave_cbefrest2(2:2:end))';
ave_ibefrest2_2 = abs(ave_ibefrest2(1:2:end))' + abs(ave_ibefrest2(2:2:end))';
ave_cafrest2_2 = abs(ave_cafrest2(1:2:end))' + abs(ave_cafrest2(2:2:end))';
ave_iafrest2_2 = abs(ave_iafrest2(1:2:end))' + abs(ave_iafrest2(2:2:end))';
% Compute contrasts for each segment
% Subject 1
contrast13545bef = ave_cbefrest1_2 - ave_ibefrest1_2; % Before break
contrast13545af = ave_cafrest1_2 - ave_iafrest1_2; % After break

% Subject 2
contrast23545bef = ave_cbefrest2_2 - ave_ibefrest2_2; % Before break
contrast23545af = ave_cafrest2_2 - ave_iafrest2_2; % After break

% Determine the global color range for all contrasts
global_min = min([contrast13545bef(:); contrast13545af(:); contrast23545bef(:); contrast23545af(:)]);
global_max = max([contrast13545bef(:); contrast13545af(:); contrast23545bef(:); contrast23545af(:)]);

% Ensure valid color range
if global_min >= global_max
    global_min = global_min - 1;
    global_max = global_max + 1;
end

% Plot topographies to compare before and after break
figure;

% Subject 1 - Before Break
subplot(2, 2, 1);
plot_topography_mod('all', contrast13545bef, false, 'grad_loc.mat');
set(gca, 'clim', [global_min, global_max]); % Apply global color range
title('S1 Before Break (Contrast)');

% Subject 1 - After Break
subplot(2, 2, 2);
plot_topography_mod('all', contrast13545af, false, 'grad_loc.mat');
set(gca, 'clim', [global_min, global_max]); % Apply global color range
title('S1 After Break (Contrast)');
% Subject 2 - Before Break
subplot(2, 2, 3);
plot_topography_mod('all', contrast23545bef, false, 'grad_loc.mat');
set(gca, 'clim', [global_min, global_max]); % Apply global color range
title('S2 Before Break (Contrast)');

% Subject 2 - After Break
subplot(2, 2, 4);
plot_topography_mod('all', contrast23545af, false, 'grad_loc.mat');
set(gca, 'clim', [global_min, global_max]); % Apply global color range
title('S2 After Break (Contrast)');

% Add color bar to the figure
colorbar;
sgtitle('Comparison of Neural Activity Before and After Break');


