# `parse_dbcan_to_humann_map.sh`

SLURM batch wrapper that runs `parse_dbcan_to_humann_map.py` inside a Singularity container to produce a HUMAnN CAZy mapping file.

## Purpose

Automates the final conversion step from merged dbCAN overview output to:

- `dbcan_map_cazy_uniref90.txt.gz`

which can be supplied to HUMAnN via `--id-mapping`.

## Prerequisites

- HPC with SLURM.
- Modules:
  - `singularity`
- Existing files:
  - input overview file:
    - `${WORK_DIR}/final_results/uniref90_cazymes_overview.txt`
  - parser script:
    - `${SCRIPT_DIR}/parse_dbcan_to_humann_map.py`
  - container image:
    - `${DBCAN_CONTAINER}` (default `$PWD/database/dbcan.sif`)

## Inputs

- No command-line parameters.
- Uses hardcoded variables in-script:
  - `WORK_DIR`
  - `SCRIPT_DIR`
  - `DBCAN_CONTAINER`
  - `INPUT_OVERVIEW`
  - `OUTPUT_MAP`

## Outputs Produced

- Gzipped mapping file:
  - `${SCRIPT_DIR}/dbcan_map_cazy_uniref90.txt.gz`
- SLURM logs:
  - stdout: `log/parse_dbcan_cazy-%j.out`
  - stderr: `log/parse_dbcan_cazy-%j.err`

## Usage

Submit with SLURM:

```bash
sbatch parse_dbcan_to_humann_map.sh
```

## Error Conditions

The script exits with error if either is missing:

- merged input overview file,
- parser Python script.

It prints a recovery command for creating the merged overview if needed.

## HUMAnN Integration Example

```bash
humann --input sample.fastq.gz \
  --output output_dir \
  --id-mapping $PWD/dbcan_map_cazy_uniref90.txt.gz
```
