% BASIC_EXAMPLE Solve a two-variable nonlinear system with BMLA.

repositoryRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(repositoryRoot);
setup_bmla();

fun = @(x) [ ...
    x(1)^2 + x(2)^2 - 1; ...
    x(1) - x(2)];

x0 = [0.8; 0.2];

options = bmla.options( ...
    "FunctionTolerance", 1e-10, ...
    "Display", "final", ...
    "ReturnHistory", true);

result = bmla.solve(fun, x0, options);

disp("Computed solution:");
disp(result.X);

disp("Final residual:");
disp(result.F);
