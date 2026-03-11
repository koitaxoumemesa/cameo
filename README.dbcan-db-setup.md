# `dbcan-db-setup.sh`

SLURM batch script to initialize a dbCAN database directory by downloading reference files and creating required indexes with tools inside a Singularity container. Swap out docker as needed. 

## Purpose

Prepares `${WORKDIR}/db` with the files needed by `run_dbcan` (HMM databases, Diamond databases, PUL resources, and example data files).

## Prerequisites

- HPC with SLURM.
- Environment modules available:
  - `singularity`
- Existing dbCAN container image path:
  - `DBCAN_CONTAINER` (default: `$PWD/database/dbcan.sif`)
- Write access to:
  - `WORKDIR` (default: `$PWD`)

## Inputs

- No command-line arguments.
- Downloads remote dbCAN resources directly from dbCAN-hosted URLs.
- Uses variables defined in-script:
  - `WORKDIR`
  - `DBCAN_CONTAINER`
  - `DBCAN_DB_DIR`

## Outputs Produced

Primary output location: `${DBCAN_DB_DIR}`

Examples of produced files:

- `fam-substrate-mapping.tsv`
- `PUL.faa` and BLAST DB index files from `makeblastdb`
- `dbCAN-PUL.xlsx`
- extracted `dbCAN-PUL/` directory contents
- `dbCAN_sub.hmm` + `hmmpress` index files
- `CAZyDB.fa` + Diamond database files (`CAZy*.dmnd`)
- `dbCAN.txt` + `hmmpress` index files
- `tcdb.fa` + Diamond database files (`tcdb*.dmnd`)
- `tf-1.hmm`, `tf-2.hmm`, `stp.hmm` + `hmmpress` index files

Additional sample files written in `${WORKDIR}`:

- `EscheriaColiK12MG1655.fna`
- `EscheriaColiK12MG1655.faa`
- `EscheriaColiK12MG1655.gff`

SLURM logs:

- stdout: `$PWD/log/db-build-%j.out`
- stderr: `$PWD/log/db-build-%j.err`

## Usage

Submit with SLURM:

```bash
sbatch dbcan-db-setup.sh
```

## Notes

- The script runs as a chained command sequence with `set -euo pipefail`; any failed download/indexing step stops the job.
- If URLs or dbCAN versions change upstream, update the hardcoded filenames/URLs in the script.
