# `dbcan_reads.def`

Singularity definition file for building a dbCAN-focused container image from Ubuntu 22.04.

## Purpose

Builds an image that includes:

- Conda (Miniforge)
- Python 3.9 environment (`dbcan`)
- dbCAN Python package
- core bioinformatics dependencies (`hmmer`, `diamond`, `prodigal`, `fraggenescan`, etc.)

The image runscript executes `run_dbcan` directly.

## Build Inputs

- Base image: `ubuntu:22.04`
- Internet access at build time for:
  - apt packages
  - Miniforge installer
  - Conda packages/channels
  - `pip install dbcan`

## Build Output

- A Singularity image file (name chosen at build time, e.g., `dbcan.sif`).

## Runtime Behavior

- `%environment` configures PATH and conda variables.
- `%runscript` activates `dbcan` conda environment and runs:

```bash
run_dbcan "$@"
```

- `%test` checks key executables and `run_dbcan --help`.

## Usage

Build image:

```bash
sudo singularity build dbcan.sif dbcan_reads.def
```

Run dbCAN through runscript:

```bash
singularity run dbcan.sif <dbcan-args>
```

Or explicit exec:

```bash
singularity exec dbcan.sif run_dbcan <dbcan-args>
```

## Notes

- If building on clusters without `sudo`, use your site’s approved build workflow (remote build or fakeroot if supported).
- Keep dependency versions synchronized with your downstream scripts and dbCAN database version.
