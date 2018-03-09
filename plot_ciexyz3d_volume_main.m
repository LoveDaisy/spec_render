clear; close all; clc;

lambda_store = (400:700)';
spectrum = ones(size(lambda_store));

spec_xyz = spec_to_ciexyz([lambda_store, spectrum], 'CmfProfile', 'lin2012xyz10e_1');
spec_sum = sum(spec_xyz, 2);
spec_rgb = ciexyz_to_rgb(spec_xyz, 'Space', 'sRGB', ...
    'Method', 'ShrinkToGray');

d = 0.01; md = 1.4;
[xx, yy, zz] = meshgrid(0:d:md, 0:d:md, 0:10*d:md);
xyz = [xx(:), yy(:), zz(:)];
xyz = (xyz + rand(size(xyz)) * d * 0.).^1.3;
xyz = xyz(all(xyz > 0, 2), :);
idx = inpolygon(xyz(:,1)./sum(xyz,2), xyz(:,2)./sum(xyz,2), ...
    spec_xyz(:,1)./spec_sum, spec_xyz(:,2)./spec_sum);
rgb = ciexyz_to_rgb(xyz(idx,:), 'Space', 'sRGB', ...
    'Method', 'ShrinkToGray');

%%
figure(1); clf;
hold on;
for i = 1:10:length(lambda_store)
    plot3([0, spec_xyz(i,1)], [0, spec_xyz(i,2)], ...
        [0, spec_xyz(i,3)], 'Color', [1,1,1]*.8);
end
patch([1, 0, 0], [0, 1, 0], [0, 0, 1], 'k');
% plot3([1, 0, 0, 1], [0, 1, 0, 0], [0, 0, 1, 0], 'k');
plot3(spec_xyz(:,1)./spec_sum, spec_xyz(:,2)./spec_sum, spec_xyz(:,3)./spec_sum, 'k');
scatter3(spec_xyz(:,1), spec_xyz(:,2), spec_xyz(:,3), 50, spec_rgb, 'fill');

set(gcf, 'Position', [100, 100, 800, 640]);
set(gca, 'FontSize', 18);
axis equal;
grid on;
q = -40;
set(gca, ...
    'XLim', [-.05, 1.25], 'YLim', [-.05, 1.05], ...
    'Projection', 'perspective', ...
    'CameraPosition', [cosd(q), sind(q), .7]*5 + [.6, .6, 0], ...
    'CameraViewAngle', 28, 'CameraTarget', [.6, .6, 1]);

%%
figure(2); clf;
scatter3(xyz(idx,1), xyz(idx,2), xyz(idx,3), 50, rgb, 'fill');
set(gcf, 'Position', [100, 100, 800, 640]);
set(gca, 'FontSize', 18);
xlabel('$X$', 'FontSize', 22, 'Interpreter', 'latex');
ylabel('$Y$', 'FontSize', 22, 'Interpreter', 'latex');
zlabel('$Z$', 'FontSize', 22, 'Interpreter', 'latex');
axis equal;
% for q = 0:5:360
%     set(gca, ...
%         'Projection', 'perspective', ...
%         'CameraPosition', [cosd(q), sind(q), .5]*3 + [.5, .5, 0], ...
%         'CameraViewAngle', 25, 'CameraTarget', [.5, .5, .4]);
%     pause(.1);
% end
q = -40;
set(gca, 'XLim', [-.01, md+.05], 'YLim', [-.01, md+.05], 'ZLim', [-.01, md+.05], ...
    'XTick', 0:.2:md, 'YTick', 0:.2:md, 'ZTick', 0:.2:md, ...
    'Projection', 'perspective', ...
    'CameraPosition', [cosd(q), sind(q), .7]*3 + [.5, .5, 0]*md, ...
    'CameraViewAngle', 35, 'CameraTarget', [.5, .5, .4]*md);
