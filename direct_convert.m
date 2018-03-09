function rgb = direct_convert(spec, method)
% This function use direct methods to convert spectrum

switch lower(method)
    case 'youngsmethod'
        rgb = young_method(spec);
    case 'spektresmethod'
        rgb = spektre_method(spec);
    otherwise
        error('Method must be one of these strings: YoungsMethod, SpektresMethod');
end
end


function rgb = young_method(spec)
% Read from image
% wavelength range: [400, 800]
spectrum_img = im2double(imread('best_spectrum.jpg'));
spectrum_map = reshape(mean(spectrum_img, 1), [], 3);

ind = floor((spec(:,1) - 400) / 400 * (size(spectrum_map, 1) - 1) + 1);
rgb = bsxfun(@times, spectrum_map(ind, :), spec(:,2));
rgb = rgb / max(rgb(:));
end


function rgb = spektre_method(spec)
% Reference:
%   http://stackoverflow.com/questions/3407942/rgb-values-of-visible-spectrum
n = size(spec, 1);
lambda = spec(:,1);
rgb = zeros(n, 3);

idx = lambda >= 400 & lambda < 410;
t = (lambda(idx) - 400) / (410 - 400);
rgb(idx, 1) = (.33 * t) - (.2 * t.^2);

idx = lambda >= 410 & lambda < 475;
t = (lambda(idx) - 410) / (475 - 410);
rgb(idx, 1) = 0.14 - (0.13 * t.^2);

idx = lambda >= 545 & lambda < 595;
t = (lambda(idx) - 545) / (595 - 545);
rgb(idx, 1) = (1.98 * t) - t.^2;

idx = lambda >= 595 & lambda < 650;
t = (lambda(idx) - 595) / (650 - 595);
rgb(idx, 1) = 0.98 + 0.06*t - 0.4*t.^2;

idx = lambda >= 650 & lambda < 700;
t = (lambda(idx) - 650) / (700 - 650);
rgb(idx, 1) = 0.65 - 0.84*t + 0.2*t.^2;

idx = lambda >= 415 & lambda < 475;
t = (lambda(idx) - 415) / (475 - 415);
rgb(idx, 2) = 0.8*t.^2;

idx = lambda >= 475 & lambda < 590;
t = (lambda(idx) - 475) / (590 - 475);
rgb(idx, 2) = 0.8 + 0.76*t - 0.8*t.^2;

idx = lambda >= 590 & lambda < 639;
t = (lambda(idx) - 585) / (639 - 585);
rgb(idx, 2) = 0.84 - 0.84*t;

idx = lambda >= 400 & lambda < 475;
t = (lambda(idx) - 400) / (475 - 400);
rgb(idx, 3) = 2.2*t - 1.5*t.^2;

idx = lambda >= 475 & lambda < 560;
t = (lambda(idx) - 475) / (560 - 475);
rgb(idx, 3) = 0.7 - t + 0.3*t.^2;
end