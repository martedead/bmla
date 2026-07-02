# MATLAB API

## Setup

From the repository root:

```matlab
setup_bmla();
```

## Default options

```matlab
options = bmla.options();
```

## Configure options

```matlab
options = bmla.options( ...
    "FunctionTolerance", 1e-10, ...
    "StepTolerance", 1e-10, ...
    "MaxIterations", 1000, ...
    "Display", "final", ...
    "ReturnHistory", true);
```

## Solve a system

```matlab
result = bmla.solve(fun, x0, options);
```

The stable public result fields are:

- `X`
- `F`
- `ResidualNorm`
- `Iterations`
- `FunctionEvaluations`
- `Converged`
- `StopReason`
- `History`
- `Core`

The `Core` field preserves the complete output of the frozen numerical
implementation. Its internal fields are not yet part of the stable public API.
