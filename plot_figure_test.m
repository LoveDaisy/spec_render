clear; close all; clc;

%%
lambda_store = (400:720)';

sun_spectrum = ones(size(lambda_store));
sun_spectrum = sun_spectrum / sum(sun_spectrum);

adjust_method = 'ShrinkToGrayAdjust';
color_space = 'sRGB';
max_y = .55;
rgb = spec_to_rgb([lambda_store, sun_spectrum], 'Space', color_space, ...
    'Method', adjust_method, ...
    'MaxY', max_y);

%%
img = ind2rgb(repmat(lambda_store-min(lambda_store), [1, 10])', rgb);

figure(1); clf;
set(gcf, 'Position', [100, 100, 1200, 600]);
subplot('Position', [0.05, 0.75, 0.48, 0.15]);
imagesc(img);
axis off;

h = subplot('Position', [0.05, 0.1, 0.48, 0.62]);
line_h = plot(lambda_store, rgb, 'LineWidth', 2.5);
set(h, 'XLim', [min(lambda_store), max(lambda_store)], 'YLim', [-.05, 1.05], ...
    'YTick', [], 'FontSize', 18);
xlabel('Wavelength (nm)', 'FontSize', 22);
set(line_h(1), 'Color', [1;0;0]);
set(line_h(2), 'Color', [0,1,0]);
set(line_h(3), 'Color', [0,0,1]);

%%
% load(sprintf('%s_%s.mat', color_space, adjust_method));
% 
% h = subplot('Position', [0.55, 0.1, 0.37, .8]);
% hold on;
% image(x, y, rgb_img);
% plot(W(1)/sum(W), W(2)/sum(W), 'sk', 'MarkerFaceColor', 'w', 'MarkerSize', 8);
% plot(xy(1,1), xy(1,2), 'ok', 'MarkerSize', 8);
% plot(xy(2,1), xy(2,2), 'ok', 'MarkerSize', 8);
% plot(xy(3,1), xy(3,2), 'ok', 'MarkerSize', 8);
% plot([xy(:,1); xy(1,1)], [xy(:,2); xy(1,2)], 'k', 'Color', [1,1,1]*.5);
% % xlabel('x', 'FontSize', 22, 'FontName', 'Times New Roman', 'FontAngle', 'italic');
% % ylabel('y', 'FontSize', 22, 'FontName', 'Times New Roman', 'FontAngle', 'italic');
% set(h, 'XLim', [-.05, .75], 'YLim', [0, .9], 'XTick', [], 'YTick', [],...
%     'Color', 'k', 'YAxisLocation', 'right', ...
%     'FontSize', 18);
% 
% axis equal;
% axis xy;
