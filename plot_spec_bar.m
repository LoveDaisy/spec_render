clear; clc; close all;

%%
lambda_store = (400:.1:800)';

% sun_spectrum = ones(size(lambda_store));
% sun_spectrum = sun_spectrum / sum(sun_spectrum);
sun_spectrum = ones(size(lambda_store));
sun_spectrum(550<lambda_store&lambda_store<555) = 0;

adjust_method = 'clipadjust';
color_space = 'sRGB';
max_y = .75;
rgb = spec_to_rgb([lambda_store, sun_spectrum], 'Space', color_space, ...
    'Method', adjust_method, ...
    'MaxY', max_y);

%%
% img = ind2rgb(repmat(lambda_store-min(lambda_store), [1, 10])', rgb);

% figure(1); clf;
% set(gcf, 'Position', [100, 500, 800, 120]);
% image(lambda_store, 1, img);
% set(gca, 'FontSize', 18, 'YTick', [], 'XTick', 400:40:720);
% xlabel('Wavelength (nm)', 'FontSize', 22);

figure(2); clf;
set(gcf, 'Position', [100, 500, 800, 420]);
subplot('Position', [0.1, 0.3, 0.8, 0.6]);
plot(lambda_store, sun_spectrum);
set(gca, 'xlim', [min(lambda_store), max(lambda_store)]);
subplot('Position', [0.1, 0.1, 0.8, 0.1]);
image(reshape(rgb,1,[],3), 'xdata', lambda_store);
set(gca, 'FontSize', 18, 'YTick', [], 'XTick', 400:40:800);
xlabel('Wavelength (nm)', 'FontSize', 22);