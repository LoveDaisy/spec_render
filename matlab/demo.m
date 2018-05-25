clear; clc; close all;

lambda_store = (400:.1:800)';

sun_spectrum1 = ones(size(lambda_store));
sun_spectrum1(550<lambda_store&lambda_store<555) = 0;

sun_spectrum2 = ones(size(lambda_store));
sun_spectrum2(580<lambda_store&lambda_store<585) = 0;

spec = [lambda_store, sun_spectrum1, sun_spectrum2];

adjust_method = 'clipadjust';
color_space = 'sRGB';
max_y = .75;
rgb = spec_to_rgb(spec, 'Space', color_space, ...
    'Method', adjust_method, ...
    'MaxY', max_y);

%%
spec_idx = 1;

figure(2); clf;
set(gcf, 'Position', [100, 500, 800, 420]);
subplot('Position', [0.1, 0.3, 0.8, 0.6]);
plot(lambda_store, spec(:,spec_idx+1));
set(gca, 'xlim', [min(lambda_store), max(lambda_store)]);
subplot('Position', [0.1, 0.1, 0.8, 0.1]);
image(reshape(rgb(:,:,spec_idx),1,[],3), 'xdata', lambda_store);
set(gca, 'FontSize', 18, 'YTick', [], 'XTick', 400:40:800);
xlabel('Wavelength (nm)', 'FontSize', 22);