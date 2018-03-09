clear; close all; clc;

lambda_store = (380:750)';

%%
lms_data = dlmread('linss10e_1.csv');
lms = interp1(lms_data(:,1), lms_data(:,2:end), lambda_store);

figure(1); clf;
set(gcf, 'Position', [100, 100, 800, 640]);
h = plot(lambda_store, lms, 'linewidth', 2);
set(gca, 'FontSize', 18, 'XLim', [360, 770], 'YLim', [-.02, 1.05]);
set(h(1), 'Color', 'r');
set(h(2), 'Color', 'g');
set(h(3), 'Color', 'b');
xlabel('Wavelength (nm)', 'FontSize', 22);
ylabel('Sensitivity', 'FontSize', 22);
legend({'L-type', 'M-type', 'S-type'}, 'FontSize', 18, 'Location', 'best', ...
    'Position', [.7, .7, .15, .18]);


%%
cmf_data = dlmread('lin2012xyz10e_1_7sf.csv');
cmf = interp1(cmf_data(:,1), cmf_data(:,2:end), lambda_store);

figure(2); clf;
set(gcf, 'Position', [100, 100, 800, 640]);
h = plot(lambda_store, cmf, 'LineWidth', 2);
set(gca, 'FontSize', 18, 'XLim', [360, 770], 'YLim', [-.02, 2.25]);
set(h(1), 'Color', 'r');
set(h(2), 'Color', 'g');
set(h(3), 'Color', 'b');
xlabel('Wavelength (nm)', 'FontSize', 22);
ylabel('Tristimulus Value', 'FontSize', 22);
legend({'$\bar{x}(\lambda)$', '$\bar{y}(\lambda)$', '$\bar{z}(\lambda)$'}, ...
    'FontSize', 18, 'Location', 'best', ...
    'Position', [.7, .7, .15, .18], 'Interpreter', 'latex');

%%
rgb_cmf_data = dlmread('SB10_corrected_indiv_CMFs.csv');
idx = abs(diff([rgb_cmf_data(1,:); rgb_cmf_data])) > 0.5 & abs(rgb_cmf_data) < 1e-10;
rgb_cmf_data(idx) = nan;
rgb_cmf = [rgb_cmf_data(:,2), nanmean(rgb_cmf_data(:,3:3:end),2), ...
    nanmean(rgb_cmf_data(:,4:3:end),2), nanmean(rgb_cmf_data(:,5:3:end),2)];
rgb_cmf_sum = sum(bsxfun(@times, diff(rgb_cmf(:,1)), (rgb_cmf(1:end-1,2:end) + ...
    rgb_cmf(2:end,2:end))/2));

figure(3); clf;
set(gcf, 'Position', [100, 100, 800, 640]);
hold on;
h = plot(500, 0, 'r', 'LineWidth', 2.5); set(h, 'Visible', 'off');
h = plot(500, 0, 'g', 'LineWidth', 2.5); set(h, 'Visible', 'off');
h = plot(500, 0, 'b', 'LineWidth', 2.5); set(h, 'Visible', 'off');
plot(rgb_cmf_data(:,2), rgb_cmf_data(:,3:3:end), 'Color', [1, .8, .8]);
plot(rgb_cmf_data(:,2), rgb_cmf_data(:,4:3:end), 'Color', [.8, 1, .8]);
plot(rgb_cmf_data(:,2), rgb_cmf_data(:,5:3:end), 'Color', [.8, .8, 1]);
plot(rgb_cmf(:,1), rgb_cmf(:,2), 'r', 'LineWidth', 2.5);
plot(rgb_cmf(:,1), rgb_cmf(:,3), 'g', 'LineWidth', 2.5);
plot(rgb_cmf(:,1), rgb_cmf(:,4), 'b', 'LineWidth', 2.5);
set(gca, 'FontSize', 18);
xlabel('Wavelength (nm)', 'FontSize', 22);
ylabel('Tristimulus Value', 'FontSize', 22);
legend({'$\bar{r}(\lambda)$', '$\bar{g}(\lambda)$', '$\bar{b}(\lambda)$'}, ...
    'FontSize', 18, 'Location', 'best', ...
    'Position', [.2, .7, .15, .18], 'Interpreter', 'latex');
box on;

figure(4); clf;
set(gcf, 'Position', [100, 100, 800, 640]);
hold on;
plot(rgb_cmf(:,1), rgb_cmf(:,2)/rgb_cmf_sum(1)*50, 'r', 'LineWidth', 2.5);
plot(rgb_cmf(:,1), rgb_cmf(:,3)/rgb_cmf_sum(2)*50, 'g', 'LineWidth', 2.5);
plot(rgb_cmf(:,1), rgb_cmf(:,4)/rgb_cmf_sum(3)*50, 'b', 'LineWidth', 2.5);
set(gca, 'FontSize', 18, 'XLim', [360, 770]);
xlabel('Wavelength (nm)', 'FontSize', 22);
ylabel('Tristimulus Value (Normalized)', 'FontSize', 22);
legend({'$\bar{r}(\lambda)$', '$\bar{g}(\lambda)$', '$\bar{b}(\lambda)$'}, ...
    'FontSize', 18, 'Location', 'best', ...
    'Position', [.7, .7, .15, .18], 'Interpreter', 'latex');
box on;
