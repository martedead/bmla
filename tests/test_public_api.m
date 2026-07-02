function tests = test_public_api
%TEST_PUBLIC_API Tests for the public MATLAB interface.

    tests = functiontests(localfunctions);
end


function setupOnce(~)

    testsFolder = fileparts(mfilename('fullpath'));
    repositoryRoot = fileparts(testsFolder);

    addpath(repositoryRoot);
    setup_bmla();
end


function testDefaultOptions(testCase)

    options = bmla.options();

    verifyEqual(testCase, options.FunctionTolerance, 1e-8);
    verifyEqual(testCase, options.StepTolerance, 1e-10);
    verifyEqual(testCase, options.MaxIterations, 500);
    verifyEqual(testCase, string(options.Display), "off");
    verifyFalse(testCase, options.ReturnHistory);
end


function testNameValueOptions(testCase)

    options = bmla.options( ...
        "FunctionTolerance", 1e-12, ...
        "MaxIterations", 25, ...
        "Display", "final", ...
        "ReturnHistory", true);

    verifyEqual(testCase, options.FunctionTolerance, 1e-12);
    verifyEqual(testCase, options.MaxIterations, 25);
    verifyEqual(testCase, string(options.Display), "final");
    verifyTrue(testCase, options.ReturnHistory);
end


function testUnknownOptionRejected(testCase)

    verifyError( ...
        testCase, ...
        @() bmla.options("NotAnOption", 1), ...
        'bmla:options:UnknownOption');
end


function testBasicSolveWhenCoreInstalled(testCase)

    packageFolder = fileparts(which('bmla.solve'));
    coreFile = fullfile( ...
        packageFolder, ...
        'private', ...
        'bmla_v4_1_radius_consistent_solver.m');

    assumeTrue( ...
        testCase, ...
        isfile(coreFile), ...
        'Frozen core has not yet been installed.');

    fun = @(x) [ ...
        x(1)^2 + x(2)^2 - 1; ...
        x(1) - x(2)];

    result = bmla.solve( ...
        fun, ...
        [0.8; 0.2], ...
        bmla.options( ...
            "FunctionTolerance", 1e-8, ...
            "MaxIterations", 500));

    verifyTrue(testCase, result.Converged);
    verifyLessThanOrEqual( ...
        testCase, ...
        result.ResidualNorm, ...
        1e-8);
    verifyEqual(testCase, size(result.X), [2, 1]);
end
