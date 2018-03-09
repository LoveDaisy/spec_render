clear; close all; clc;

h = 6.626e-34;
c = 3e8;
k = 1.381e-23;

T = 2500;
lambda = (400:800)';

bb = 8*pi*h*c ./ (lambda * 1e-9).^5 ./ (exp(h*c/k/T./(lambda * 1e-9)) - 1);
rayleigh = 1 ./ (lambda * 1e-9).^4;
reflect = bb .* rayleigh;
uniform = ones(size(lambda));

source = bb / max(bb);
rayleigh = rayleigh / max(rayleigh);
reflect = reflect / max(reflect);

rgb_bar = spec_to_rgb([lambda, uniform], 'Space', 'sRGB', ...
    'Method', 'clipadjust', ...
    'MaxY', .75);
source_rgb = spec_to_rgb([lambda, source], 'Space', 'sRGB', ...
    'Method', 'clipadjust', ...
    'MaxY', .85, 'Mix', true);
reflect_rgb = spec_to_rgb([lambda, reflect], 'Space', 'sRGB', ...
    'Method', 'clipadjust', ...
    'MaxY', .65, 'Mix', true);

%%
figure(1); clf;
set(gcf, 'Position', [20, 100, 1250, 400]);

subplot('Position', [.06, .25, .26, .6]); hold on;
plot(lambda, source, 'LineWidth', 2);
patch([550, 650, 650, 550], [.4, .4, .6, .6], source_rgb, ...
    'EdgeColor', 'none');
set(gca, 'XDir', 'reverse', 'XTick', [], 'YLim', [0, 1.1], ...
    'FontSize', 14);
ylabel('Power Spectral Distribution', 'FontSize', 16);
title('Source Light', 'FontSize', 16);
box on;
subplot('Position', [.06, .18, .26, .07]);
image(reshape(rgb_bar, [1, length(lambda), 3]), 'XData', lambda);
set(gca, 'XDir', 'reverse', 'YTick', [], ...
    'FontSize', 14);
xlabel('Wavelength (nm)', 'FontSize', 16);

subplot('Position', [.32, .5, .055, .055]);
text(0.5, 0.5, '\times', 'FontSize', 32, 'HorizontalAlignment', 'center');
axis off;

subplot('Position', [.375, .25, .26, .6]);
plot(lambda, rayleigh, 'LineWidth', 2);
set(gca, 'XDir', 'reverse', 'XTick', [], 'YLim', [0, 1.1], ...
    'FontSize', 14, 'YTickLabel', '');
title('Reflectance', 'FontSize', 16);
% ylabel('Power Spectral Distribution', 'FontSize', 16);
subplot('Position', [.375, .18, .26, .07]);
image(reshape(rgb_bar, [1, length(lambda), 3]), 'XData', lambda);
set(gca, 'XDir', 'reverse', 'YTick', [], ...
    'FontSize', 14);
xlabel('Wavelength (nm)', 'FontSize', 16);

subplot('Position', [.635, .5, .055, .055]);
text(0.5, 0.5, '=', 'FontSize', 32, 'HorizontalAlignment', 'center');
axis off;

subplot('Position', [.69, .25, .26, .6]); hold on;
plot(lambda, reflect, 'LineWidth', 2);
patch([550, 650, 650, 550], [.4, .4, .6, .6], reflect_rgb, ...
    'EdgeColor', 'none');
set(gca, 'XDir', 'reverse', 'XTick', [], 'YLim', [0, 1.1], ...
    'FontSize', 14, 'YAxisLocation', 'right');
title('Object Color', 'FontSize', 16);
box on;
% ylabel('Power Spectral Distribution', 'FontSize', 16);
subplot('Position', [.69, .18, .26, .07]);
image(reshape(rgb_bar, [1, length(lambda), 3]), 'XData', lambda);
set(gca, 'XDir', 'reverse', 'YTick', [], ...
    'FontSize', 14);
xlabel('Wavelength (nm)', 'FontSize', 16);


% subplot(1,2,1);
% image(reshape(source_rgb, [1,1,3]));
% subplot(1,2,2);
% image(reshape(reflect_rgb, [1,1,3]));