clear; clc; close all;

%% Make a black body spectrum
lambda_store = (400:800)';
T_store = exp(linspace(log(.5), log(100), 75))*1e3;
h = 6.626e-34;      % The Planck constant
k = 1.381e-23;      % The Boltzman constant
c = 3e8;            % The light speed
T = 5500;           % The temperature

color_space = 'sRGB';
adjust_method = 'ShrinkToGray';
lumi_store = exp(linspace(log(.1), log(10), 50));
color_store = zeros(length(lumi_store), length(T_store), 3);
spectrum_store = zeros(length(lambda_store), length(T_store));

for i = 1:length(T_store)
    T = T_store(i);
%     bb_spectrum = 2*h*c^2*1e45 ./lambda_store.^5 ./ (exp(h*c/k/T./lambda_store*1e9) - 1);
    bb_spectrum = 2*h*c^2*1e81 ./lambda_store.^9 ./ (exp(h*c/k/T./lambda_store*1e9) - 1);
    spectrum_store(:, i) = bb_spectrum;
end

lumi = sum(spectrum_store);

for i = 1:length(T_store)
    xyz = spec_to_ciexyz([lambda_store, spectrum_store(:,i)], 'cmfProfile', 'ciexyz31_1');
    for j = 1:length(lumi_store)
        xyz_norm = sum(xyz) / sum(xyz(:, 2)) * 2.*lumi_store(j)*(lumi(i)/max(lumi)).^.15;
        rgb = ciexyz_to_rgb(xyz_norm, 'space', color_space, 'method', adjust_method);
        color_store(j, i, :) = rgb;
    end
end

%%
figure(1); clf;
set(gcf, 'Position', [100, 100, 800, 640]);
hold on;
image(color_store);
sun_x = (log(5.5) - log(.5)) / (log(100) - log(.5)) * length(T_store);
sun_y = (log(1.) - log(.1)) / (log(10) - log(.1)) * length(lumi_store);
proxb_x = (log(3) - log(.5)) / (log(100) - log(.5)) * length(T_store);
plot(sun_x, sun_y, 'ok', 'MarkerSize', 20);
text(sun_x, sun_y + 2.5, 'Earth', 'FontSize', 18);
plot(proxb_x, sun_y, 'ok', 'MarkerSize', 20);
text(proxb_x - 7, sun_y + 2.5, 'Proxima b', 'FontSize', 18);
xtick = [.1 .2, .5, 1, 2, 5 10];
ytick = [.5, 1, 2, 5, 10, 20, 50, 100];
set(gca, 'YTick', floor((log(xtick) - log(.09)) / (log(10) - log(.09)) * length(lumi_store)), ...
    'YTickLabel', xtick, ...
    'XTick', floor((log(ytick) - log(.45)) / (log(100) - log(.45)) * length(T_store)), ...
    'XTickLabel', ytick, ...
    'FontSize', 18);
xlabel('Temperature (\times1000 K)', 'FontSize', 22);
ylabel('Relative Luminosity', 'FontSize', 22);
axis xy;
axis equal;
axis tight;
