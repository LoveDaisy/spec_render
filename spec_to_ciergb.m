function rgb = spec_to_ciergb(spec, varargin)
% This function converts a spectral distribution
% to a CIE XYZ space
%
% INPUT
%   spec:   n-by-2 matrix. wave length, power strength
% PARAMETERS
%   merge:          false (default) | true
%   cmfprofile:     string. {'lin2012xyz10e_1' (default), 'ciexyz31_1'}
% OUTPUT
%   xyz:    n-by-3 matrix, XYZ, or
%           1-by-3 vector

assert(size(spec, 2) == 2);
assert(size(spec, 1) > 2);

parameters = handle_parameter(varargin);

cmf = parameters.cmf;

rgb = bsxfun(@times, interp1(cmf(:, 1), cmf(:, 2:4), spec(:, 1)), spec(:, 2));

if parameters.merge
    rgb = sum(rgb);
end

end


function parameters = handle_parameter(varg)
n = length(varg);
assert(mod(n, 2) == 0);

parameters.merge = false;
parameters.cmf = get_sb10_cmf();

for i = 1:n/2
    key = lower(varg{i*2-1});
    value = varg{i*2};
    switch key
        case 'merge'
            if ~islogical(value)
                error('The Merge must be a logical value!');
            end
        case 'cmfprofile'
            if ~ischar(value)
                error('The CMFProfile must be a string!');
            end
            switch lower(value)
                case 'sb10'
                    parameters.cmf = get_sb10_cmf();
                otherwise
                    warning('Unknow profile name! Use ciexyz31_1 as default!');
            end
            parameters.space = lower(value);
        otherwise
            error('Unknow parameter name!');
    end
end
end


function cmf = get_sb10_cmf()
cmf = [
392.16,0.0022015,-0.00058445,0.0090156
400,0.0088461,-0.0025243,0.039459
408.16,0.029795,-0.0096611,0.14449
416.67,0.060689,-0.023843,0.36568
425.53,0.076482,-0.034154,0.63004
434.78,0.057778,-0.027947,0.87183
444.44,0,0,1
454.55,-0.091463,0.059341,0.91953
465.12,-0.22623,0.16377,0.74043
470.59,-0.29171,0.22788,0.59509
476.19,-0.34418,0.2934,0.44151
481.93,-0.39472,0.3695,0.3173
487.8,-0.42392,0.44106,0.21641
493.83,-0.44421,0.53142,0.14448
500,-0.4365,0.62621,0.090499
506.33,-0.408,0.73348,0.053472
512.82,-0.32325,0.83827,0.0277
519.48,-0.19906,0.94141,0.010463
526.32,0,1,0
533.33,0.24415,1.0329,-0.0055165
540.54,0.56132,1.053,-0.0083935
547.95,0.89948,1.0171,-0.0096784
555.56,1.3038,0.96683,-0.009745
563.38,1.7509,0.87881,-0.009106
571.43,2.2406,0.75919,-0.0079825
579.71,2.6472,0.60232,-0.0066075
588.24,3.0337,0.45306,-0.0054029
597.01,3.1717,0.30514,-0.0039029
606.06,3.0814,0.17952,-0.0026396
615.38,2.6983,0.091175,-0.0014839
625,2.1672,0.037071,-0.00086086
645.16,1,0,0
666.67,0.29596,-0.0018473,5.1712e-05
689.66,0.059994,-0.00047334,1.682e-05
714.29,0.0097398,-7.5137e-05,3.5276e-06
];

sum_spec = sum(bsxfun(@times, diff(cmf(:, 1)), (cmf(2:end, 2:end) + cmf(1:end-1,2:end))/2));
cmf(:, 2:end) = bsxfun(@times, cmf(:, 2:end), 1./sum_spec);
end

