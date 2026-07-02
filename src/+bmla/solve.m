function result = solve(fun, x0, options)
%BMLA.SOLVE Solve a square nonlinear system without derivatives.
%
%   RESULT = BMLA.SOLVE(FUN, X0) attempts to solve FUN(X) = 0 from X0
%   using the frozen BMLA v4.1-RC numerical core.
%
%   RESULT = BMLA.SOLVE(FUN, X0, OPTIONS) uses public options created by
%   BMLA.OPTIONS.
%
%   RESULT contains stable public fields:
%
%       X                    Final point.
%       F                    Final residual vector.
%       ResidualNorm         Euclidean norm of F.
%       Iterations           Completed solver iterations.
%       FunctionEvaluations  Number of residual evaluations.
%       Converged            Solver convergence flag.
%       StopReason           Text identifier for termination.
%       History              Iteration history when requested.
%       Core                 Complete frozen-core result structure.
%
%   The public wrapper does not modify the frozen numerical algorithm.

    if nargin < 2
        error( ...
            'bmla:solve:NotEnoughInputs', ...
            'Provide a function handle and an initial point.');
    end

    if nargin < 3 || isempty(options)
        options = bmla.options();
    end

    if ~isa(fun, 'function_handle') || ~isscalar(fun)
        error( ...
            'bmla:solve:InvalidFunction', ...
            'FUN must be a scalar function handle.');
    end

    validateattributes( ...
        x0, ...
        {'numeric'}, ...
        {'vector', 'real', 'finite', 'nonempty'}, ...
        'bmla.solve', ...
        'x0');

    x0 = x0(:);
    options = validate_public_options(options);

    packageFolder = fileparts(mfilename('fullpath'));
    coreFile = fullfile( ...
        packageFolder, ...
        'private', ...
        'bmla_v4_1_radius_consistent_solver.m');

    if ~isfile(coreFile)
        error( ...
            'bmla:solve:FrozenCoreNotInstalled', ...
            ['The frozen BMLA v4.1-RC core is not installed. ' ...
             'Run tools/install_frozen_core.m using the exact frozen ' ...
             'source file before calling bmla.solve.']);
    end

    internalOptions = struct( ...
        'tolF', options.FunctionTolerance, ...
        'tolX', options.StepTolerance, ...
        'maxIterations', options.MaxIterations);

    [coreResult, history] = ...
        bmla_v4_1_radius_consistent_solver( ...
            fun, ...
            x0, ...
            internalOptions);

    result = public_result(coreResult, history, options);

    if strcmpi(string(options.Display), "final")
        fprintf('\nBMLA v4.1-RC\n');
        fprintf('  Converged:            %d\n', result.Converged);
        fprintf('  Stop reason:          %s\n', result.StopReason);
        fprintf('  Residual norm:        %.6e\n', result.ResidualNorm);
        fprintf('  Function evaluations: %d\n', result.FunctionEvaluations);
        fprintf('  Iterations:           %d\n\n', result.Iterations);
    end
end


function options = validate_public_options(options)

    if ~isstruct(options) || ~isscalar(options)
        error( ...
            'bmla:solve:InvalidOptions', ...
            'OPTIONS must be a scalar structure returned by bmla.options.');
    end

    defaults = bmla.options();
    requiredFields = fieldnames(defaults);

    for index = 1:numel(requiredFields)
        fieldName = requiredFields{index};

        if ~isfield(options, fieldName)
            options.(fieldName) = defaults.(fieldName);
        end
    end

    unknownFields = setdiff( ...
        fieldnames(options), ...
        requiredFields);

    if ~isempty(unknownFields)
        error( ...
            'bmla:solve:UnknownOptionFields', ...
            'Unknown option field "%s".', ...
            unknownFields{1});
    end

    % Reuse the public option parser for validation.
    options = bmla.options( ...
        'FunctionTolerance', options.FunctionTolerance, ...
        'StepTolerance', options.StepTolerance, ...
        'MaxIterations', options.MaxIterations, ...
        'Display', options.Display, ...
        'ReturnHistory', options.ReturnHistory);
end


function result = public_result(coreResult, history, options)

    requiredCoreFields = { ...
        'x', ...
        'f', ...
        'normF', ...
        'iterations', ...
        'functionEvaluations', ...
        'converged', ...
        'stopReason'};

    for index = 1:numel(requiredCoreFields)
        fieldName = requiredCoreFields{index};

        if ~isfield(coreResult, fieldName)
            error( ...
                'bmla:solve:UnexpectedCoreOutput', ...
                'Frozen core output is missing field "%s".', ...
                fieldName);
        end
    end

    result = struct();

    result.X = coreResult.x;
    result.F = coreResult.f;
    result.ResidualNorm = coreResult.normF;
    result.Iterations = coreResult.iterations;
    result.FunctionEvaluations = ...
        coreResult.functionEvaluations;
    result.Converged = logical(coreResult.converged);
    result.StopReason = string(coreResult.stopReason);

    if options.ReturnHistory
        result.History = history;
    else
        result.History = [];
    end

    result.Core = coreResult;
end
