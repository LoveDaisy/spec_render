function [m, W, xy, compand_func] = get_convert_param(space_model, varargin)
% This function returns the transform parameters of a
% given RGB model
% INPUT
%   space_model:    string
% PARAMETERS
%   direction:      'xyz2rgb', 'rgb2xyz'

parameters = handel_parameters(varargin);

white_points.D65 = [0.95047	1.00000	1.08883];
white_points.D55 = [0.95682	1.00000	0.92149];
white_points.D50 = [0.96422	1.00000	0.82521];
white_points.C = [0.98074	1.00000	1.18232];
white_points.E = [1.00000	1.00000	1.00000];

switch lower(space_model)
    case 'srgb'
        W = white_points.D65;
        xy = [0.6400	0.3300;
            0.3000	0.6000;
            0.1500	0.0600];
    case 'adobergb'
        W = white_points.D65;
        xy = [0.6400	0.3300;
            0.2100	0.7100;
            0.1500	0.0600];
    case 'applergb'
        W = white_points.D65;
        xy = [0.6250	0.3400;
            0.2800	0.5950;
            0.1550	0.0700];
    case 'bestrgb'
        W = white_points.D50;
        xy = [0.7347	0.2653;
            0.2150	0.7750;
            0.1300	0.0350];
    otherwise
        error('Color space must be one of these: sRGB, AdobeRGB, AppleRGB, BestRGB');
end

XYZ = [xy(:,1) ./ xy(:,2), ones(3, 1), (1 - sum(xy,2)) ./ xy(:,2)];
S = W / XYZ;
if parameters.xyz2rgb
    m = inv(XYZ' * diag(S));
    compand_func = @(rgb)compand_color(rgb, space_model);
else
    m = XYZ * diag(S);
    compand_func = @(rgb)inv_compand_color(rgb, space_model);
end
end

function rgb = compand_color(rgb, space)
switch lower(space)
    case 'srgb'
        th = 0.0031308;
        alpha = 0.055;
        low_idx = rgb < th;
        rgb(low_idx) = rgb(low_idx) * 12.92;
        rgb(~low_idx) = (1+alpha) * rgb(~low_idx) .^ (1/2.4) - alpha;
    case {'adobergb', 'bestrgb'}
        rgb = rgb.^(1/2.2);
    case 'applergb'
        rgb = rgb.^(1/1.8);
    otherwise
        error('Color space must be one of these: sRGB, AdobeRGB, AppleRGB, BestRGB');
end
end


function rgb = inv_compand_color(rgb, space)
switch lower(space)
    case 'srgb'
        th = 0.04045;
        alpha = 0.055;
        low_idx = rgb < th;
        rgb(low_idx) = rgb(low_idx) / 12.92;
        rgb(~low_idx) = ((rgb(~low_idx) + alpha) / (1+alpha)).^(2.4);
    case {'adobearg', 'bestrgb'}
        rgb = rgb.^(2.2);
    case 'applergb'
        rgb = rgb.^(1.8);
    otherwise
        error('Color space must be one of these: sRGB, AdobeRGB, AppleRGB, BestRGB');
end
end


function parameters = handel_parameters(varg)
n = length(varg);
assert(mod(n, 2) == 0);

parameters.xyz2rgb = true;

for i = 1:n/2
    key = lower(varg{i*2-1});
    value = varg{i*2};
    switch key
        case 'direction'
            if ~islogical(value)
                error('The Method must be a islogical value!');
            end
            parameters.xyz2rgb = value;
        otherwise
            error('Unknow parameter name!');
    end
end
end
