clear; clc; close all;

data_path = '/Users/jiajiezhang/Documents/Astronomy Files/Lamost Spectral Files/';
output_path = '~/Desktop/spec-images/';
type = 'quasar/';
files = dir([data_path, type, '*.fits']);

gamma = 2.5;
max_y = 0.37;
for i = 1:length(files)
    info = fitsinfo([data_path, type, files(i).name]);
    data = fitsread([data_path, type, files(i).name]);
    
    kw = info.PrimaryData.Keywords;
    idx = arrayfun(@(x)strcmpi(x,'COEFF0'),kw);
    coeff0 = kw{idx(:,1), 2};
    idx = arrayfun(@(x)strcmpi(x,'COEFF1'),kw);
    coeff1 = kw{idx(:,1), 2};
    
    wavelength = 10.^((1:size(data,2)) * coeff1 + coeff0 - 1);
    linear_wavelength = (400:.5:800)';
    linear_data = interp1(wavelength', data', linear_wavelength);
    
    idx = 400 <= linear_wavelength & linear_wavelength <= 800;
    linear_data = max(linear_data(idx, :), 0);
    linear_wavelength = linear_wavelength(idx);
    
%     if size(data,1) < 6
        continuum = smooth(linear_data(:, 1), 40, 'rlowess');
        norm_spec = linear_data(:, 1) ./ continuum;
        norm_spec = norm_spec / max(norm_spec);
        med = median(norm_spec);
%     else
%         continuum = data(1, :) ./ data(3, :);
%         norm_spec = data(3, :) / max(data(3, :));
%     end
    
    rgb = spec_to_rgb([linear_wavelength, norm_spec.^gamma], ...
        'Space', 'sRGB', 'MaxY', max_y / (med + 7.3*med*exp(-8.2*med)));
    
    figure(1); clf;
    set(gcf, 'Position', [300, 50, 600, 750]);
    
    subplot('Position', [0.11, 0.56, 0.81, 0.38]);
    hold on;
    plot(linear_wavelength, linear_data(:,1), '-', 'linewidth', 1.0);
    plot(linear_wavelength, continuum, '-', 'linewidth', 2);
    box on;
    xlabel('Wavelength (nm)', 'fontsize', 14);
    legend({'Raw data', 'Continuum'}, 'location', 'northeast');
    ylim = get(gca, 'ylim');
    set(gca, 'xlim', [400, 800], 'ylim', [0, ylim(2)], 'fontsize', 12);
    
    subplot('Position', [0.11, 0.3, 0.81, 0.18]);
    plot(linear_wavelength, norm_spec, '-', 'linewidth', 1.0);
    xlabel('Wavelength (nm)', 'fontsize', 14);
    set(gca, 'xlim', [400, 800], 'ylim', [0, 1], 'fontsize', 12);
    
    subplot('Position', [0.11, 0.05, 0.81, 0.16]);
    image(reshape(rgb, 1, [], 3), 'xdata', linear_wavelength);
    axis off;
    
    saveas(gcf, sprintf('%s%s%s.png', output_path, type, files(i).name));
end