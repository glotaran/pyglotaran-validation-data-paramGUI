# pyglotaran validation data for paramGUI

This is a pyglotaran-validation-data repository, which holds data and/or code to generate validation data and the results to check against, for cross-validation with pyglotaran.

## Current scope

- `simData01`: notebook analysis for kinetic, spectral, and spectrotemporal models
- `simData02`: notebook analysis for kinetic, spectral, and spectrotemporal models
- `simData03`: notebook analysis for kinetic, spectral, and spectrotemporal models
- `simData04`: notebook analysis for kinetic, spectral, and spectrotemporal models
- `simData05`: notebook analysis for kinetic, spectral, and spectrotemporal models
- R scripts under `paramGUI/` are archival inputs only and are not executed by the Python workflow

## Python workflow

The Python workflow is managed with `uv`.

### Bootstrap

```bash
uv sync
```

### Run a single notebook from the CLI

```bash
uv run scripts/run_notebooks.py simdata01
uv run scripts/run_notebooks.py simdata02
uv run scripts/run_notebooks.py simdata03
uv run scripts/run_notebooks.py simdata04
uv run scripts/run_notebooks.py simdata05
```

### Run all notebooks

```bash
uv run scripts/run_notebooks.py run-all
```
