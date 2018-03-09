function rgb = ciexyz_to_rgb(xyz, varargin)
% This function converts CIE XYZ to RGB space
% INPUT
%   xyz:            n-by-3
% PARAMETERS
%   space:          string. {'sRGB', 'AppleRGB', 'AdobeRGB', 'BestRGB'}
%   method:         'ShrinkToGray', 'AddWhite', 'Clip'
%   compand:        true
% OUTPUT
%   rgb:            n-by-3

assert(size(xyz, 2) == 3);

parameters = handle_parameters(varargin);

[m, W, ~, compand_func] = get_convert_param(parameters.space);
rgb_lin = parameters.xyz2rgb(xyz, m, W);
if parameters.compand
    rgb = compand_func(rgb_lin);
else
    rgb = rgb_lin;
end
end


function rgb = shrink_to_gray(xyz, m, W)
gray = bsxfun(@times, xyz(:,2), W);
alpha = bsxfun(@times, -gray * m', 1./((xyz - gray) * m'));
alpha(alpha < 0) = inf;
% beta = bsxfun(@times, 1-gray * m', 1./((xyz - gray) * m'));
% beta(beta < 0) = inf;
% r = min(min(min(alpha, beta), [], 2), 1);
r = min(min(alpha, [], 2), 1);
rgb = (bsxfun(@times, r, xyz - gray) + gray) * m';

rgb = min(max(rgb, 0), 1);
end


function rgb = shrink_to_gray_keep_lumi(xyz, m, W)
gray = bsxfun(@times, xyz(:,2), W);
alpha = bsxfun(@times, -gray * m', 1./((xyz - gray) * m'));
alpha(alpha < 0) = inf;
beta = bsxfun(@times, 1 - gray * m', 1./((xyz - gray) * m'));
beta(beta < 0) = inf;
r = min(min(min(alpha, beta), [], 2), 1);
rgb = (bsxfun(@times, r, xyz - gray) + gray) * m';

rgb = min(max(rgb, 0), 1);
end


function rgb = add_white(xyz, m)
rgb = xyz * m';
w = min(rgb, [], 2);
rgb = bsxfun(@minus, rgb, w);

xyz_hat = rgb / m';
alpha = xyz(:,2) ./ xyz_hat(:,2);
rgb = bsxfun(@times, rgb, alpha);

rgb = min(max(rgb, 0), 1);
end

function rgb = clip(xyz, m)
rgb = xyz * m';

rgb = max(min(rgb, 1), 0);
end

function rgb = clip_keep_lumi(xyz, m)
rgb = xyz * m';

rgb = min(max(rgb, 0), 1);
xyz_hat = rgb / m';
alpha = xyz(:,2) ./ xyz_hat(:,2);
rgb = bsxfun(@times, rgb, alpha);

rgb = min(max(rgb, 0), 1);
end

function parameters = handle_parameters(varg)
n = length(varg);
assert(mod(n, 2) == 0);

parameters.space = 'srgb';
parameters.xyz2rgb = @(xyz, m, W)shrink_to_gray_keep_lumi(xyz, m, W);
parameters.compand = true;

for i = 1:n/2
    key = lower(varg{i*2-1});
    value = varg{i*2};
    switch key
        case 'method'
            if ~ischar(value)
                error('The Method must be a string!');
            end
            switch lower(value)
                case {'shrinktograyadjust', 'default'}
                    parameters.xyz2rgb = @(xyz, m, W)shrink_to_gray_keep_lumi(xyz, m, W);
                case 'shrinktogray'
                    parameters.xyz2rgb = @(xyz, m, W)shrink_to_gray(xyz, m, W);
                case 'addwhite'
                    parameters.xyz2rgb = @(xyz, m, W)add_white(xyz, m);
                case 'clip'
                    parameters.xyz2rgb = @(xyz, m, W)clip(xyz, m);
                case 'clipadjust'
                    parameters.xyz2rgb = @(xyz, m, W)clip_keep_lumi(xyz, m);
                otherwise
                    warning('Unkown Method name! Use default!');
            end
        case 'space'
            if ~ischar(value)
                error('The Space must be a string!');
            end
            parameters.space = lower(value);
        case 'compand'
            if ~islogical(value)
                error('The Compand must be a logical value!');
            end
            parameters.compand = value;
        otherwise
            error('Unknow parameter name!');
    end
end
end
