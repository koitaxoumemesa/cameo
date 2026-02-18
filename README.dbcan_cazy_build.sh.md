# `dbcan_cazy_build.sh`

SLURM batch script intended to orchestrate a UniRef90 → dbCAN annotation workflow and produce merged CAZyme output tables.

## Current Script Behavior

In the checked-in version, major workflow sections (sequence extraction, chunking, array script generation) are commented out.

The active part currently:

- sets up environment variables,
- creates work/log directories,
- prints post-array merge instructions,
- exits successfully.

## Intended Pipeline Stages (from commented sections)

1. Extract FASTA records from a HUMAnN UniRef90 Diamond DB (`diamond getseq`).
2. Split protein FASTA into chunks.
3. Run `run_dbcan` across chunks via SLURM array jobs.
4. Merge chunk outputs into `final_results/` aggregate files.

## Prerequisites

- HPC with SLURM.
- Environment modules:
  - `singularity`
- Container images:
  - `DIAMOND_CONTAINER` (default: `$PWD/database/humann3.9.sif`)
  - `DBCAN_CONTAINER` (default: `$PWD/database/dbcan.sif`)
- Existing databases:
  - `DMND_DB` UniRef90 Diamond DB
  - `DBCAN_DB_DIR` dbCAN DB directory

## Inputs

- No CLI arguments.
- Uses in-script paths for:
  - UniRef90 Diamond DB (`DMND_DB`)
  - dbCAN DB directory (`DBCAN_DB_DIR`)
  - work directory (`WORK_DIR`)

## Outputs Produced

Always produced:

- `WORKDIR/log/` directory for logs.
- Console instructions for manual merge step.

If commented sections are enabled and run end-to-end, expected outputs include:

- `humann_uniref90_sequences.fa`
- `chunks/chunk_*.fa`
- `run_dbcan_array.sh`
- `dbcan_results/*overview.txt`
- `dbcan_results/*diamond.out`
- `final_results/uniref90_cazymes_overview.txt`
- `final_results/uniref90_diamond_detail.tsv`

SLURM logs:

- stdout: `log/dbcan-%A_%a.out`
- stderr: `log/dbcan-%A_%a.err`

## Usage

Submit with SLURM:

```bash
sbatch dbcan_cazy_build.sh
```

## Manual Merge Command (as printed by script)

```bash
cd $PWD/uniref90_cazyme_build
mkdir -p final_results
cat dbcan_results/*overview.txt > final_results/uniref90_cazymes_overview.txt
cat dbcan_results/*diamond.out > final_results/uniref90_diamond_detail.tsv
```

## Notes

- To restore full automation, uncomment and validate the earlier pipeline stages.
- Resource requests are currently high (`64 CPUs`, `220G RAM`) and should match cluster policy and dataset scale.
