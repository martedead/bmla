# BMLA

**BMLA** is a radius-consistent derivative-free solver for systems of nonlinear equations based on local affine models.

> **Project status:** Research preview. The public MATLAB API is under active preparation from the frozen BMLA v4.1-RC research release.

## Intended use

BMLA is designed for black-box nonlinear systems

```math
F(x)=0,
```

especially when derivatives are unavailable or expensive and residual evaluations dominate the computational cost.

## MATLAB quick start

Clone the repository and, from its root folder, run:

```matlab
setup_bmla();

fun = @(x) [ ...
    x(1)^2 + x(2)^2 - 1; ...
    x(1) - x(2)];

x0 = [0.8; 0.2];

options = bmla.options( ...
    "FunctionTolerance", 1e-10, ...
    "Display", "final");

result = bmla.solve(fun, x0, options);
```

The exact frozen BMLA v4.1-RC numerical core is included in:

```text
src/+bmla/private/bmla_v4_1_radius_consistent_solver.m
```

Verify its identity from the repository root with:

```matlab
addpath("tools")
verification = verify_frozen_core();
```

The expected SHA-256 is:

```text
363ff1986c1cfee8ca3438fbb779bf574de792b15edfc38a1c1aff6949491d69
```

The utility `tools/install_frozen_core.m` is retained for maintainers who need to reconstruct the public tree from the original frozen archive. Ordinary users do not need to run it.

## Repository layout

- `src/+bmla/` — public MATLAB package and frozen numerical core
- `examples/` — runnable examples
- `tests/` — regression and API tests
- `docs/` — algorithm, diagnostics, and API documentation
- `tools/` — integrity and maintenance utilities
- `reproduction/` — paper-reproduction materials

## Tests

From the repository root:

```matlab
results = runtests("tests");
```

## Citation

Citation metadata is provided in [`CITATION.cff`](CITATION.cff). The journal article and software DOI will be added when available.

## License

BMLA is released under the Apache License 2.0. See [`LICENSE`](LICENSE).

## Author

José L. Chávez-Hurtado  
ITESO, Universidad Jesuita de Guadalajara  
ORCID: https://orcid.org/0000-0003-4115-0999
