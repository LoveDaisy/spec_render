clear; close all; clc;

%%
color_space = 'sRGB';
adjust_method = 'Clip';

[~, W, xy, ~] = get_convert_param(color_space);

lambda_store = (400:700)';
spectrum = ones(size(lambda_store));

spec_xyz = spec_to_ciexyz([lambda_store, spectrum], 'CmfProfile', 'lin2012xyz10e_1');
spec_sum = sum(spec_xyz, 2);
spec_rgb = ciexyz_to_rgb(spec_xyz, 'Space', color_space, 'Method', adjust_method);

Y = 1;
dx = .0004; dy = .0004;
x = -.05:dx:.75; y = 0:dy:.9;
[xx, yy] = meshgrid(x, y);
zz = 1 - xx - yy;
% X = xx * Y ./ yy;
% Z = zz * Y ./ yy;
% Y = ones(size(X)) * Y;

alpha = .75./(sqrt(abs(xx - W(1)/sum(W)).^2 + abs(yy - W(2)/sum(W)).^2)+.18);
% alpha = .75./(abs(abs(xx - W(1)/sum(W)) + abs(yy - W(2)/sum(W)))+.2);
% Y = atan2(xx-W(1)/sum(W), yy-W(2)/sum(W));
% Y = (reshape(interp1(spec_to_w_ang(1:300), spec_xyz(1:300,2), Y(:)), size(xx)) + 0.1) * alpha;
% Y(isnan(Y)) = 0.1;
% X = xx .* Y ./ yy;
% Z = zz .* Y ./ yy;

X = xx .* alpha; Y = yy .* alpha; Z = alpha - X - Y;
xyz = reshape(cat(3, X, Y, Z), [], 3);

rgb_img = ones(size(xyz));
int_x = floor((spec_xyz(:,1) ./ spec_sum - min(x)) / dx) + 1;
int_y = floor((spec_xyz(:,2) ./ spec_sum - min(y)) / dy) + 1;
bw = poly2mask(int_x, int_y, length(y), length(x));

%%
tmp_rgb = ciexyz_to_rgb(xyz(bw(:),:), 'Space', color_space, 'Method', adjust_method);

rgb_img(bw(:),:) = tmp_rgb;
rgb_img = reshape(rgb_img, length(y), length(x), []);
rgb_img = imfilter(rgb_img, fspecial('gaussian', [1,1]*5, 1.0), 'symmetric');
rgb_img = imresize(rgb_img, .5);
mask = imresize(double(bw), .5);

%%
figure(1); clf;
set(gcf, 'Position', [100, 100, 800, 640]);
hold on;
image(x, y, rgb_img);
plot(W(1)/sum(W), W(2)/sum(W), 'sk', 'MarkerFaceColor', 'w', 'MarkerSize', 8);
plot(xy(1,1), xy(1,2), 'ok', 'MarkerSize', 8);
plot(xy(2,1), xy(2,2), 'ok', 'MarkerSize', 8);
plot(xy(3,1), xy(3,2), 'ok', 'MarkerSize', 8);
text(xy(1,1)-.01, xy(1,2)+.02, '$R$', 'Interpreter', 'latex', 'FontSize', 22);
text(xy(2,1)-.01, xy(2,2)+.02, '$G$', 'Interpreter', 'latex', 'FontSize', 22);
text(xy(3,1)-.01, xy(3,2)+.02, '$B$', 'Interpreter', 'latex', 'FontSize', 22);
text(W(1)/sum(W)-.01, W(2)/sum(W)+.02, '$W$', 'Interpreter', 'latex', 'FontSize', 22);
% plot([xy(:,1); xy(1,1)], [xy(:,2); xy(1,2)], 'k--', 'Color', [1,1,1]*.5);
xlabel('x', 'FontSize', 22, 'FontName', 'Times', 'FontAngle', 'italic');
ylabel('y', 'FontSize', 22, 'FontName', 'Times', 'FontAngle', 'italic');
set(gca, 'XLim', [-.05, .75], 'YLim', [0, .9], 'XTick', [], 'YTick', [],...
    'Color', 'w', 'YAxisLocation', 'right', ...
    'FontSize', 18);

axis equal;
axis xy;
axis tight;
axis off;


%%
macadam_ellipse_data = dlmread('MacAdam_Ellipse.csv', ',', 1, 0);
macadam_ellipse_data = bsxfun(@times, macadam_ellipse_data, [1, 1, 1e-3, 1e-3, 1]);

figure(2); clf;
set(gcf, 'Position', [100, 100, 800, 640]);
hold on;
image(x, y, rgb_img);
plot(macadam_ellipse_data(:,1), macadam_ellipse_data(:,2), '.k');

axis equal;
axis xy;
axis tight;
axis off;


% %%
% save('result.mat', 'W', 'xy', 'color_space', 'x', 'y', ...
%     'adjust_method', 'lambda_store', 'rgb_img');
